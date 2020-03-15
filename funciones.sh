#!/bin/bash

# Importa variables

        source ./00000-entorno.cfg

tmpusuario=${USUARIO_ACCESO}

# Comprobar la existencia de un usuario

existe_usuario () {
	usuario=`cat /etc/passwd|cut -d: -f1|grep -i $1`
	if [ "${usuario}" == "$1" ]
	then 
		return 1

	else
		return 0
	fi
            
}


parsea_dominio () {
	userpass_web
	log "## "
	log "## Parseando valores...."
	log "##"
	log "## "
	 if [ ${ES_SSL} = "SSL" ]
	 then
   		echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/mysql-ssl.sql.template |sed 's/value=0/value=1/g' > ${RUTA_DOCKER_BBDD}/mysql-ssl.sql`
    		echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/000-default.conf.SSL.template > ${RUTA_DOCKER_WWW}/000-default.conf`
    		#echo `sed 's/VAR_SSL/''/g' ${RUTA_TEMPLATES_DOCKER}/Dockerfile.template|sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' > ${RUTA_DOCKER}/Dockerfile`
    		echo `sed 's/VAR_SSL/''/g' ${RUTA_TEMPLATES_DOCKER}/Dockerfile-Web.template|sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g'|sed 's/VAR_IMAGEN_BASE_WWW/'"${IMAGEN_BASE_WWW}"'/g' > ${RUTA_DOCKER_WWW}/Dockerfile`
  	else 
    		echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/mysql-ssl.sql.template |sed 's/value=1/value=0/g' > ${RUTA_DOCKER_BBDD}/mysql-ssl.sql`
    		echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/000-default.conf.noSSL.template > ${RUTA_DOCKER_WWW}/000-default.conf`
    		#echo `sed 's/VAR_SSL/'#'/g' ${RUTA_TEMPLATES_DOCKER}/Dockerfile.template|sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' > ${RUTA_DOCKER}/Dockerfile`
    		echo `sed 's/VAR_SSL/'#'/g' ${RUTA_TEMPLATES_DOCKER}/Dockerfile-Web.template|sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g'|sed 's/VAR_IMAGEN_BASE_WWW/'"${IMAGEN_BASE_WWW}"'/g' > ${RUTA_DOCKER_WWW}/Dockerfile`
  	fi

  	echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/fqdn.conf.template > ${RUTA_DOCKER_WWW}/fqdn.conf`
  	echo `sed 's/VAR_DOMINIO/'"${URL_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/default-ssl.conf.template > ${RUTA_DOCKER_WWW}/default-ssl.conf`
  	echo `sed 's/VAR_WEB_USER/'"${USER_WEB}"'/g' ${RUTA_TEMPLATES_DOCKER}/mysqlconfig.cnf.template |sed 's/VAR_PASS_USER/'"${PASS_WEB}"'/g' > ${RUTA_DOCKER_BBDD}/mysqlconfig.cnf`

# Sustitucion template de docker-compose.yml	

	parsea_docker_compose

	log "## Fin del parseo de templates"
	log "##"
}

parsea_htaccess(){
        echo "Parseando .htaccess..."
        echo "El valor de SSL es: ${ES_SSL} "
        echo "La URL es:  ${URL_TIENDA}"

	if [ ${ENTORNO_UPPER} == "TEST" ];
	then
		RUTA_HTACCESS=${TEST_RUTA_WEB}
	elif [  ${ENTORNO_UPPER} == "PROD" ];
	then
		RUTA_HTACCESS=${PROD_RUTA_WEB}
	else
       	 echo "Como puede ser que aqui no esten definidos los entornos????"
       	 exit 323
	fi

	if [ ${ES_SSL} = "SSL" ]
  	then
		echo `sed 's/VAR_DOMINIO_TIENDA/'"${DOMINIO_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/htaccess.template |sed 's/VAR_URL_TIENDA/'"${URL_TIENDA}"'/g'|sed 's/VAR_SSL/''/g' > ${RUTA_HTACCESS}/.htaccess`

  	else
		echo `sed 's/VAR_DOMINIO_TIENDA/'"${DOMINIO_TIENDA}"'/g' ${RUTA_TEMPLATES_DOCKER}/htaccess.template |sed 's/VAR_URL_TIENDA/'"${URL_TIENDA}"'/g'|sed 's/VAR_SSL/'#'/g' > ${RUTA_HTACCESS}/.htaccess`

  	fi
}

