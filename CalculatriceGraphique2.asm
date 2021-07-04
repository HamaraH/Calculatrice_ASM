
CSEG SEGMENT
    
    ASSUME CS:CSEG, DS:CSEG, ES:CSEG
    ORG 100h
         
JMP debut    
    

    
;////////////////////////////////////////////// DECLARATION DES DIFFERENTES MACROS //////////////////////////////////////////////
    
   
pixelseul macro col,lig
    
    MOV AH,0CH
    MOV AL,111B        
    MOV BH,00H
    
     
    MOV DX,lig
    MOV CX,col
    INT 10H
    
endm    

    
pixel macro col,lig
    
    MOV AH,0CH
    MOV AL,111B        
    MOV BH,00H
    
     
    MOV DX,lig
    MOV CX,col
    INT 10H
    

    SUB CX,0001H
    INT 10H
    
    
    SUB CX,0001H
    INT 10H
    
    
    ADD CX,0003H
    INT 10H 
    
    ADD CX,0001H
    INT 10H
    
    SUB DX,0002H
    SUB CX,0002H
    INT 10H
    
    ADD DX,0001H
    INT 10H
    
    ADD DX,0001H
    INT 10H
    
    ADD DX,0001H
    INT 10H
    
    ADD DX,0001H
    INT 10H
      
endm 

saisieEtAffichageNb macro Tab, var  ; Macro qui saisie les nombres dans les tableaux correspondants et les passe en hexadecimal
    
local finsaisie,null, pasegal,bouclecarac,oppasfinie
         
    call zero 
    
    MOV CHIFFRE, 01H
    call attente_click_bouton  ; On recupere la valeur de la touche cliquee
    
    
    ; a faire en cas de nouvelle operation : on clear la zone de saisie
    
    CMP OPFINIE,00H
    JE oppasfinie
       
    call efface
        
    oppasfinie:
    MOV OPFINIE, 00H    
    
    carac 02H,CURSEUR,BTN_CLICK  ; print du bouton sur lequel on a clique
    INC CURSEUR
                                   
    MOV AL, BTN_CLICK          ; Si la saisie est un operateur, on jump
    CMP AL, 30H
    JB finsaisie
    CMP AL, 39H
    JA finsaisie
        
                               ; Sinon on rentre la valeur dans le tableau 
    MOV AH, 00H
    MOV Tab[BX],AX 
    
    MOV CHIFFRE, 00H
    call attente_click_bouton     ; On recupere la valeur de la touche cliquee
    carac 02H,CURSEUR,BTN_CLICK  ; print du bouton sur lequel on a clique
    INC CURSEUR
    
    MOV AL, BTN_CLICK          ; Si la saisie est un operateur, on jump
    CMP AL, 30H
    JB finsaisie
    CMP AL, 39H
    JA finsaisie               
                               ; On rentre la valeur dans le tableau 
    XOR AH,AH
    MOV Tab[BX+2],AX 
     
     
    call attente_click_bouton    ; etc etc
    carac 02H,CURSEUR,BTN_CLICK  ; print du bouton sur lequel on a clique
    INC CURSEUR
    
    MOV AL, BTN_CLICK
    CMP AL, 30H
    JB finsaisie
    CMP AL, 39H
    JA finsaisie                    
    
    MOV AH, 00H
    MOV Tab[BX+4],AX 
    
    
    call attente_click_bouton 
    carac 02H,CURSEUR,BTN_CLICK  ; print du bouton sur lequel on a clique
    INC CURSEUR
     
    MOV AL, BTN_CLICK
    CMP AL, 30H
    JB finsaisie
    CMP AL, 39H
    JA finsaisie   
    
    MOV AH, 00H
    MOV Tab[BX+6],AX 
    
    MOV AX, NOMBRE
    CMP AX, 02H
    JNE pasegal                ; Si on est au nombre deux et que la saisie est terminee, on affiche =
    carac 02H, CURSEUR, "="
    INC CURSEUR
    
    pasegal:
    
    finsaisie:   
    
                        ; Debut de la conversion en hexa  
    MOV CX,000AH
    MOV AX,0000H
     
    CMP Tab[BX],00H
    JE null
     
    ADD AX,Tab[BX]
    SUB AX,0030H
     
    CMP Tab[BX+2],00H
    JE null
    MUL CX
     
    ADD AX,Tab[BX+2]
    SUB AX,0030H
     
    CMP Tab[BX+4],00H
    JE null
    MUL CX
     
    ADD AX,Tab[BX+4]
    SUB AX,0030H
    
    CMP Tab[BX+6],00H
    JE null
    MUL CX
    
    ADD AX,Tab[BX+6]
    SUB AX,0030H
         
    null:
     
    MOV var,AX          ; On stocke la valeur en hexa dans une variable
     
    call zero
     
endm 


carac macro abs,ord,caractere     ; Macro qui permet d'afficher un caractere a une position, le tout passe en parametre
     
      MOV AH,02H
      MOV DH,abs
      MOV DL,ord
      XOR BH,BH
      INT 10H
      
      MOV AH,0AH
      MOV AL,caractere
      XOR BH,BH
      MOV CX,1
      INT 10H
endm

                                  ; Macro qui permet de tracer un bouton de 35*20 avec comme origine le point passe en parametre
bouton2 macro x,y

