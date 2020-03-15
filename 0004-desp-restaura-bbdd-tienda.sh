#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg

echo  ""
echo "###################################################"
echo "### RESTAURANDO ESTRUCTURA Base de Datos  TIENDA ##"
echo "###################################################"
echo ""

# Extraccion de componentes

        tar xfz ${RUTA_TEMP}/${FX_RESTORE}/*.${FILE_BACKUP_BBDD_TIENDA} --strip-components=3 -C  ${RUTA_TIENDA}
	chmod 777 -R ${RUTA_TIENDA}

# temporalmente para poder hacer pruebas
        rm -rf ${RUTA_DESPLIEGUE}/tienda/test-bbdd
        cp -r ${RUTA_DESPLIEGUE}/tienda/prod-bbdd ${RUTA_DESPLIEGUE}/tienda/test-bbdd
	chmod 777 -R  ${RUTA_DESPLIEGUE}/tienda/test-bbdd

