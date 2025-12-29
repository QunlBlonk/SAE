AFF_PERSO: *A2 Perso
    MOVE.B (A2)+,D1 *déplace les co du perso dans d1 pour pos_curs
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
    ADD #1, A2 *ajoute 1 à y
    SUB.B #1, (A2)
    SUB #1, A2
    JSR CAN_MOVE
    MOVE #67, D5
Q_PRESSED:
    SUB.B #1, (A2) *retire 1 à x
    BRA FIN_MOVE_PERSO
S_PRESSED:
    ADD #1, A2 *retire 1 à y
    ADD.B #1, (A2)
    SUB #1, A2
    BRA FIN_MOVE_PERSO
D_PRESSED:
    ADD.B #1, (A2) *ajoute 1 à x
    BRA FIN_MOVE_PERSO
CAN_MOVE:
    ADD #1, A2 *go sur y
    MOVE.B (A2),D1
    ASL #8, D1 *pb ici, j'arrive pas à déplace au 16 ème bits
    ASL #2, D1
    
    SUB #1, A2 *retoure sur x
    MOVE.B (A2),D1
    JSR GET_AFFCAR
    
    CMP #23, D1 *regarde si mur
    BNE FIN_MOVE_PERSO
    RTS
    
    
    
FIN_MOVE_PERSO:
    RTS
