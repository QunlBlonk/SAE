Bienvenue dans ce petit guide d'utilisation de toute les fonctions
Elle se divise en deux parties
- la partie C
- et la partie Bash

la partie C n'est pas forcément fait poure être utiliser tout seul, à utiliser avec précaution
cependant la partie Bash elle est faite pour être utiliser sans problème


===== LA PARTIE C =====

dosseir soruce: src

decipher.c [clef] [fichier]
explication:
decipher permet de déchiffrer un fichier dont le chemin est donnée en deuxième paramètre grâce à une clef en base64 passer en premier paramètre
decipher ne peut déchiffrer que des fichiers chiffré en vigenere avec l'alphabet BASE64
la clef en base64 peut contenir des = ou non, le programme le gérera
decipher en sortie créara un fichier du même nom que celui passer en paramètre avec "Decode" écrit juste avant l'extension

findkey.c [ficher intact] [fichier attaqué] [option]
explicaiton: 
findkey prend deux fichiers en entré, un intact en base64 et un chiffré en base64 + vigenere.
Son objectif est de trouver la clef de vigenere qui encode le fichier attaqués pour pouvoir la réutiliser sur les autres fichiers chiffrés
en sortie on obtient la clef en base64 qui encode les fichiers

option:
-o : l'option -o permet de donner dans un paramètre qui le suit un chemin de fichier. Le chemin doit exister mais le fichier pas forcément. et qui en plus de resortir la clef écrit la clef dans ce fichier




===== LA PARTIE BASH =====

init-toolbox.sh
explication:
init-toolbox.sh sert d'initialisateur à l'environnement, il s'assure que .sh-toolbox existe ainsi que le fichier archives.
Si ils n'exsitent pas il les créer.
Il s'assure aussi de la présence de decipher et findkey, ainsi que leur fichier sources dans dossier src
et les compile si il ne sont pas présent et les déplacent dans . pour pouvoir être utiliser par les autre programmes proprement
il s'assure aussi d'autre choses, référé vous à la partie exit si vous voulez en savoir plus

EXIT:
0 : tous c'est bien passer
1 : .sh-toolbox ou le fichier archives n'a pas réussis à être créer
2 : des archives existent déjà dans .sh-toolbox
10 : un des fichiers sources de la partie c n'existent pas
11 : gcc ou make n'existent pas sur cette appareil
12 : erreur de compilation


import-archive.sh [fichier] ... [option] [fichiers]
explication:
import-archives.sh permet d'importer une ou plusieurs archives dans .sh-toolbox
en les important il s'assure de les mentionner correctement dans le fichier archives

option:
-f : l'option -f permet de forcer l'import des archives qui suivent le -f, si elle est déjà présente on ne demandera pas l'utilisateur si il veut remplacer l'ancienne

EXIT:
0 : tous c'est bien passer
1 : .sh-toolbox n'existe pas
2 : archive passer en paramètre n'existe pas
3 : problème de copie
4 : problème de mise à jour de l'archive


is-shtoolbox-good.sh
explication: 
permet de s'assure que le fichier archives contient toutes les mentions de chaque archives stoqués dans .sh-toolbox
et que le chiffre en haut du fichier est correcte

EXIT:
0 : tous c'est bien passer
1 : problème de mention dans archives
2 : le chiffre en haut de archives et mauvais



ls-toolbox.sh
explication:
ls-toolbox.sh affiche toutes les mentions d'archives du fichier archives et si ils possèdent une clef.
ls-toolbox.sh sert aussi à savoir si un problème est présent :
soit une mention d'archives existe sans que l'archives soit stoqués
soit une archives est présentes dans .sh-toolbox mais il n'y a aucune mention dans le ficheir archives.
soit .sh-toolbox existe pas
soit le fichier archives n'existe pas

EXIT:
0 : la liste a été affichée sans erreur
1 : le dossier .sh-toolbox n’existe pas
2 : le fichier archives n’existe pas
3 : une archive mentionnée dans le fichier archives n’existe pas
3 : une archive existe sans être mentionnée dans le fichier archives


check-archive.sh [option]
explication:
check-archive.sh permet de trouver les fichiers attaqués et ce toujours sains.
en début on demande qu'elle archive on veut décomprésés
si elle est décompressable (.tar.gz) alros on la décompresse dans un dossier temporaire temp
si temp existe déjà on demande si l'utilisateur veut le supprimer pour le recréer
une fois le dossier décompréssés on regarde quand l'attaque a été effecuté (dernière connexion de admin)
puis on affiche tout les dossiers qui ont était modifiés après la date de l'attaque

option:
-l : l'option -l, pour less, raccourcis le programme pour juste utiliser la partie décomprésion sans la partie détéction de fichier attaqués

EXIT:
0 : toutes les opérations ont réussies
1 : le dossier .sh-toolbox n’existe pas
2 : le fichier archives n’existe pas
3 : la décompression a échoué
4 : le fichier des logs est manquant
5 : le dossier de données est vide
6 : le fichier que l'utilisateur veut décomprésé n'est pas un .tar.gz
7 : il y a 0 archives mentionner dans le fichier archive
8 : il n'y a aucun fichier intact trouver


restore-toolbox.sh
explication:
restore-toolbox.sh est en quelque sort similaire à innit-toolbox.sh. Il sert à rénitialiser et corriger tout les problèmes
demande de créer .sh-toolbox si il n'existe pas
demande de créer le fichiers archives si il n'existe pas
demande si il veut mentionner une archive présentes dans le dossier .sh-toolbox mais pas mentionnés dans le fichier archive
ainsi que demander quelle option de stoquage de clef il veut
demande si il veut supprimer la mention d'une archive qui n'est pas présentes dans le dossier .sh-toolbox

EXIT:
0 : tous c'es bien passé
1 : problème lors de l'ajout de la mention d'une archive



restore-archive.sh [dossier]
explication:
restore-archive.sh sert à restaurer l'entierté des fichiers infectés d'une archive.
il prend un dossier de stoquage existant ou non.
LE DOSSIER EN PARAMETRE EST OBLIGATOIRE
si il est remplis on demande si il veut le vider
dans tout les cas l'arborescence de l'archive est copier dans ce dossier
on trouve les fichier intact qui correspondent à des fichier infectés pour trouver la clef
une fois la clef trouver on decode tout les fichiers attaqués que l'on stoque à leur place dans le dossier passer en paramètre
si il existe déjà alors on demande à l'utilisateur si il veut récrire par dessus
la clef utiliser est maitenant stoqués et déchiffrer de la base64 à l'endroit exiger par l'utilisateur
f pour un fichier indépendant
s pour dans le fichier archives

avretissement : seul les fichiers infecté décoder sont restoqués dans le dossier passer en paramètre, les autres intact eux sont laisser tranquille sans les copier dans le dossier

EXIT :
0 : tous c'est bien passer
1 : .sh-toolbox n'existe pas
2 : le dossier de destination n’a pas pu être créé
3 : la mise à jour du fichier archives a échoué ou la clef à pas était stoqués dans son fichier indépendant
4 : un des fichiers n’a pas pu être restauré (pas réussis)
5 : trop ou pas assez d'agument (1 argument obligatoire)
6 : le fichier que l'utilisateur veut décomprésé n'est pas un .tar.gz
7 : il y a 0 archives mentionner dans le fichier archive
8 : le chemin passer en paramètre est un fichier
