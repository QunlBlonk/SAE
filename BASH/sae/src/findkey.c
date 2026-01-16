#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "statique.h"




int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	char * option=(char*)calloc(1,sizeof(char));
	//test pour s'assurer du nombre d'argument
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}

	if (argc > 3){
		if (argc < 5) {printf("aucun nom de fichier passer en paramètre"); return 2;}
		if (strcmp("-o",argv[3])==0){
			option=(char *)realloc(option, sizeof(char)*strlen(argv[4]));
			option=argv[4];
		}
	}
	

	//créer ma table de vigenere
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);

	char * fichierC = argv[1];
    	char * fichierA = argv[2];
	if (access(fichierC, F_OK) == 0 && access(fichierA, F_OK) == 0) {
		printf("%s",findKey(fichierC, fichierA, option));
	} else {
		printf("erreur : les paramètres ne sont pas des dossiers");
		return 3;
	}

	return 0;
}
