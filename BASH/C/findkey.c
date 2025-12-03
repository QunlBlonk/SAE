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

char * comp(char * mot, char * motChiffre, char tabVigenere[][64]){
	char alphabet_base64[64]="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/";
	int i=0
	char k=""
	while (mot[î] || motChiffre[i] != 0){
		k=alphabet_base64[placement_alphabet[motChiffre[i]]-placement_alphabet[mot[i]]];
		printf(%s,k);
	}
}






int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}



#gros WIP mais je galère vraiment sur comment le faire sans ton aide mais voilà la "base" que j'ai mis
