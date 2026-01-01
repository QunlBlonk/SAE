CLOSE_ALL_FILE:
    MOVE #50, D0
    TRAP #15
    RTS 

OPEN_FILE:
    MOVE #51, D0
    TRAP #15
    RTS
    
READ_FILE:
    MOVE #53, D0
    TRAP #15
    RTS
    
WRITE_FILE:
    MOVE #54, D0
    TRAP #15
    RTS
   
 
INIT_TAB: *A1 entré tableau A2 Perso, A3 Taille
    MOVE.L A1,A6
    
    MOVE.B #0,D5
    MOVE.B #0,D6
    MOVE.B #0,D7 *stocke la taille
BOUCLE_INIT_TAB:
    CMP.B #0, (A6) *si fin fichier stop boucle
    BEQ FIN_INIT_TAB
    
    CMP.B #64, (A6)
    BEQ REM_SPAWN

    CMP.B #10, (A6) *si fin ligne stocke taille
    BEQ TAILLE_FOUND
    
    
    
    ADD #1, D7
    ADD #1, A6
    JMP BOUCLE_INIT_TAB
    
TAILLE_FOUND:
    MOVE.B D7, (A3)
    
    MOVE.B #0,D7
    ADD #1, A6
    ADD #1, D5
    
    JMP BOUCLE_INIT_TAB
    
REM_SPAWN:
    *stocke les pos du perso
    MOVE.B D7, (A2)+
    MOVE.B D5, (A2)
    SUB #1, A2
    
    *retire le @ de spawn
    MOVE.B #32, (A6)
    ADD #1, A6
    
    ADD #1, D7
    JMP BOUCLE_INIT_TAB

    
FIN_INIT_TAB:
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

