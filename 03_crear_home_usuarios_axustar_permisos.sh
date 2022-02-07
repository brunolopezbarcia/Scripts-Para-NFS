#!/bin/bash


#Lembrar que  cada usuario ten o seguinte formato
# Un/unha profe  -> sol:x:10000:10000:Profe - Sol Lua:/home/iescalquera/profes/sol:/bin/bash
# Un/unha alumna -> mon:x:10002:10000:DAM1 Mon Mon:/home/iescalquera/alumnos/dam1/mon:/bin/bash

# Observar que posición ocupan os campos e que están separados por :

# Imos extraer con awk dos usuarios con ID (campo 3) entre 10000 e 60000 os campos
# Usuario (campo 1) e home (campo 6)
# Deste campo (home) imos extraer o grupo ao que pertence o usuario
# Neste caso o separador de campos é /, e o grupo está no 4º campo.


#Volcamos tódolos usuarios (locais e ldap) do sistema a un ficheiro
getent passwd>usuarios.txt


#Extraemos os campos anteriores
for USUARIO in $( awk -F: '$3>=10000 && $3<60000  {print $1":"$6}' usuarios.txt )
do
	#USUARIO vai ter o seguinte formato
	# sol:/home/iescalquera/profes/sol

 	NOME_USUARIO=$( echo $USUARIO | awk -F: '{print $1}')
 	HOME_USUARIO=$( echo $USUARIO | awk -F: '{print $2}')
	GRUPO_GLOBAL_USUARIO=$( echo $HOME_USUARIO | awk -F/ '{print $4}')

	#Creamos a carpeta persoal do usuario/a
	test -d $HOME_USUARIO || mkdir -p $HOME_USUARIO

 	#Copiamos o contido de skel_ubuntu (ocultos incluídos, -a) á carpeta persoal do usuario/a
	cp -a skel_ubuntu/\. $HOME_USUARIO

	#Comprobamos se o usuario/a é un profe
	if [ $GRUPO_GLOBAL_USUARIO = "profes" ]
	then
		#Se é un profe deixamos entrar só a ese profe na súa carpeta persoal
		chown -R $NOME_USUARIO:g-usuarios $HOME_USUARIO
		chmod -R 700 $HOME_USUARIO
	else
		#Se é un alumno o campo 5 do home coincide con parte do nome do grupo ao que pertence
		GRUPO_ALUMNO=$( echo $HOME_USUARIO |awk -F/ '{print $5}')

		#Se é un alumno deixamos entrar en modo lectura execución aos profes dese curso
		# en modo recursivo
		chown -R $NOME_USUARIO:g-"$GRUPO_ALUMNO"-profes $HOME_USUARIO
		chmod -R 750 $HOME_USUARIO
	fi
done

rm usuarios.txt