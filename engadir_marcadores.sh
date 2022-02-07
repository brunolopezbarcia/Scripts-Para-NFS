#!/bin/bash

#Comprobamos se o usuario que inicia sesion e un profe.
#E non ten creado o favorito

if (groups ${u} | grep profes) && !(cat ~/.config/gtk-3.0/bookmarks | grep Alumnos)
then
	#Engadimos o favorito ao ficheiro pero non machacamos o ficheiro porque
	#o usuario xa pode ter por se mesmo creados marcadores dende o entorno grafico.
	echo file:///home/iescalquera/alumnos Alumnos>> ~/.config/gtk-3.0/bookmarks
fi