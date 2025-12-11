#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

# Déchiffre un fichier chiffrer via la clef de déchiffrement, renvoyant un fichier encodé en base64
void dechiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){
    int longeurClef = strlen(clef);

    FILE * fichier = fopen(nom_fichier, "r");
	
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Decoder"); #Rajoute le mot "Decoder" en fin de nom du fichier
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


int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);


	char * clef = argv[1];
    char * chemin_fichier = argv[2];


    char * motChiffre;
    int longeurClef = strlen(clef);
    char * new_clef=(char *)calloc(longeurClef,sizeof(char));

    for (int i = 0; i < longeurClef; i++){
        if (clef[i]!='=') new_clef[i]=clef[i];
    }
    dechiffrement(chemin_fichier,new_clef,tab_vigenere);
}
