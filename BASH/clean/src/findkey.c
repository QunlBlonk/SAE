#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "statique.h"




int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	char * option = "";
	
	if (argc > 3){
		if (argv[3] != "-0"){
			option = argv[4];
		}else {printf("mauvaise option");return 1;}
	}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 2;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);
	
	char * fichierC = argv[1];
    char * fichierA = argv[2];
    
	if (access(fichierC, F_OK) == 0 && access(fichierA, F_OK) == 0)  {
		printf("%s",findKey(fichierC, fichierA, option));
	} 

	return 0;
}
