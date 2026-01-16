#!/bin/bash

#test si l'option -l à était passer en paramètre
less=0
if [ "${1}" == "-l" ]; then
	less=1
	shift
fi



#teste si le dossier .sh-toolbox existe
if [ ! -e .sh-toolbox ]; then
	echo "le dossier .sh-toolbox n'existe pas"
	exit 1
fi 

#teste si le fichier archives existe
if [ ! -e .sh-toolbox/archives ]; then
	echo "le fichier archives n'existe pas"
	exit 2
fi 


#assure qu'il y est au moins une archive mentionner dans le fichier archive
nombre_ligne_archives=`sed '1d' .sh-toolbox/archives | wc -l`
if [ $nombre_ligne_archives -eq 0 ]; then
	echo "le fichier archives ne possèdent aucune metion d'aucune archives"
	exit 7
fi

#affiche toutes les mentions d'archives présentes dans le fichier archives
echo | sed -E 's/(.*).*:.*/\1/gm' | sed '1d' .sh-toolbox/archives

#demande un utilisateur un nombre et s'assure que ce soit bien un nombre
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

#rajoute 1 car par exemple, la troisème ligne affiché et la quatrième dans le fichier archive
let "rep=rep+1"

archive_choisis=`sed -n ${rep}p .sh-toolbox/archives | sed -E 's/(.*):.*:.*:.*/\1/'`
echo "vous avez choisis l'archive : $archive_choisis"

#on s assure que le fichier choisis est bien un fichier .tar.gz que l'on peut décomprésé
if [ ! `echo $archive_choisis | cut  -d '.' -f 2` == "tar" ]; then
        echo "on ne peut pas décompresser non compressé"
        exit 6
fi

#demande si on veut effacer et recréer temp pour le rmeplir ou non des nouvelles informations au cas ou il existe
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

#on décompresse l'archive
tar -xzf $archive_choisis -C "./temp"

#note qulle archives à était choisis dans un fichier dans temp
touch ./temp/archive_choisis.txt
echo $rep > ./temp/archive_choisis.txt

#teste si tar n a pas eu derreur
if [ ! $? -eq 0 ]; then
	echo "la décompression du fichier a échoué"
	exit 3
fi
echo "archive décomprésé"

#teste si le dossier log existe
if [ ! -e temp/var/log ]; then
	echo "le fichier des logs n'existe pas"
	exit 4
fi

#compte le nombre de fichier qu'il y a dans data
combien_fichier=`ls -l temp/data | wc -l`

#si il y en 0 alors erreur 5
if [ $combien_fichier -eq 0 ]; then
	echo "le dossier des données est vide"
	exit 5
fi

#si l'option -l est utiliser on s arrete la
if [ $less -eq 1 ];then
	exit 0
fi


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

echo "dernière connexion de l'admin : $date_admin"
echo "voilà les fichiers décomprésé posterieur à la dernière connexion d'admin : "

#on stoque et affiche les fichiers inféctés
post_modif_fich=`find temp -mtime $distance -type f`
find temp -mtime $distance -type f

#on stoque combien de fichiers sont inféctés
taille_post_mod=`find temp -mtime $distance -type f | wc -l`

echo "recherche de fichier similaire et non contaminés"
not_found=0 #dans le cas ou aucun ficheir intact existe
i=1
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
			echo "$same_name_file fait la même taille et à le même nom que le fichier $file infecté"
			not_found=1
		fi

		let "j=j+1"
	done
	let "i=i+1"
done

#si on ne trouve aucun fichier intact alors on le dit à l'utilisateur
if [ $not_found -eq 0 ]; then
	echo "aucun dossier intact trouver"
	exit 8
fi
rm -rf ./temp
exit 0
