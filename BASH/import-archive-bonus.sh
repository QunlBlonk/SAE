#!/bin/bash




if [ ! -d .sh-toolbox ]; then #regarde si .sh-toolbox existe
	echo ".sh-toolbox n'existe pas"
	exit 1
fi

forcage=0
if [ "${1}" = "-f" ]; then 
	forcage=1
	shift
fi

if [ ! -d ${1} ] && [ ! -f ${1} ]; then #regarde si le fichier/dossier à copier existe
	echo "l'archive n'existe pas"
	exit 2
fi

while [ $# -ne 0 ]; do
	nom=$(basename ${1})
	if [ ! -f .sh-toolbox/$nom ]; then #regarde si l'archive est dans .sh-toolbox
		cp ${1} .sh-toolbox #si oui le copie
		if [ $? -ne 0 ]; then
			echo "problème de copie"
			exit 3
		fi
		
		
		nbrL=`ls .sh-toolbox | wc -l`
		let "nbrL=nbrL-1"
		
		fichier=`sed -s "1d" .sh-toolbox/archives`
		echo $nbrL > .sh-toolbox/archives
		cat << TAG >> .sh-toolbox/archives
$fichier 
TAG
		
		echo "$nom:$(date '+%Y%m%d-%H%M%S'):" >> .sh-toolbox/archives
		if [ $nbrL -eq 1 ];then
			fichier=`sed -s "2d" .sh-toolbox/archives`
			cat << TAG > .sh-toolbox/archives
$fichier 
TAG
		fi
		
		nbrLA=`cat .sh-toolbox/archives | wc -l`
		let "nbrLA=nbrLA-1"

		if [ $nbrLA -ne $nbrL ]; then #regarde si archive à bien pris +1
			echo "la mise à jour de l'archive à rencontré un problème"
			exit 4
		fi
	else
		
		if [ $forcage -eq 0 ]; then
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
		echo "la copie à rencotnré un problème"
		exit 3
	fi
	shift
done





exit 0
