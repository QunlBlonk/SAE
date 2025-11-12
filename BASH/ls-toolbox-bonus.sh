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
while [ $taille -ne $i ]; do
	sed -n ${i}p .sh-toolbox/archives 
	temp=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 `
	if [ ! -e ".sh-toolbox/$temp" ]; then
		echo "l'archive $temp existe dans archives mais n'est pas dans le repertoire sh-toolbox"
		f=1
	fi
	let "i=i+1"
done
j=1
parcours_archive=1
temp2=`ls -1 .sh-toolbox | wc -l`
let "temp2=temp2+1"
while [ $temp2 -ne $j ]; do
	dossier=` ls -1 .sh-toolbox | sed -n ${j}p `
	if [ $dossier != "archives" ];then
		l=0
		while [ $taille -ne $parcours_archive ]; do
			list_fich=`sed -n ${parcours_archive}p .sh-toolbox/archives | cut -d ":" -f 1 `
			if [ $list_fich = $dossier ];then
				let "l=l+1"
			fi
			let "parcours_archive=parcours_archive+1"
		done
	
	if [ $l -eq 0 ]; then
		echo "le fichier $dossier existe dans le repertoire mais n'est pas dans l'archive"
		f=1
	fi
	fi
	let "j=j+1"
done

if [ $f -eq 1 ]; then
	exit 3
fi
exit 0
