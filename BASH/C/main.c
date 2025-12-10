#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "statique.h"




int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	printf("%d",3); 
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	 printf("%d",3); 
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);
	printf("%d",3);
	char * fichierC = argv[1];
    char * fichierA = argv[2];
    printf("%d",3);
	if (access(fichierC, F_OK) == 0) {
		printf("%d",3);
		printf("clef : %s\n",findKey(fichierC, fichierA));
	} else {
		int longeurClef = strlen(fichierC);
		
		char * new_clef=(char *)calloc(longeurClef+6,sizeof(char));

		for (int i = 0; i < longeurClef; i++){
		    if (fichierC[i]!='=') new_clef[i]=fichierC[i];
		}
		printf("%s", fichierA);
		dechiffrement(fichierA, new_clef,tab_vigenere);
	}

	

    
    
    
	return 0;
}
