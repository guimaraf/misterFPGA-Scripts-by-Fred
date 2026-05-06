#!/bin/sh

MAIN_FILE="/media/fat/MiSTer"
LIMIT_BYTES=1100000

clear
printf "\n"
printf "  MiSTer main file check\n"
printf "  Verificacao do arquivo principal MiSTer\n"
printf "\n"
printf "  File / Arquivo: %s\n" "$MAIN_FILE"
printf "\n"

if [ ! -f "$MAIN_FILE" ]; then
    printf "  ERROR: MiSTer file not found.\n"
    printf "  ERRO: arquivo MiSTer nao encontrado.\n"
    sleep 5
    exit 1
fi

if command -v stat >/dev/null 2>&1; then
    SIZE_BYTES=$(stat -c %s "$MAIN_FILE" 2>/dev/null)
else
    SIZE_BYTES=$(wc -c < "$MAIN_FILE" 2>/dev/null)
fi

case "$SIZE_BYTES" in
    ''|*[!0-9]*)
        printf "  ERROR: could not read file size.\n"
        printf "  ERRO: nao foi possivel ler o tamanho do arquivo.\n"
        sleep 5
        exit 1
        ;;
esac

printf "  Size / Tamanho: %s bytes\n" "$SIZE_BYTES"
printf "\n"

if [ "$SIZE_BYTES" -lt "$LIMIT_BYTES" ]; then
    printf "  MiSTer Original\n"
else
    printf "  MiSTer Archiviements\n"
fi

sleep 5
exit 0
