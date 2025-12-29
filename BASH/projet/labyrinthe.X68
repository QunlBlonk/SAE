    ORG    $400
START:                 
    JSR CLOSE_ALL_FILE
    MOVE.L #Nom, A1
    JSR OPEN_FILE
    
    MOVE.L #122, D2 *faire que l'on peut changer de 122
    MOVE.L #Tableau, A1
    JSR READ_FILE
    ADD.L D2, A1
    MOVE.B #0, (A1) *met un zéro à la fin de tableau
    MOVE.L #Tableau, A1
    
    JSR CLOSE_ALL_FILE
    
    *a pas oublier, a1, a2 et a3 ne change PAS
    *A1 = adresse tableau
    *A2 = adresse Perso
    *A3 = adress Taille (du tableau horizontal)
    *ça ne doit pas changer pour qu'on ne se perde pas
    MOVE.L #Tableau, A1 
    MOVE.L #Perso, A2
    MOVE.L #Taille, A3
    JSR INIT_TAB
    
    
GAMEPLAY_LOOP:
    
    JSR AFF_TAB
    JSR AFF_PERSO
    JSR MOVE_PERSO
    BRA GAMEPLAY_LOOP
    
    JSR FINPRG
    
    INCLUDE 'BIBFICH.x68'
    INCLUDE 'BIBLIO.x68'
    INCLUDE 'BIBGRAPH.x68'
    INCLUDE 'PERSO.x68'
    
Nom: DC.B 'caca.txt',0
Tableau: DS.B 200    
Perso: DS.B 2
Taille: DS.B 1

    END    START        






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
