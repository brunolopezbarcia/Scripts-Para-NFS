#!/usr/bin/env bash

#MODIFICAR CORREO

cd /root/Scripts/Scripts\ archivos\ LDIF/

. ./01_extraer_nombre_dominio.sh

 getent passwd | awk -F ':' '{if ($3>=10000 && $3<=60000){print $1}}' >> usuariosldap.txt


#Creacion fichero ldif para eliminar los usuarios.
for usuario in $(cat usuariosldap.txt); do

echo "dn: cn=""$usuario"",ou=grupos,""$DOMINIO" >> cambiaremail.ldif
echo "changetype: modify" >> cambiaremail.ldif
echo "replace: mail" >> cambiaremail.ldif
echo "mail: "$usuario"_actualizar@iescalquera.local" >> cambiaremail.ldif

#ldapadd -D "cn=admin,dc=iescalquera,dc=local" -w abc123. -f eliminargrupo.ldif

rm usuarios_grupo.txt 2> /dev/null
rm eliminargrupo.ldif 2> /dev/null
