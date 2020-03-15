#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg

	cd ${RUTA_IMAGENES}

	tar -zcf imagenes.tar.gz .
	mv ${PROD_RUTA_WEB}/imagenes.tar.gz ${PROD_RUTA_WEB}/imagenes.tar.gz.${ID_UNICO_PROCESO}
	mv imagenes.tar.gz ${PROD_RUTA_WEB}



