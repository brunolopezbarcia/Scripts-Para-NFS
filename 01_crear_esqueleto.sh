#!/bin/bash

#Chamar ao script de variables, temos varias opciones:
source ./00_variables.sh

#Crear esqueleto profes
#Por se executamos o script varias veces, comprobamos se xa existe o directorio
test -d $DIR_HOME_LDAP/profes   || mkdir -p $DIR_HOME_LDAP/profes

#Crear o esqueleto alumnos e comun
#Lemos o ficheiro cursos e procesamos cada curso
for CURSO in $(cat f00_cursos.txt)
do
    test -d $DIR_HOME_LDAP/alumnos/$CURSO || mkdir -p $DIR_HOME_LDAP/alumnos/$CURSO
    test -d $DIR_COMUN/$CURSO || mkdir -p $DIR_COMUN/$CURSO
done

test -d $DIR_COMUN/departamentos || mkdir -p $DIR_COMUN/departamentos

