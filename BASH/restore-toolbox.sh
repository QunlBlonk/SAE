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
				cat << TAG > .sh-toolbox/archives
$fichier				
TAG
				fichier=`sed -s "1d" .sh-toolbox/archives`
				newTaille=0
				let "newTaille=taille-3"
				cat << TAG > .sh-toolbox/archives
$newTaille
$fichier				
TAG
				
				
			fi
		fi
		let "i=i+1"
	done
	
	taille2=`ls -1 .sh-toolbox | wc -l`
	j=1
	while [ $taille -ne $j ];do
		nom_fich= `ls -1 .sh-toolbox | sed -n ${j}p` 
		if [ $nom_fich != "archives" ]; then
			parcours_archive=2
			taille2=`wc -l < .sh-toolbox/archives`
			t=1
			while [ $parcours_archive -ne $taille2 ]; do
				nom_archive=`sed -n ${parcours_archive}p .sh-toolbox/archives | cut -d ":" -f 1 `
				if [ $nom_fich == $nom_archive ]; then
					let "j=j+1"
					t=0
				fi
				let "parcours_archive=parcours_archive+1"
			done
		else
			let "j=j+1"
		fi
			
			if [ $t -eq 1 ];then
				echo "voulez vous créer supprimer la mention de l'archive ? (y/n)"
				read var3
				while [ $var3 != "y" ] && [ $var3 != "n" ]; do
					echo "ti est con ma parole, j'ai dit y ou n"
					read var3
				done
				if [ $var3 = "y" ]; then #rappel : faire l'exception pour 0
					nbr_ligne=`wc -l .sh-toolbox/archives`
					fichier2=`sed -s "1d" .sh-toolbox/archives`
					cat << TAG > .sh-toolbox/archives
$nbr_ligne
$fichier2							
TAG
					echo "$nom_fich:$(date '+%Y%m%d-%H%M%S'):" >> .sh-toolbox/archives
				fi
			fi
	
	done	
	

fi
