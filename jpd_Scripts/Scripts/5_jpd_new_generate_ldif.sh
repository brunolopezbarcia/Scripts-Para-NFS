#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Debes proporcionar el fichero con las OU."
else

var_domainname=$(slapcat | head -1 | awk -F ' ' '{print $2}')

	while IFS= read -r var_ou
	do
		var_father_ou=$(ldapsearch -x -b $var_domainname ou=$(echo $var_ou | awk -F ':' '{print $2}') | grep 'dn:' | awk -F ' ' '{print $2}')
		var_new_ou=$(echo $var_ou | awk -F ':' '{print $1}')
		var_failed_ou=$(echo $var_ou | awk -F ':' '{print $2}')

		if [ ! -z "$var_father_ou" ]
		then
			echo "dn: ou=$var_new_ou,$var_father_ou" >> sou_file.ldif
			echo "objectClass: organizationalUnit" >> sou_file.ldif
			echo "ou: $var_new_ou" >> sou_file.ldif
			echo "description: OU para almacenar $var_new_ou." >> sou_file.ldif
			echo "" >> sou_file.ldif
		else
			echo "La OU padre *$var_failed_ou* no existe. La nueva OU *$var_new_ou* no se añadirá al fichero LDIF."
		fi
	done < $1

fi