local : ligne1,ligne2,colonne1,colonne2
    
     MOV CX,x
     MOV DX,y
     
     ligne1:
     
    
     MOV AH,0CH
     MOV AL,111B
     MOV BH,00H
     INT 10H
    
     ADD CX,1
     
     CMP CX,x+35 
     JLE ligne1
     
     
     MOV DX,y
      
      
     colonne1:
     
     INT 10H
    
     ADD DX,1
     
     CMP DX,y+20
     JLE colonne1
     

     MOV CX,x
     MOV DX,y
     
     colonne2:
     
     INT 10H
    
     ADD DX,1
     
     CMP DX,y+20
     JLE colonne2
     
     ligne2:
     
     INT 10H
    
     ADD CX,1
     
     CMP CX,x+35
     JLE ligne2
     
       
     MOV DH, x+2
     MOV DL, y+2
                                          
endm 


debut:

MAIN : 
    
    XOR AH,AH
    MOV AL,13H         ; Choix du mode video
    INT 10H
    
    call interface_calculatrice


; //////////////////////////////// Debut de la saisie ////////////////////////////////



MOV CURSEUR, 02H ; On initialise le curseur a la premiere position

bouclecalcul:
call reset_all

MOV NOMBRE,01H
              
saisieEtAffichageNb T_NB1, NB1  ; Saisie du premier nombre

call saisieOp                        ; Choix de l'operateur 

CMP OP,21H
JE fact

CMP OP,44H
JE hexa

MOV NOMBRE,02H

saisieEtAffichageNb T_NB2, NB2  ; Saisie du deuxieme nombre


; //////////////////////////////// Partie calculatoire ////////////////////////////////

 
    MOV AH,OP
    CMP AH,2DH
    JNE pasous          ; Si l'operateur saisi n'est pas celui d'une soustraction, on continue
    
    call soustraction   ; Sinon on appelle la procedure de soustraction 
     
    pasous:
       
    MOV AH,OP
    CMP AH,2BH
    JNE pasadd          ; Si l'operateur saisi n'est pas celui d'une addition, on continue
      
    call zero  
    call addition       ; Sinon on appelle la procedure d'addition
       
    pasadd:
    
    MOV AH,OP
    CMP AH,2AH
    JNE pasmul           ; Si l'operateur saisi n'est pas celui d'une multiplication, on continue
        
    call zero
    call multiplication  ; Sinon on appelle la procedure de multiplication
    
    pasmul:
    
    MOV AH,OP
    CMP AH,2FH
    JNE fact             ; Si l'operateur saisi n'est pas celui d'une division, on continue
    
    call zero
   
    CMP NB2,0000H
    JE error                
    call division        ; Sinon on appelle la procedure de division
    
    
    fact:
    
    MOV AH,OP
    CMP AH,21H
    JNE puiss            ; Si l'operateur saisi n'est pas celui d'une factorielle on continue
    
    carac 02H,CURSEUR, "="
    INC CURSEUR
    
    CMP NB1,0009H
    JAE error
    
    call factorielle
    
    
    puiss:
    
    MOV AH,OP
    CMP AH,50H
    JNE hexa           ; Si l'operateur saisi n'est pas celui d'une puissance on continue
                     ; puissance a introduire
    
    call puissance
    
    hexa:
    
    MOV AH,OP
    CMP AH,44H
    JNE finop
    
    call hexadecimal
    
    carac 02H,CURSEUR, "="
    INC CURSEUR
    
   
    
    JMP hexaaaa                          
    finop:               ; Si l'on arrive ici, les calculs sont termines

    
; /////////////////////////// Conversion du resultat en decimal et affichage ///////////////////////////


    call hextod2            ; Conversion du resultat en decimal
    hexaaaa:               
    call AfficherResultat  ; Affichage du resultat
    
    CMP OP,44H
    JNE pash
    
    carac 02H,CURSEUR, "H"
    INC CURSEUR
    
    pash:
    
    MOV AH, OP
    CMP AH, "/"
    JNE pasreste
               
    call afficherReste     ; On affiche le reste dans le cas d'une division
    
   
    error: 
    
    carac 02H,CURSEUR, "E" 
    INC  CURSEUR
    carac 02H,CURSEUR, "R"
    INC  CURSEUR
    carac 02H,CURSEUR, "R"
    INC  CURSEUR
    carac 02H,CURSEUR, "O"
    INC  CURSEUR
    carac 02H,CURSEUR, "R"
   
    pasreste:
    

    
    MOV OPFINIE,01H
    
    JMP bouclecalcul
    
    apreset:
    
    call efface_all
    call reset_all
    JMP bouclecalcul
    
; //////////////////////////////// Fin du programme : interruption 4CH / INT 21H ////////////////////////////////
    
    endprog:
 
    MOV AH,4CH
    INT 21H

        
    graphique:
    
    call tracerep
    call carre
    call affine
    

; ////////////////////////////////  Declaration des variables utilisees ////////////////////////////////


CURSEUR DB 1
BTN_CLICK DB 1
OPFINIE DB DUP (0) 

CPT1 DW DUP (11)
CPT2 DW DUP (17)

COEFF DW DUP (2) 
ORDOR DW DUP (1)
 
YPOINT DW ?
XPOINT DW DUP (0)
XPOINTR DW ?


PFO DW ?
PFA DW ?

RESTE DW ?        
NB1 DW ?
NB2 DW ?     
RESULTAT DW ?
OP DB 1 ?
CPT DB ?
A_CLIQUE DB ? 
NOMBRE DW ?
CHIFFRE DB ?

