#!/bin/bash
# mibox.sh - Si/No box demo
dialog --title "Borrar archivo" \
--backtitle "Sololinux.es Script de Ejemplo" \
--yesno "Quieres borrar permanentemente el archivo \"/tmp/archivo.txt\"?" 7 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in
   0) echo "Archivo borrado.";;
   1) echo "Archivo no borrado.";;
   255) echo "[ESC] key pressed.";;
esac

