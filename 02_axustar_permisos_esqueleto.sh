#!/bin/bash

#Chamar ao script das variables
. ./00_variable.

#Cartafol /home/iescalquera
chown root:g-usuarios $DIR_HOME_LDAP
chmod 750 $DIR_HOME_LDAP


#Cartafol profes
chown root:g-profes $DIR_HOME_LDAP/profes
chmod 750 $DIR_HOME_LDAP/profes


#Cartafol alumnos
chown root:g-usuarios $DIR_HOME_LDAP/alumnos
chmod 750 $DIR_HOME_LDAP/alumnos


#Cartafol Cursos
for CURSO in $(cat f00_cursos.txt)
do
    chown root:g-usuarios $DIR_HOME_LDAP/alumnos/$CURSOS
    chmod 750 $DIR_HOME_LDAP/alumnos/$CURSO
done


#Cartafol Comun
chown root:g-usuarios $DIR_COMUN
chmod 750 $DIR_COMUN

#Subcartafol departamentos
chown root:g-profes $DIR_COMUN/departamentos
chmod 750 $DIR_COMUN/departamentos

#Subcartafol Cursos
for CURSO in $(cat f00_cursos.txt)
do
    chown root:g-$CURSO-profes $DIR_COMUN/$CURSO
    chmod 750 $DIR_COMUN/$CURSO
don