sintaxis () {
	echo ""
	echo "Error de sintaxis!!!"
	echo ""
	echo " se necesita algun parametro"
	echo ""
	echo "Sintaxis: lanza {TIPO} {ENTORNO}"
	echo ""
	echo " donde {TIPO} puede tener dos valores:"
	echo "   SSL para indicar que se contruya con SSL"
	echo "   noSSL para indicar que no utilice SSL"
	echo ""
	echo " donde {ENTORNO} puede tener dos valores:"
	echo "   TEST para crear el entorno de Test"
	echo "   PROD para crear el entorno de Produccion"
	echo ""
	echo "Ejemplo: 'lanza SSL PROD'"
	echo ""
}


check_443 () {
	log "##"
	log "## Chequea si hay contenedores con el puerto 443 activo ..."
	#echo "...Chequeando si hay otros contenedores con 443 activo...."
	HAY_SSL_YA=`docker ps -a|grep -i "vicsoft01/tienda"|grep -i ":443"`
	CABECERA_SSL_YA=`docker ps -a|head -1`
	export HAY_SSL=${HAY_SSL_YA:-0}

	if [ "${HAY_SSL}" != "0" ]; then
		log "#######################"
		log "##  ERROR !!!!!!!   ###"
		log "#######################"
		log ""
	        log "Ya existe un contenedor con el puerto 443 asignado"
	        log "Solo puede tener un contenedor con puerto 443"
	        log ""
		log ${CABECERA_SSL_YA}
	        log ${HAY_SSL}
		exit 124
	else
		log "# No hay contenedores activos con SSL"
	fi

}


mensaje_no_parametros(){
                clear
                echo "!!!"
                echo "Falta definir entorno"
                echo ""
                sintaxis

}




muestra_variables(){
	log "##"
	log ""
	log "#################################################"
	log "## La configuración final es la siguiente: "
	log "#################################################"
	log "##"
        log "## Puerto wb: ${PUERTO_WEB}"
        log "## Puerto_mysql: ${PUERTO_MYSQL}"
        log "## Virtual Host: ${VIRTUAL_HOST}"
        log "## DNS: ${DNS}"
        log "## RUTA_WEB: ${RUTA_WEB}"
        log "## RUTA_MYSQL: ${RUTA_MYSQL}"
        log "## RUTA_LOGS: ${RUTA_LOGS}"
        log "## PUERTO_SSL: ${PUERTO_SSL}"
        log "## VIRTUAL_PROTO: ${VIRTUAL_PROTO}"
        log "## VIRTUAL_PORT: ${VIRTUAL_PORT}"

        log "## -----------------------------"
        log "## PARAM_PUERTO_SSL=${PARAM_PUERTO_SSL}"
        log "## PARAM_VIRTUAL_PROTO=${PARAM_VIRTUAL_PROTO}"
        log "## PARAM_VIRTUAL_PORT=${PARAM_VIRTUAL_PORT}"
        log "## PARAM_RUTA_SSL=${PARAM_RUTA_SSL}"

        log "## -----------------------------"
        log "## NOMBRE_IMAGEN: ${NOMBRE_IMAGEN}"
        log "## NOMBRE_IMAGEN sin tag: ${NOMBRE_IMAGEN_SIN_TAG}"
        log "## RUTA_DOCKERFILE=${RUTA_DOCKERFILE}"

        log "######"
        log ""
        log "##############################"
        log "#### PROCESO FINALIZADO !!!"        
        log "##############################"
}

montar_volumen_logs () {
 	log "##"
	log "## Montando volumenes docker de LOGS"
	log "##  .. borrando el volumen: logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"
 	docker volume rm logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}
	log "##   .. creando el volumen logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"
 	docker volume create logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}
 #RUTA_VOLUMEN_LOGS=`docker volume inspect logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}|grep Mountpoint`
	RUTA_VOLUMEN_LOGS=`docker volume inspect logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}|grep Mountpoint|cut -d ":" -f 2|awk -F\" '{ print $2 }'`
	log "## La ruta del volumen de logs es: ${RUTA_VOLUMEN_LOGS}"	

}

