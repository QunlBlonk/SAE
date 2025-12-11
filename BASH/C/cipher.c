#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char alphabet_base64[64]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#Parcours du tableau pour retrouver l'indice de l'indice de la lettre recherchée
int placement_alphabet(char lettre){ 
	
    int indice = 0;
    while (lettre != alphabet_base64[indice] && indice < 64){ 
    	indice=indice+1;
    }
    if (lettre == alphabet_base64[indice]) return indice;
    else return -1;
}
 #utilisation du tableau de vigenere pour les futurs cryptage et décryptage
void vigenere(char tableau[][64]){
    for (int y = 0; y < 64; y++){
        for (int x = 0; x < 64; x++){
            tableau[y][x] = ((x + y) % 64) ;
        }
    }
}
#Affiche tous les lignes du tableau de la colonne x
void ligne_tableau(int x, char tableau[][64]){
    for (int y = 0; y < 64; y++){
        printf("%c",alphabet_base64[tableau[y][x]]);
    }
    printf("\n");
}

# Rajoute au nouveau nom de fichier un ensemble de caractères pour le différencier de celui d'origine
char * rajout(char * mot, char * ajout){
    int atteint = 0;
    int i = 0; int j = 0; int k = 0; int point = 0;

    int taille_mot=strlen(mot);
    int taille_ajout = strlen(ajout);
    int taille_mot_final=taille_mot+taille_ajout;
    

    char * mot_final = (char *)calloc(taille_mot_final, sizeof(char));
    char * extension = (char *)calloc(20, sizeof(char));

    for (i=0; i < taille_mot; i++){ # Vérification d'une présence possible d'un point dans l'ajout
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

    free(extension);
    return mot_final;
}

#Chiffrement d'un fichier encodé en base 64 via une clef de chiffrement en passant par un tableau de vigenere
void chiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){
    int longeurClef = strlen(clef);

    FILE * fichier = fopen(nom_fichier, "r");
    
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Chiffrer"); #On créera un nouveau fichier chiffré avec "Chiffrer" derrière le nom de base
    remove(nom_fichier_chiffrer);
    FILE * fichierClean=fopen(nom_fichier_chiffrer, "a");

    int i = 0;
    char lettre = fgetc(fichier); int place_lettre; int place_clef;
    while (lettre != EOF){
        place_lettre = placement_alphabet(lettre);
        place_clef = placement_alphabet(clef[i%longeurClef]);
        printf("%c %d\n",clef[i%longeurClef], place_clef);
        ligne_tableau(place_lettre, tabVigenere);

        if (place_lettre != -1) fputc(alphabet_base64[tabVigenere[place_lettre][place_clef]], fichierClean); #Après avoir fait le chiffrement de la lettre, on ajoute sa version cryptée dans notre nouveau fichier, le retour à la ligne et les = sont comptés aussi juste après
        if (lettre == '=') fputc('=', fichierClean);
        if (lettre == '\n') fputc('\n',fichierClean);
        i++; lettre = fgetc(fichier);
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
    chiffrement(chemin_fichier,new_clef,tab_vigenere);
    free(new_clef);
}
