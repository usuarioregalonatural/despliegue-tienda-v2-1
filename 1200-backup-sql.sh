#!/bin/bash

# Importa variables

        source /home/MTTO-TIENDA/despliegue-tienda/00000-entorno.cfg

	# hago backup del fichero sql
	mv ${PROD_RUTA_WEB}/backup-sql/bck_regalonatural.sql ${PROD_RUTA_WEB}/backup-sql/bck_regalonatural.sql.${ID_UNICO_PROCESO}
	docker exec ${VAR_CONT_MYSQL} /usr/bin/mysqldump -u root --password=vmsn2004 regalonatural > ${PROD_RUTA_WEB}/backup-sql/bck_regalonatural.sql
	chmod 700 ${PROD_RUTA_WEB}/backup-sql/bck_regalonatural.sql