copia_base_files(){
	log "## Copiando para docker ficheros base que no se modifican "
	
	rm -f ${RUTA_DOCKER_WWW}/ejecuta.sh
#        rm -f ${RUTA_DOCKER}/mysqlconfig.cnf
        rm -f ${RUTA_DOCKER_WWW}/php.ini

	cp ${RUTA_DOCKER_BASEFILES}/ejecuta.sh ${RUTA_DOCKER_WWW}
#	cp ${RUTA_DOCKER_BASEFILES}/mysqlconfig.cnf ${RUTA_DOCKER}
	cp ${RUTA_DOCKER_BASEFILES}/php.ini ${RUTA_DOCKER_WWW}
	cp ${RUTA_DOCKER_BASEFILES}/apache2.conf ${RUTA_DOCKER_WWW}
}

construye_cmd_docker (){
	log "##"
	log "## Construyendo comando docker"
	montar_volumen_logs

	PARAM_NOMBRE_CONTENEDOR="--name tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"
        export CMD_EJECUCION_DOCKER_RUN="docker run -d -p ${PUERTO_WEB}:80 -p ${PUERTO_MYSQL}:3306 ${PARAM_PUERTO_SSL} -e VIRTUAL_HOST=${VIRTUAL_HOST} ${PARAM_VIRTUAL_PROTO} ${PARAM_VIRTUAL_PORT} -v ${RUTA_WEB}:/var/www/html -v logs-tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}:/var/log:rw -v ${RUTA_MYSQL}:/var/lib/mysql ${PARAM_NOMBRE_CONTENEDOR} -h ${DNS} ${NOMBRE_IMAGEN}"

	echo ${CMD_EJECUCION_DOCKER_RUN} > ${RUTA_DOCKER}/cmd_ejecucion_docker.txt

	log "## El comando es: "
 	log "## ${CMD_EJECUCION_DOCKER_RUN}"
	log "##"
	log "##"
}

eliminar_contenedor (){
	log "##"
	log "## Eliminando contenedor actual tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"
	log "##"
	CMD_PARADA_CONTENEDOR="docker stop tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"
	CMD_BORRADO_CONTENEDOR="docker rm tienda-${ENTORNO}${SUFIJO_NOMBRE_CONTENEDOR}"

	echo -e `${CMD_PARADA_CONTENEDOR}`
        if [ $? -ne 0 ];
        then
		log "## Error parando el contenedor"
	else
		log "## Contenedor parado con exito!!!"	
	fi
	echo -e `${CMD_BORRADO_CONTENEDOR}`
        if [ $? -ne 0 ];
        then
                log "## Error borrando el contenedor"
        else
                log "## Contenedor eliminado con exito!!!"
        fi
}

construye_imagen(){
	log "##"
	log "## Construyendo imagen de docker: ${NOMBRE_IMAGEN}"
	log "##  desde la ruta: ${RUTA_DOCKER}"
        CMD_BORRADO_IMAGEN="docker rmi -f ${NOMBRE_IMAGEN}"
        CMD_CREACION_IMAGEN="docker build -t ${NOMBRE_IMAGEN} ${RUTA_DOCKER}"
	log "##    ... borrado previo de la imagen"
	echo -e `${CMD_BORRADO_IMAGEN}`
        log "##    ... Creando la imagen"	
	echo -e `${CMD_CREACION_IMAGEN}`
	if [ $? -ne 0 ];
	then
      	  log "#######################################################"
      	  log "##"
      	  log "##!!!ERROR -  No se ha creado la imagen: ${NOMBRE_IMAGEN}"
      	  log "##"
      	  log "#######################################################"
      	  exit 122
	else
      	  log "#############################################"
      	  log ""
      	  log "## Imagen: ${NOMBRE_IMAGEN} creada con exito!!! "
      	  log "---------------------------------------------"
      	  log ""
      	  docker images |grep -i "REPOSITORY"
      	  docker images |grep -i ${NOMBRE_IMAGEN_SIN_TAG}
     	  log ""
      	  log "---------------------------------------------"
	fi
}

