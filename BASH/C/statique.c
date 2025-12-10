#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "statique.h"

char alphabet_base64[64]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


int placement_alphabet(char lettre){
	
    int indice = 0;
    while (lettre != alphabet_base64[indice] && indice < 64){
    	indice=indice+1;
    }
    if (lettre == alphabet_base64[indice]) return indice;
    else return -1;
}

void vigenere(char tableau[][64]){
    for (int y = 0; y < 64; y++){
        for (int x = 0; x < 64; x++){
            tableau[y][x] = ((x + y) % 64) ;
        }
    }
}

void ligne_tableau(int x, char tableau[][64]){
    for (int y = 0; y < 64; y++){
        printf("%c",alphabet_base64[tableau[y][x]]);
    }
    printf("\n");
}


char * rajout(char * mot, char * ajout){
    int atteint = 0;
    int i = 0; int j = 0; int k = 0; int point = 0;

    int taille_mot=strlen(mot);
    int taille_ajout = strlen(ajout);
    int taille_mot_final=taille_mot+taille_ajout;
    

    char * mot_final = (char *)calloc(taille_mot_final, sizeof(char));
    char * extension = (char *)calloc(20, sizeof(char));

    for (i=0; i < taille_mot; i++){
        if (mot[i]=='.') {
            point=i;
        } 
    }

    for (i=0; i < point; i++){
        mot_final[i]=mot[i];
    }

    i=point;
    while (mot[i]!=0){
        extension[j]=mot[i];
        j++; i++;
    }
    strncat(mot_final, ajout, taille_mot_final);
    strncat(mot_final, extension, taille_mot_final);

    return mot_final;
}

void dechiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){
    int longeurClef = strlen(clef);

    FILE * fichier = fopen(nom_fichier, "r");
	
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Decoder");
    remove(nom_fichier_chiffrer);
    FILE * fichierClean=fopen(nom_fichier_chiffrer, "a");

    int i = 0;
    char lettre = fgetc(fichier); 
    int place_lettre; int place_lettre_clef;
    while (lettre != -1 && lettre != EOF){
        place_lettre = placement_alphabet(lettre);
        place_lettre_clef = placement_alphabet(clef[i % longeurClef]);

        printf("%c %d\n",clef[i%longeurClef], place_lettre_clef);
        ligne_tableau(place_lettre, tabVigenere);

        int j =0;
        while(tabVigenere[j][place_lettre_clef] != place_lettre && j<=63) {
        	j++;
        }
        if (place_lettre != -1 )fputc(alphabet_base64[j], fichierClean);
        if(lettre == '=') fputc('=',fichierClean);
        if (lettre == '\n')fputc('\n',fichierClean);

        i++;lettre = fgetc(fichier);
    }

    fclose(fichier); fclose(fichierClean);
}

char * findKey(char * nom_fichierClean, char * nom_fichierCorrompu){

    FILE * fichierClean = fopen(nom_fichierClean, "r");
    FILE * fichierCorrompu = fopen(nom_fichierCorrompu, "r");

    char * clef = (char *)malloc(1025 * sizeof(char)); int clefTemp[1024];
    int ci = 0; int cti = 0; int pci = 0; int pcti = 0;
    int lettreClean = placement_alphabet(fgetc(fichierClean)); int lettreCorrompu = placement_alphabet(fgetc(fichierCorrompu));
    
    int diffLettre = (lettreCorrompu-lettreClean + 64)%64;
    
    clef[ci] = diffLettre; ci++;
    lettreClean = placement_alphabet(fgetc(fichierClean)); lettreCorrompu = placement_alphabet(fgetc(fichierCorrompu));
    diffLettre = (lettreCorrompu-lettreClean + 64)%64;
    while(cti < 1024 && lettreClean != EOF && lettreClean != -1){

        if (diffLettre == clef[pci]){
            clefTemp[cti] = diffLettre; 
            pci++; cti++;
            if (pci >= ci) pci = 0;
        }else{
            for(pcti=0; pcti < cti; pcti++){
                clef[ci]=clefTemp[pcti];
                ci++;
            }
            clef[ci]=diffLettre;

		
            cti=0; ci++;pci = 0;
             for(int i=0; i < ci; i++){
       	
        
    }
        }

        lettreClean = placement_alphabet(fgetc(fichierClean));
        lettreCorrompu = placement_alphabet(fgetc(fichierCorrompu));
        diffLettre=(lettreCorrompu - lettreClean + 64)%64;
    }
    
    for(int i=0; i < ci; i++){
        clef[i]=alphabet_base64[clef[i]];
        
    }
    clef[ci]=0;

    fclose(fichierClean);
    fclose(fichierCorrompu);

    return clef;
}

void chiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){
    int longeurClef = strlen(clef);

    FILE * fichier = fopen(nom_fichier, "r");
    
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Chiffrer");
    remove(nom_fichier_chiffrer);
    FILE * fichierClean=fopen(nom_fichier_chiffrer, "a");

    int i = 0;
    char lettre = fgetc(fichier); int place_lettre; int place_clef;
    while (lettre != EOF){
        place_lettre = placement_alphabet(lettre);
        place_clef = placement_alphabet(clef[i%longeurClef]);
        printf("%c %d\n",clef[i%longeurClef], place_clef);
        ligne_tableau(place_lettre, tabVigenere);

        if (place_lettre != -1) fputc(alphabet_base64[tabVigenere[place_lettre][place_clef]], fichierClean);
        if (lettre == '=') fputc('=', fichierClean);
        if (lettre == '\n') fputc('\n',fichierClean);
        i++; lettre = fgetc(fichier);
    }

    fclose(fichier); fclose(fichierClean);
}
