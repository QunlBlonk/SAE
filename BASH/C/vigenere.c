#include <stdio.h>
#include <stdlib.h>


int placement_alphabet(char lettre){
	char alphabet_base64[64]="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/";
	
    int indice = 0;
    while (lettre != alphabet_base64[indice]){
    	indice=indice+1;
    }
    return indice;
}

int longstr(char * mot){
    int i = 0;
    while (mot[i] != 0){
        i++;
    }
    return i+1;
}



void vigenere(char tableau[][64]){
    for (int y = 0; y < 64; y++){
        for (int x = 0; x < 64; x++){
            tableau[y][x] = ((x + y) % 64) ;
        }
    }
}


char * chifrement(char * mot, FILE * clef, char tabVigenere[][64]){
    char alphabet_base64[64]="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/";
    
    int i = 0;
    char * motChiffre = (char *) calloc(longstr(mot),sizeof(char));
	clef=fopen("clef","rt");
	fseek(clef, 0, SEEK_END);
    int longeurClef = ftell(clef);

    while (mot[i] != 0){
        motChiffre[i] = alphabet_base64[tabVigenere[placement_alphabet(mot[i])][placement_alphabet(clef[i%longeurClef])]];
        i++;
    }
    return motChiffre;
}

char * dechiffrement(char * mot, FILE * clef, char tabVigenere[][64]){
	char alphabet_base64[64]="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/";
	
    int i = 0;
    char * motChiffre = (char *) calloc(longstr(mot),sizeof(char));
    clef=fopen("clef","rt");
	fseek(clef, 0, SEEK_END);
    int longeurClef = ftell(clef);

    while (mot[i] != 0){
        int j =0;
        while(tabVigenere[placement_alphabet(clef[i % longeurClef])][j] != placement_alphabet(mot[i])) {
        	j++;
        	
        }
        motChiffre[i] = alphabet_base64[j];

        i++;
    }
    return motChiffre;
}


int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);
	char * clef = argv[1];
    char * mot = argv[2];
    char * motChiffre;
	motChiffre = chifrement(mot, clef,tab_vigenere);
    printf("%s\n",mot);
    printf("%s\n",motChiffre);
    motChiffre = dechiffrement(motChiffre, clef,tab_vigenere);
    printf("%s\n",mot);
    printf("%s\n",motChiffre);
	return 0;
}
