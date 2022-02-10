#!/bin/bash
var_domainname=$(slapcat | head -1 | awk -F ' ' '{print $2}')

if [ $# -ne 1 ]
 then
	echo "Debes indicar el fichero que contiene las OU a borrar."
 else
	grep dn $1 | awk -F ' ' '{print $2}' > temp_ou_del.txt

	while IFS= read -r OU
	do
		ldapdelete -D cn=admin,$var_domainname -w abc123. "$OU" -r
	#echo $OU
	#echo $var_domainname
	done < temp_ou_del.txt
fi

rm temp_ou_del.txt