T_NB1 DW 4 DUP(?)
T_NB2 DW 4 DUP(?)
T_RESULT DW 8 DUP(?)
T_RESTE DW 8 DUP(?)

SAVE_SP DW ?              ; Ces variables permettent de stocker les adresses de retour dans le cas de procedures imbriquees
SAVE_AD DW ?

BOOL_NEG DB 1 DUP(?)      ; Booleen permettant de savoir si le resultat d'une soustraction est negatif


; ////////////////////////////////  Declaration des differentes procedures ////////////////////////////////

hexadecimal proc
  
    MOV SAVE_AD,SP
    
    XOR BX,BX
    
    MOV AX,NB1
    MOV CX,10H
    XOR DX, DX
    DIV CX
    
    MOV T_RESULT[BX+14],DX
    XOR DX, DX
    CMP T_RESULT[BX+14],0AH
    JNAE chiffrehex1
    ADD T_RESULT[BX+14],07H
    
    chiffrehex1:
    
    ADD T_RESULT[BX+14],30H
    
    CMP AX,0000H
    JE finhex
    
    
    DIV CX
    
    MOV T_RESULT[BX+12],DX
    XOR DX, DX
    CMP T_RESULT[BX+12],0AH
    JNAE chiffrehex2
    ADD T_RESULT[BX+12],07H
    
    chiffrehex2:
    
    ADD T_RESULT[BX+12],30H

    CMP AX,0000H
    JE finhex
    
    
    DIV CX
    
    MOV T_RESULT[BX+10],DX
    XOR DX, DX
    CMP T_RESULT[BX+10],0AH
    JNAE chiffrehex3
    ADD T_RESULT[BX+10],07H
    
    chiffrehex3:
    
    ADD T_RESULT[BX+10],30H
    
    CMP AX,0000H
    JE finhex
    
    
    DIV CX
    
    MOV T_RESULT[BX+8],DX
    XOR DX, DX
    CMP T_RESULT[BX+8],0AH
    JNAE chiffrehex4
    ADD T_RESULT[BX+8],07H
    
    chiffrehex4:
    
    ADD T_RESULT[BX+8],30H 
    
    CMP AX,0000H
    JE finhex

    finhex:
     
endp
ret

   
affine proc
        
    courbe1:  
  
    MOV AX,XPOINT
    MUL COEFF
    ADD AX,ORDOR 
    MOV CX,10H
    MUL CX
    MOV DX,85H
    SUB DX,AX
     
    MOV YPOINT,DX
    
    MOV AX,XPOINT
  
    MUL CX
    MOV DX,99H
    ADD DX,AX
    
    MOV XPOINTR,DX
     
    
    pixel XPOINTR,YPOINT
    
    ADD XPOINT,01H
                        ; on trace 4 points positifs
    
    CMP XPOINT,04H
    
    JL courbe1
    
    
    MOV XPOINT,00H
    
    MOV AX,XPOINT
    
    courbe2:
    
    MOV AX,XPOINT
    MUL COEFF
    ADD AX,ORDOR 
    MOV CX,10H
    MUL CX
    MOV DX,85H
    ADD DX,AX
     
    MOV YPOINT,DX
    
    MOV AX,XPOINT
    ADD AX,01H
  
    MUL CX
    MOV DX,99H
    SUB DX,AX
    
    MOV XPOINTR,DX
     
    
    pixel XPOINTR,YPOINT
    
    ADD XPOINT,01H
    CMP XPOINT,04H
    
    JL courbe2
    
    
    
    
    MOV XPOINT,79H
    MOV YPOINT,0B5H
     
     MOV AX,XPOINT
     MOV AX,YPOINT
    
    tracediagonale:
    
    pixelseul XPOINT,YPOINT
    
    ADD XPOINT,01H
    SUB YPOINT,02H
    
    CMP YPOINT,015H
    JA tracediagonale
     

    
endp
ret  


carre proc
        
    carre1:
    
    MOV AX,XPOINT
    MUL XPOINT
    MOV DX,10H
    MUL DX
    
    MOV DX,85H
    SUB DX,AX
    
    MOV YPOINT,DX
    
    MOV AX,XPOINT
    MOV DX,10H
    MUL DX
    
    ADD AX,99H 
    MOV XPOINTR,AX
    
    pixel XPOINTR,YPOINT
    
    INC XPOINT
    
    CMP XPOINT,03H
    JL carre1
              
              
    MOV XPOINT,00H
            
            
    carre2:
                   
    MOV AX,XPOINT
    MUL XPOINT
    MOV DX,10H
    MUL DX
    
    MOV DX,85H
    SUB DX,AX
    
    MOV YPOINT,DX
    
    MOV AX,XPOINT
    MOV DX,10H
    MUL DX
    
    MOV DX,99H
    SUB DX,AX
     
    MOV XPOINTR,DX
    
    pixel XPOINTR,YPOINT
    
    INC XPOINT
    
    CMP XPOINT,03H
    JL carre2
       
    
    MOV XPOINTR,79H
    MOV YPOINT,45H
    
    courbecarre1:
    
    INC XPOINTR
    ADD YPOINT,03H
    
    
    
    CMP XPOINTR, 89H
    pixelseul XPOINTR,YPOINT
                   
                   
    JL courbecarre1
     
    
    MOV XPOINTR,0B9H
    MOV YPOINT,45H
    
    courbecarre2:
    
    SUB XPOINTR,01H
    ADD YPOINT,03H
    
    
    
    CMP XPOINTR, 0A9H
    pixelseul XPOINTR,YPOINT
                   
                   
    JA courbecarre2 
    
    
    MOV XPOINTR,89H
    MOV YPOINT,75H
    
     courbecarre3:
    
    ADD XPOINTR,01H
    ADD YPOINT,01H
    
    
    
    CMP XPOINTR, 99H
    
    pixelseul XPOINTR,YPOINT
                   
                   
    JL courbecarre3 
    
    MOV XPOINTR,0A9H
    MOV YPOINT,75H
    
    courbecarre4:
    
    SUB XPOINTR,01H
    ADD YPOINT,01H
    
    
    
    CMP XPOINTR, 99H
    
    pixelseul XPOINTR,YPOINT
                   
                   
    JA courbecarre4
    
