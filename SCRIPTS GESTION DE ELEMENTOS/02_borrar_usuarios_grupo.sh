#!/bin/bash

echo "De que grupo quieres borrar usuarios?"
read entradagrupo

. ./ayudante2.sh $entradagrupo

cd /root/Scripts/Scripts\ archivos\ LDIF/

. ./01_extraer_nombre_dominio.sh

entradagrupo="g-"$entradagrupo

ldapsearch -x -b cn="$entradagrupo",ou=grupos,"$DOMINIO" | egrep '^member' | awk -F':' '{print $1}' | sed -r 's/\s+//g'  > usuarios_grupo.txt

#Creacion fichero ldif para eliminar los usuarios.

echo "dn: cn=""$entradagrupo"",ou=grupos,""$DOMINIO" >> eleminargrupo.ldif
echo "changetype: modify" >> eliminargrupo.ldif
echo "delete: memberUid" >> eliminargrupo.ldif

ldapadd -D "cn=admin,dc=iescalquera,dc=local" -w abc123. -f eliminargrupo.ldif

rm usuarios_grupo.txt 2> /dev/null
rm eliminargrupo.ldif 2> /dev/null
