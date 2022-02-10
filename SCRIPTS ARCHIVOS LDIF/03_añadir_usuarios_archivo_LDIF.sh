+#!/bin/bash
#Este script nos sirve para crear nuevas OU en nuestro servidor

echo "Cual es el nombre de la OU que quieres añadir?"

read OUNUEVA

. ./01_extraer_nombre_dominio.sh

. ./02_para_usar_en_03.sh $OUNUEVA

USUARIOS=ou=usuarios

echo "dn: ou="$OUNUEVA","$USUARIOS","$DOMINIO >> nuevousuario.ldif
echo "objectClass: organizationalUnit" >> nuevousuario.ldif
echo "ou: "$OUNUEVA >> nuevousuario.ldif
echo "description: prueba de creacion de un archivo ldif con un script" >> nuevousuario.ldif

ldapadd -D "cn=admin,dc=iescalquera,dc=local" -w abc123. -f nuevousuario.ldif


cat nuevousuario.ldif
