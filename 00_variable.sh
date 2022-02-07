#!/bin/bash


#../scripts/00_variables.sh
# Define variables globais que van a usar os demais scripts

#VARIABLES
DIR_HOME_LDAP=/home/iescalquera
DIR_COMUN=/comun

# Exportar variables
# Nos scripts que se van a usar a continuacion non faria falla que se exportasen as variables
# Pero quedan exportadas por se a posteriori calquera dos scripts que vai a importar o contenido deste fichero precisase chamara a outros scripts que precisasen usar estas variables

export DIR_HOME_LDAP
export DIR_COMUN