#include <stdio.h>
#include <stdlib.h>

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

void motEqualiser(char * key, char * toEqualise){
    //le premier possède des majsucules, le suexième nom, cette fonction fait que le deuxième va prendre des majuscules la ou le premier en a
    int i=0;
    while (key[i]!=0){
        if (key[i] < 97) toEqualise[i]-=32;
        i++;
    }
}

char * lowerStr(char * mot){
    int i = 0;
    char * newMot = (char *) calloc(longstr(mot),sizeof(char));

    while (mot[i] != 0){
        if(mot[i] >= 'A' && mot[i] <= 'Z') {
            newMot[i] = mot[i]-'A'+'a';
        } else newMot[i] = mot[i];
        i++;
    }
    return newMot;
}



void vigenere(char tableau[][26]){
    for (int y = 0; y < 26; y++){
        for (int x = 0; x < 26; x++){
            tableau[y][x] = 97 + ((x + y) % 26) ;
        }
    }
}

char * chifrement(char * mot, char * clef, char tabVigenere[][26]){
    int i = 0;
    char * motLower = lowerStr(mot); char * clefLower = lowerStr(clef);

    char * motChiffre = (char *) calloc(longstr(mot),sizeof(char));
    int longeurClef = longstr(clef)-1;

    while (motLower[i] != 0){
        motChiffre[i] = tabVigenere[motLower[i] - 97][clefLower[i % longeurClef] - 97];
        i++;
    }
    motEqualiser(mot, motChiffre);
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

int main(){
    char tableau[26][26];
    vigenere(tableau);
    char * clef = "MERDESPERME";
    char * mot = "CACACaCPROUT";
    char * motChiffre;
    motChiffre = chifrement(mot, clef,tableau);
    printStr(mot);
    printStr(motChiffre);
    motChiffre = dechiffrement(motChiffre,clef,tableau);
    printStr(motChiffre);
    printStr(mot);


    return 0;
}