endp
ret 


tracerep proc
    
    MOV AH,00H     ; mode video
    MOV AL,13H
    INT 10H
    

    
    MOV AH,0CH
    MOV AL,111B    ;parametres de laffichage  
    MOV BH,01H

    
;axe des ordonnees

    
    MOV BX,0BFH 
    MOV DX,0010H
    MOV CX,99H
    
    
    trace1: 
    
    INT 10H
    
    ADD DX,0001H
    
    CMP DX,BX
     
    JL trace1
    
;axe des abscisses

    
    MOV DX,0085H
    MOV CX,015H
    MOV BX,125H

    trace2: 
    
    INT 10H
    
    ADD CX,0001H
    
    CMP CX,BX
     
    JL trace2

    
;graduations ordonnees
    
    
    MOV DX,0015H
    MOV CX,096H
    MOV BX,09DH
    
    continuegrad1:
    
    grad1:
    INT 10H
    ADD CX,01H
    CMP CX,BX
    
    JL grad1
    
    DEC CPT1
    ADD DX,10H
    SUB CX,07H
    
    CMP CPT1,0000H
    
    JA continuegrad1

    
;graduations abcisses

    
    MOV DX,0082H
    MOV CX,019H
    MOV BX,0089H
    
    
    continuegrad2:
    
    grad2:
    INT 10H
    
    ADD DX,01H
    CMP DX,BX
    JL grad2
                     
    
    
    DEC CPT2
    ADD CX,10H
    SUB DX,07H
    
    CMP CPT2,0000H
    
    JA continuegrad2
    
; nombres abscisses
    
    carac 12H,015H,31H        
    carac 12H,017H,32H
    carac 12H,019H,33H        
    carac 12H,01BH,34H
    carac 12H,01DH,35H        
    carac 12H,01FH,36H
    carac 12H,021H,37H        
    carac 12H,023H,38H

;nombres ordonnees
    
    carac 02H,011H,37H        
    carac 04H,011H,36H
    carac 06H,011H,35H        
    carac 08H,011H,34H
    carac 0AH,011H,33H        
    carac 0CH,011H,32H
    carac 0EH,011H,31H        
    
    
endp
ret   
   
   
efface proc
    
    bouclecarac:
    
    carac 02H,CURSEUR,00H
    DEC CURSEUR
    
    CMP CURSEUR,02H    
    JA bouclecarac
    
endp
ret

efface_all proc
    
    bouclecarac2:
    
    carac 02H,CURSEUR,00H
    DEC CURSEUR
    
    CMP CURSEUR,01H    
    JA bouclecarac2
    
    INC CURSEUR
    
endp
ret

puissance proc
    
    
     
    MOV AX,NB1
    
    MOV CX,NB2
    DEC CX
    
    suitepuiss:
    
    CMP DX,0000H
    JA error
     
    MUL NB1
    
    DEC CX
    CMP CX,0000H
    JNE suitepuiss
            
    MOV RESULTAT, AX 
    
    
endp
ret


factorielle proc
    
    MOV SAVE_AD,SP
    
    MOV AX,NB1
    MOV CX,NB1
    DEC CX
    
    facto:
    
    MUL CX
    
    DEC CX
    
    CMP CX,00H
    JA facto
    
    MOV RESULTAT,AX
    
    MOV SP,SAVE_AD
    
endp
ret

attente_click_bouton proc          ; macro qui verifie quel bouton a ete active
                                       
 MOV SAVE_SP,SP
                                       
MOV A_CLIQUE, 00H ; on initialise le booleen A_CLIQUE a faux
              
attclick:

MOV AX, 0003H                          
INT 33H           ;Cette interruption permet de savoir si un click a ete effectue                   
CMP BX, 1         ;Tant que l'on a pas clique
JNE attclick


PUSH 37H
PUSH 0045H
PUSH 0066H
PUSH 0030H
PUSH 0020H
call verif_click  ; cas du bouton 7

PUSH 38H
PUSH 0045H
PUSH 00D4H
PUSH 0030H
PUSH 008AH
call verif_click  ; cas du bouton 8

PUSH 39H
PUSH 0045H
PUSH 013EH
PUSH 0030H
PUSH 00F4H
call verif_click  ; cas du bouton 9
                                                                                                   
PUSH 34H
PUSH 006CH
PUSH 0066H
PUSH 0055H
PUSH 0020H
call verif_click  ; cas du bouton 4


PUSH 35H
PUSH 006CH
PUSH 00D4H
PUSH 0055H
PUSH 008AH
call verif_click  ; cas du bouton 5

PUSH 36H
PUSH 006CH
PUSH 013EH
PUSH 0055H
PUSH 00F4H
call verif_click  ; cas du bouton 6

