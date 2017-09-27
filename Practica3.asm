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
    varAuxB             db 0
    varAuxW             dw 0
    Opera1              db 0
    Opera2              db 0
    resultado           db 0
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Arreglos ++++++++++++++++++++++++++++++++++++++++++
    Coefs               db 5 dup(0)
    Deriv               db 4 dup(0)
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Banderas ++++++++++++++++++++++++++++++++++++++++++
    bandNumNeg          db 0
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
    ;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    leeTecla proc
        mov AH,01h                                  ;Asigna la funcion para leer un caracter de teclado
        int 21h                                     ;llama a la interrupcion
        ret
    endp
    ;realiza una multiplicación entre las
    ;variables Opera
    hacerMulti proc
        mov AH,00h
        mov AL,Opera1                             ;guarda el valor del primer operando en AX
        imul Opera2                                 ;realiza una mumltipliación entre los operandos
        mov resultado,AL                            ;Se Guarda el resultado en la variable Resultado
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
        ;je  funMemoria                              ;si es, salta a mostrar la función en memoria
        cmp AL,33h                                  ;compara si es la opción tres
        je  derivada                                ;si es, salta a calcular la derivada
        cmp AL,34h                                  ;compara si es la opción cuatro
        ;je  integral                                ;si es, salta a calcular la integral de f
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

    ;Calcular la derivada de f
    derivada:
        mov CX,04h
        mov iCoefs,00h
        mov Opera1,04h
        xor SI,SI
        loopCalcDerivada:
            mov SI,iCoefs
            mov DL,Coefs[SI]
            mov Opera2,DL
            call hacerMulti
            mov DL,resultado
            mov Deriv[SI],DL
            inc iCoefs
            dec Opera1
        loop loopCalcDerivada
        call pausa
        jmp MenuPrin
    ;Menu Graficar Funciones
    menuGra:
        call limpPant
        imprimir stringMenGra
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        ;je  ingFun                                  ;si es, salta a Grafica de f
        cmp AL,32h                                  ;compara si es la opción dos
        ;je  funMemoria                              ;si es, salta a Grafica de f'
        cmp AL,33h                                  ;compara si es la opción tres
        ;je  derivada                                ;si es, salta a Grafica de F
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  MenuPrin                                ;si es, regresa al Menú Principal
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
