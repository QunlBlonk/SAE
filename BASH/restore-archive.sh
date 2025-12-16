#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "pas assez ou trop d'argument"
	exit 5
fi

if [ ! -e .sh-toolbox ]; then
	echo ".sh-toolbox n'existe pas"
	exit 1
fi

if [ ! -e ${1} ];then
	mkdir ${1}
	if [ ! $? -eq 0 ];then
		echo "problème de création du dossier"
		exit 2
	fi
else
	if [ -f ${1} ];then
		echo "le chemin passer en paramètre ammène à un fichier"
		exit 6
	fi
fi


./check-archive.sh -l

if [ $? -eq 6 ]; then
	exit 6
fi

#stoque le numéro de la ligne de l'archive choisis
archives_choisis=`cat ./temp/archive_choisis.txt`

#trouve la dernière ligne au admin est présent et stoque la date de l'attaque
dernier_ligne=`cat temp/var/log/auth.log | grep ' admin ' | wc -l`
date_admin=`cat temp/var/log/auth.log | grep ' admin ' | sed -n ${dernier_ligne}p | sed -E 's/(.* [0-9]{2} .*) .* .*: .*/\1/'`

#extrait le mois de l'attaque
mois=`echo $date_admin | cut -d ' ' -f 1`

#transforme le mois en lettre en chiffres utilisables
list_mois="Jan=01 Feb=02 Mar=03 Apr=04 May=05 Jun=06 Jul=07 Aug=08 Sep=09 Oct=10 Nov=11 Dec=12"
mois_en_chiffres=`echo $list_mois | sed -E "s/.* ${mois}=([0-9]{2}) .*/\1/"`
date_admin=`echo $date_admin | sed -E "s/.* ([0-9]{2}) (.*)/${mois_en_chiffres}-\1 \2/"`

#compare la date de l'attaque et la date actuelle pour trouver depuis comebien de jour l attaque a été effectué
date_perso=` date '+%Y-%m-%d %T'`
date_admin=`date "+%Y-$date_admin"` #on rajoute l'année à la date pour pouvoir comparer
let "distance=($(date -d "$date_perso" +%s) - $(date -d "$date_admin" +%s))/86400"

#on stoque et affiche les fichiers inféctés
post_modif_fich=`find temp -mtime $distance -type f`
find temp -mtime $distance -type f

#on stoque combien de fichiers sont inféctés
taille_post_mod=`find temp -mtime $distance -type f | wc -l`

not_found=0 #dans le cas ou aucun ficheir intact existe
i=1
clef=""
while [ $i -le $taille_post_mod ]; do
        #prend un fichier infécté et en extrait le nom + suffix ainsi que sa taille
        file=`find temp -mtime $distance -type f | sed -n ${i}p`
        name=`basename $file`
        size_file=$(stat -c %s $file)

        j=1
        #on stoque le nombre de dossier avec le même nom que le fichier infécté
        taille_same_name=`find temp -name $name -type f | grep -v "$file" | wc -l`
        while [ $j -le $taille_same_name ];do
                #on extrait et stoques le nom d'un fichier intact du même nom de fichier ainsi que sa taille
                same_name_file=`find temp -name $name -type f | grep -v "$file" | sed -n ${j}p`
                size_same_name_file=$(stat -c %s $same_name_file)

                #on compare la taille du fichier infécté avec le fichier intact trouver pour voir si ce sont bien les mêmes
                if [ $size_file == $size_same_name_file ]; then
			if [ -z $clef ];then
				same_name_file_64=`echo $same_name_file | sed -E "s/^(.*)\.(.*)$/\1_64.txt/"`
                        	base64 $same_name_file > $same_name_file_64

                        	file_64=`echo $file | sed -E "s/^(.*)\.(.*)$/\1_64.txt/"`
                        	base64 $file > $file_64
				clef=`./prog $same_name_file_64 $file_64`
			fi
                        not_found=1
                fi

                let "j=j+1"
        done
        let "i=i+1"
done

echo "clef : $clef"

#si on ne trouve aucun fichier intact alors on le dit à l'utilisateur
if [ $not_found -eq 0 ]; then
        echo "aucun dossier intact trouver"
        exit 8
else
	ligne_archives=`sed -n ${archives_choisis}p .sh-toolbox/archives | sed -E "s/(.*:.*:).*/\1/"`
	reste_lignes=`sed ${archives_choisis}d .sh-toolbox/archives`
	echo -n "" > .sh-toolbox/archives
	cat << TAG > .sh-toolbox/archives
$reste_lignes
${ligne_archives}${clef}
TAG


fi
exit 0
