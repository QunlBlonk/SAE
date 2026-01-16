#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "pas assez ou trop d'argument"
	exit 5
fi

if [ ! -e ./.sh-toolbox ]; then
	echo ".sh-toolbox n'existe pas"
	exit 1
fi

#si dossier en paramètre existe
if [ ! -e ${1} ];then
	mkdir ${1}
	#si mkdir à échoué
	if [ ! $? -eq 0 ];then
		echo "problème de création du dossier"
		exit 2
	fi
else
	#si le chemin en paramètre amène à un fichier = erreur
	if [ -f ${1} ];then
		echo "le chemin passer en paramètre ammène à un fichier"
		exit 8
	fi
	#si le dossier n'est pas vide on demande si on veule vider
	est_vide=`ls ${1} | wc -l`
	if [ $est_vide -ne 0 ];then
		echo "le dossier que vous avez choisis n'est pas vide"
		rep_erase=""
		while [ "$rep_erase" != "1" ] && [ "$rep_erase" != "2" ]; do
			echo "voulez vous l'écrase (1) ou voulez vous le garder intact (2)"
			read rep_erase
		done

		if [ "$rep_erase" == "1" ]; then
			rm -rf ${1}/*
		fi
	fi
fi


#on appelle check-archive avec l'option l (less) pour juste décompresser mon archive sans avoir à recopier tout le code ici
./check-archive.sh -l
sortie=$?
if [ $sortie -eq 6 ]; then
	exit 6
fi

if [ $sortie -eq 7 ];then
	exit 7
fi

#créer l'arborescence de l archive dans le dossier passer en paramètre
taille_archi=`find ./temp -type d -links 2 | wc -l`
i_archi=1
while [ $i_archi -le $taille_archi ]; do
	to_create=`find ./temp -type d -links 2 | sed ${i_archi}p | sed -E "s|^.\/temp\/(.*)|${1}\/\1|gm"`
	mkdir -p $to_create
	let "i_archi=i_archi+1"
done

#stoque le numéro de la ligne de l'archive choisis
archives_choisis=`cat ./temp/archive_choisis.txt`

#trouve l'option de mon archive est créer un dossier si besoin (f)
option_archive=`sed -n ${archives_choisis}p .sh-toolbox/archives | cut -d ":" -f 4`
nom_archive_sans_extention=`sed -n ${archives_choisis}p .sh-toolbox/archives | cut -d ":" -f 1 | cut -d "." -f 1`
if [ "$option_archive" == "f" ];then
	if [ ! -e ".sh-toolbox/$nom_archive_sans_extention" ]; then
		mkdir ".sh-toolbox/$nom_archive_sans_extention"
	else
		replace_key=""
		while [ "$replace_key" != "y" ] && [ "$replace_key" != "n" ];do
			echo "une clef est déjà stoqué voulez vous la remplacer (y/n)"
			read replace_key
		done
	fi
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

#on stoque et affiche les fichiers inféctés
#post_modif_fich=`find temp -mtime $distance -type f`
find temp -mtime $distance -type f

#on stoque combien de fichiers sont inféctés
taille_post_mod=`find temp -mtime $distance -type f | wc -l`

not_found=0 #dans le cas ou aucun ficheir intact existe
i=1
clef=""
maxClefTaille=0
maxClef=""
touch ./temp/fichier_infectés
echo -n "" > ./temp/fichier_infectés
while [ $i -le $taille_post_mod ]; do
        #prend un fichier infécté et en extrait le nom + suffix ainsi que sa taille
        file=`find temp -mtime $distance -type f | sed -n ${i}p`
        name=`basename $file`
        size_file=$(stat -c %s $file)
	echo $file >> ./temp/fichier_infectés

	#créer le fichier base64 de mes fichiers corompus
	file_64=`echo $file | sed -E "s/^(.*)\.(.*)$/\1_64.\2/"`
	base64 $file > $file_64

        j=1
        #on stoque le nombre de dossier avec le même nom que le fichier infécté
        taille_same_name=`find temp -name $name -type f | grep -v "$file" | wc -l`
        while [ $j -le $taille_same_name ];do
                #on extrait et stoques le nom d'un fichier intact du même nom de fichier ainsi que sa taille
                same_name_file=`find temp -name $name -type f | grep -v "$file" | sed -n ${j}p`
                size_same_name_file=$(stat -c %s $same_name_file)

                #on compare la taille du fichier infécté avec le fichier intact trouver pour voir si ce sont bien les mêmes
                if [ $size_file == $size_same_name_file ]; then
			same_name_file_64=`echo $same_name_file | sed -E "s/^(.*)\.(.*)$/\1_64.txt/"`
                        base64 $same_name_file > $same_name_file_64
			clef=$(./findkey $same_name_file_64 $file_64)

			if [ -z $clef ] || [ ${#clef} -gt $maxClefTaille ]; then
				echo "fichier utiliser pour clef : $same_name_file_64"
				maxClef=$(./findkey $same_name_file_64 $file_64)
				maxClefTaille=${#clef}
			fi
                        not_found=1
                fi

                let "j=j+1"
        done
        let "i=i+1"
done

#si l'option en fin de mention d archive est f on stoque la clef dans un fichier nommé KEY dans .sh-toolbox/nom du fichier sans extension
if [ "$option" == "f" ];then
	echo $maxClef | base64 -d | sed -E "s|(.*)base64.*|\1|" > ".sh-toolbox/$nom_archive_sans_extention/KEY"
	if [ ! -e ".sh-toolbox/$nom_archive_sans_extention/KEY" ];then
		echo "problème archive"
		exit 3
	fi
else
	if echo $maxClef | base64 -d | sed -E "s|(.*)base64.*|\1|" | grep -q '[^[:print:]\t\n]'; then
    		echo "La clef contient des caractères non imprimables"
		change=""
		while [ "$change" != "y" ] && [ "$change" != "n" ]; do
			echo "voulez vous plutot stoquer la clef dans un fichier"
			read change
		done
		if [ "$change" == "y" ];then
			mkdir ".sh-toolbox/$nom_archive_sans_extention"
			echo $maxClef | base64 -d | sed -E "s|(.*)base64.*|\1|" > ".sh-toolbox/$nom_archive_sans_extention/KEY"
			sed -E -i "${archives_choisis}s/^(.*:.*:).*:s/\1::f/" .sh-toolbox/archives

		fi
	fi
fi

#decode les fichiers infectés grâce à la clef est les stoque dans le dossier passer en paramètre en suivant bien l'arborescence
taille_fich_infect=`wc -l ./temp/fichier_infectés | cut -d " " -f 1`
i_fich_infect=1
probleme_decode=0
while [ $i_fich_infect -le $taille_fich_infect ]; do
	line=`sed -n ${i_fich_infect}p ./temp/fichier_infectés`
	#on trouve nos fichiers infectés encoder en 64
	nom_64=`echo -n $line | sed -E "s|^(.*)\.(.*)$|\1_64.\2|"`

	#on déchffre et trouve le dossier decoder
	./decipher $clef $nom_64
	nom_64Decoder=`echo -n $nom_64 | sed -E "s|^(.*_64)\.(.*)|\1Decoder.\2|"`

	#on créer le fichier décoder mais dans le dossier passer en paramètre
	new_nom_64Decoder=`echo -n $nom_64 | sed -E "s|^temp\/(.*_64)\.(.*)|${1}\/\1Decoder.\2|"`
	mv $nom_64Decoder $new_nom_64Decoder

	#on génère le nom du fichier décoder au propre
	nom=`echo -n $line | sed -E "s|^temp\/(.*)\.(.*)$|${1}\/\1.\2|"`
	if [ -e $nom ]; then
		sup=""
		#si un fichier du même nom existe on demande si on veut réecrire par dessus
		while [ "$sup" != "y" ] && [ "$sup" != "n" ];do
			echo "voulez vous récrire par dessus le fichier déjà présent (y) ou non (n)"
			read sup
		done
		if [ "$sup" == "y" ];then
        		cat $new_nom_64Decoder | base64 -di > $nom
		fi
	else #si le fichier existe pas alors on créer le créer dans le fichier passer en paramètre et le remplis
		touch $nom
        	cat $new_nom_64Decoder | base64 -di > $nom
	fi
	
	rm $new_nom_64Decoder
	let "i_fich_infect=i_fich_infect+1"
done


echo "clef_64 : $clef"

clef=`echo $clef | base64 -d | sed -E "s/^(.*)base64.*/\1/"`

echo "clef : $clef"

#si on ne trouve aucun fichier intact alors on le dit à l'utilisateur
if [ $not_found -eq 0 ]; then
        echo "aucun dossier intact trouver"
        exit 5
else
	if [ "$option_archive" == "s" ];then
		sed -E -i "${archives_choisis}s/^(.*:.*:).*:.*/\1${clef}:s/" .sh-toolbox/archives
		if [ `sed -n ${archives_choisis}p .sh-toolbox/archives | sed -E "s|^.*:.*:(.*):.*|\1|"` != "${clef}" ];then
			echo "problème archive"
			exit 3
		fi
	else
		 sed -E -i "${archives_choisis}s/^(.*:.*:).*:.*/\1:f/" .sh-toolbox/archives
	fi

fi
rm -rf ./temp
exit 0
