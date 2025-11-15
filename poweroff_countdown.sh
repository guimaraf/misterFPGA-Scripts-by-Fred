#!/bin/sh
# =============================================================================
# Nome:        poweroff_countdown_sh
# Descrição:   Desliga o MiSTer com segurança após uma contagem regressiva.
#              Exibe mensagem final informando que já é seguro desligar.
#
# Versão:      1.2
# Data:        2025-08-19
# Autor:       (Fred Oliveira)
#
# Instalação:  /media/fat/Scripts  (aparece no menu System → Scripts)
# Uso:         poweroff_countdown_sh [SEGUNDOS]   # padrão: 10
#
# Notas:
#  - Sem interação/cancelamento (ideal para uso apenas com gamepad).
#  - Faz 'sync' antes de desligar para garantir flush dos dados no SD.
# =============================================================================

SEC="${1:-10}"
case "$SEC" in ''|*[!0-9]*) echo "Uso: $0 [segundos]"; exit 1;; esac

echo "O sistema será desligado em $SEC segundo(s)."
i="$SEC"
while [ "$i" -gt 0 ]; do
  printf "\rDesligando em %2ds... " "$i"
  sleep 1
  i=$((i-1))
done
echo
echo "Sincronizando dados..."
sync

echo
echo "O MiSTer pode ser desligado com segurança."
echo "A tela pode permanecer estática; os comandos já foram desabilitados e"
echo "os dados foram sincronizados (cartão SD preparado)."
sleep 2

# Desliga usando o que estiver disponível
if command -v poweroff >/dev/null 2>&1; then
  exec poweroff
elif command -v shutdown >/dev/null 2>&1; then
  exec shutdown -h now
else
  exec busybox poweroff
fi
