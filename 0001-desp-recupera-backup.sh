#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg


echo  ""
echo "########################################"
echo "### RECUPERANDO BACKUP COMPLETO TIENDA ##"
echo "########################################"
echo ""

# Recuperacion de la copia del docker de la tienda

	# Descomentar la siguiente linesa para realizar la descarga del backup desde remoto
        #scp -r -P ${HOST_BACKUP_PUERTO} ${HOST_BACKUP_NOMBRE}:${HOST_BACKUP_RUTA} ${RUTA_TEMP}
        scp -r -P ${HOST_BACKUP_PUERTO} ${HOST_BACKUP_NOMBRE}:${FILEUSERCONNECT} ${RUTA_TEMP}

	# Comentar para realizar la descarga del backup desde remoto
#	cp -r /home/temp/20191116 ${RUTA_TEMP}
	cd ${RUTA_TIENDA}

### solo para recuperar una existente en GIT
### para una en blanco comentar las dos siguientes lineas
	git clone ${GIT_TIENDA_WEB} # solo para recuperar una existente en git
        mv ${WEB_GIT} web-prod # solo para recuperar una existente en git


#	mkdir web-prod #solo para utilizar una web en blanco	


#	git clone https://github.com/usuarioregalonatural/web-prod.git
	cd -

