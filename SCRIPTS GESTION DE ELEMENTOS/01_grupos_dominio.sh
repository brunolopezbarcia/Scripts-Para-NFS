#!/bin/bash
#Este script nos sirve para crear nuevas OU en nuestro servidor

echo "Cual es el nombre del nuevo grupo que quieres añadir?"

read GRUPONUEVO

. ./ayudante.sh $GRUPONUEVO

cd /root/Scripts/Scripts\ archivos\ LDIF/

. ./01_extraer_nombre_dominio.sh

GRUPONUEVO="g-"$GRUPONUEVO

echo "dn: cn="$GRUPONUEVO",""ou=grupos"","$DOMINIO >> nuevousuario.ldif
echo "objectClass: posixGroup" >> nuevousuario.ldif
echo "cn: "$GRUPONUEVO >> nuevousuario.ldif
var_gid=`getent group | tail -n 1 | awk -F':' '{print $3}'`
let "var_gid=var_gid+1"
echo "gidNumber:"$var_gid >> nuevousuario.ldif

ldapadd -D "cn=admin,dc=iescalquera,dc=local" -w abc123. -f nuevousuario.ldif

cat nuevousuario.ldif

rm nuevousuario.ldif