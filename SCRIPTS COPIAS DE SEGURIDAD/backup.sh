#!/bin/bash

#..../backup.sh

#Variables configurables polo ususario ---------------------------------

ORDENADOR=$(dserver00) #Nome do ordenador que executa o script

BACKUP_DIR="/root" #Onde se vai realizar o backup. Debe existir

DIRECTORIOS="/home/iescalquera/profes/sol/TareasDeCompresion/dir1 /home/iescalquera/profes/sol/TareasDeCompresion/dir2" #Directorios a copiar

N_C_D="--no-check-device" # Se BACKUP_DIR está sobre almacenamento:
# nfs: --no-check-device, para que non teña
#     en conta o UUID no arquivo de metadatos.
#
# sistema fixo: nada, para que colla o UUID

SNAR=snar #Subdirectorio de BACKUP_DIR no que gardar os arquivos de metadatos

COMPRESOR=.lzma #Tar ten o parametro -a para que en funcion da extension use o compresor que corresponda
#Posibles valores para COMPRESOR (opcional):
#nada -> non comprime,solo empaqueta
#.gz -> usa gzip, menor compresion y alta velocidade
#.bz2 -> usa bzip2,boa compresion y velocidade moderada
#.lzma -> usa lzma, alta compresion y velocidade baja

N_DIA_SEMANA_COPIA_TOTAL=5 #En que numero de dia da semana se desea realizar la copia total. 5(ven), 6(sab)....
#Nos dias da semana superiores a este non se realizaran copias, salvo que non exista
#ningunha copia e sexa a primeira vez que se executa o script, enton si fara a primeira copiar
#Mais vale prevenir que lamentar!!!
#Obrigatorio

#Variables do script-----------------------------------------------------

N_MES=$(date +%m) #Numero mes actual 01...12

MES_ABREV=$(date +%b) #Nome Mes abreviado: Xan...Dec

N_DIA_MES=$(date +%d) #Numero do dia do mes:1...31

N_DIA_SEMANA=$(date +%u) #Numero do dia da semana: 1...7

DIA_SEMANA_ABREV=$(date +%a) #Nome dia semana abreviado: Lun... Dom

COPIA_MENSUAL='N' #Flag para controlar se a copia mensual

ANO=$(date +%Y) #Obter os dos ultimos dixitos do ano

BACKUP_DIR=$BACKUP_DIR"/"$ANO #Redefinir o directorio do backup

F_METADATOS_ULTIMA_TOTAL=$BACKUP_DIR/$SNAR/$ORDENADOR-00-ULTIMA_TOTAL.snar
#Ten a ruta o ficheiro de metadatos da ultima copia total

REXISTRO_COPIAS=$BACKUP_DIR/$SNAR/rexistro.txt
#Neste ficheiro vaise levar un log das copias que se realizan.Cando comenzan, tipo, cando rematan

#--- SCRIPT ---

if ! test -d "$BACKUP_DIR/$SNAR"; then
    mkdir -p "$BACKUP_DIR/$SNAR"
fi

#Comprobar se hoxe e o dia de facer unha copia total

