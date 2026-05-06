#!/bin/bash

NTP_SERVERS="
a.ntp.br
b.ntp.br
c.ntp.br
0.pool.ntp.org
1.pool.ntp.org
time.cloudflare.com
time.google.com
time.windows.com
"

sync_ok=false
used_server=""

clear
echo
echo "  RTC date/time update"
echo "  Atualizacao de data/hora do RTC"
echo

if ! command -v ntpdate >/dev/null 2>&1; then
    echo "  ERROR: ntpdate not found."
    echo "  ERRO: ntpdate nao encontrado."
    sleep 5
    exit 1
fi

for server in $NTP_SERVERS; do
    echo "  Trying NTP server: $server"
    echo "  Tentando servidor NTP: $server"

    if ntpdate -s -b -u "$server"; then
        sync_ok=true
        used_server="$server"
        break
    fi

    echo "  Failed / Falhou"
    echo
done

if [ "$sync_ok" != true ]; then
    echo
    echo "  ERROR: unable to sync date and time."
    echo "  ERRO: nao foi possivel sincronizar data e hora."
    echo
    echo "  Possible causes:"
    echo "  Possiveis causas:"
    echo
    echo "  - No Internet connection"
    echo "  - Sem conexao com a Internet"
    echo "  - DNS problem"
    echo "  - Problema de DNS"
    echo "  - NTP blocked by ISP/router/firewall"
    echo "  - NTP bloqueado pela operadora/roteador/firewall"
    sleep 8
    exit 1
fi

echo
echo "  Date and time synced successfully."
echo "  Data e hora sincronizadas com sucesso."
echo
echo "  Server / Servidor: $used_server"
echo "  Date / Data      : $(date)"
echo

if [ ! -e /dev/rtc0 ] && [ ! -e /dev/rtc ] && [ ! -e /dev/misc/rtc ]; then
    echo "  RTC hardware not found."
    echo "  RTC fisico nao encontrado."
    echo
    echo "  System time was updated, but it cannot be saved to RTC."
    echo "  A hora do sistema foi atualizada, mas nao pode ser gravada no RTC."
    sleep 8
    exit 0
fi

if ! command -v hwclock >/dev/null 2>&1; then
    echo "  WARNING: hwclock not found."
    echo "  AVISO: hwclock nao encontrado."
    echo
    echo "  System time was updated, but it cannot be saved to RTC."
    echo "  A hora do sistema foi atualizada, mas nao pode ser gravada no RTC."
    sleep 8
    exit 0
fi

mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
[ "$RO_ROOT" == "true" ] && mount / -o remount,rw

if hwclock -wu; then
    echo "  RTC set successfully."
    echo "  RTC ajustado com sucesso."
    result=0
else
    echo "  ERROR: unable to set the RTC."
    echo "  ERRO: nao foi possivel ajustar o RTC."
    result=1
fi

[ "$RO_ROOT" == "true" ] && mount / -o remount,ro

sleep 5
exit "$result"
