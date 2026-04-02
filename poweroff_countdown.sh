#!/bin/sh
# =============================================================================
# Nome:        poweroff_countdown.sh
# Descrição:   Desliga o MiSTer com segurança após uma contagem regressiva.
#              Exibe mensagem em fonte grande. Pressionar botão cancela.
#
# Versão:      2.1
# Data:        2026-04-01
# Autor:       (Fred Oliveira)
#
# Instalação:  /media/fat/Scripts  (aparece no menu System → Scripts)
# Uso:         poweroff_countdown.sh [SEGUNDOS]   # padrão: 10
#
# Notas:
#  - Pressionar qualquer botão do controle cancela o desligamento.
#  - Faz 'sync' antes de desligar para garantir flush dos dados no SD.
#  - Usa fonte maior (solar24x32) para melhor leitura na TV/monitor.
#  - Restaura a fonte padrão ao encerrar (cancelado ou após desligar).
# =============================================================================

SEC="${1:-10}"
case "$SEC" in ''|*[!0-9]*) echo "Uso: $0 [segundos]"; exit 1;; esac

CANCEL_FLAG="/tmp/_poweroff_cancel_$$"
JS_DEV="/dev/input/js0"
FONT_BIG="/usr/share/consolefonts/solar24x32.psfu.gz"

# Salva o estado atual do terminal para restaurar ao sair
STTY_SAVE=$(stty -g 2>/dev/null)

# -----------------------------------------------------------------------------
# Limpeza ao sair (qualquer saída: normal, cancelamento, sinal)
# -----------------------------------------------------------------------------
cleanup() {
    # Restaura o estado original do terminal (echo, modo canônico, etc.)
    [ -n "$STTY_SAVE" ] && stty "$STTY_SAVE" 2>/dev/null
    setfont 2>/dev/null
    rm -f "$CANCEL_FLAG"
    [ -n "$JS_PID" ] && kill "$JS_PID" 2>/dev/null
}
trap cleanup EXIT INT TERM

# Desabilita o echo: impede que teclas do gamepad (mapeadas como teclado)
# apareçam na tela durante a contagem regressiva
stty -echo 2>/dev/null

# -----------------------------------------------------------------------------
# Fonte maior para facilitar a leitura na tela
# -----------------------------------------------------------------------------
setfont "$FONT_BIG" 2>/dev/null

# -----------------------------------------------------------------------------
# Monitor de gamepad em background
# Lê eventos brutos de /dev/input/js0 e sinaliza cancelamento ao apertar botão.
#
# Formato do evento joystick (8 bytes):
#   [0-3] timestamp   [4-5] value   [6] type   [7] number
#
# Tipo 0x01 = botão; bit 0x80 setado no tipo = evento de inicialização (ignorar)
# value_lsb = 01 → botão pressionado; 00 → botão solto
# -----------------------------------------------------------------------------
watch_gamepad() {
    while true; do
        hex=$(dd if="$JS_DEV" bs=8 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')
        [ -z "$hex" ] && break

        # Byte 6 = tipo do evento (índice 12-13 na string hex sem espaços)
        type_byte="${hex:12:2}"

        # Eventos de inicialização têm bit 0x80 setado (tipo começa com '8')
        case "$type_byte" in
            8*) continue ;;
        esac

        # Tipo 0x01 = evento de botão
        if [ "$type_byte" = "01" ]; then
            # value LSB (índice 8-9): 01 = pressionado
            [ "${hex:8:2}" = "01" ] && touch "$CANCEL_FLAG" && break
        fi
    done
}

if [ -e "$JS_DEV" ]; then
    watch_gamepad &
    JS_PID=$!
fi

# -----------------------------------------------------------------------------
# Loop de contagem regressiva
# Dupla verificação: gamepad (via arquivo de sinalização) + teclado (via read)
# O "MiSTer virtual input" mapeia botões do gamepad para teclado no terminal,
# então o 'read' também captura entradas do controle.
# -----------------------------------------------------------------------------
i="$SEC"
while [ "$i" -gt 0 ]; do
    clear
    printf "\n\n"
    printf "  DESLIGANDO O MiSTer\n"
    printf "\n"
    printf "  Em %2d segundo(s)...\n" "$i"
    printf "\n"
    printf "  Aperte qualquer botao\n"
    printf "  do controle para CANCELAR\n"

    [ -f "$CANCEL_FLAG" ] && break

    # Aguarda 1 segundo por qualquer tecla (teclado ou controle mapeado)
    if read -t 1 -n 1 2>/dev/null; then
        touch "$CANCEL_FLAG"
        break
    fi

    [ -f "$CANCEL_FLAG" ] && break
    i=$((i - 1))
done

# -----------------------------------------------------------------------------
# Desligamento cancelado
# -----------------------------------------------------------------------------
if [ -f "$CANCEL_FLAG" ]; then
    clear
    printf "\n\n"
    printf "  CANCELADO!\n"
    printf "\n"
    printf "  Voltando ao menu...\n"
    sleep 2
    # Remove os traps para evitar dupla limpeza, faz cleanup manual e
    # mata o processo pai (terminal do MiSTer) para voltar ao menu
    # sem exibir o prompt "pressione qualquer botao".
    trap - EXIT INT TERM
    cleanup
    kill -9 $PPID 2>/dev/null
    exit 0
fi

# -----------------------------------------------------------------------------
# Prosseguir com o desligamento
# -----------------------------------------------------------------------------
clear
printf "\n\n"
printf "  Sincronizando dados...\n"
sync

printf "\n"
printf "  Seguro para desligar.\n"
sleep 2

if command -v poweroff >/dev/null 2>&1; then
    exec poweroff
elif command -v shutdown >/dev/null 2>&1; then
    exec shutdown -h now
else
    exec busybox poweroff
fi
