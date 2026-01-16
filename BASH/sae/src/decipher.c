#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "statique.h"




int main(int argc, char * argv[]){
	
	int taille_alphabet=64;

	//test pour s'assurer du nombre d'argument
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}

	//créer ma table de vigenere
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);

	char * fichierC = argv[1];
    	char * fichierA = argv[2];

	
	int longeurClef = strlen(fichierC);
		
	char * new_clef=(char *)calloc(longeurClef+6,sizeof(char));

	//retire les "=" de la clef
	for (int i = 0; i < longeurClef; i++){
		if (fichierC[i]!='=') new_clef[i]=fichierC[i];
	}
	dechiffrement(fichierA, new_clef,tab_vigenere);
	return 0;
}