if [ $N_DIA_SEMANA = $N_DIA_SEMANA_COPIA_TOTAL ]; then
    # En que semana do mes se vai realizar a copia semanal Total ou mensual
    case $N_DIA_MES in

    0[1-7])
        SEMANA=Semana_1
        ;;
    08 | 09 | 1[0-4])
        SEMANA=Semana_2
        ;;
    1[5-9] | 20 | 21)
        SEMANA=Semana_3
        ;;

        # Se a semana é a 4, hai que saber se dentro
        # de 7 días se está no mesmo mes (habería unha
        # semana 5) ou non (habería que facer a copia
        # mensual)
    2[2-8])
        SEMANA=Semana_4
        if [ $N_MES != $(date -d "7 days" +%m) ]; then
            COPIA_MENSUAL='S'
        fi
        ;;
    29 | 30 | 31)
        SEMANA=Semana_5
        COPIA_MENSUAL='S'
        ;;
    esac

    # Se a copia é mensual hai que facer unha Total do mes.

    if [ $COPIA_MENSUAL = 'S' ]; then
        echo $(date) "Avó     :$ORDENADOR - INICIO: Total mensual $MES_ABREV" >>$REXISTRO_COPIAS

        F_BACKUP=$BACKUP_DIR/$ORDENADOR-01-Total-Mes-$N_MES-$MES_ABREV.tar$COMPRESOR
        F_METADATOS=$BACKUP_DIR/$SNAR/$ORDENADOR-01-Total-Mes-$N_MES-$MES_ABREV.snar
    else
        echo $(date) "Pai     :$ORDENADOR - INICIO: Total $SEMANA" >>$REXISTRO_COPIAS

        F_BACKUP=$BACKUP_DIR/$ORDENADOR-02-Total-$SEMANA.tar$COMPRESOR
        F_METADATOS=$BACKUP_DIR/$SNAR/$ORDENADOR-02-Total-$SEMANA.snar
    fi

    # Se existe o arquivo de metadatos hai que borralo. para que faga unha
    # copia completa.

    if test -f "$F_METADATOS"; then
        rm $F_METADATOS
    fi

    # Realizase a copia total, en función das variables enriba especificadas
    # Cópiase o arquivo de metadatos, para poder realizar logo as copias
    # diarias diferenciais.

    tar cfa $F_BACKUP -g $F_METADATOS $N_C_D $DIRECTORIOS
    cp $F_METADATOS $F_METADATOS_ULTIMA_TOTAL

    echo $(date) "Avó-Pai :$ORDENADOR - FIN   : Total" >>$REXISTRO_COPIAS
    echo >>$REXISTRO_COPIAS

    # Cada mes métese unha separación no arquivo de rexistro de copias
    if [ $COPIA_MENSUAL = 'S' ]; then
        echo >>$REXISTRO_COPIAS
        echo >>$REXISTRO_COPIAS
        echo ---------- MES de $(date -d "7 days" +%B) ------------- >>$REXISTRO_COPIAS
    fi

    # PRIMEIRA COPIA TOTAL

    # Se non existe unha copia Total, entón é a primeira vez que se executa este
    # script e ademais, non é o día que tocaría facer unha copia semanal ou mensual.
    # Neste caso vaise crear unha copia Total, aínda que no día en que se realice
    # non se debera facer copias ou tocara unha diferencial.
    # Máis vale previr que lamentar!!!

elif
    ! test -f "$F_METADATOS_ULTIMA_TOTAL"
then

    echo $(date) "Primeira:$ORDENADOR - INICIO: Total. $DIA_SEMANA_ABREV" >>$REXISTRO_COPIAS

    F_BACKUP=$BACKUP_DIR/$ORDENADOR-00-Primeira-$DIA_SEMANA_ABREV.tar$COMPRESOR
    F_METADATOS=$F_METADATOS_ULTIMA_TOTAL

    tar cfa $F_BACKUP -g $F_METADATOS $N_C_D $DIRECTORIOS

    echo $(date) "Primeira:$ORDENADOR - FIN   : Total. $DIAS_SEMANA_ABREV" >>$REXISTRO_COPIAS
    echo >>$REXISTRO_COPIAS

# Se é un día de semana anterior ó que se realiza a copia semanal total.

elif [ $N_DIA_SEMANA -lt $N_DIA_SEMANA_COPIA_TOTAL ]; then

    echo $(date) "Fillo   :$ORDENADOR - INICIO: Diferencial. Día $DIA_SEMANA_ABREV" >>$REXISTRO_COPIAS

    F_BACKUP=$BACKUP_DIR/$ORDENADOR-03-Dif$N_DIA_SEMANA-$DIA_SEMANA_ABREV.tar$COMPRESOR
    F_METADATOS=$BACKUP_DIR/$SNAR/$ORDENADOR-03-Dif$N_DIA_SEMANA-$DIA_SEMANA_ABREV.snar

    # Copiar o arquivo de metadatos da última total, para o día de hoxe.

    cp $F_METADATOS_ULTIMA_TOTAL $F_METADATOS
    tar cfa $F_BACKUP -g $F_METADATOS $N_C_D $DIRECTORIOS

    echo $(date) "Fillo   :$ORDENADOR - FIN   : Diferencial. Día $DIA_SEMANA_ABREV" >>$REXISTRO_COPIAS
    echo >>$REXISTRO_COPIAS

else

    echo $(date) "Non     :$ORDENADOR - Ós $DIA_SEMANA_ABREV non se realizan backups" >>$REXISTRO_COPIAS
    echo >>$REXISTRO_COPIAS

fi
