#!/bin/bash

clear

# Importa variables
        source ./00000-entorno.cfg

# Preparacion de entorno
	./0000-desp-entorno.sh

# Ejecuta la recuperacion del backup y la deja en temp
	./0001-desp-recupera-backup.sh

# Restaura los datos de docker de la tienda
#	./0002-desp-restaura-docker-tienda.sh

# Restaura los datos de la web de produccion de la tienda
#	./0003-desp-restaura-web-tienda.sh

# Restaura los datos de la base de datos de produccion de la tienda
	
	./0005-desp-recupera-bbdd-tienda.sh

#./0004-desp-restaura-bbdd-tienda.sh


