#!/bin/bash
#Implementa un script que dado un arquivo de texto o cal conteña en cada liña un nome de ou,
#xere un arquivo ldif que permita crear esas OUs base.
#Deberás comprobar que se lle pasa un parámetro e que ese parámetro é un arquivo de nomes de OUs.
#Tamén se deberá empregar o código do punto anterior para verificar que a ou non existe xa
#var_oufile=$1
var_domainname=$(slapcat | head -1 | awk -F ' ' '{print $2}')

if [ $# -ne 1 ]
then
	echo "Debes proporcionar el fichero con las OU."
else
   while IFS= read -r var_ou
   do
	ldapsearch -x -s base -b 'ou='$var_ou,$var_domainname |  grep 'dn: ou='$var_ou
	if [ $? -eq 1 ]
	then
		echo "dn: ou=$var_ou,$var_domainname" >> ou_file.ldif
		echo "objectClass: organizationalUnit" >> ou_file.ldif
		echo "ou: $var_ou" >> ou_file.ldif
		echo "description: OU para almacenar $var_ou." >> ou_file.ldif
		echo "" >> ou_file.ldif
	else
		echo "La OU "$var_ou" YA EXISTE. Abortando creación de fichero LDIF."
	        exit 0
	fi
   done < $1
fi


