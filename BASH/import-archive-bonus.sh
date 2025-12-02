#!/bin/bash
#test si .sh-toolbox existe
if [ ! -d .sh-toolbox ]; then
	echo ".sh-toolbox n'existe pas"
	exit 1
fi

#regarde au premier emplacement de paramètre pour voir sil l'action forcage est demandé
forcage=0
if [ "${1}" = "-f" ]; then 
	forcage=1
	shift
fi

#test si le fichier/dossier à copier existe
if [ ! -e ${1} ]; then
	echo "l'archive n'existe pas"
	exit 2
fi

while [ $# -ne 0 ]; do
	nom=$(basename ${1})

	#test si l'archive est pas dans .sh-toolbox
	if [ ! -f .sh-toolbox/$nom ]; then 
	
		#copie le fichier dans .sh-toolbox
		cp ${1} .sh-toolbox

		#test si la copie à eu un problème
		if [ $? -ne 0 ]; then
			echo "problème de copie"
			exit 3
		fi

		#stoque le nombre de ligne de archives avant ajout
		nbr=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`

		#-1 pour obtenir le nombre de mention
		let "nbr=nbr-1"

		#deux cas, soit il n'y a qu'un 0 dans archives alors je le remplace par 1 puis ajoute
		#ou le fichier archive à en première ligne un chiffre et une mention d'archive après. Alors je prend la première ligne rajoute un, rajoute le reste du fichier que j'ai stoqué et enfin ajoute la mention supplémentaire
		if [ $nbr -eq 0 ]; then
			cat << TAG2 > .sh-toolbox/archives
1		
TAG2
			
		else
			#stoque les mentions d'archives déjà présentes sans le chiffre
			fichier=`sed -s "1d" .sh-toolbox/archives`

			#+1 à nombre car on va rajouter une archive
			let "nbr=nbr+1"

			#rajoute dans le fichier le nombre d'archive qu'il va y avoir, et les mentions des précédentes archives qui était stoqués
			cat << TAG > .sh-toolbox/archives
$nbr
$fichier 
TAG
		fi
		
		
		
		
		
		#ajout de la mention supplémentaire (celle passé en paramètre)
		echo "$nom:$(date '+%Y%m%d-%H%M%S'):" >> .sh-toolbox/archives

		#recalcule le nombre de ligne qu'il y a dans le fichier archive -1 pour avoir le nombre de mention
		nbrLA=`cat .sh-toolbox/archives | wc -l`
		let "nbrLA=nbrLA-1"

		#test si le nombre stoqués dans archives (nbr) n'est pas égal au nombre de mention d'arcchives (nbrLA)
		if [ $nbr -ne $nbrLA ]; then
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
		echo "la copie à rencontré un problème"
		exit 3
	fi
	shift
done





exit 0

