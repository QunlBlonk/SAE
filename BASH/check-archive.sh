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
fi
echo $archive_choisis
tar -xzf $archive_choisis -C "./temp"
if [ $? -eq 0 ]; then
        echo "archibe décomprésé"
fi
