#!/bin/sh

URL="https://raw.githubusercontent.com/turri21/Senhor/main/Scripts/update_senhor.sh"
TARGET="/media/fat/Scripts/update_senhor.sh"
BACKUP="${TARGET}.bak.$(date +%Y%m%d-%H%M%S)"
TEMP_FILE="/tmp/update_senhor.sh.$$"

cleanup() {
    [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
}

trap cleanup EXIT INT TERM

fail() {
    clear
    printf "\n"
    printf "  ERROR: %s\n" "$*"
    printf "  ERRO: %s\n" "$*"
    sleep 5
    exit 1
}

clear
printf "\n"
printf "  Restore update_senhor.sh\n"
printf "  Restaurar update_senhor.sh\n"
printf "\n"
printf "  Source / Origem      : %s\n" "$URL"
printf "  Destination / Destino: %s\n" "$TARGET"
printf "\n"
printf "  The current file will be replaced.\n"
printf "  O arquivo atual sera substituido.\n"
printf "\n"
printf "  Please wait 5 seconds...\n"
printf "  Aguarde 5 segundos...\n"
sleep 5

command -v wget >/dev/null 2>&1 || fail "wget not found / wget nao encontrado"

[ -d "$(dirname "$TARGET")" ] || fail "target folder not found / pasta de destino nao encontrada"

clear
printf "\n"
printf "  Downloading update_senhor.sh...\n"
printf "  Baixando update_senhor.sh...\n"
printf "\n"

wget -q --tries=3 --timeout=15 "$URL" -O "$TEMP_FILE" || fail "download failed / falha no download"

[ -s "$TEMP_FILE" ] || fail "downloaded file is empty / arquivo baixado esta vazio"

if ! grep -q '^#!/bin/bash' "$TEMP_FILE"; then
    fail "downloaded file does not look valid / arquivo baixado nao parece valido"
fi

if [ -f "$TARGET" ]; then
    cp -p "$TARGET" "$BACKUP" || fail "could not create backup / nao foi possivel criar backup"
fi

cp "$TEMP_FILE" "$TARGET" || fail "could not replace target file / nao foi possivel substituir o arquivo"
chmod +x "$TARGET" 2>/dev/null || true
sync

clear
printf "\n"
printf "  update_senhor.sh restored successfully.\n"
printf "  update_senhor.sh restaurado com sucesso.\n"
printf "\n"
if [ -f "$BACKUP" ]; then
    printf "  Backup / Backup: %s\n" "$BACKUP"
fi
sleep 5
exit 0
