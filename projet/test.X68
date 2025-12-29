CAN_MOVE:
    MOVE.L #0, D7
    
    MOVE.L #0, D6
    MOVE.L #Taille, A5
    MOVE.B (A5),D6
    
    MOVE.L #Perso, A6
    ADD.L #1, A6
    MOVE.B (A6),D7
    SUB.L #1, A6
    
    MULU D6,D7
    
    ADD.B (A6),D7
    ADD.L #Tableau, D7
    
    MOVE.L D7, D7
    JSR POS_CURS
    
    *CMP.L #23,(D7)
    *BNE FIN_MOVE_PERSO:

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
