AFF_TAB: *A1 adresse tableau
    MOVE.L A1,A6
    MOVE #$FF00, D1
    JSR POS_CURS
    MOVE.L #0, D1
    
AFF_CAR:
    CMP.B #0, (A6)
    BEQ FIN_AFF_CAR
    
    MOVE.B (A6),D1
    MOVE #6, D0
    TRAP #15
    ADD #1, A6
    JMP AFF_CAR
FIN_AFF_CAR:
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
