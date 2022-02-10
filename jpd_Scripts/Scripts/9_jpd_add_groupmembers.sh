#!/bin/bash

if [ -z $1  ]
then
	echo "Debes introducir el nombre del grupo al que se añadirán los usuarios. ej ./jpd_add_groupmembers.sh profes usuarios.txt"
	exit 1
else
	if [ -z $2 ]
	then
		echo "Debes introducir el nombre del fichero que contiene lo usuarios. ej ./jpd_add_groupmembers.sh profes usuarios.txt"
		exit 1
	else
		while IFS= read -r var_user
		do
			ldapadduser $var_user $1
		done < $2
	fi
fi
