#!/bin/bash
#Este script nos sirve para crear nuevas OU en nuestro servidor

echo "Cual es el nombre de la OU que quieres añadir?"

read OUNUEVA

. ./01_extraer_nombre_dominio.sh

. ./02_para_usar_en_03.sh $OUNUEVA

USUARIOS=ou=usuarios

echo "dn: cn="$OUNUEVA","$USUARIOS","$DOMINIO >> nuevousuario.ldif
echo "objectClass: inetOrgPerson" >> nuevousuario.ldif
echo "objectClass: posixAccount" >> nuevousuario.ldif
echo "objectClass: shadowAccount" >> nuevousuario.ldif
echo "sn: apellido" >> nuevousuario.ldif
echo "cn: "$OUNUEVA >> nuevousuario.ldif
echo "givenName: "$OUNUEVA >> nuevousuario.ldif
var_uid=`getent passwd | tail -n 1 | awk -F':' '{print $3}'`
let "var_uid=var_uid+1"
echo "uidNumber:"$var_uid >> nuevousuario.ldif
echo "gidNumber: 10000">> nuevousuario.ldif
echo "userPassword: abc123." >> nuevousuario.ldif
echo "gecos: prueba de creacion de un archivo ldif con un script" >> nuevousuario.ldif
echo "loginShell: /bin/bash" >> nuevousuario.ldif
echo "homeDirectory: /home/iescalquera/profes/"$OUNUEVA >> nuevousuario.ldif
echo "INITIALS: P1" >> nuevousuario.ldif


ldapadd -D "cn=admin,dc=iescalquera,dc=local" -w abc123. -f nuevousuario.ldif


cat nuevousuario.ldif

