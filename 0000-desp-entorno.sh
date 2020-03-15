#!/bin/bash

echo "      "
echo "#################################################"
echo "##  DESPLEGANDO ENTORNO ...........           ###"
echo "#################################################"
echo "      "

#################################################
# Importa variables
#################################################

  	source ./00000-entorno.cfg
	source ./funciones.sh

#################################################
# Elimina el entorno existente
#################################################
	
	./00001-des-entorno-borra.sh

#################################################
# Creacion de usuarios si es que no existen
#################################################
echo  ""
echo "########################################"
echo "###    CREANDO USUARIOS NECESARIOS    ##"
echo "########################################"
echo ""

echo "Creado usuario para mysql: ${USUARIO_MYSQL} ..."
	existe_usuario ${USUARIO_MYSQL}
	tmp_user=$?
	if [ ${tmp_user} == 1 ] 
	then
		echo "      ### El usuario ${USUARIO_MYSQL} existe.. OK!"
	else
		echo "### El usuario ${USUARIO_MYSQL} NO EXISTE....creando usuario "
		adduser ${USUARIO_MYSQL}
	fi

echo "Creado usuario para web: ${USUARIO_WEB} ..."
        existe_usuario ${USUARIO_WEB}
        tmp_user=$?
        if [ ${tmp_user} == 1 ]
        then
                echo "      ### El usuario ${USUARIO_WEB} existe.. OK!"
        else
                echo "### El usuario ${USUARIO_WEB} NO EXISTE....creando usuario "
                adduser ${USUARIO_WEB}
        fi

echo "Creado usuario para acceso: ${USUARIO_ACCESO} ..."
        existe_usuario ${USUARIO_ACCESO}
        tmp_user=$?
        if [ ${tmp_user} == 1 ]
        then
                echo "      ### El usuario ${USUARIO_ACCESO} existe.. OK!"
        else
                echo "### El usuario ${USUARIO_ACCESO} NO EXISTE....creando usuario "
                adduser ${USUARIO_ACCESO}
        fi


#################################################
# Creacion de las carpetas principales
#################################################
	echo "## Creando las rutas nuevas....en ${RUTA_DESPLIEGUE}"
        cd ${RUTA_DESPLIEGUE_BASE}
	mkdir ${RUTA_DESPLIEGUE}
        mkdir ${RUTA_DESPLIEGUE}/docker
	mkdir ${RUTA_DESPLIEGUE}/docker/web
	mkdir ${RUTA_DESPLIEGUE}/docker/bbdd
        mkdir ${RUTA_DESPLIEGUE}/tienda
        mkdir ${RUTA_DESPLIEGUE}/tienda/imagenes
	mkdir ${RUTA_DESPLIEGUE}/backup_dockers
	mkdir ${RUTA_DESPLIEGUE}/logs
#################################################
# Creación de la carpeta temporal para recuperar la copia
#################################################
        mkdir ${RUTA_TEMP}



