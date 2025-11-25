#!/bin/bash

echo | sed -E 's/(.*).*:.*/\1/gm' | sed '1d' .sh-toolbox/archives
bienUnChiffre="x"
nbrLigne=`wc -l .sh-toolbox/archives | cut -d ' ' -f 1`

while [ "$bienUnChiffre" != "ouichiffre" ]; do

        echo "choissisez une archive (indice de l'archive que vous voulez)"
        read rep
        bienUnChiffre=`echo $rep | sed 's/[1-9][0-9]*/ouichiffre/'`

        if [ "$bienUnChiffre" == "ouichiffre" ]; then
                if [ $rep -lt 1 ] || [ $rep -gt $nbrLigne ];then
                        bienUnChiffre="x"
                fi
        fi
done

let "rep=rep+1"

echo -n "vous avez choisis l'archive "
archive_choisis=`sed -n ${rep}p .sh-toolbox/archives | sed -E 's/(.*):.*:.*/\1/'`
if [ ! -e "./temp" ]; then
        mkdir temp
        else
        echo "voulez vous effacer et recréer le fichier temp ?"
        read effacer
        while [ "$effacer" != 'y' ] && [ "$effacer" != 'n' ];do
                echo "voulez vous effacer et recréer le fichier temp ?(y/n)"
                read effacer
        done
        if [ "$effacer" == 'y' ]; then
                rm -dr temp
                mkdir temp
        fi
fi
echo $archive_choisis
tar -xzf $archive_choisis -C "./temp"

echo "archive décomprésé"

date_admin=`cat temp/var/log/auth.log | grep ' admin ' | sed -n 1p | sed -E 's/(.* [0-9]{2} .*) .* .*: .*/\1/'`
echo $date_admin