PUSH 31H
PUSH 0090H
PUSH 0066H
PUSH 007AH
PUSH 0020H
call verif_click  ; cas du bouton 1

PUSH 32H
PUSH 0090H
PUSH 00D4H
PUSH 007AH
PUSH 008AH
call verif_click  ; cas du bouton 2                                

PUSH 33H
PUSH 0090H
PUSH 013EH
PUSH 007AH
PUSH 00F4H
call verif_click  ; cas du bouton 3

PUSH 30H
PUSH 00B4H
PUSH 0068H
PUSH 009FH
PUSH 0020H
call verif_click  ; cas du bouton 0


MOV AX, NOMBRE    ; Si l'on est entrain de saisir le second nombre, on ne peut pas saisir d'operateur
CMP AX, 02H
JE nombre2 
MOV AH, CHIFFRE   ;si l'on est entrain de saisir le premier chiffre d'un nombr, on ne peut pas saisir d'operateur        
CMP AH, 01H
JE chiffre1  

PUSH 2BH
PUSH 0044H
PUSH 01D2H
PUSH 002FH
PUSH 0188H
call verif_click   ; cas de l'addition (+)

PUSH 2DH
PUSH 0044H
PUSH 0244H
PUSH 002FH
PUSH 01FCH
call verif_click   ; cas de la soustraction (-)

PUSH 2AH
PUSH 006CH
PUSH 01D2H
PUSH 0055H
PUSH 0188H
call verif_click   ; cas de la multiplication (*)

PUSH 2FH
PUSH 006CH
PUSH 0244H
PUSH 0055H
PUSH 01FCH
call verif_click   ; cas de la division (/)
                                                  

PUSH 21H
PUSH 0090H
PUSH 01D2H
PUSH 007AH
PUSH 0188H
call verif_click   ; cas de la factorielle (!)

PUSH  44H
PUSH  0B3H
PUSH  210H
PUSH  9FH
PUSH  1C8H

call verif_click    ; conversion hexa


PUSH 50H
PUSH 0090H
PUSH 0244H
PUSH 007AH
PUSH 01FCH
call verif_click   ; cas de la puissance (P)

nombre2:
                   ; Si on est au premier nombre, la saisie d'operateurs n'est pas possible
MOV AX, NOMBRE
CMP AX, 01H
JE nombre1

PUSH 3DH
PUSH 00C7H
PUSH 027EH
PUSH 009FH
PUSH 0234H
call verif_click   ; cas de l'entree (=)

chiffre1: 
nombre1:
   
PUSH 58H  
PUSH 0020H
PUSH 270H
pUSH 0000H
PUSH 230H    
call verif_click    ; on quitte le programme (x)

PUSH  43H
PUSH  0B3H
PUSH  0D2H
PUSH  9DH
PUSH  8AH
call verif_click    ; clear all

PUSH  47H
PUSH  0B3H
PUSH  1A6H
PUSH  9FH
PUSH  15EH
call verif_click    ; graphique 

CMP BTN_CLICK,47H
JE  graphique
    
CMP BTN_CLICK,58H
JE endprog

CMP BTN_CLICK, 43H
JE apreset
    
MOV AL, A_CLIQUE
CMP AL, 01H
JNE attclick       ; Si aucun bouton n'a ete active, la procedure boucle sur elle-meme
 
MOV AH,CURSEUR
 
MOV SP,SAVE_SP
 
endp
ret


interface_calculatrice proc    

; ****************** PREMIERE LIGNE DE BOUTONS ******************

  
    bouton2 10H,30H   ; bouton 7 
    carac 07H,04H,37H 
    bouton2 45H,30H   ; bouton 8
    carac 07H,0BH,38H  
    bouton2 7AH,30H   ; bouton 9
    carac 07H,11H,39H 
  
    
; ****************** DEUXIEME LIGNE DE BOUTONS ******************


    bouton2 10H,55H   ; bouton 4
    carac 0CH,04H,34H
    bouton2 45H,55H   ; bouton 5
    carac 0CH,0BH,35H  
    bouton2 7AH,55H   ; bouton 6
    carac 0CH,11H,36H
    
    
; ****************** TROISIEME LIGNE DE BOUTONS ******************


    bouton2 10H,7AH   ; bouton 1
    carac 10H,04H,31H
    bouton2 45H,7AH   ; bouton 2
    carac 10H,0BH,32H                     
    bouton2 7AH,7AH   ; bouton 3
    carac 10H,11H,33H
    
    bouton2 7AH,9FH   ;bouton virgule
    carac 15H,11H,2CH
    
    bouton2  0AFH,9FH
    carac 15H,18H,47H
    
    bouton2  0E4H,9FH
    carac 15H,1FH, 48H
    
    
    
    MOV AH,0CH
    MOV AL,111B
    MOV BH,00H
    MOV BX,6AH
    
    bouton2 10H,9FH
    
    carac 15H,04H,30H  
    
    bouton2 45H,9FH
    
    carac 15H,0BH,43H  
    
; PRINT LIGNE DE LECRAN SUPERIEUR  

      MOV AH,0CH
      MOV AL,111B
      MOV BH,00H
      MOV BX,0140H
       
      MOV CX,00H
      MOV DX,20H
      
      ligne1:
      
      
      INT 10H
      
      
      ADD CX,01H
      
      CMP CX,BX
      JL ligne1
      
      
