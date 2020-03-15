
source ../00000-entorno.cfg

function config_previo(){
	#directorio_tmp= "$dir_actual/tmp"
	#echo "Directorio tmp: ${directorio_tmp}" 
	echo "Directorio tmp: ${dic_actual}" 
	VAR_BBDD_TIENDA=${PROD_BBDD_TIENDA}
	INPUT=/home/despliegues/MENUS/tmp/menu.sh.$$
	OUTPUT=/home/despliegues/MENUS/tmp/output.sh.$$
	# trap and delete temp files
	trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM
	echo "La ruta es : $INPUT"
}

function Bienvenido(){
	dialog --title "Bienvenido a la gestion de mantenimiento de RegaloNatural" --clear --msgbox "Bienvenido!!!" 10 41
}


function selecciona_bbdd(){
echo "pepe"
}

function seleccionar_fichero(){
	FILE=$(dialog --title "Tablas a exportar" --stdout --title "Selecciona fichero: " --fselect /listadotablas 14 48)

}
function menuprincipal(){

	dialog --menu "Selecciona una copcion: " 10 30 3 1 Backup 2 Utiles 3 Salir 

}

function bbdd(){
	dialog \
	--backtitle "RegaloNatural Mantenimiento" \
	--title "BBDD a utilizar" \
	--inputbox "Seleccione BBDD" \
	14 30 \
	${PROD_BBDD_TIENDA} \
	3>&1 1>&2 2>&3 3>&-

}

function MenuInicial() {
	dialog --clear --help-button --backtitle "RegaloNatural Mantenimiento" \
	--title "[MENU PRINCIPAL]" \
	--menu "Escoge una opcion" 15 50 4 \
	Backup "Realiza Backup" \
	Utiles "Utilidades" \
	Salir "Finalizar ejeuccion" 2>"${INPUT}"



}

function mnu_backup() {
	echo "menu backup"

}

function mnu_utiles() {
	echo "menu utiles"

}
Bienvenido
config_previo
#menuprincipal
#seleccionar_fichero
#MenuInicial
#bbdd_seleccionada=$( bbdd )



while true
do

### display main menu ###

        dialog --clear --help-button --backtitle "RegaloNatural Mantenimiento" \
        --title "[ M E N U    P R I N C I P A L ]" \
        --menu "Escoge una opcion" 15 50 4 \
        Backup "Realiza Backup" \
        Utiles "Utilidades" \
        Salir "Finalizar ejeuccion" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

# make decsion 
case $menuitem in
	Backup) mnu_backup;;
	Utiles) mnu_utiles;;
	Exit) echo "Bye"; break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT





