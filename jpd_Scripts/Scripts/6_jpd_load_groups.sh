#!/bin/bash
var_uid=$(id -u)
if [ $# -ne 1 ]
then
	echo "Debes proporcionar un fichero con los grupos."
	exit 1
else

	if [ ! $var_uid -eq 0 ]
	then
		echo "El usuario debe ser root para poder ejecutar este script."
		exit 1
	else

	var_domainname=$(slapcat | head -1 | awk -F ' ' '{print $2}')
	var_group_root="grupos"

	while IFS= read -r var_group
	do
		var_group_name=$(ldapsearch -x -b ou=$var_group_root,$var_domainname cn=$(echo g-$var_group | awk -F ':' '{print $1}') | grep 'dn:' | awk -F ' ' '{print $2}')

		if [ -z "$var_group_name" ]
		then
			echo "dn: cn=$(echo g-$var_group | awk -F ':' '{print $1}'),ou=$var_group_root,$var_domainname" >> temp_group.ldif
			echo "objectClass: posixGroup" >> temp_group.ldif
			echo "cn: $(echo g-$var_group | awk -F ':' '{print $1}')" >> temp_group.ldif
			echo "gidNumber: $(echo $var_group | awk -F ':' '{print $2}')" >> temp_group.ldif
			echo "" >> temp_group.ldif

		else
			echo "$(date). El grupo *$(echo g-$var_group | awk -F ':' '{print $1}')* ya existe y no se añadirá al dominio." >> /var/log/jpd_load_groups_errors.txt
			echo "Uno o más grupos no fueron añadidos, compruebe el fichero jpd_load_groups_errors.txt"
		fi

	done < $1

			ldapadd -D cn=admin,dc=iescalquera,dc=local -w abc123. -f temp_group.ldif

			if [ $? -eq 1 ]
			then
				echo "Ocurrió algún error al intentar añadir los grupos al dominio."
			fi
	fi
fi

rm temp_group.ldif