; PRINT DU BOUTON ENTREE
       
      MOV AH,0CH
      MOV AL,111B
      MOV BH,00H
      MOV BX,0C8H
      
      MOV CX,119H    ; si on diminue ca va a droite
      MOV DX,9EH     ;si on augmente ca va vers le bas
       
      jsp:
      ADD DX,01H
      INT 10H
      
      CMP DX,BX
      JL jsp
    
      MOV BX,140H
      
      MOV CX,118H    ; si on diminue ca va a droite
      MOV DX,9EH
      
      entreeligne1:
      ADD CX,01H
      INT 10H
      
      CMP CX,BX
      JL entreeligne1
      
      carac 16H,25H,3DH  
      
      
;PRINT DU BOUTON QUITTER
      
      MOV AH,0CH
      MOV AL,111B
      MOV BH,00H
      
      MOV BX,020H
      MOV CX,119H      ; si on diminue ca va a droite
      MOV DX,01H    
      
      okemdr:
      ADD DX,01H
      INT 10H
      
      CMP DX,BX
      JL okemdr
      
      carac 01H,25H,58H

; PRINT DES BOUTONS OPERATEURS   
      bouton2 0C4H,30H   ; bouton +
      carac 07H,1AH,2BH  
      bouton2 0FDH,30H   ; bouton -
      carac 07H,22H,2DH  
      bouton2 0C4H,55H   ; bouton *
      carac 0CH,1AH,2AH  
      bouton2 0FDH,55H   ; bouton /
      carac 0CH,22H,2FH       
      bouton2 0C4H,7AH   ; bouton !
      carac 10H,1AH,21H       
      bouton2 0FDH,7AH   ; bouton puissance
      carac 10H,22H,50H  
;    
endp
ret


verif_click proc 

MOV SAVE_AD,SP     ; On stocke l'adresse de retour

POP AX             ; On vide la premiere adresse due a l'appel de la procedure
 
POP AX

CMP AH, 0FFH       ; On corrige le bug de POP AX : ajout de FF ?
JNE pasret1:       ; On verifie si le click concerne le bouton 1
XOR AH, AH

pasret1:
 
CMP CX,AX
JB click_ailleurs  ; Si on a clique en dessous on jump

POP AX
 
CMP AH, 0FFH       ; On corrige le bug de POP AX : ajout de FF ?
JNE pasret2
XOR AH, AH

pasret2:

CMP DX,AX
JB click_ailleurs  ; Si on a clique en dessous on jump 

POP AX
 
CMP AH, 0FFH       ; On corrige le bug de POP AX : ajout de FF ?
JNE pasret3
XOR AH, AH

pasret3:

CMP CX,AX
JA click_ailleurs  ; Si on a clique au dessus on jump

POP AX

CMP AH, 0FFH       ; On corrige le bug de POP AX : ajout de FF ?
JNE pasret4
XOR AH, AH

pasret4:

CMP DX,AX
JA click_ailleurs  ; Si on a clique au dessus on jump

POP AX

MOV BTN_CLICK,AL   ; On stocke la valeur du bouton si on a clique
MOV A_CLIQUE, 01H  ; On signale qu'on a clique sur un bouton

click_ailleurs:
                   ; Si on a clique ailleurs que dans la zone du bouton
MOV SP,SAVE_AD    ; On recupere l'adresse de retour
   
endp
ret


zero proc      
    
    XOR AX,AX 
    XOR DX,DX       ; Procedure qui remet tous les registres a zero
    XOR BX,BX
    XOR CX,CX
    
endp
ret


saisieOp proc                  
    
    
    MOV SAVE_SP,SP      ; On recupere l'adresse de retour
    MOV AL, BTN_CLICK
                        ; Si on a deja saisi un operateur a letape precedente, on skip
    CMP AL, 30H
    JB finsaisieop
    CMP AL, 39H
    JA finsaisieop
    
    debutsaisieop:                    ; On effectue la saisie de l'operateur :
    attclicke:
    
    MOV AX, 0003H
    INT 33H
                        ; Tant que l'on a pas clique
    CMP BX, 1
    JNE attclicke
    
    MOV BTN_CLICK, 00H                    ; On enregistre l'operateur sur lequel on a clique
                        
    PUSH 2BH
    PUSH 0044H
    PUSH 01D2H
    PUSH 002FH
    PUSH 0188H
    call verif_click    ; cas de l'addition (+)

    PUSH 2DH
    PUSH 0044H
    PUSH 0244H
    PUSH 002FH
    PUSH 01FCH
    call verif_click    ; cas de la soustraction (-)

    PUSH 2AH
    PUSH 006CH
    PUSH 01D2H
    PUSH 0055H
    PUSH 0188H
    call verif_click    ; cas de la multiplication (*)

    PUSH 2FH
    PUSH 006CH
    PUSH 0244H
    PUSH 0055H
    PUSH 01FCH
    call verif_click    ; cas de la division (/)

    PUSH 21H
    PUSH 0090H
    PUSH 01D2H
    PUSH 007AH
    PUSH 0188H
    call verif_click    ; cas de la factorielle (!) 

    PUSH 50H
    PUSH 0090H
    PUSH 0244H
    PUSH 007AH
    PUSH 01FCH
    call verif_click    ; cas de la puissance (P) 
    
    PUSH  44H
    PUSH  0B3H
    PUSH  210H
    PUSH  9FH
    PUSH  1C8H
    
    call verif_click    ; conversion hexa


    PUSH 3DH
    PUSH 00C7H
    PUSH 027EH
    PUSH 009FH
    PUSH 0234H
    call verif_click    ; cas de l'entree (=)

     
    PUSH 58H
    PUSH 230H
    PUSH 0000H
    PUSH 270H
    PUSH 0020H
    
    call verif_click    ; on quitte le programme (x)
    
    PUSH  43H
    PUSH  0B3H
    PUSH  0D2H
    PUSH  9DH
    PUSH  8AH
    
    call verif_click    ; clear all
    
    PUSH  47H
    PUSH  0B3H
    PUSH  1A6H
    PUSH  9FH
    PUSH  15EH
    
    call verif_click    ; graphique 
    
    CMP BTN_CLICK,47H
    JE  graphique
        
    CMP BTN_CLICK,58H
    JE endprog
    
    CMP BTN_CLICK, 43H
    JE apreset
    
    CMP BTN_CLICK,58H
    JE endprog
    MOV AL, BTN_CLICK
    CMP AL, 00H
    JE debutsaisieop
    carac 02H, CURSEUR, BTN_CLICK  ; On print l'operateur

    INC CURSEUR 
    
    
       
    finsaisieop:        ; On enregistre l'operateur saisi
    
    MOV OP, AL
    MOV SP, SAVE_SP     ; On recupere l'adresse de retour
    
