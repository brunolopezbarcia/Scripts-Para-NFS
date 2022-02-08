#!/bin/bash
#Escribe un script que comprobe se existe unha OU dada. Deberás comprobar que se pasa un parámetro.
#No caso de que non se atope a OU, o comando rematará estado de exit de erro.
cd /root/Scripts/Scripts\ archivos\ LDIF/

. ./01_extraer_nombre_dominio.sh

if [ $# -ne 1 ]; then
  echo "Debes introducir el nombre de la OU."
else

  #Sacamos el nombre de dominio
  #Opcion 1
  #var_domainname=$(slapcat | grep 'dn: dc' | cut  -d ':' -f 2 | cut -d ' ' -f 2)

  #Opcion 2 (mejor)
  var_domainname=$(slapcat | head -1 | awk -F ' ' '{print $2}')
  var_ou="cn="g-$1

  ldapsearch -x -s base -b $var_ou,ou=grupos,$DOMINIO | grep 'dn: '$var_ou >/dev/null
  if [ $? -eq 1 ]; then
    echo "El grupo "$var_ou" no existe en esta base de datos."
  else
    echo "El grupo "$var_ou" existe en esta base de datos."
    echo "Debes de cambiar el nombre del grupo"
    exit 0
  fi
fi
