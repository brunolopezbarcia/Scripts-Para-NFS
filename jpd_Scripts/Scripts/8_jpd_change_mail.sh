#!/bin/bash

#slapcat | grep uid= | awk -F {,=} '{print $2}' | awk -F ',' '{print $1}' > temp_user_list.txt

#Sacamos ruta completa del usuario
slapcat | grep uid= | awk -F ' ' '{print $2}' > temp_users_list.txt

#Parseamos la lista de usuarios para crear el ldif con su formato correcto
while IFS= read -r var_user
do
	echo "dn: $var_user" >> temp_users_list.ldif
	echo "changetype: modify" >> temp_users_list.ldif
	echo "replace: mail" >> temp_users_list.ldif
	echo "mail: $(echo $var_user | awk -F {,=} '{print $2}' | awk -F ',' '{print $1}')_actualizar@tudominio.local" >> temp_users_list.ldif
	echo "" >> temp_users_list.ldif
done < temp_users_list.txt

#Le pasamos el fichero de modificaciones al LDAP
ldapmodify  -D "cn=admin,dc=iescalquera,dc=local" -W -f temp_users_list.ldif

#Borramos los ficheros creados
rm temp_users_list.txt
rm temp_users_list.ldif