construye_imagen_www(){
        log "##"
        log "## Construyendo imagen de docker Web: ${NOMBRE_IMAGEN_WWW}"
        log "##  desde la ruta: ${RUTA_DOCKER_WWW}"
        CMD_BORRADO_IMAGEN="docker rmi -f ${NOMBRE_IMAGEN_WWW}"
        #CMD_CREACION_IMAGEN="docker build -t ${NOMBRE_IMAGEN_WWW} ${RUTA_DOCKER}"
        CMD_CREACION_IMAGEN="docker build -t ${NOMBRE_IMAGEN_WWW} ${RUTA_DOCKER_WWW}"
        log "##    ... borrado previo de la imagen"
        echo -e `${CMD_BORRADO_IMAGEN}`
        log "##    ... Creando la imagen"
        echo -e `${CMD_CREACION_IMAGEN}`
	echo "Comando creacion imagen: ${CMD_CREACION_IMAGEN}"
        if [ $? -ne 0 ];
        then
          log "#######################################################"
          log "##"
          log "##!!!ERROR -  No se ha creado la imagen: ${NOMBRE_IMAGEN_WWW}"
          log "##"
          log "#######################################################"
          exit 122
        else
          log "#############################################"
          log ""
          log "## Imagen: ${NOMBRE_IMAGEN_WWW} creada con exito!!! "
          log "---------------------------------------------"
          log ""
          docker images |grep -i "REPOSITORY"
          docker images |grep -i ${NOMBRE_IMAGEN_WWW}
          log ""
          log "---------------------------------------------"
        fi
}

construye_imagen_bbdd(){
        log "##"
        log "## Construyendo imagen de docker: ${NOMBRE_IMAGEN_BBDD}"
        log "##  desde la ruta: ${RUTA_DOCKER_BBDD}"
        CMD_BORRADO_IMAGEN="docker rmi -f ${NOMBRE_IMAGEN_BBDD}"
        CMD_CREACION_IMAGEN="docker build -t ${NOMBRE_IMAGEN_BBDD} ${RUTA_DOCKER_BBDD}"
        log "##    ... borrado previo de la imagen"
        echo -e `${CMD_BORRADO_IMAGEN}`
        log "##    ... Creando la imagen"
        echo -e `${CMD_CREACION_IMAGEN}`
        if [ $? -ne 0 ];
        then
          log "#######################################################"
          log "##"
          log "##!!!ERROR -  No se ha creado la imagen: ${NOMBRE_IMAGEN_BBDD}"
          log "##"
          log "#######################################################"
          exit 122
        else
          log "#############################################"
          log ""
          log "## Imagen: ${NOMBRE_IMAGEN_BBDD} creada con exito!!! "
          log "---------------------------------------------"
          log ""
          docker images |grep -i "REPOSITORY"
          docker images |grep -i ${NOMBRE_IMAGEN_SIN_TAG}
          log ""
          log "---------------------------------------------"
        fi
}

userpass_web(){
	log "##"
	log "## Recogiendo usuario y password"
	export USER_WEB=`cut -d";" -f1 ${TMP_FILEUSERCONNECT}`
	export PASS_WEB=`cut -d";" -f2 ${TMP_FILEUSERCONNECT}`
	log "##"
}


recoge_cert_ssl(){
 if [ ${ES_SSL} = "SSL" ]
  then
	log "########################################################"
	log "###     Recogiendo certificados SSL del servidor     ###"
	log "########################################################"
        scp -r -P ${HOST_BACKUP_PUERTO} ${HOST_BACKUP_NOMBRE}:${HOST_CERT_SSL} ${RUTA_TEMP}
        cp ${RUTA_TEMP}/${URL_TIENDA}/${URL_TIENDA}.crt ${RUTA_DOCKER_WWW}
        cp ${RUTA_TEMP}/${URL_TIENDA}/${URL_TIENDA}.key ${RUTA_DOCKER_WWW}
        cp ${RUTA_TEMP}/${URL_TIENDA}/certificate.ca.crt ${RUTA_DOCKER_WWW}

else
	log "########################################################"
	log "No se ha seleccionado SSL. No recogemos los certificados"  
	log "########################################################"

fi
}

