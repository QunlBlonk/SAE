#pragma once
#ifndef STATIQUE_H
#define STATIQUE_H

void chiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]);

int placement_alphabet(char lettre);

void vigenere(char tableau[][64]);

void ligne_tableau(int x, char tableau[][64]);

char * rajout(char * mot, char * ajout);

void dechiffrement(char * nom_fichier, char * clef, char tabVigenere[][64]);

char * findKey(char * nom_fichierClean, char * nom_fichierCorrompu);

#endif // STATIQUE_H

