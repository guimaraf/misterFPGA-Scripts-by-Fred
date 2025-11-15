#!/bin/bash
INI="/media/fat/MiSTer.ini"
BKP_DIR="/media/fat/iniBkp"
BACKUP="$BKP_DIR/backupMister.ini"

mkdir -p "$BKP_DIR"

echo "Backupando MiSTer.ini para $BACKUP"
cp "$INI" "$BACKUP"

echo "Definindo vsync_adjust=2"
sed -i "s/^vsync_adjust=[0-2]/vsync_adjust=2/" "$INI"

echo "Pronto. Reinicie o sistema para ativar o novo valor."