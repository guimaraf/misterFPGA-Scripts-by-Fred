#!/bin/bash

INI="/media/fat/MiSTer.ini"

if [ ! -f "$INI" ]; then
  echo "Arquivo $INI não encontrado!"
  exit 1
fi

# lê a linha vsync_adjust
VALOR=$(grep -E '^vsync_adjust=' "$INI" | sed 's/.*=//')

if [[ -z "$VALOR" ]]; then
  echo "vsync_adjust não está definido no arquivo .ini"
  exit 1
fi

# Mostra o valor com destaque usando OSDutils (se instalado) ou echo simples
echo "=============================="
echo "      vsync_adjust = $VALOR      "
echo "=============================="

# Se quiser usar OSD — depende se o utilitário está disponível
if [ -x /media/fat/Scripts/OSDutils ]; then
  /media/fat/Scripts/OSDutils "vsync_adjust = $VALOR" 5  # ex: 5 segundos
fi

exit 0