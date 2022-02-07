#!/bin/bash

function existe () {
        res=$(ldapsearch -x -b 'dc=iescalquera,dc=local' ou=$1 | tail -n 1 | grep numEntries)
        if [[ $res == "" ]]
        then
                return -1
        else
                return 1
        fi
}



if [ -z $1 ]
then
	echo "Error: Este script necesita un archivo como parámetro donde se especifiquen as uos y sus padres"
	exit -1
fi

echo > ous.ldif
for linea in $(cat $1)
do
	sou=$(echo $linea | awk -F: '{print $1}')
	spou=$(echo $linea | awk -F: '{print $2}')
	fpou=$(ldapsearch -x -b 'dc=iescalquera,dc=local' ou=$spou | grep ou=$spou, | awk '{split($0,a," "); print a[2]}')
	fou="ou=$sou,$fpou"
	if [[  $fpou == "" ]]
	then
		echo "W: La ou $spou no existe, ignorando..."
		continue
	fi

	existe $sou
	if [[ $? == 1 ]]
	then
		echo "W: la ou $sou ya existe. No se insertará"
		continue
	fi

	echo dn: $fou >> ous.ldif
	echo objectClass: organizationalUnit >> ous.ldif
	echo ou: $sou >> ous.ldif
	echo >> ous.ldif
done

echo "Se ejecutará la operación de agregado sobre el siguiente fichero: " && cat ous.ldif
ldapadd -D cn=admin,dc=iescalquera,dc=local -w abc123. -f ous.ldif
rm ous.ldif
echo "Operación completada"
