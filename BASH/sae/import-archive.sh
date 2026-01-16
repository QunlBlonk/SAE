#!/bin/bash

if [ ! -d .sh-toolbox ]; then #regarde si .sh-toolbox existe
	echo ".sh-toolbox n'existe pas"
	exit 1
fi

forcage=1

while [ $# -ne 0 ]; do
	#si -f est trouver alors toutes les archives suivant sont forcer
	if [ "${1}" = "-f" ]; then
                forcage=0
                shift
        fi

	if [ ! -e ${1} ]; then #regarde si le fichier/dossier à copier existe
        	echo "l'archive n'existe pas"
        	exit 2
	fi

	nom=$(basename ${1})
	if [ ! -e .sh-toolbox/$nom ]; then #regarde si l'archive est dans .sh-toolbox
		cp ${1} .sh-toolbox #si oui le copie
		if [ $? -ne 0 ]; then
			echo "problème de copie"
			exit 3
		fi
		
		nbr=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`
		let "nbr=nbr-1"

		#prépare le fichier pour l'ajout de la nouvelle mention
		if [ $nbr -eq 0 ]; then
			cat << TAG2 > .sh-toolbox/archives
1
TAG2
			
		else
			let "nbr=nbr+1"
			fichier=`sed -s "1d" .sh-toolbox/archives`
			cat << TAG > .sh-toolbox/archives
$nbr
$fichier
TAG
		fi
		
		#demande quelle option (f ou s) l'utilisateur veut
		rep=""
		while [ "$rep" != "f" ] && [ "$rep" != "s" ];do
			echo "voulez vous stoquer la clef de cette archives dans un fichier (f) ou directement dans le fichier archive (s)"
			read rep
		done
		
		
		
		#rajoute la mention à la suite et s'assure que archives est bien mise à jour
		echo "$nom:$(date '+%Y%m%d-%H%M%S')::$rep" >> .sh-toolbox/archives
		
		./is-shtoolbox-good.sh
		if [ $? -ne 0 ]; then
			echo "la mise à jour de l'archive à rencontré un problème"
			exit 4
		fi
	else
		
		if [ $forcage -eq 1 ]; then
			echo "voulez vous écraser ce fichier ? (y/n)"
			cp -i ${1} .sh-toolbox
		else
			cp ${1} .sh-toolbox
		fi
		
		
		
		
		if [ $? -ne 0 ]; then
			echo "problème de copie"
			exit 3
		fi
			

			

	fi



	if [ ! -d .sh-toolbox/$nom ] && [ ! -f .sh-toolbox/$nom ]; then #regarde si la copie à bien été faite
		echo "la copie à rencontré un problème"
		exit 3
	fi
	shift
done





exit 0
