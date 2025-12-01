#!/bin/bash

if [ ! -e .sh-toolbox ]; then
	echo "le dossier .sh-toolbox n'existe pas"
	exit 1
fi 

if [ ! -e .sh-toolbox/archives ]; then
	echo "le fichier archives n'existe pas"
	exit 2
fi 


list_mois="Jan=01 Feb=02 Mar=03 Apr=04 May=05 Jun=06 Jul=07 Aug=08 Sep=09 Oct=10 Nov=11 Dec=12" 
echo | sed -E 's/(.*).*:.*/\1/gm' | sed '1d' .sh-toolbox/archives
bienUnChiffre="x"
nbrLigne=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`

while [ "$bienUnChiffre" != "ouichiffre" ]; do

        echo "choissisez une archive (indice de l'archive que vous voulez)"
        read rep
        bienUnChiffre=`echo $rep | sed 's/[1-9][0-9]*/ouichiffre/'`

        if [ "$bienUnChiffre" == "ouichiffre" ]; then
                if [ $rep -lt 1 ] || [ $rep -gt $nbrLigne ];then
                        bienUnChiffre="x"
                fi
        fi
done

let "rep=rep+1"

echo -n "vous avez choisis l'archive "
archive_choisis=`sed -n ${rep}p .sh-toolbox/archives | sed -E 's/(.*):.*:.*/\1/'`
echo $archive_choisis
if [ ! -e "./temp" ]; then
        mkdir temp
        else
        echo "voulez vous effacer et recréer le fichier temp ?"
        read effacer
        while [ "$effacer" != 'y' ] && [ "$effacer" != 'n' ];do
                echo "voulez vous effacer et recréer le fichier temp ?(y/n)"
                read effacer
        done
        if [ "$effacer" == 'y' ]; then
                rm -dr temp
                mkdir temp
        fi
fi

if [ ! `echo $archive_choisis | cut  -d '.' -f 2` == "tar" ]; then
	echo "on ne peut pas décompresser non compressé" 
	exit 6
fi
tar -xzf $archive_choisis -C "./temp"
if [ ! $? -eq 0 ]; then
	echo "la décompression du fichier a échoué"
	exit 3
fi
echo "archive décomprésé"

if [ ! -e temp/var/log ]; then
	echo "le fichier des logs n'existe pas"
	exit 4
fi

if [ ! -e temp/data ]; then
	echo "le dossier des données n'existe pas"
	exit 5
fi

dernier_ligne=`cat temp/var/log/auth.log | grep ' admin ' | wc -l`
date_admin=`cat temp/var/log/auth.log | grep ' admin ' | sed -n ${dernier_ligne}p | sed -E 's/(.* [0-9]{2} .*) .* .*: .*/\1/'`
mois=`echo $date_admin | cut -d ' ' -f 1`
mois_en_chiffres=`echo $list_mois | sed -E "s/.* ${mois}=([0-9]{2}) .*/\1/"` 

date_admin=`echo $date_admin | sed -E "s/.* ([0-9]{2}) (.*)/${mois_en_chiffres}-\1 \2/"`
date_perso=` date '+%Y-%m-%d %T'`
date_admin=`date "+%Y-$date_admin"`
let "distance=($(date -d "$date_perso" +%s) - $(date -d "$date_admin" +%s))/86400"

echo "dernière connexion de l'admin : $date_admin"
echo "voilà les fichiers décomprésé posterieur à la dernière connexion d'admin : "
post_modif_fich=`find temp -mtime $distance -type f`
find temp -mtime $distance -type f
find .sh-toolbox -mtime $distance -type f
exit 0
