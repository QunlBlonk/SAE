Bonjour dans ce petit README des fichiers en .c
si vous avez des doutes sur l'un des programmes, des commentaires sont aussi présents dans chaque fichiers

SOMMAIRE:
1. cipher.c (12 - 22)
2. decipher.c (25 - 39)
3. findkey.c (41 - 54)



1. cipher.c
"cipher.c permet de prendre un fichier de base qui a été encodé en base64 et pouvoir le chiffrer grâce à une clé de chiffrement
Pour cela un tableau de Vigenère devra être utilisé pour permettre cela. 
Si le fichier n'est pas encodé en base64 de base des erreurs de chiffrement et après de déchiffrement se créeront. 
Un nouveau fichier chiffré sera créer avec comme nom "nom_du_fichierChiffrer"



2. decipher.c
"decipher.c prend un fichier chiffré qui lui même est encodé en base64 et permet de le déchiffrer, renvoyant donc un nouveau fichier déchiffrer
La clé de chiffrement du fichier chiffré est nécessaire ainsi qu'un tableau de Vigenère.
Si le fichier n'avait pas été encodé en base64 de base (ce qui est une possibilité) des erreurs de déchiffrement se créeront
Le nouveau fichier créé s'appellera "nom_du_fichierChiffrerDecoder"

3. findkey.c
"findkey.c prend en paramètres deux fichiers codés en base64, l'un étant le fichier de base et l'autre étant le fichier qui a été chiffrer.
 Le but de ce code est de retrouver la clé de chiffrement ayant permis de passer du fichier de base au fichier chiffrer
findkey.c comparera chaque lettre des deux fichiers pour trouver ainsi la clé de chiffrement (si la clé est une répétition de caractères tel que abaabaaba, seul "aba" sera conserver comme clé"
"