endp
ret 


proc AfficherResultat
    
    
    MOV AX, T_RESULT[BX]   ; Caractere 1
    CMP AL, 00H
    JE pasprint1           ; Si le caractere est null, on passe au suivant sans rien afficher
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint1:
                           ; Etc etc
    
    MOV AX, T_RESULT[BX+2] 
    CMP AL, 00H
    JE pasprint2 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint2:
    
    MOV AX, T_RESULT[BX+4] 
    CMP AL, 00H
    JE pasprint3 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint3:
    
    MOV AX, T_RESULT[BX+6] 
    CMP AL, 00H
    JE pasprint4 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint4: 
    
    MOV AX, T_RESULT[BX+8] 
    CMP AL, 00H
    JE pasprint5 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint5:
    
    MOV AX, T_RESULT[BX+10] 
    CMP AL, 00H
    JE pasprint6 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint6:    
    
    MOV AX, T_RESULT[BX+12] 
    CMP AL, 00H
    JE pasprint7 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint7:
    
    MOV AX, T_RESULT[BX+14] 
    CMP AL, 00H
    JE pasprint8 
    carac 02H, CURSEUR, AL
    INC CURSEUR
      
    pasprint8:
      
endp
ret


reset_all proc     ; Procedure qui remet tous les tableaux a zero pour pouvoir les reutiliser
    
    XOR BX,BX
    
    MOV NB1, 0000H
    MOV T_NB1[BX],00H
    MOV T_NB1[BX+2],00H
    MOV T_NB1[BX+4],00H
    MOV T_NB1[BX+6],00H
    
    MOV NB2, 0000H
    MOV T_NB2[BX],00H
    MOV T_NB2[BX+2],00H
    MOV T_NB2[BX+4],00H
    MOV T_NB2[BX+6],00H
    
    MOV RESULTAT, 0000H
    MOV T_RESULT[BX],00H
    MOV T_RESULT[BX+2],00H
    MOV T_RESULT[BX+4],00H
    MOV T_RESULT[BX+6],00H
    MOV T_RESULT[BX+8],00H
    MOV T_RESULT[BX+10],00H
    MOV T_RESULT[BX+12],00H
    MOV T_RESULT[BX+14],00H
    
    MOV RESTE, 0000H
    MOV T_RESTE[BX],00H
    MOV T_RESTE[BX+2],00H
    MOV T_RESTE[BX+4],00H
    MOV T_RESTE[BX+6],00H
    MOV T_RESTE[BX+8],00H
    MOV T_RESTE[BX+10],00H
    MOV T_RESTE[BX+12],00H
    MOV T_RESTE[BX+14],00H
    
    MOV BOOL_NEG,00H
    
endp
ret 


addition proc    ; Procedure qui effectue une addition
    
    MOV AX,NB1
    ADD AX,NB2   ; Addition
    MOV RESULTAT, AX   ; Stockage du resultat dans une variable
    
    
endp
ret


multiplication proc ; proc qui effectue une multiplication
    
     
    MOV AX,NB1
    MOV CX,NB2
    MUL CX  ;multiplication
    MOV RESULTAT, AX   ; stockage resultat
    
endp
ret


division proc ; proc qui effectue une division
    
    MOV AX,NB1 ; le dividende dans AX
    MOV CX,NB2 ; le diviseur dans CX
    
    DIV CX 
    
    MOV RESTE,DX  ; on recupere le reste dans DX
    
    
    MOV RESULTAT, AX   ; on recupere le quotient dans AX
    
    MOV AX,RESTE
    MOV DX,0000H  ; on clean DX pour la suite du programme (conversion hextod)
    call hextodReste ; on convertit le reste en decimal
  
    
     
endp 
ret

   soustraction proc ;Macro qui effectue une soustraction entre les deux nombres saisis et affiche le resultat

   MOV BOOL_NEG,0000H
   
   MOV AX,NB1  
   CMP AX,NB2
   JAE positif ; si NB1 > NB2 alors le resultat sera positif : on jump
   
   MOV BOOL_NEG,01H  ; sinon le resultat sera negatif
   carac 02H, CURSEUR, "-"  ; on print un - devant le resultat 
   INC CURSEUR
   XOR DX, DX 
   ; on inverse NB1 et NB2
   MOV AX, NB1
   MOV CX,NB2
   MOV NB2,AX
   MOV NB1,CX
      
   MOV AX,NB1  
 
   positif:   
   SUB AX,NB2
   MOV RESULTAT, AX