backup_dockerfiles(){
 cp -r ${RUTA_DOCKER} ${BACKUP_RUTA_DOCKER}/${ID_UNICO_PROCESO}
 #rm -rf ${RUTA_DOCKER}/*
 rm -rf ${RUTA_DOCKER}/*
 mkdir ${RUTA_DOCKER_WWW}
 mkdir ${RUTA_DOCKER_WWW}/certs
 mkdir ${RUTA_DOCKER_BBDD}

}


log(){
	now
	pref_fecha="# ${curl} - "
	#Comprobamos si ya existe el fichero de log
	if [ -f ${FICHERO_LOG} ];
	then
		echo ${pref_fecha} $1 >> ${FICHERO_LOG}
	else
		echo ${pref_fecha} $1 > ${FICHERO_LOG}

	fi
	echo $1
}

now(){
        DIA=`date +%d`
        MES=`date +%m`
        ANYO=`date +%Y`
        HORA=`date +%H`
        MINUTOS=`date +%M`
        SEGUNDOS=`date +%S`
        MILISEGUNDOS=`date +%3N`
        tmptiempo=$ANYO-$MES-$DIA" "$HORA":"$MINUTOS":"$SEGUNDOS
        tmptiempo_sin_fecha=$HORA":"$MINUTOS":"$SEGUNDOS
 
        export curl=${tmptiempo}
}

ejecuta_docker(){
	log ""
	log "##"
	log "###############################################################"
	log "##                   EJECUTANDO DOCKER                       ##"

	echo -e `${CMD_EJECUCION_DOCKER_RUN}`
        if [ $? -ne 0 ];
        then
                log "## Error Ejecutando Docker"
        else
                log "## DOCKER EJECUTADO CON EXITO !!!!!!!!"
        fi
	echo -e `docker ps -a` >> ${FICHERO_LOG}

}

ejecuta_compose(){
        #export CMD_EJECUCION_COMPOSE="docker-compose ${RUTA_DOCKER}/docker-compose.yml up -d"
        export CMD_EJECUCION_COMPOSE="docker-compose up -d"
	cd ${RUTA_DOCKER} 
        log ""
        log "##"
        log "###############################################################"
        log "##               EJECUTANDO DOCKER-COMPOSE                   ##"

        echo -e `${CMD_EJECUCION_COMPOSE}`
        if [ $? -ne 0 ];
        then
                log "## Error Ejecutando Compose"
        else
                log "## DOCKER-COMPOSE EJECUTADO CON EXITO !!!!!!!!"
        fi

	cd -
        echo -e `docker ps -a` >> ${FICHERO_LOG}

}


parsea_docker_compose (){
# Sustitucion template de docker-compose.yml
        echo `sed 's/VAR_IMAGEN_BASE/'"${NOMBRE_IMAGEN_WWW}"'/g' ${RUTA_TEMPLATES_DOCKER}/docker-compose.template > ${RUTA_DOCKER}/docker-compose.yml.01`

        VAR_RUTA_WEB_SIN_BARRAS=`echo ${PROD_RUTA_WEB}|sed 's/\//\\\\\//g'`
        VAR_RUTA_BBDD_SIN_BARRAS=`echo ${PROD_RUTA_MYSQL}|sed 's/\//\\\\\//g'`
        VAR_RUTA_IMAGENES_SIN_BARRAS=`echo ${RUTA_IMAGENES}|sed 's/\//\\\\\//g'`

        echo `sed 's/VAR_RUTA_WEB/'"${VAR_RUTA_WEB_SIN_BARRAS}"'/g' ${RUTA_DOCKER}/docker-compose.yml.01 |sed 's/VAR_RUTA_BBDD/'"${VAR_RUTA_BBDD_SIN_BARRAS}"'/g'|sed 's/VAR_CONT_MYSQL/'"${VAR_CONT_MYSQL}"'/g'|sed 's/VAR_RUTA_IMAGENES/'"${VAR_RUTA_IMAGENES_SIN_BARRAS}"'/g'|sed 's/VAR_DOMINIO_TIENDA/'"${DOMINIO_TIENDA}"'/g' > ${RUTA_DOCKER}/docker-compose.yml`

	rm ${RUTA_DOCKER}/docker-compose.yml.01
}

parsea_activacion_root_mysql () {
 echo `sed 's/VAR_CONT_MYSQL/'"${VAR_CONT_MYSQL}"'/g' ${RUTA_TEMPLATES_DOCKER}/activaroot.sh.template > ${RUTA_DOCKER_BBDD}/activaroot.sh`

}

parsea_seteo_dominio_ssl () {
 VAR_RUTA_DOCKER_BBDD_SIN_BARRAS=`echo ${RUTA_DOCKER_BBDD}|sed 's/\//\\\\\//g'`
 echo `sed 's/VAR_CONT_MYSQL/'"${VAR_CONT_MYSQL}"'/g' ${RUTA_TEMPLATES_DOCKER}/setear_dominio_ssl.sh.template|sed 's/VAR_RUTA_DOCKER_BBDD/'"${VAR_RUTA_DOCKER_BBDD_SIN_BARRAS}"'/g' > ${RUTA_DOCKER_BBDD}/setear_dominio_ssl.sh`

}

parsea_create_db_regalonatural () {
 echo `sed 's/VAR_CONT_MYSQL/'"${VAR_CONT_MYSQL}"'/g' ${RUTA_TEMPLATES_DOCKER}/creadbregalonatural.sh.template > ${RUTA_DOCKER_BBDD}/creadbregalonatural.sh`
}

parsea_restore_db_regalonatural () {
 VAR_RUTA_WEB_SIN_BARRAS=`echo ${PROD_RUTA_WEB}|sed 's/\//\\\\\//g'`
 VAR_FILE_BCKSQL_REGALONATURAL="${VAR_RUTA_WEB_SIN_BARRAS}\/${SQL_BBDD}"
 echo "VAR_RUTA_WEB_SIN_BARRAS = ${VAR_RUTA_WEB_SIN_BARRAS}"
 echo "SQL_BBDD = ${SQL_BBDD}"
 echo "VAR_FILE_BCKSQL_REGALONATURAL= ${VAR_FILE_BCKSQL_REGALONATURAL}"

 echo `sed 's/VAR_CONT_MYSQL/'"${VAR_CONT_MYSQL}"'/g' ${RUTA_TEMPLATES_DOCKER}/restoreregalonatural.sh.template|sed 's/VAR_FILE_BCKSQL_REGALONATURAL/'"${VAR_FILE_BCKSQL_REGALONATURAL}"'/g' > ${RUTA_DOCKER_BBDD}/restoreregalonatural.sh`

}


activarootmysql () {
       log ""
       log "##"
       log "###############################################################"
       log "##             ACTIVANDO ACCESO ROOT MYSQL                   ##"


       echo -e `bash ${RUTA_DOCKER_BBDD}/activaroot.sh`

       log "##"
       log "###############################################################"
       log ""
       log ""
 
}

create_db_regalonatural () {
       log ""
       log "##"
       log "###############################################################"
       log "##             CREANDO BBDD REGALONATURAL                    ##"


       echo -e `bash ${RUTA_DOCKER_BBDD}/creadbregalonatural.sh`

       log "##"
       log "###############################################################"
       log ""
       log ""

}

restore_db_regalonatural () {
       log ""
       log "##"
       log "###############################################################"
       log "##           RESTAURANDO BBDD REGALONATURAL                  ##"


       echo -e `bash ${RUTA_DOCKER_BBDD}/restoreregalonatural.sh`

       log "##"
       log "###############################################################"
       log ""
       log ""

}

setear_dominio_ssl (){
       log ""
       log "##"
       log "###############################################################"
       log "##        ACTUALIZANDO DOMINIO Y SSL EN PRESTASHOP           ##"


       echo -e `bash ${RUTA_DOCKER_BBDD}/setear_dominio_ssl.sh`
       echo "bash ${RUTA_DOCKER_BBDD}/setear_dominio_ssl.sh"

       log "##"
       log "###############################################################"
       log ""
       log ""
}

asigna_permisos_web () {
	chmod 777 -R ${RUTA_TIENDA}
}
