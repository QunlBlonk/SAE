#!/bin/bash


taille_archives=`wc -l .sh-toolbox/archives | cut -d " " -f 1`
i_archives=2
#regarde chaque mention de archives et regarde si elle les trouvent dans .sh-toolbox
while [ $i_archives -le $taille_archives ];do
	mention=`cat .sh-toolbox/archives | sed -n ${i_archives}p | cut -d ":" -f 1 | cut -d "." -f 1`
	nbr_mention=`ls .sh-toolbox | grep "$mention" | wc -l`
	i_mention_ls=1
	bon=0
	while [ $i_mention_ls -le $nbr_mention ];do
		possible_fichier=`ls .sh-toolbox | grep "$mention" | sed -n ${i_mention_ls}p | sed -E "s|(.*)|.sh-toolbox/\1|"`
		if [ -f $possible_fichier ]; then
			bon=1
		fi
		let "i_mention_ls=i_mention_ls+1"
	done
	let "i_archives=i_archives+1"

	if [ $bon -eq 0 ];then
		echo "problème"
		exit 1;
	fi
done



#calcul le nombre de mention total et prend le chiffre en haut du fichier archives

nbr_mention=`wc -l .sh-toolbox/archives | cut -d " " -f 1`
#retire la ligne du chiffre
let "nbr_mention=nbr_mention-1"

nbr_mention_archives=`cat .sh-toolbox/archives | sed -n 1p`

echo "$nbr_mention $nbr_mention_archives"

#si ils sont différent alors problème dans archives
if [ $nbr_mention -ne $nbr_mention_archives ];then
	echo "le nombre en haut du fichier archives ne correspond pas au nombre d'archive réel"
	exit 2
fi

exit 0;
