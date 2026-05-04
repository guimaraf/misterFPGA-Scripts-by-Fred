#!/bin/bash

INI="/media/fat/MiSTer.ini"

if [ ! -f "$INI" ]; then
  echo "File $INI not found!"
  echo "Arquivo $INI nao encontrado!"
  exit 1
fi

# Read the vsync_adjust line.
VALOR=$(grep -E '^vsync_adjust=' "$INI" | sed 's/.*=//')

if [[ -z "$VALOR" ]]; then
  echo "vsync_adjust is not defined in the .ini file"
  echo "vsync_adjust nao esta definido no arquivo .ini"
  exit 1
fi

# Show the value using OSDutils if available, or plain echo otherwise.
echo "=============================="
echo "      vsync_adjust = $VALOR"
echo "      Current value / Valor atual"
echo "=============================="

if [ -x /media/fat/Scripts/OSDutils ]; then
  /media/fat/Scripts/OSDutils "vsync_adjust = $VALOR | Current value / Valor atual" 5
fi

exit 0
