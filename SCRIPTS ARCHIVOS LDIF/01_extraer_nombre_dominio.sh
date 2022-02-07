#!/bin/bash

#Este script nos permitira extraer el nombre de dominio del servidor de ldap

slapcat  > /tmp/salida.slapcat

head -n 1 /tmp/salida.slapcat > /tmp/salidamodificada.slapcat

egrep  '....dc=*' /tmp/salidamodificada.slapcat > /tmp/salidafiltrada.slapcat

cat /tmp/salidafiltrada.slapcat | sed -r 's/\s+//g' > /tmp/salidased.slapcat

awk -F ":" '{print $2}' /tmp/salidased.slapcat > salidaawk.slapcat

DOMINIO=`cat salidaawk.slapcat`

export DOMINIO

rm /tmp/salida*.slapcat