endp
ret
 

hextod2 proc ; procedure qui convertit un nombre hexadecimal en decimal et le stocke dans un tableau (sous forme ASCII)
    
   MOV SAVE_AD,SP
    
   MOV AX, RESULTAT
   MOV CX,2710H
   
   DIV CX    
   
   MOV PFA,DX
   MOV PFO,AX
   
   XOR DX,DX
   
   MOV AX,PFA
                    ;on recupere le dividende
   MOV CX,0AH                ; on divise par 10 = 0AH
   
   
   DIV CX
   
   CMP PFO,00H
   JE paspfo
   
   MOV T_RESULT[BX+14],30H
   MOV T_RESULT[BX+12],30H
   MOV T_RESULT[BX+10],30H
   MOV T_RESULT[BX+8],30H
   
   paspfo:
   
   MOV T_RESULT[BX+14],DX  ;on ajoute le reste dans le tableau
   ADD T_RESULT[BX+14],30H ; on add 30 pour ASCII
   XOR DX,DX
   CMP AX,0000H
   JE finconvpfa2 ;si le quotient est nul alors on a fini la conversion
   
   
   ;pareil qu'au dessus : 
   DIV CX
   MOV T_RESULT[BX+12],DX
   ADD T_RESULT[BX+12],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvpfa2
   
   DIV CX
   MOV T_RESULT[BX+10],DX
   ADD T_RESULT[BX+10],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvpfa2
   
   DIV CX 
   MOV T_RESULT[BX+8],DX
   ADD T_RESULT[BX+8],30H
   MOV DX,0000H
   
   finconvpfa2:
   
   MOV AX,PFO
   CMP AX,0000H
   JE finconv2
   
   
   
      
   DIV CX
   MOV T_RESULT[BX+6],DX
   ADD T_RESULT[BX+6],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconv2
   
   DIV CX
   MOV T_RESULT[BX+4],DX
   ADD T_RESULT[BX+4],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconv2
   
   DIV CX
   MOV T_RESULT[BX+2],DX
   ADD T_RESULT[BX+2],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconv2
   
   DIV CX
   MOV T_RESULT[BX],DX
   ADD T_RESULT[BX],30H
   
   finconv2: ; on jump ici quand la conversion du nombre est terminee
   
   MOV SP,SAVE_AD
   
endp
ret 

proc AfficherReste ; affiche le reste de la division
    
    ADD CURSEUR, 05H ; on laisse un espace entre le resultat et le reste
    ; AFFICHAGE MOT "RESTE : "
    carac 02H, CURSEUR, "R"
    INC CURSEUR
    carac 02H, CURSEUR, "e"
    INC CURSEUR 
    carac 02H, CURSEUR, "s"
    INC CURSEUR
    carac 02H, CURSEUR, "t"
    INC CURSEUR
    carac 02H, CURSEUR, "e"
    INC CURSEUR
    carac 02H, CURSEUR, ":"
    ADD CURSEUR, 02H
    
    
    ; AFFICHAGE TABLEAU T RESTE
    ;caractere 1
    MOV AX, T_RESTE[BX] 
    CMP AL, 00H
    JE pasprintreste1
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste1:
    
    ;caractere 2
    MOV AX, T_RESTE[BX+2] 
    CMP AL, 00H
    JE pasprintreste2
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste2:
    
    ;caractere 3
    MOV AX, T_RESTE[BX+4] 
    CMP AL, 00H
    JE pasprintreste3
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste3:
    
    ;caractere 4
    MOV AX, T_RESTE[BX+6] 
    CMP AL, 00H
    JE pasprintreste4
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste4: 
    
    ;caractere 5
    MOV AX, T_RESTE[BX+8] 
    CMP AL, 00H
    JE pasprintreste5
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste5:
    
    ;caractere 6
    MOV AX, T_RESTE[BX+10] 
    CMP AL, 00H
    JE pasprintreste6
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste6:    
    
    ;caractere 7
    MOV AX, T_RESTE[BX+12] 
    CMP AL, 00H
    JE pasprintreste7
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste7:
    
    ;caractere 8
    MOV AX, T_RESTE[BX+14] 
    CMP AL, 00H
    JE pasprintreste8
    carac 02H, CURSEUR, AL
    INC CURSEUR  
    pasprintreste8:  
endp
ret

hextodReste proc ;procedure qui convertit le reste en decimal
  
       
   MOV AX, RESTE
   MOV CX,0AH
   
   DIV CX
   MOV T_RESTE[BX+14],DX
   ADD T_RESTE[BX+14],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX+12],DX
   ADD T_RESTE[BX+12],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX+10],DX
   ADD T_RESTE[BX+10],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX 
   MOV T_RESTE[BX+8],DX
   ADD T_RESTE[BX+8],30H
   MOV DX,0000H
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX+6],DX
   ADD T_RESTE[BX+6],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX+4],DX
   ADD T_RESTE[BX+4],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX+2],DX
   ADD T_RESTE[BX+2],30H
   XOR DX,DX
   CMP AX,0000H
   JE finconvreste
   
   DIV CX
   MOV T_RESTE[BX],DX
   ADD T_RESTE[BX],30H
   
   finconvreste:
   
   
endp
ret  



CSEG ENDS
END MAIN
