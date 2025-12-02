#!/bin/bash
#cas où le dossier d'entreposage n'existe pas
if [ ! -e .sh-toolbox ]; then
	echo "le dossier .sh-toolbox n'existe pas"
	exit 1
fi 
#cas où le fichier d'archivage n'existe pas
if [ ! -e .sh-toolbox/archives ]; then
	echo "le fichier archives n'existe pas"
	exit 2
fi 
f=0
i=2
taille=`wc -l < .sh-toolbox/archives` #récupération du nombre de lignes dans l'archives et ajout de 1 pour sauter la ligne avec le nombre d'archives
let "taille = taille +1"
while [ $taille -ne $i ]; do
	sed -n ${i}p .sh-toolbox/archives 
	temp=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 `
	if [ ! -e ".sh-toolbox/$temp" ]; then #après vérification dans le repertoire, si un dossier inscrit dans le registre ne s'y trouve pas, on relève l'erreur dans la variable f
		echo "l'archive $temp existe dans archives mais n'est pas dans le repertoire sh-toolbox"
		f=1
	fi
	let "i=i+1"
done
j=1
parcours_archive=2
temp2=`ls -1 .sh-toolbox | wc -l`
let "temp2=temp2+1"
while [ $temp2 -ne $j ]; do
	dossier=` ls -1 .sh-toolbox | sed -n ${j}p `
	if [ $dossier != "archives" ];then
		l=0
		parcours_archive=2
		while [ $taille -ne $parcours_archive ]; do
			list_fich=`sed -n ${parcours_archive}p .sh-toolbox/archives | cut -d ":" -f 1 `
			if [ $list_fich == $dossier ];then
				let "l=l+1"
			fi
			let "parcours_archive=parcours_archive+1"
		done
	#prise en compte du cas où l'archive ne contient pas un dossier existant dans le répertoire, avec prise en note de cette erreur dans la variable f
	if [ $l -eq 0 ]; then
		echo "le fichier $dossier existe dans le repertoire mais n'est pas dans l'archive"
		f=1
	fi
	fi
	let "j=j+1"
done
#si jamais le fichier existe dans le répertoire mais pas dans l'archive ou l'inverse, renvoie la sortie n°3 si la variable f a reçue la prise en note de l'erreur.
if [ $f -eq 1 ]; then
	exit 3
fi
exit 0
