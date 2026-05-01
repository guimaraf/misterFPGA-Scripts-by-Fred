#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET_FILE="$SCRIPT_DIR/update_senhor.sh"
BACKUP_FILE="$TARGET_FILE.bak.$(date +%Y%m%d-%H%M%S)"
TEMP_FILE="${TARGET_FILE}.tmp.$$"

cleanup() {
    [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
}

trap cleanup EXIT INT TERM

fail() {
    echo "Erro: $*" >&2
    exit 1
}

[ -f "$TARGET_FILE" ] || fail "Arquivo update_senhor.sh nao encontrado em: $SCRIPT_DIR"
[ -r "$TARGET_FILE" ] || fail "Sem permissao para ler: $TARGET_FILE"
[ -w "$TARGET_FILE" ] || fail "Sem permissao para alterar: $TARGET_FILE"

command -v awk >/dev/null 2>&1 || fail "awk nao encontrado"
command -v cp >/dev/null 2>&1 || fail "cp nao encontrado"
command -v grep >/dev/null 2>&1 || fail "grep nao encontrado"
command -v mv >/dev/null 2>&1 || fail "mv nao encontrado"
command -v cmp >/dev/null 2>&1 || fail "cmp nao encontrado"

check_count=$(grep -c '^[[:space:]]*check_internet[[:space:]]*()[[:space:]]*{' "$TARGET_FILE" || true)
next_count=$(grep -c '^[[:space:]]*check_for_updates[[:space:]]*()[[:space:]]*{' "$TARGET_FILE" || true)

[ "$check_count" -eq 1 ] || fail "Esperava encontrar exatamente 1 funcao check_internet(), encontrei: $check_count"
[ "$next_count" -eq 1 ] || fail "Esperava encontrar exatamente 1 funcao check_for_updates(), encontrei: $next_count"

cp -p "$TARGET_FILE" "$BACKUP_FILE" || fail "Nao foi possivel criar backup: $BACKUP_FILE"

set +e
awk '
function print_fixed_check_internet() {
    print "check_internet() {"
    print "    log \"Checking internet connection...\""
    print ""
    print "    if ping -4 -q -c 1 -W 3 1.1.1.1 >/dev/null 2>&1 || \\"
    print "       ping -4 -q -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then"
    print "        log \"Internet connection is available.\" SUCCESS"
    print "        return 0"
    print "    fi"
    print ""
    print "    if wget -q --spider --timeout=5 https://www.google.com/generate_204; then"
    print "        log \"Internet connection is available.\" SUCCESS"
    print "        return 0"
    print "    fi"
    print ""
    print "    log \"No internet connection detected.\" ERROR"
    print "    exit 1"
    print "}"
    print ""
}

/^[[:space:]]*check_internet[[:space:]]*\(\)[[:space:]]*\{[[:space:]]*$/ {
    if (replaced) {
        print
        next
    }

    print_fixed_check_internet()
    replaced = 1
    skipping = 1
    next
}

skipping && /^[[:space:]]*check_for_updates[[:space:]]*\(\)[[:space:]]*\{[[:space:]]*$/ {
    skipping = 0
    print
    next
}

skipping {
    next
}

{
    print
}

END {
    if (!replaced) {
        exit 10
    }
    if (skipping) {
        exit 11
    }
}
' "$TARGET_FILE" > "$TEMP_FILE"

awk_status=$?
set -e

if [ "$awk_status" -eq 10 ]; then
    fail "Nao foi possivel encontrar check_internet()"
fi

if [ "$awk_status" -eq 11 ]; then
    fail "Nao foi possivel encontrar check_for_updates() apos check_internet()"
fi

[ "$awk_status" -eq 0 ] || fail "Falha ao gerar arquivo corrigido"
[ -s "$TEMP_FILE" ] || fail "Arquivo temporario ficou vazio; abortando"

if cmp -s "$TARGET_FILE" "$TEMP_FILE"; then
    rm -f "$TEMP_FILE"
    echo "Nenhuma alteracao necessaria."
    echo "Backup criado em: $BACKUP_FILE"
    exit 0
fi

mv "$TEMP_FILE" "$TARGET_FILE" || fail "Nao foi possivel atualizar update_senhor.sh"
chmod +x "$TARGET_FILE" 2>/dev/null || true

echo "Funcao check_internet() atualizada com sucesso."
echo "Backup criado em: $BACKUP_FILE"
