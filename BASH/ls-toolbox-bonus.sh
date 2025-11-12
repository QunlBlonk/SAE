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
while 
