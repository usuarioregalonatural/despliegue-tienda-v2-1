# Importa variables
#source ../00000-entorno.cfg
source ./migra.conf

clear
echo "###############################################################"
echo "#"
echo "# COMIENZO DE LA EXPORTACION DE TABLAS DE MYSQL"
echo "#"
echo "#"
echo "#### Variables utilizadas"
echo "#"
echo "#"
echo "#       El contenedor MySQL es: ${VAR_CONT_MYSQL}"
#echo "#       La ruta de salida es: ${DIR_SALIDA}"
cd ./SALIDA
rm -rf *.sql
cd ..

comando="docker container exec ${VAR_CONT_MYSQL} mysqldump -u ${VAR_USUARIO} -p${VAR_PASSWORD} ${VAR_OPCIONES} ${VAR_BBDD} "
while LISTA= read -r line
do
	echo "$line"
	fichero="--result-file=${DIR_SALIDA_DOCKER}/expportado_${line}.sql"
	comando="docker exec ${VAR_CONT_MYSQL} mysqldump -u ${VAR_USUARIO} -p${VAR_PASSWORD} ${VAR_CHARACTER_SET} ${VAR_OPCIONES} ${fichero}  ${VAR_BBDD} "	
	ejecutar="${comando} $line"
	echo -e `${ejecutar}`
	mv ${VAR_RUTA_MYSQL_LOCAL}/expportado_${line}.sql ./SALIDA
	echo "USE ${VAR_BBDD}; DELETE FROM ${VAR_BBDD}.$line;" > ./SALIDA/exp_${line}.sql
	cat ./SALIDA/expportado_${line}.sql >>./SALIDA/exp_${line}.sql
	rm ./SALIDA/expportado_${line}.sql
done < ./lista-tablas.conf

echo "##############################"
echo "# MOVIENDO DATOS GENERADOS  ##"
echo "##############################"
 bash ./mueve_datos.sh

