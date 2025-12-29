AFF_PERSO: *A2 Perso
    MOVE.B (A2)+,D1
    ASL #8, D1
    MOVE.B (A2),D1
    JSR POS_CURS
    SUB #1, A2
    MOVE.W #64, D1
    JSR AFFCAR
    RTS
    
   
MOVE_PERSO: *A2 Perso
    MOVE.B (Taille),D1
    ADD.W #1, D1
    JSR POS_CURS
    JSR SAISCAR
    
    *z 122
    CMP.B #122, D1 
    BEQ Z_PRESSED
    *q 113
    CMP.B #113, D1 
    BEQ Q_PRESSED
    *s 115
    CMP.B #115, D1 
    BEQ S_PRESSED
    *d 100
    CMP.B #100, D1 
    BEQ D_PRESSED
    
Z_PRESSED:
    ADD #1, A2
    SUB.B #1, (A2)
    BRA CAN_MOVE
Q_PRESSED:
    SUB.B #1, (A2)
    BRA FIN_MOVE_PERSO
S_PRESSED:
    ADD #1, A2
    ADD.B #1, (A2)
    SUB #1, A2
    BRA FIN_MOVE_PERSO
D_PRESSED:
    ADD.B #1, (A2)
    BRA FIN_MOVE_PERSO
CAN_MOVE:
    
    
    
FIN_MOVE_PERSO:
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
