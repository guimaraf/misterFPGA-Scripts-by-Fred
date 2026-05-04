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
    echo "Error / Erro: $*" >&2
    exit 1
}

[ -f "$TARGET_FILE" ] || fail "update_senhor.sh file not found in: $SCRIPT_DIR / Arquivo update_senhor.sh nao encontrado em: $SCRIPT_DIR"
[ -r "$TARGET_FILE" ] || fail "No permission to read: $TARGET_FILE / Sem permissao para ler: $TARGET_FILE"
[ -w "$TARGET_FILE" ] || fail "No permission to modify: $TARGET_FILE / Sem permissao para alterar: $TARGET_FILE"

command -v awk >/dev/null 2>&1 || fail "awk not found / awk nao encontrado"
command -v cp >/dev/null 2>&1 || fail "cp not found / cp nao encontrado"
command -v grep >/dev/null 2>&1 || fail "grep not found / grep nao encontrado"
command -v mv >/dev/null 2>&1 || fail "mv not found / mv nao encontrado"
command -v cmp >/dev/null 2>&1 || fail "cmp not found / cmp nao encontrado"

check_count=$(grep -c '^[[:space:]]*check_internet[[:space:]]*()[[:space:]]*{' "$TARGET_FILE" || true)
next_count=$(grep -c '^[[:space:]]*check_for_updates[[:space:]]*()[[:space:]]*{' "$TARGET_FILE" || true)

[ "$check_count" -eq 1 ] || fail "Expected exactly 1 check_internet() function, found: $check_count / Esperava encontrar exatamente 1 funcao check_internet(), encontrei: $check_count"
[ "$next_count" -eq 1 ] || fail "Expected exactly 1 check_for_updates() function, found: $next_count / Esperava encontrar exatamente 1 funcao check_for_updates(), encontrei: $next_count"

cp -p "$TARGET_FILE" "$BACKUP_FILE" || fail "Could not create backup: $BACKUP_FILE / Nao foi possivel criar backup: $BACKUP_FILE"

set +e
awk '
function print_fixed_check_internet() {
    print "check_internet() {"
    print "    log \"Checking internet connection...\""
    print "    log \"Verificando conexao com a internet...\""
    print ""
    print "    if ping -4 -q -c 1 -W 3 1.1.1.1 >/dev/null 2>&1 || \\"
    print "       ping -4 -q -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then"
    print "        log \"Internet connection is available.\" SUCCESS"
    print "        log \"Conexao com a internet disponivel.\" SUCCESS"
    print "        return 0"
    print "    fi"
    print ""
    print "    if wget -q --spider --timeout=5 https://www.google.com/generate_204; then"
    print "        log \"Internet connection is available.\" SUCCESS"
    print "        log \"Conexao com a internet disponivel.\" SUCCESS"
    print "        return 0"
    print "    fi"
    print ""
    print "    log \"No internet connection detected.\" ERROR"
    print "    log \"Nenhuma conexao com a internet detectada.\" ERROR"
    print "    echo"
    print "    echo -e \"                  ████████████████████                                         \""
    print "    echo -e \"                  ████  ██████████████████                                     \""
    print "    echo -e \"                  ████████████████████████                                     \""
    print "    echo -e \"                  ████████████████████████                                     \""
    print "    echo -e \"                  ████████████████████████                                     \""
    print "    echo -e \"                  ████████████████████████                                     \""
    print "    echo -e \"██                ████████████                                                 \""
    print "    echo -e \"██                ████████████████████                                         \""
    print "    echo -e \"██              ██████████████                                                 \""
    print "    echo -e \"████        ██████████████████                          ██                     \""
    print "    echo -e \"██████    ████████████████████████                    ██████                   \""
    print "    echo -e \"██████████████████████████████  ██                ██  ██████  ██               \""
    print "    echo -e \"██████████████████████████████                    ██████████████               \""
    print "    echo -e \"    ██████████████████████████                        ██████                   \""
    print "    echo -e \"      ██████████████████████                          ██████                   \""
    print "    echo -e \"        ██████████████████                            ██████                   \""
    print "    echo -e \"          ████████████████                            ██████                   \""
    print "    echo -e \"███████████████████████████████████████████████████████████████████████████████\""
    print "    echo -e \"            ██████  ████                              ██████                   \""
    print "    echo -e \"            ████      ██                                                       \""
    print "    echo -e \"      ████  ██        ██                                          ████         \""
    print "    echo -e \"████        ████      ████        ████                                         \""
    print "    echo -e \"                                                  ██          ████      ████   \""
    print "    echo -e \"${C_RED}  ╔════════════════════════════════════════════════════╗${C_RESET}\""
    print "    echo -e \"${C_RED}  ║        ✖  No Internet Connection                  ║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║        ✖  Sem conexao com a internet              ║${C_RESET}\""
    print "    echo -e \"${C_RED}  ╠════════════════════════════════════════════════════╣${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Check your WiFi/Ethernet cable           ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Verifique seu WiFi/cabo Ethernet         ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Verify DNS (try 8.8.8.8 / 1.1.1.1)       ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Verifique o DNS (8.8.8.8 / 1.1.1.1)      ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Check for a firewall or blocked network  ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ║${C_RESET}  ${C_YELLOW}▸${C_RESET} Verifique firewall ou rede bloqueada      ${C_RED}║${C_RESET}\""
    print "    echo -e \"${C_RED}  ╚════════════════════════════════════════════════════╝${C_RESET}\""
    print "    echo"
    print "    read -p \"  Press Enter to exit / Pressione Enter para sair...\""
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
    fail "Could not find check_internet() / Nao foi possivel encontrar check_internet()"
fi

if [ "$awk_status" -eq 11 ]; then
    fail "Could not find check_for_updates() after check_internet() / Nao foi possivel encontrar check_for_updates() apos check_internet()"
fi

[ "$awk_status" -eq 0 ] || fail "Failed to generate fixed file / Falha ao gerar arquivo corrigido"
[ -s "$TEMP_FILE" ] || fail "Temporary file is empty; aborting / Arquivo temporario ficou vazio; abortando"

if cmp -s "$TARGET_FILE" "$TEMP_FILE"; then
    rm -f "$TEMP_FILE"
    echo "No changes needed."
    echo "Nenhuma alteracao necessaria."
    echo "Backup created at: $BACKUP_FILE"
    echo "Backup criado em: $BACKUP_FILE"
    exit 0
fi

mv "$TEMP_FILE" "$TARGET_FILE" || fail "Could not update update_senhor.sh / Nao foi possivel atualizar update_senhor.sh"
chmod +x "$TARGET_FILE" 2>/dev/null || true

echo "check_internet() function updated successfully."
echo "Funcao check_internet() atualizada com sucesso."
echo "Backup created at: $BACKUP_FILE"
echo "Backup criado em: $BACKUP_FILE"
