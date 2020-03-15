#!/bin/bash

clear

# Importa variables
        source ./00000-entorno.cfg
        source ./funciones.sh
export FICHERO_LOG=${RUTA_LOGS}/log_${DOMINIO_TIENDA}.${ID_UNICO_PROCESO}.log


# COMIENZO DE LOG
# COMPROBACON DE PARAMETROS
log "######################################"
log "# COMIENZO DEL DESPLIEGUE DEL DOCKER "
log "######################################"
log ""
log ""
log "# LANZADOR ........"

ENTORNO=`echo "$2"|tr "[:upper:]" "[:lower:]"`
ENTORNO_UPPER=`echo "$2"|tr "[:lower:]" "[:upper:]"`
ES_SSL=$1

if [ "$1" == "SSL" ];
then
        export PUERTO_SSL="443"
	check_443
        export SUFIJO_NOMBRE_CONTENEDOR="-ssl"
	export VIRTUAL_PROTO="https"
	export VIRTUAL_PORT="443"
	export PARAM_PUERTO_SSL="-p ${PUERTO_SSL}:443"
        export PARAM_VIRTUAL_PROTO="-e VIRTUAL_PROTO=${VIRTUAL_PROTO}"
        export PARAM_VIRTUAL_PORT="-e VIRTUAL_PORT=${VIRTUAL_PORT}"
        export PARAM_RUTA_SSL="-v ${RUTA_SSL}:/etc/apache2/ssl"

        export PARAM_VIRTUAL_PROTO="- VIRTUAL_PROTO=${VIRTUAL_PROTO}"
	export PARAM_VIRTUAL_PORT="- VIRTUAL_PORT=${VIRTUAL_PORT}"

	#log "...el protocolo es SSL"
	#echo "--> Se ha seleccionado como SSL"
        # Comprobamos que entorno es el elegido
        if [ "$2" == "PROD" ];
        then
	#	echo "--> Se ha seleccionado el entorno de PRODUCCION"
	#	log "...entorno de PRODUCCION"
                export URL_TIENDA=${URL_TIENDA}
                #echo "La url es: ${URL_TIENDA}"
	#	log "...la URL es: ${URL_TIENDA}"
        elif [ "$2" == "TEST" ];
        then
	#	log "...entorno de TEST"
                #echo "--> Se ha seleccionado el entorno de TEST"
                export URL_TIENDA=${URL_TIENDA_TEST}
	#	log "...la URL es: ${URL_TIENDA}"
                #echo "La url es: ${URL_TIENDA}"
        else
                exit 122
        fi
        export HOST_CERT_SSL=${HOST_BACKUP_CONN}/${URL_TIENDA}

elif [ "$1" == "noSSL" ];
then
        PUERTO_SSL=""
        export SUFIJO_NOMBRE_CONTENEDOR="-no-ssl"
        export VIRTUAL_PROTO=""
        export VIRTUAL_PORT=""
        export PARAM_PUERTO_SSL=""
        export PARAM_VIRTUAL_PROTO=""
        export PARAM_VIRTUAL_PORT=""
        export PARAM_RUTA_SSL=""
	#echo "--> Se ha seleccionado como NO SSL"
	#log "...el protocolo es NO SSL"
        # Comprobamos que entorno es el elegido
        if [ "$2" == "PROD" ];
        then
                #echo "--> Se ha seleccionado el entorno de PRODUCCION"
                export URL_TIENDA=${URL_TIENDA}
                #echo "La url es: ${URL_TIENDA}"
	#	log "...entorno de PRODUCCION"
	#	log "...la URL es: ${URL_TIENDA}"
         elif [ "$2" == "TEST" ];
        then
                #echo "--> Se ha seleccionado el entorno de TEST"
                export URL_TIENDA=${URL_TIENDA_TEST}
                #echo "La url es: ${URL_TIENDA}"
        #        log "...entorno de TEST"
        #        log "...la URL es: ${URL_TIENDA}"
         else
                mensaje_no_parametros
                exit 122
        fi

else
        sintaxis
        exit 122
fi

if [ "$3" == "NUEVA" ];
then
     export ES_NUEVA_INSTALACION="NUEVA"
else
     export ES_NUEVA_INSTALACION=""
fi
 

export ES_SSL ENTORNO_UPPER PUERTO_SSL ENTORNO SUFIJO_NOMBRE_CONTENEDOR
log "#############################################"
log "##                                         "
log "##         PARAMETROS DE EJECUCION         "
log "##         -----------------------         "
log "##                                         "
log "##   Entorno	: ${ENTORNO_UPPER}"
log "##   SSL		: ${ES_SSL}"
log "##   Puerto SSL	: ${PUERTO_SSL}"
log "##   URL		: ${URL_TIENDA}"
log "##                                         "
log "#############################################"

#echo "Voy a lanzar con: "
#echo "ENTORNO_UPPER: ${ENTORNO_UPPER}"
#echo "ES_SSL=${ES_SSL}"
#echo "PUERTO_SSL=${PUERTO_SSL}"
#echo "URL_TIENDA=${URL_TIENDA}"

./reiniciadockers

./1000-genera-docker.sh ${ES_SSL} ${ENTORNO_UPPER}




