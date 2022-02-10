#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Debes introducir el nombre del grupo que deseas borrar."
	exit 1
else

	var_uid=$(id -u)

	if [ ! $var_uid -eq 0 ]
	then
		echo "El usuario debe ser root para poder ejecutar este script."
		exit 1
	else
		var_group_route="ou=grupos,dc=iescalquera,dc=local"
		ldapsearch -x -b cn=g-$1,$var_group_route > /dev/null

		if [ $? -eq 0 ]
		then
			ldapsearch -xb cn=g-$1,$var_group_route | grep member | awk -F ' ' '{print $2}'> temp_memberuid.txt
			while IFS= read -r var_memuid
			do
			echo "dn: cn=g-$1,$var_group_route" >> temp_remove_users.ldif
			echo "changeType: modify" >> temp_remove_users.ldif
			echo "delete: memberUid" >> temp_remove_users.ldif
			echo "memberUid:$var_memuid" >> temp_remove_users.ldif
			echo "" >> temp_remove_users.ldif
			done < temp_memberuid.txt

			ldapmodify -D "cn=admin,dc=iescalquera,dc=local" -W -f temp_remove_users.ldif
			rm temp_remove_users.ldif
			rm temp_memberuid.txt
		else
			echo "El grupo $1 no existe."
		fi

	fi

fi

