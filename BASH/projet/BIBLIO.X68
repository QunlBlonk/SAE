SAISCAR:
    MOVE #5, D0
    TRAP #15
    RTS
    
AFFCAR:
    MOVE #6, D0
    TRAP #15
    RTS
        
POS_CURS:
    MOVE #11, D0
    TRAP #15
    RTS
    
GET_AFFCAR:
    MOVE #22, D0
    TRAP #15
    RTS
    
MODULO: * D1 MOD D2 -> stocker dans D3
    DIVU D2,D1
    SWAP D1
    MOVE.W D1,D3
    RTS

FINPRG:
    MOVE #9, D0
    TRAP #15
    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
