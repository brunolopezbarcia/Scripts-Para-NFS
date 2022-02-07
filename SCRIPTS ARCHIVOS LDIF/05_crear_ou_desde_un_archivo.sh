#!/usr/bin/env bash

cat ou.txt | awk -F ':' '{print $1}' >nombreou.txt
cat ou.txt | awk -F ':' '{print $2}' >nombrepadreou.txt

. ./01_extraer_nombre_dominio.sh


for i in `cat nombreou.txt`; do

. ./02_para_usar_en_03.sh $i

done

for n in `cat nombreou.txt`; do
    for j in `cat nombrepadreou.txt`; do
        echo "dn: ou="$n","$j","$DOMINIO >> nuevaou.ldif
        echo "objectClass: organizationalUnit" >> nuevaou.ldif
        echo "ou: "$n >> nuevaou.ldif
        echo "description: prueba de creacion de un archivo ldif con un script" >> nuevaou.ldif
    done
done


cat nuevaou.ldif

rm nombre*
rm salida*
rm nuevaou*