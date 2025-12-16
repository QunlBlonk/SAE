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


    mkdir tmp
    touch KEY
    echo clef >> ./tmp/KEY;
}


int main(int argc, char * argv[]){
	
	int taille_alphabet=64;
	
	if (argc > 3){printf("trop d'argument passé en paramètre\n");return 1;}
	if (argc < 3){printf("pas assez d'argument passé en paramètre\n");return 1;}
	
	char tab_vigenere[64][64];
	vigenere(tab_vigenere);


	char * fichierC = argv[1];
    char * fichierA = argv[2];

    
    
    printf("clef : %s\n",findKey(fichierC, fichierA));
	return 0;
}