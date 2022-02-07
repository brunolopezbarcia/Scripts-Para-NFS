#!/bin/bash

for line in `cat ficherousuariosañadidos.txt | egrep '^dn:'`;
do
echo "$line" >> ousinprocesar.txt
done


cat ousinprocesar.txt | egrep '^ou=' >>  ouprocesadas.txt


for ou in `cat ouprocesadas.txt`
do
ldapdelete -D "cn=admin,dc=iescalquera,dc=local" -w abc123. $ou
done

rm ficherousuariosañadidos.txt
rm ousinprocesar.txt
rm ouprocesadas.txt