#!/bin/bash

if [ ! -e .sh-toolbox ]; then
	echo "le dossier .sh-toolbox n'existe pas"
	exit 1
fi 

if [ ! -e .sh-toolbox/archives ]; then
	echo "le fichier archives n'existe pas"
	exit 2
fi 
f=0
i=2
taille=`wc -l < .sh-toolbox/archives`
let "taille = taille +1"

#on teste si les mentions amène à une archive
while [ $taille -ne $i ]; do
	sed -n ${i}p .sh-toolbox/archives
	temp=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 `

	#regarde si la clef existe dan le cas ou elle stoqués dans le fichier archives
	if [ -z `sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 3 ` ] && [ `sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 4` == "s" ]; then
		echo "la clef de chiffrement de l'archive $temp n'est pas connue"
	fi

	#regarde si la clef existe dans le cas ou elle est stoqués dans fichier indépendant
	nom_sans_extension=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 | cut -d "." -f 1`
	if [ `sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 4` == "f" ] && [ ! -e ".sh-toolbox/$nom_sans_extension" ]; then
		echo "la clef de chiffrement de l'archive $temp n'est pas connue"
	fi


	#si le fichier n'est pas dans .sh-toolbox erreur
	if [ ! -e ".sh-toolbox/$temp" ]; then
		echo "l'archive $temp existe dans archives mais n'est pas dans le repertoire sh-toolbox"
		f=1
	fi
	echo ""
	let "i=i+1"
done
j=1

temp2=`ls -1 .sh-toolbox | wc -l`
let "temp2=temp2+1"

#on teste si un archive ammène à une mention dans le fichier archives
while [ $temp2 -ne $j ]; do
	dossier=` ls -1 .sh-toolbox | sed -n ${j}p `

	if [ $dossier != "archives" ] && [ -f $dossier ];then #on passe le ficheir archives et les dossier (qui stoque des clefs)
		l=0
		parcours_archive=2
		#on teste toute les mentions
		while [ $taille -ne $parcours_archive ]; do
			list_fich=`sed -n ${parcours_archive}p .sh-toolbox/archives | cut -d ":" -f 1 `
			if [ $list_fich == $dossier ];then
				let "l=l+1"
			fi
			let "parcours_archive=parcours_archive+1"
		done

		#si une archive n'ammène à aucune mention erreur
		if [ $l -eq 0 ]; then
			echo "le fichier $dossier existe dans le repertoire mais n'est pas dans l'archive"
			f=1
		fi
	fi
	let "j=j+1"
done

#si une erreur a était détecté on exit 3
if [ $f -eq 1 ]; then
	exit 3
fi
exit 0
