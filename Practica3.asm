; multi-segment executable file template.
;_____________________________________________ Segmento Datos _____________________________________________
data segment
    ;+++++++++++++++++++++++++++++++++++++++++++++ Mensajes ++++++++++++++++++++++++++++++++++++++++++++++
    pkey                db "Adios...$"
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"
    ;ingresar coeficiente x
    stringCoef          db "Coeficiente de X","$"
    ;+++++++++++++++++++++++++++++++++++++++++ Mensajes de Error +++++++++++++++++++++++++++++++++++++++++
    erCarInv            db 0Dh,0Ah,"Error Caracter invalido",0Dh,0Ah,"$"
    ;++++++++++++++++++++++++++++ String del encabezado y menú principal +++++++++++++++++++++++++++++++++ 
    stringEncabezado    db "Universidad de San Carlos de Guatemala",0Dh,0Ah
                        db "Facultad de Ingenieria",0Dh,0Ah
                        db "Escuela de Ciencias y Sistemas",0Dh,0Ah
                        db "Arquitectura de computadores Y Ensambladores 1 A",0Dh,0Ah
                        db "Segundo Semestre 2017",0Dh,0Ah
                        db "Walter Alfredo Ordo",0A4h,"ez Garc",0A1h,"a",0Dh,0Ah
                        db "2007-14802",0Dh,0Ah
                        db "TERCERA PRACTICA",0Dh,0Ah,"$"
    stringMenPri        db "---------------------------------MENU PRINCIPAL--------------------------------",0Dh,0Ah
                        db "1- Ingresar funci",0A2h,"n f(x)",0Dh,0Ah          
                        db "2- Funci",0A2h,"n en Memoria",0Dh,0Ah
                        db "3- Derivada f",60h,"(x)",0Dh,0Ah
                        db "4- Integral F(x)",0Dh,0Ah
                        db "5- Graficar Funciones",0Dh,0Ah
                        db "6- Reporte",0Dh,0Ah
                        db "7- Salir",0Dh,0Ah,"$"
    ;+++++++++++++++++++++++++++++++++++++++++++ String del Menu Graficar ++++++++++++++++++++++++++++++++++
    stringMenGra        db "----------------------------------MENU GRAFICA---------------------------------",0Dh,0Ah
                        db "1- Graficar Original",0Dh,0Ah
                        db "2- Graficar Derivada",0Dh,0Ah
                        db "3- Graficar Integral",0Dh,0Ah                 
                        db "4- Regresar",0Dh,0Ah,"$"
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Variables +++++++++++++++++++++++++++++++++++++++++
    X                   dw 0
    Y                   dw 0
    OrgX                dw 0xA0
    OrgY                dw 0x64
    xPant               dw 0
    yPant               dw 0
    varAuxB             db 0
    varAuxW             dw 0
    Opera1              dw 0
    Opera2              dw 0
    resultado           dw 0
    resultadoW          dd 0
    numCoefs            dw 0
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Arreglos ++++++++++++++++++++++++++++++++++++++++++
    Coefs               db 5 dup(0)
    Deriv               db 4 dup(0)
    Integ               db 6 dup(0)
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Banderas ++++++++++++++++++++++++++++++++++++++++++
    bandNumNeg          db 0
    bandFunAGra         db 0
    ;+++++++++++++++++++++++++++++++++++++++++++++ Variables Indices ++++++++++++++++++++++++++++++++++++++
    iCoefs              dw 0

ends
;______________________________________________Segmento Stack _____________________________________________
stack segment
    dw   128  dup(0)
