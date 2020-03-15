#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg

echo  ""
echo "########################################"
echo "### Eliminando directorios existentes ##"
echo "########################################"

rm -rf ${RUTA_TEMP}
rm -rf ${RUTA_DOCKER}
rm -rf ${RUTA_TIENDA}

