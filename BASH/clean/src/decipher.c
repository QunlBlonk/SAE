#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "statique.h"




int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);
	
	char * clef = argv[1];
    char * fichierA = argv[2];
    
	int longeurClef = strlen(clef);
		
	char * new_clef=(char *)calloc(longeurClef+1,sizeof(char));

	for (int i = 0; i < longeurClef; i++){
		if (clef[i]!='=') new_clef[i]=clef[i];
	}
		
	dechiffrement(fichierA, new_clef,tab_vigenere);

	

    
    
    
	return 0;
}
