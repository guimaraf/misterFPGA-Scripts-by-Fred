#!/bin/sh

SOURCE="/media/fat/!mainBKP/RetroArchiviements/MiSTer"
DEST="/media/fat/MiSTer"
TEMP_DEST="/media/fat/MiSTer.tmp.$$"
MIN_RETRO_BYTES=1100000

cleanup() {
    [ -f "$TEMP_DEST" ] && rm -f "$TEMP_DEST"
}

trap cleanup EXIT INT TERM

get_file_size() {
    if command -v stat >/dev/null 2>&1; then
        stat -c %s "$1" 2>/dev/null
    else
        wc -c < "$1" 2>/dev/null
    fi
}

validate_retro_size() {
    size=$(get_file_size "$1")
    case "$size" in
        ''|*[!0-9]*) return 1 ;;
    esac

    [ "$size" -gt "$MIN_RETRO_BYTES" ]
}

force_reboot() {
    sync
    sleep 2
    clear
    printf "\n"
    printf "  Copy completed successfully.\n"
    printf "  Copia concluida com sucesso.\n"
    printf "\n"
    printf "  Rebooting MiSTer now...\n"
    printf "  Reiniciando o MiSTer agora...\n"
    printf "\n"
    printf "  The new file version will be loaded on next boot.\n"
    printf "  A nova versao do arquivo sera carregada no proximo boot.\n"
    sleep 3

    if command -v reboot >/dev/null 2>&1; then
        reboot -f
    fi

    if command -v busybox >/dev/null 2>&1; then
        busybox reboot -f
    fi

    clear
    printf "\n"
    printf "  ERROR: automatic reboot failed.\n"
    printf "  ERRO: nao foi possivel reiniciar automaticamente.\n"
    printf "\n"
    printf "  Reboot MiSTer manually to apply the change.\n"
    printf "  Reinicie o MiSTer manualmente para aplicar a troca.\n"
    sleep 5
    exit 1
}

clear
printf "\n"
printf "  MiSTer file switch\n"
printf "  Troca do arquivo MiSTer\n"
printf "\n"
printf "  Source / Origem      : %s\n" "$SOURCE"
printf "  Destination / Destino: %s\n" "$DEST"
printf "  Temporary / Temporario : %s\n" "$TEMP_DEST"
printf "\n"

if [ ! -f "$SOURCE" ]; then
    printf "  ERROR: source file not found.\n"
    printf "  ERRO: arquivo de origem nao encontrado.\n"
    printf "\n"
    printf "  Check if this file exists:\n"
    printf "  Verifique se existe o arquivo:\n"
    printf "  %s\n" "$SOURCE"
    sleep 5
    exit 1
fi

printf "  The RetroArch support file will be copied to the fat folder.\n"
printf "  O arquivo com suporte RetroArch sera copiado para a pasta fat.\n"
printf "\n"
printf "  The current MiSTer file will be replaced.\n"
printf "  O arquivo MiSTer atual sera substituido.\n"
printf "\n"
printf "  Please wait 5 seconds...\n"
printf "  Aguarde 5 segundos...\n"
sleep 5

clear
printf "\n"
printf "  Copying RetroArch support file...\n"
printf "  Copiando arquivo com suporte RetroArch...\n"
printf "\n"

if cp -f "$SOURCE" "$TEMP_DEST" && sync && validate_retro_size "$TEMP_DEST" && mv -f "$TEMP_DEST" "$DEST"; then
    force_reboot
fi

clear
printf "\n"
printf "  ERROR: could not copy the file.\n"
printf "  ERRO: nao foi possivel copiar o arquivo.\n"
printf "\n"
printf "  Source / Origem      : %s\n" "$SOURCE"
printf "  Destination / Destino: %s\n" "$DEST"
printf "\n"
printf "  The RetroArch file must be larger than 1.1 MB.\n"
printf "  O arquivo RetroArch precisa ser maior que 1.1 MB.\n"
sleep 5
exit 1