ends
;______________________________________________Segmento Codigo _____________________________________________
code segment
    ;++++++++++++++++++++++++++++++++++++++++++ Macros ++++++++++++++++++++++++++++++++++++++++++++++++
    ;Macro para imprimir una cadena, recibe un parametro
    imprimir macro str
        mov AH,09h                                  ;funcion para imprimir en pantalla
        mov DX,offset str   
        int 21H
    endm
    ;imprime un caracter en pantalla
    imprimirChar macro char
         mov AH,02h                                 ;funcion 2, imprimir byte en pantalla
         mov DL,char                                ;valor del parametro char a DL
         int 21h                                    ;se llama a la interrupcion
    endm
    ;si es Negativo aplica Complemento A2
    compA2 macro num
        cmp bandNumNeg,00h
        je  salirCompA2
        neg num
        salirCompA2:
            nop
    endm
    ;Macro para pintar un pixel en pantalla
    pixel macro xPix,yPix
        push CX
        mov AH,0Ch
        mov AL,32h
        mov BH,00h
        mov DX,yPix
        mov CX,xPix
        int 10h
        pop CX
    endm
    ;+++++++++++++++++++++++++++++++++++++++ Procedimientos ++++++++++++++++++++++++++++++++++++++++++++
    ;Limpia la pantalla, modo texto
    limpPant proc
        mov AH, 00h
        mov AL, 3h                                  ;modo texto
        int 10h                                     ;interrupcion
        mov AH,02h                                  ;funcion posicionar cursor
        mov DX,0000h                                ;cordenadas 0,0
        int 10h                                     ;interrupcion
        mov AX,0600h                                ;ah 06(es un recorrido), al 00(pantalla completa)
        mov BH,07h                                  ;fondo negro(0), sobre blanco(7)
        mov CX,0000h                                ;es la esquina superior izquierda reglon: columna
        mov DX,184Fh                                ;es la esquina inferior derecha reglon: columna
        int 10h                                     ;interrupcion
        ret
    endp
    ;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    pausa proc
        mov AH, 07h                                 ;funcion 7, obtener caracter de pantalla, sin imprimir en pantalla(echo)
        int 21h                                     ;se llama a la interrupcion
        ret
    endp
    ;espera una pulsación de tecla con ECO
    leeTecla proc
        mov AH,01h                                  ;Asigna la funcion para leer un caracter de teclado, mostrandolo en pantalla
        int 21h                                     ;llama a la interrupcion
        ret
    endp
    ;realiza una multiplicación entre las
    ;variables Opera
    hacerMulti proc
        mov AX,Opera1                               ;guarda el valor del primer operando en AX
        imul Opera2                                 ;realiza una mumltipliación entre los operandos
        mov resultado,AX                            ;Se Guarda el resultado en la variable Resultado
        ret
    endp
    ;realiza una divición entre las
    ;variables Opera
    hacerDivi proc
        xor DX,DX                                   ;inicia el registro en 0
        cmp Opera1,3E8h                             ;Compara si el operador 1 con 1000
        jb diviPositiva                             ;si es menor, la divición es positvia
        mov DX,0xFFFF                               ;si no, la división es negativa, inicia
                                                    ;la word alta en FFFF
        diviPositiva:
        mov AX,Opera1                               ;guarda el primer operando en AX
        idiv Opera2                                 ;realiza la división con signo, de los operandos
        mov resultado,AX                            ;Guarda el resultado en la variable
        ret
    endp
    ;realiza la potenciación tomando
    ;Opera1 como base y Opera2 como potencia
    hacerPot proc
        push CX                                     ;Guarda el valor actual de CX en la pila
        mov CX,Opera2                               ;se guarda la cantidad de veces a multiplicar
        mov AX,01h                                  ;se inicia el acumulador con 1 en hexa
        cmp CX,00h                                  ;si CX es 0, es una potencia elevada a la 0
        je  salirPot                                ;sale, devolviendo un 1 como resultado
        loopPot:
            imul Opera1                             ;hace las multiplicaciones de la base
        loop loopPot
        salirPot:
        mov resultadoW[0],AX                        ;se guarda el resultado, variable tamaño Doble Word
        mov resultadoW[2],DX                        ;DX palabra alta, AX palabra baja
        pop CX                                      ;se recupera el valor de CX
        ret
    endp
    ;seleccionar si es F, f' o f
    selecF proc
        cmp bandFunAGra,00h                         ;compara la variable bandera con 0
        jne gDeriv                                  ;si no es igual, no es la función y salta
        mov DL,Coefs[SI]                            ;si es igual, Guarda el coeficiente
        jmp salirSelecF                             ;sale del selector
        gDeriv:
        cmp bandFunAGra,01h                         ;compara la variable bandera con 1
        jne gInteg                                  ;si no es igual, no es la derivada y salta
        mov DL,Deriv[SI]                            ;si es igual, Guarda el coeficiente
        jmp salirSelecF                             ;sale del selector
        gInteg:
        mov DL,Integ[SI]                            ;Guarda el coeficiente de la integral
        salirSelecF:
        ret
    endp

    ;Calcular f(x)=y
    calcY proc
        mov Y,00h
        mov CX,numCoefs                             ;Inicia CX en 4, el grado más grande de f
        mov iCoefs,00h
        loopCalcY:
            mov DX,X                                
            mov Opera1,DX                           ;Guarda en el operador 1 el valor de X
            mov Opera2,CX                           ;Guarda en el operador 2 el grado
            call hacerPot                           ;hace la potencia de X al grado
            mov Opera1,AX                           ;Guarda el resultado de la potencia en el Operador 1
            mov SI,iCoefs 
            xor DH,DH                               ;pone 0 el byte más significativo de DX
            call selecF
            cmp DX,0Ah                              ;compara el coeficiente con 10 en hexa
            jb  coefPost                            ;si es menor, es positivo
            mov DH,0xFF                             ;sino negativo, guarda en el byte alto FF
            coefPost:
            mov Opera2,DX                           ;Guarda el coeficiente en el operador 2
            call hacerMulti                         ;Hace la multiplicación, coeficiente y la potencia 
            mov DX,Resultado                        
            add Y,DX                                ;se le agrega a Y el resultado
            inc iCoefs
        loop loopCalcY
        mov SI,iCoefs                               
        xor DH,DH
        mov DL,Coefs[SI]                            ;se agrega el ultimo coeficiente
        cmp DL,0Ah                                  ;Comprobando nuevamente si es positivo o negativo
        jb  coefPost2                               ;   .
        mov DH,0xFF                                 ;   .
        coefPost2:                                  ;   .
            add Y,DX                                ;se suma a la variable Y
        ret 
    endp

    ;Calcular la posición X en pantalla
    ;Del pixel a pintar
    calcXPix proc
        mov DX,X
        mov Opera1,DX
        mov Opera2,08h
        call hacerMulti
        mov DX,OrgX
        add DX,AX
        mov xPant,DX
        ret
    endp

    ;Calcular la posición Y en pantalla
    ;Del pixel a pintar
    calcYPix proc
        mov DX,Y
        mov Opera1,DX
        mov Opera2,01h
        call hacerMulti
        mov DX,OrgY
        sub DX,AX
        mov yPant,DX
        ret
    endp

    ;Graficar los ejes X y Y
    graEjes proc 
        mov CX,140h
        loopEjes:
            cmp CX,0xC7
            ja  ejeX
            pixel 0xA0,CX
            ejeX:
            pixel CX,64h
        loop loopEjes
        ret
    endp

    ;Graficar un polinomio
    graficar proc
        loopGraFun:
            push CX                                 ;guarda el valor actual de CX en la pila
            call graEjes
            call calcY                              ;calcula f(x)=y
            jns YPost                               ;sí Y no es negativa, salta a YPost
            cmp Y,0xFF9C                            ;compara con -100
            jb  salirLoopGraFun                     ;si es menor que -100 no grafica
            jmp PintarPix                           ;si es mayor o igual grafica el punto
            YPost:
            cmp Y,64h                               ;Compara con 100
            ja  salirLoopGraFun                     ;si es mayor a 100 no grafica
            PintarPix:
                call calcXPix                       ;convierte X, a coordenadas de la pantalla
                call calcYPix                       ;convierte Y, a coordenadas de la pantalla
                pixel xPant,yPant                   ;grafica el punto
            salirLoopGraFun:
            inc X
            pop CX                                  ;recupera el valor de CX
        loop loopGraFun
        ret
    endp
    ;+++++++++++++++++++++++++++++++++++++++ Etiquetas +++++++++++++++++++++++++++++++++++++++++++++++
    ;Menu principal de la aplicación
    MenuPrin:
        call limpPant
        imprimir stringEncabezado
        imprimir saltoLin
        imprimir saltoLin
        imprimir stringMenPri
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        je  ingFun                                  ;salta a Ingresar la función f
        cmp AL,32h                                  ;compara si es la opción dos
        je  funMemoria                              ;si es, salta a mostrar la función en memoria
        cmp AL,33h                                  ;compara si es la opción tres
        je  derivada                                ;si es, salta a calcular la derivada
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  integral                                ;si es, salta a calcular la integral de f
        cmp AL,35h                                  ;compara si es la opción cinco
        je  menuGra                                 ;si es, salta al Menu Graficar
        cmp AL,36h                                  ;compara si es la opción seis
        ;je  reporte                                 ;si es, salta a generar el reporte            
        cmp AL,37h                                  ;compara si es la opción Siete
        je  salirApp                                ;si es la opción 7 salta a la salida de la aplicación
        jmp menuPrin                                ;Si no es ninguna opcion, se mantiene en el menu

    ;ingresar función f
    ingFun:
        mov iCoefs,00h                              ;Inicia el indice del vector en 0
        mov varAuxB,34h                             ;Asigna a la variable auxiliar 4 en ASCII
        call limpPant
        mov CX,05h                                  ;Establece en 5 el contador del Loop
        loopIngCoef:                                ;loop para ingresar los 5 coeficientes
            imprimir stringCoef                     ;Imprime la petición del x coeficiente
            mov DL,varAuxB                          ;   .
            imprimirChar DL                         ;   .
            mov DL,3Ah                              ;   .
            imprimirChar DL                         ;   .
            mov DL,20h                              ;   .    
            imprimirChar DL                         ; ........................
            esperaTecla:                            ;loop para capturar teclas precionadas
                call leeTecla                       ;interrupcion para captura de tecla, con ECO
                cmp AL,2Dh                          ;Compara si es el signo -
                je  esNeg                           ;si es Salta a modificar la bandera de signo
                cmp AL,2Bh                          ;Compara si es el signo +
                je  esperaTecla                     ;Simplemente la ignora
                cmp AL,30h                          ;compara si es 0 en ASCII
                jb  errorCarInv                     ;si es menor no es un número, salta a error
                cmp AL,39h                          ;compara si es 9 en ASCII
                ja  errorCarInv                     ;si es mayor no es un número, salta a error
                sub AL,30h                          ;resta 30 al número, para pasarlo a entero
                compA2 AL                           ;comprueba si es negativo el número y aplica complemento A2
                mov SI,iCoefs                       
                mov Coefs[SI],AL                    ;Guarda el numero en el vector de coeficientes
                inc iCoefs             
                dec varAuxB
                mov bandNumNeg,00h                  
                imprimir saltoLin
        loop loopIngCoef
        call pausa
        jmp menuPrin
    ;es negativo el numero
    esNeg:
        mov bandNumNeg,01h                          ;cambia la bandera de signo a 1, negativo
        jmp esperaTecla
    ;error al ingresar un caracter no valido
    errorCarInv:
        imprimir erCarInv           
        mov bandNumNeg,00h                          ;La bandera de numeros negativos regresa a 0, positivo
        jmp loopIngCoef

    ;Mostrar Función en Memoria
    funMemoria:
        mov Opera1,19h
        mov Opera2,05h
        call hacerPot
        call pausa
        jmp menuPrin

    ;Calcular la derivada de f
    derivada:
        mov CX,04h
        mov iCoefs,00h
        mov Opera1,04h                              ;Inicia el Operador 1 en 4, grado más grande de f
        xor SI,SI
        loopCalcDerivada:
            mov SI,iCoefs
            xor DH,DH
            mov DL,Coefs[SI] 
            mov Opera2,DX                           ;Guarda en Operador 2 el coeficiente de f
            call hacerMulti                         ;Multiplica coeficiente con grado
            mov DX,resultado                
            mov Deriv[SI],DL                        ;Guarda el resultado en el vector derivada
            inc iCoefs
            dec Opera1
        loop loopCalcDerivada
        call limpPant
        call pausa
        jmp MenuPrin

    ;Calcular la Integral de f
    integral:
        mov CX,05h
        xor SI,SI
        loopCalcInteg:
            xor DH,DH
            mov DL,Coefs[SI]                        ;Guarda el coeficiente de f en DL
            cmp DL,0Ah                              ;compara con 10
            jb  digPost                             ;si es menor es un digito y es positivo
            mov DH,0xFF                             ;si no, es un negativo, y se llena DH con FF, por el signo
            digPost: 
            mov Opera1,DX                       
            mov Opera2,CX
            call hacerDivi                          ;se divide entre CX, o el grado del polinomio
            mov DX,Resultado        
            mov Integ[SI],DL                        ;Guarda el resultado en el vector Integral
            inc SI
        loop loopCalcInteg
        call limpPant
        call pausa
        jmp MenuPrin

    ;Menu Graficar Funciones
    menuGra:
        call limpPant
        imprimir stringMenGra
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        je  graFun                                  ;si es, salta a Grafica de f
        cmp AL,32h                                  ;compara si es la opción dos
        je  graDeriv                                ;si es, salta a Grafica de f'
        cmp AL,33h                                  ;compara si es la opción tres
        je  graInteg                                ;si es, salta a Grafica de F
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  MenuPrin                                ;si es, regresa al Menú Principal
        jmp menuGra

    ;Graficar Función f
    graFun:
        call limpPant
        mov ax,13h                                  ;modo video
        int 10h                               
        mov CX,28h                                  ;Inicia el loop en 40 en hexa
        mov X,0XFFEC                                ;inicia X en -20 en hexa
        mov bandFunAGra,00h                         ;bandera indica que se grafica la función
        mov numCoefs,04h                            ;Indica los 5 coeficientes posibles 
        call graficar                               ;Grafica la función
        call pausa                                  ;espera una pulsación para salir
        mov ax,03h                                  ;Modo texto
        int 10h
        jmp menuGra

    ;Graficar Derivada
    graDeriv:
        call limpPant
        mov ax,13h                                  ;modo video
        int 10h                               
        mov CX,28h                                  ;Inicia el loop en 40 en hexa
        mov X,0XFFEC                                ;inicia X en -20 en hexa
        mov bandFunAGra,01h                         ;bandera indica que se grafica la derivada
        mov numCoefs,03h                            ;Indica que tiene 4 coeficientes posibles
        call graficar                               ;Grafica la Derivada
        call pausa                                  ;espera una pulsación para salir
        mov ax,03h                                  ;Modo texto
        int 10h
        jmp menuGra

    ;Graficar Integral
    graInteg:
        call limpPant
        mov ax,13h                                  ;modo video
        int 10h                               
        mov CX,28h                                  ;Inicia el loop en 40 en hexa
        mov X,0XFFEC                                ;inicia X en -20 en hexa
        mov bandFunAGra,02h                         ;bandera indica que se grafica la Integral
        mov numCoefs,05h                            ;Indica que tiene 4 coeficientes posibles
        mov SI,numCoefs
        mov Integ[SI],00h                           ;Asignacion de la constante C
        call graficar                               ;Grafica la Integral
        call pausa                                  ;espera una pulsación para salir
        mov ax,03h                                  ;Modo texto
        int 10h
        jmp menuGra
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    jmp MenuPrin

    salirApp:
        lea dx, pkey
        mov ah, 9
        int 21h        ; output string at ds:dx
        
        ; wait for any key....    
        mov ah, 1
        int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.