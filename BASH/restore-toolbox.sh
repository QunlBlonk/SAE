#!/bin/bash
var1=0
var2=0
var3=0
./ls-toolbox.sh
code_erreur="$?"
if [ $code_erreur -eq 1 ]; then
	echo "voulez vous créer le dossier .sh-toolbox ? (y/n)"
	read var1
	while [ $var1 != "y" ] || [ $var1 != "n" ]; do
		echo "ti est con ma parole, j'ai dit y ou n"
		read var1
	done
	if [ $var1 = "y" ]; then
		mkdir .sh-toolbox
	fi
else if [ $code_erreur -eq 2 ]; then
	echo "voulez vous créer le fichier archives ? (y/n)"
	read var2
	while [ $var2 != "y" ] || [ $var2 != "n" ]; do
		echo "ti est con ma parole, j'ai dit y ou n"
		read var2
	done
	if [ $var2 = "y" ]; then
		touch .sh-toolbox/archives
		echo 0 > .sh-toolbox/archives
	fi
fi
fi
if [ $code_erreur -eq 3 ]; then
	i=2
	taille=`wc -l < .sh-toolbox/archives`
	let "taille = taille +1"
	while [ $taille -ne $i ]; do
		temp=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 `
		if [ ! -e ".sh-toolbox/$temp" ]; then
			echo "voulez vous créer supprimer la mention de l'archive ? (y/n)"
			read var3
			while [ $var3 != "y" ] && [ $var3 != "n" ]; do
				echo "ti est con ma parole, j'ai dit y ou n"
				read var3
			done
			if [ $var3 = "y" ]; then
				fichier=`sed -s "${i}d" .sh-toolbox/archives`
				echo $fichier > .sh-toolbox/archives
				echo "$taille"
				newTaille=0
				let "newTaille=taille-2"
				sed -i "1c$newTaille" .sh-toolbox/archives
			fi
		fi
		let "i=i+1"
	done
fi
