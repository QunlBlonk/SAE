#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "statique.h"

char alphabet_base64[64]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//donne le placement d'une lettre dans l'alphabet
int placement_alphabet(char lettre){
	
    int indice = 0;
    while (lettre != alphabet_base64[indice] && indice < 64){
    	indice=indice+1;
    }
    if (lettre == alphabet_base64[indice]) return indice;

    else return -1;
}

//créer mon tableau de vigenere
void vigenere(char tableau[][64]){
    for (int y = 0; y < 64; y++){
        for (int x = 0; x < 64; x++){
            tableau[y][x] = ((x + y) % 64) ;
        }
    }
}

//fonction de débuggage qui affiche une ligne du tableau
void ligne_tableau(int x, char tableau[][64]){
    for (int y = 0; y < 64; y++){
        printf("%c",alphabet_base64[tableau[y][x]]);
    }
    printf("\n");
}

//rajoute un bout de mot entre mon nom de fichier et mon extension
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


//trouve la clef en lui donnant un fichieClean et le fichier attaqués
char * findKey(char * nom_fichierClean, char * nom_fichierCorrompu){

    //j'ouvre mes fichiers
    FILE * fichierClean = fopen(nom_fichierClean, "r");
    FILE * fichierCorrompu = fopen(nom_fichierCorrompu, "r");

    //définis toutes mes variables
    char * clef = (char *)malloc(1024 * sizeof(char)); char * clefTemp = (char*)malloc(1*sizeof(char));
    int ci = 0; int cti = 0; int pci = 0; int pcti = 0; int maxcti = 0;
    char lettreClean = fgetc(fichierClean); char lettreCorrompu = fgetc(fichierCorrompu);
    int place_lettreClean = placement_alphabet(lettreClean); int place_lettreCorrompu = placement_alphabet(lettreCorrompu);
    int diffLettre = (place_lettreCorrompu - place_lettreClean + 64)%64;
    
    //je met la première lettre de ma clef
    clef[ci] = alphabet_base64[diffLettre];ci++;

    while(lettreClean != EOF && lettreClean != '='){
        
        lettreClean = fgetc(fichierClean); lettreCorrompu = fgetc(fichierCorrompu);
        place_lettreClean = placement_alphabet(lettreClean); place_lettreCorrompu = placement_alphabet(lettreCorrompu);
        diffLettre = (place_lettreCorrompu - place_lettreClean + 64)%64;

        if (lettreClean != '='){
            //printf("%c %c\n", lettreClean, lettreCorrompu);
            clefTemp[cti] = alphabet_base64[diffLettre]; 
            cti++;
                    
            if (maxcti < cti){ //si j'ai atteint une nouvelle taille maximale je réalloue ma clefTemp.
                maxcti = cti;
                clefTemp=(char*)realloc(clefTemp,sizeof(char)*maxcti+1);
            }
        }

        
        
    }


    int bon=1;
    int finit=0;
    
    while (finit == 0 && pcti < cti){
        
            //printf("%c",clefTemp[pcti]);
            
            bon=1;
            
            for (pci=0; pci < ci; pci++){
                //if(pcti+pci >= cti)finit = 1
                if(clefTemp[pcti+pci] != clef[pci]){
                    bon = 0;
                }
            }
            if (bon==0){
                    clef=(char*)realloc(clef, sizeof(char)*(ci+1));
                    clef[ci]=clefTemp[ci-1];
                    ci++;
            }else finit = 1;
            
        pcti++;
    }

    free(clefTemp);
    fclose(fichierClean);
    fclose(fichierCorrompu);

    return clef;
}


//fonction de déchiffrement
void dechiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){
    int longeurClef = strlen(clef);

    FILE * fichier = fopen(nom_fichier, "r");
	
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Decoder");
    remove(nom_fichier_chiffrer);
    FILE * fichierClean=fopen(nom_fichier_chiffrer, "a");

    int i = 0;
    char lettre = fgetc(fichier); 
    int place_lettre; int place_lettre_clef;

    //lit jusqu'à la fin de mon fichier et déchifre mes lettres
    while (lettre != EOF){
        //trouve les placements dans l'alphabet de ma lettre et la lettre de ma clef
        place_lettre = placement_alphabet(lettre);
        place_lettre_clef = placement_alphabet(clef[i % longeurClef]);

        int j =0;
        //trouve la lettre de base en les testant une a une jusqu'à trouver la bonne
        while(tabVigenere[j][place_lettre_clef] != place_lettre && j<=63) {
        	j++;
        }

        //rajoute la lettre ou un = ou un retour à la ligne dnas le besoin
        if (place_lettre != -1 ){fputc(alphabet_base64[j], fichierClean);i++;}
        else if(lettre == '=') fputc('=',fichierClean);
        else if (lettre == '\n')fputc('\n',fichierClean);
        else printf("caractère introuvable (n'est ni un = ni un \n)");

        lettre = fgetc(fichier);
    }

    fclose(fichier); fclose(fichierClean);
}

//fonction dui chiffre en vigenere dans l'alphabet de base64 spécifiquement
void chiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]){

    int longeurClef = strlen(clef);
    FILE * fichier = fopen(nom_fichier, "r");
    
    //on créer un nouveau fichier avec un nouveau nom pour pas récrire sur le fichier de base
    char * nom_fichier_chiffrer = rajout(nom_fichier, "Chiffrer");
    remove(nom_fichier_chiffrer);
    FILE * fichierClean=fopen(nom_fichier_chiffrer, "a");

    int i = 0;
    char lettre = fgetc(fichier); int place_lettre; int place_clef;

    //lit jusqu'à la fin de mon fichier et déchifre mes lettres
    while (lettre != EOF){
        //trouve les placements dans l'alphabet de ma lettre et la lettre de ma clef
        place_lettre = placement_alphabet(lettre);
        place_clef = placement_alphabet(clef[i%longeurClef]);

        //rajoute la lettre ou un = ou un retour à la ligne dnas le besoin
        if (place_lettre != -1) {fputc(alphabet_base64[tabVigenere[place_clef][place_lettre]], fichierClean);i++;}
        else if (lettre == '=') fputc('=', fichierClean);
        else if (lettre == '\n') fputc('\n',fichierClean);
        else printf("caractère introuvable (n'est ni un = ni un retour à la ligne)");
            

        lettre = fgetc(fichier);
    }

    fclose(fichier); fclose(fichierClean);
}
