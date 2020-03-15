echo "##########################################################################"
echo "##########################################################################"
echo "##########################################################################"
echo "#########      GENERACION DE COPIA DE DATOS"
echo "##########################################################################"
echo "##########################################################################"
echo "##########################################################################"

#!/bin/bash
 
# funcino que muestra el menu principal
function _menuPrincipal()
{
    echo "-----------------------------------------------"
    echo " SELECCION DEL TIPO DE BACKUP"
    echo "-----------------------------------------------"
    echo
    echo "1) Backup completo"
    echo "2) Backup parcial"
    echo "3) "
    echo "4) Salir"
    echo
    echo -n "Indica una opcion: "
}
 
# funcion que muestra el primer submenu
function _submenu1()
{
    echo "-----------------------------------------------"
    echo
    echo "1) Submenu1-1"
    echo "2) Submenu1-2"
    echo "3) Salir"
    echo
    echo -n "Indica una opcion: "
}
 
# funcion que muestra el segundo submenu
function _submenu2()
{
    #Backup parcial
    echo "-----------------------------------------------"
    echo " BACKUP PARCIAL DE TABLAS"
    echo "-----------------------------------------------"
    echo " las tablas deben estar definidas en fichero: migra.conf"
    echo
    echo "1) Submenu2-1"
    echo "2) Submenu2-2"
    echo "3) Salir"
    echo
    echo -n "Indica una opcion: "
}
 
# establecemos un valor por defecto
opc=0
 
# bucle hasta que no se pulse la opcion 4 del primer menu
until [ $opc -eq 4 ]
do
    case $opc in
        1)
            # iniciamos el primer submenu
            opc1=0
            until [ $opc1 -eq 3 ]
            do
                case $opc1 in
                    1)
                        echo "menu 1 submenu 1"
                        _submenu1
                        ;;
                    2)
                        echo "menu 1 submenu 2"
                        _submenu1
                        ;;
                    *)
                        _submenu1
                        ;;
                esac
                read opc1
            done
            _menuPrincipal
            ;;
 
        2)
            # iniciamos el segundo submenu
            opc2=0
            until [ $opc2 -eq 3 ]
            do
                case $opc2 in
                    1)
                        echo "menu 2 submenu 1"
                        _submenu2
                        ;;
                    2)
                        echo "menu 2 submenu 2"
                        _submenu2
                        ;;
                    *)
                        _submenu2
                        ;;
                esac
                read opc2
            done
            _menuPrincipal
            ;;
 
        3)
            echo "Esta opcion no dispone de submenu"
            _menuPrincipal
            ;;
 
        *)
            _menuPrincipal
            ;;
    esac
 
    # esperamos solicitando una nueva opción de menu
    read opc
done

