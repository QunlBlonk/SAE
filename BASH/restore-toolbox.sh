#!/bin/bash
var1=0
var2=0
var3=0
./ls-toolbox.sh
code_erreur="$?"
if [ $code_erreur -eq 1 ]; then
	echo "voulez vous créer le dossier .sh-toolbox ? (y/n)"
	read var1
	while [ $var1 != "y" ] && [ $var1 != "n" ]; do
		echo "ti est con ma parole, j'ai dit y ou n"
		read var1
		echo $var1
	done
	if [ $var1 = "y" ]; then
		mkdir .sh-toolbox
	fi
fi
if [ $code_erreur -eq 2 ] || [ $code_erreur -eq 1 ]; then #dans le cas de l'erreur 2 c est si le fichier archives n existe pas, dans le deuxième cas on crée .sh-toolbox juste au dessus donc sa fait juste sens que le fichier archives doivent aussi être créer
	echo "voulez vous créer le fichier archives ? (y/n)"
	read var2
	while [ $var2 != "y" ] && [ $var2 != "n" ]; do
		echo "ti est con ma parole, j'ai dit y ou n"
		read var2
	done
	if [ $var2 = "y" ]; then
		touch .sh-toolbox/archives
		echo 0 > .sh-toolbox/archives
	fi
fi

if [ $code_erreur -eq 3 ]; then
	i=2
	taille=`wc -l < .sh-toolbox/archives`
	let "taille = taille +1"
	while [ $taille -ne $i ]; do
		name_mention=`sed -n ${i}p .sh-toolbox/archives | cut -d ":" -f 1 `
		if [ ! -e ".sh-toolbox/$name_mention" ]; then
			echo "relier $name_mention à une archive (chemin relatif ou chemin absolu)"
			read rep
			verif="y"
			#demande à l'utilisteur le chemin de l archive et si il ne veut pas, répond n à voulez vous réassayez
			while [ ! -e $rep ] && [ $verif == "y" ]; do
				echo "$rep n'existe pas ou le chemin est incorrect"

				#premiere demande pour s'assurer qu il le veut bien
				echo "voulez vous réessayer ?"
                                read verif

				while [ $verif != "y" ] && [ $verif != "n" ];do
					echo "voulez vous réessayer ?"
					read verif
				done
				if [ $verif == "y" ]; then
					echo "donnez le chemin absolu ou relatif de l'archive"
					read rep
				fi
			done
			
			copie=1
			#si après les vérifs, $rep est bien une archive qui existe alors la rajoute
			if [ -e $rep ]; then
                        	name_archive=`basename $rep`

				#si l'archive donner par l utilisateur n est pas la même que celle de la mention
                                if [ $name_archive != $name_mention ]; then
                                	echo "l'archive que vous avez choisi ne possèdent pas le même nom que celle précédente"
					echo ""
                                else
                                        cp $rep .sh-toolbox
					copie=0
                                fi
                        fi
			if [ $copie -eq 1 ]; then
				echo "voulez vous supprimer la mention de l'archive ? (y/n)"
				read rep
				while [ $rep != "y" ] && [ $rep != "n" ]; do
					echo "ti est con ma parole, j'ai dit y ou n"
					read rep
				done
				if [ $rep == "y" ]; then
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
		fi
		let "i=i+1"
	done
	#check toute les fichiers et regardent si elles osnt mentionnés dans l'archives, si elles ene sont pas mentionnés alors on demande si il veut lajouter
	taille_fichier=`ls -1 .sh-toolbox | wc -l`
	let "taille_fichier=taille_fichier+1"
	j=1
	t=1
	while [ $j -lt $taille_fichier ];do
		nom_fich=`ls -1 .sh-toolbox | sed -n ${j}p`
		if [ "$nom_fich" != "archives" ]; then
			parcours_archive=2
			taille_archive=`wc -l < .sh-toolbox/archives`
			let "taille_archive=taille_archive+1"
			t=1
			while [ $parcours_archive -lt $taille_archive ]; do
				nom_archive=`sed -n ${parcours_archive}p .sh-toolbox/archives | cut -d ":" -f 1 `
				if [ $nom_fich == $nom_archive ]; then
					let "j=j+1"
					t=0
				fi
				let "parcours_archive=parcours_archive+1"
			done
		else
			t=0
			let "j=j+1"
		fi
			
			if [ $t -eq 1 ];then
				echo "voulez vous créer la mention de l'archive ${nom_fich} ? (y/n)"
				read var3
				while [ $var3 != "y" ] && [ $var3 != "n" ]; do
					echo "ti est con ma parole, j'ai dit y ou n"
					read var3
				done
				if [ $var3 = "y" ]; then #rappel : faire l'exception pour 0
					nbr_ligne=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`
					fichier2=`sed -s "1d" .sh-toolbox/archives`
					if [ $nbr_ligne -eq 1 ]; then
					cat << TAG > .sh-toolbox/archives
$nbr_ligne
TAG
					else
					cat << TAG > .sh-toolbox/archives
$nbr_ligne
$fichier2
TAG
					fi
					echo "$nom_fich:$(date '+%Y%m%d-%H%M%S'):" >> .sh-toolbox/archives
				else
					let "j=j+1"
				fi
			fi
	done
fi

taille_archive=`wc -l .sh-toolbox/archives | cut -d " " -f 1`
let "taille_archive=taille_archive-1"
nombre_mention=`sed -n "1p" .sh-toolbox/archives`

if [ $taille_archive -ne $nombre_mention ]; then
	echo "le nombre de mention à été corrigé"
	all_mentions=`sed -s "1d" .sh-toolbox/archives`
	cat << TAG > .sh-toolbox/archives
$taille_archive
$all_mentions
TAG
fi
