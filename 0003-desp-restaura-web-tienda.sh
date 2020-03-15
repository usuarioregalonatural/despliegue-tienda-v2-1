#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg

echo  ""
echo "########################################"
echo "### RESTAURANDO ESTRUCTURA WEB TIENDA ##"
echo "########################################"
echo ""

# Extraccion de componentes

        tar xfz ${RUTA_TEMP}/${FX_RESTORE}/*.${FILE_BACKUP_WEB_TIENDA} --strip-components=3 -C  ${RUTA_TIENDA}
	chmod 777 -R ${RUTA_TIENDA}

# temporalmente para poder hacer pruebas
	rm -rf ${RUTA_DESPLIEGUE}/tienda/test-web
	cp -r ${RUTA_DESPLIEGUE}/tienda/prod-web ${RUTA_DESPLIEGUE}/tienda/test-web
	chmod 777 -R ${RUTA_DESPLIEGUE}/tienda/test-web

