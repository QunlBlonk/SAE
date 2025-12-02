#include <stdio.h>
#include <stdlib.h>

char alphabet_base64[64]="123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/.";
int taille_alphabet=64;

int placement_alphabet(char lettre){
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

void printStr(char * mot){
    int i = 0;
    while (mot[i] != 0){
        printf("%c", mot[i]);
        i++;
    }
    printf("\n");
}


void vigenere(char tableau[][64]){
    for (int y = 0; y < 64; y++){
        for (int x = 0; x < 64; x++){
            tableau[y][x] = ((x + y) % 64) ;
        }
    }
}


char * chifrement(char * mot, char * clef, char tabVigenere[][64]){
    int i = 0;
    char * motChiffre = (char *) calloc(longstr(mot),sizeof(char));
    int longeurClef = longstr(clef)-1;

    while (mot[i] != 0){
        motChiffre[i] = alphabet_base64[tabVigenere[placement_alphabet(mot[i])][placement_alphabet(clef[i%longeurClef])]];
        i++;
    }
    //motEqualiser(mot, motChiffre);
    return motChiffre;
}

char * dechiffrement(char * mot, char * clef, char tabVigenere[][26]){
    int i = 0;
    char * motLower = lowerStr(mot); char * clefLower = lowerStr(clef);

    char * motChiffre = (char *) calloc(longstr(mot),sizeof(char));
    int longeurClef = longstr(clef)-1;

    while (motLower[i] != 0 && i < 50){
        int j =0;
        while(tabVigenere[clefLower[i % longeurClef] - 97][j] != motLower[i]) j++;
        motChiffre[i] = 97 + j;

        i++;
    }
    motEqualiser(mot, motChiffre);
    return motChiffre;
}


int main(int argc, char * argv[]){
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);
	char * clef = argv[1];
    	char * mot = argv[2];
    	char * motChiffre;
	motChiffre = chifrement(mot, clef,tab_vigenere);
    	printStr(mot);
    	printStr(motChiffre);
	return 0;
}

