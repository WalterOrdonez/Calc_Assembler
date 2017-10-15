; multi-segment executable file template.
;_____________________________________________ Segmento Datos _____________________________________________
data segment
    ;+++++++++++++++++++++++++++++++++++++++++++++ Mensajes ++++++++++++++++++++++++++++++++++++++++++++++
    pkey                db "Adios...$"
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"
    ;ingresar coeficiente x
    stringCoef          db "Coeficiente de X","$"
    strRepCre           db "Reporte Creado con Exito",0Dh,0Ah,"$"
    strConsC            db "Ingrese el valor de la constante C",0Dh,0Ah,"$"
    strLInfX            db "Ingrese el l",0A1h,"mite inferior de X: ","$"
    strLSupX            db "Ingrese el l",0A1h,"mite superior de X: ","$"
    ;+++++++++++++++++++++++++++++++++++++++++ Mensajes de Error +++++++++++++++++++++++++++++++++++++++++
    erCarInv            db 0Dh,0Ah,"Error Caracter invalido",0Dh,0Ah,"$"
    erNoFun             db "No se ha encontrado función en memoria",0Dh,0Ah,"$"
    ;mensaje de error al crear el archivo            
    erCreArch           db "No se pudo crear el archivo de Reporte","$"
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
    linfX               db 0
    lSupX               db 0
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
    ;día del Sistema
    diaSis              db 0
    ;mes del Sistema
    mesSis              db 0
    ;año del sistema 
    anioSis             dw 0
    ;hora del Sistema
    horaSis             db 0
    ;Minutos Sistema
    MinSis              db 0
    ;constante C
    constC              db 0
    ;identificador del archivo de reporte 
    handleRep           dw ?
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Arreglos ++++++++++++++++++++++++++++++++++++++++++
    Coefs               db 5 dup(0)
    Deriv               db 4 dup(0)
    Integ               db 6 dup(0)
    strFunc             db 23 dup("$")
    strDeriv            db 22 dup("$")
    strInteg            db 38 dup("$")
    NumAux              db 5 dup("$")
    ;Dirección del archivo de reporte
    pathArchivoRep      db "Reporte.rep",00h
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Banderas ++++++++++++++++++++++++++++++++++++++++++
    bandNumNeg          db 0
    bandFunAGra         db 0
    bandFunMem          db 0
    ;+++++++++++++++++++++++++++++++++++++++++++++ Variables Indices ++++++++++++++++++++++++++++++++++++++
    iCoefs              dw 0
    iFuncion            dw 0
    iDerivada           dw 0
    iIntegral           dw 0
    ;++++++++++++++++++++++++++++++++++++++++ String Reporte +++++++++++++++++++++++++++++++++++++++++
    strRepFac           db "Factorial: ","$"
    strRepHor           db "Hora: ","$"
    strRepFec           db "Fecha: ","$"
    strRepDP            db " : "
    strRepD             db " / "
    strRepFun           db "Funci",0A2h,"n Original: ",0Dh,0Ah,"$"
    strRepDer           db "Derivada: ",0Dh,0Ah,"$"
    strRepInt           db "Integral: ",0Dh,0Ah,"$"

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
    ;escribir en archivo
    escArch macro dato,largo
        push AX                                     ;Guarda el Valor de AX en la pila
        mov AH,40h                                  ;Escritura en archivo
        mov BX,handleRep                            ;handle del archivo de reporte
        mov CX,largo                                ;cantidad de bytes a escribir
        lea DX,dato                                 ;los datos a escribir
        int 21h                                     ;llamada a la interrupcion
        pop AX                                      ;Regresar el valor de AX    
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

    ;si es Negativo aplica Complemento A2
    compA2 proc
        cmp bandNumNeg,00h
        je  salirCompA2
        neg varAuxW
        salirCompA2:
        ret
    endp

    ;convierte el resultado a una variable
    ;tipo String
    aString proc
        mov AX,resultado                            ;inicia AX con el resultado
        mov DX,resultado                            ;inicia DX con el resultado
        xor SI,SI                                   ;inicia SI en 0
        cmp resultado,3E8h                          ;compara si el resultado con 1,000
        jb  centenas                                ;si es menor salta a las centenas
        xor DX,DX                                   ;si no, inicia DX en 0
        mov BX,3E8h                                 ;Guarda 1,000 en BX
        idiv BX                                     ;divide el resultado entre 1,000
        add AX,30h                                  ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                           ;agrega el digito en la variable numero auxiliar
        inc SI                                      ;incrementa SI
        mov AX,DX                                   ;mueve el residuo a AX
        centenas:
        cmp resultado,064h                          ;compara si el resultado con 1,000
        jb  decenas                                 ;si es menor salta a las centenas
        xor DX,DX                                   ;si no, inicia DX en 0
        mov BX,64h                                  ;Guarda 100 en BX
        idiv BX                                     ;divide el resultado entre 100
        add AX,30h                                  ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                           ;agrega el digito en la variable numero auxiliar
        inc SI                                      ;incrementa SI
        mov AX,DX
        decenas:
            cmp resultado,0Ah                       ;compara si el resultado con 10
            jb  unidades                            ;si es menor salta a las centenas
            xor DX,DX                               ;si no, inicia DX en 0
            mov BX,0Ah                              ;Guarda 10 en BX
            idiv BX                                 ;divide el resultado entre 10
            add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
            mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
            inc SI
        unidades:
            add DL,30h                              ;toma el cociente le agrega 30, pasa a ASCII
            mov NumAux[SI],DL                       ;agrega el digito en la variable numero auxiliar
            inc SI
            mov NumAux[SI],24h                      ;agrega el fin de cadena al numero auxiliar
        ret
    endp

    ;Guarda el NumAux al Vector strDeriv
    movNumAuxAstrDeriv proc
        xor SI,SI
        loopMovNumADeriv:
            mov DI,iDerivada
            mov DL,NumAux[SI]
            cmp DL,24h
            je  salirLoopMov
            mov strDeriv[DI],DL
            inc iDerivada
            inc SI
            jmp loopMovNumADeriv
        salirLoopMov:
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
    ;Calcular la derivada de f
    derivada proc
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
        ret
    endp

    ;Calcular la Integral de f
    integral proc
        mov CX,05h
        xor SI,SI
        loopCalcInteg:
            xor DH,DH
            mov DL,Coefs[SI]                        ;Guarda el coeficiente de f en DL
            mov Integ[SI],DL                        ;Guarda el resultado en el vector Integral
            inc SI
        loop loopCalcInteg
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
            cmp DX,64h                              ;compara el coeficiente con 10 en hexa
            jb  coefPost                            ;si es menor, es positivo
            mov DH,0xFF                             ;sino negativo, guarda en el byte alto FF
            coefPost:
            mov Opera2,DX                           ;Guarda el coeficiente en el operador 2
            call hacerMulti                         ;Hace la multiplicación, coeficiente y la potencia 
            mov DX,Resultado                        
            cmp bandFunAGra,02h                     ;compara si la bandera es 2, integral
            jne nodivide                            ;si no lo es, no divide
            mov Opera1,DX               
            mov Opera2,CX
            call hacerDivi                          ;si es, hace la división de la integral
            mov DX,Resultado
            nodivide:                        
            add Y,DX                                ;se le agrega a Y el resultado
            inc iCoefs
        loop loopCalcY
        mov SI,iCoefs                               
        xor DH,DH
        call selecF                                 ;se agrega el ultimo coeficiente
        cmp DL,64h                                  ;Comprobando nuevamente si es positivo o negativo
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
        push CX
        mov CX,140h
        loopEjes:
            cmp CX,0xC7
            ja  ejeX
            pixel 0xA0,CX
            ejeX:
            pixel CX,64h
        loop loopEjes
        pop CX
        ret
    endp

    ;Graficar un polinomio
    graficar proc
        call graEjes
        loopGraFun:
            push CX                                 ;guarda el valor actual de CX en la pila
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

    ;Hora del Sistema
    horaSistema proc
        mov AH,2Ch
        int 21h
        mov horasis,CH
        mov MinSis,CL
        ret
    endm

    ;Fecha del Sistema
    fechaSistema proc
        mov AH,2Ah
        int 21h
        mov anioSis,CX
        mov mesSis,DH
        mov diaSis,DL
        ret
    endm

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
        je  derMemoria                              ;si es, salta a calcular la derivada
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  intMemoria                              ;si es, salta a calcular la integral de f
        cmp AL,35h                                  ;compara si es la opción cinco
        je  menuGra                                 ;si es, salta al Menu Graficar
        cmp AL,36h                                  ;compara si es la opción seis
        je  reporte                                 ;si es, salta a generar el reporte            
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
            mov bandNumNeg,00h 
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
                xor DH,DH
                mov DL,AL
                mov varAuxW,DX
                call compA2                         ;comprueba si es negativo el número y aplica complemento A2
                mov DX,varAuxw
                mov AL,DL
                mov SI,iCoefs                       
                mov Coefs[SI],AL                    ;Guarda el numero en el vector de coeficientes
                inc iCoefs             
                dec varAuxB
                imprimir saltoLin
        loop loopIngCoef
        call derivada
        call integral
        mov bandFunMem,01h
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

    ;Mostrar función en Memoria
    funMemoria:
        call limpPant
        cmp bandFunMem,00h                          ;compara la bandera de almacenamiento de función en memoria
        je  errorNoFuncion                          ;si es 0, aún no se ha almacenado la función
        mov bandFunAGra,00h                         ;guarda con que polinomio se está trabajando 0 función
        mov iCoefs,00h
        mov iFuncion,00h
        mov varAuxB,34h                             ;Inicia la variable con 4 en ASCII 
        mov CX,05h
        loopFunMem:
            mov SI,iCoefs
            mov DI,iFuncion
            call selecF                             ;selecciona el coeficiente indicado por SI
            cmp DL,0Ah                              ;compara con 10
            jb  Cpost                               ;si es menor salta a positivo
            mov strFunc[DI],2Dh                     ;si no, guarda un - en el vector
            inc iFuncion
            mov DI,iFuncion
            neg DL                                  ;aplica complemento A2
            jmp Cpost2                              
            Cpost:
                cmp DL,00h                          ;compara con 0 el coeficiente
                je incIndLoopFunMem                 ;si es 0, sigue con el siguiente coeficiente
                mov strFunc[DI],2Bh                 ;guarda el signo + en el vector
                inc iFuncion
                mov DI,iFuncion
                Cpost2:
                add DL,30h                          ;le suma 30 al coeficiente, para convertirlo a ASCII
                mov strFunc[DI],DL                  ;guarda el coeficiente en el vector
                inc iFuncion
                cmp varAuxB,30h                     ;compara el exponente actual es 0
                je  incIndLoopFunMem                ;si es, no agrega la X
                mov DI,iFuncion     
                mov strFunc[DI],58h                 ;Agrega la X al vector
                inc iFuncion
                cmp varAuxB,31h                     ;compara el exponente con 1
                je  espStrFunc                      ;si es no agrega el 1 despues de la X
                mov DI,iFuncion
                mov DL,varAuxB                      ;agrega el exponente
                mov strFunc[DI],DL 
                inc iFuncion
                espStrFunc:
                mov DI,iFuncion
                mov strFunc[DI],20h                 ;agrega un espacio
                inc iFuncion
            incIndLoopFunMem:
                dec varAuxB
                inc iCoefs
        loop loopFunMem
        mov DI,iFuncion
        mov strFunc[DI],24h                         ;agrega el fin de cadena al final del vector
        imprimir strFunc
        call pausa
        jmp menuPrin                                ;regresa al menú principal

    ;Mostrar error que no hay función en memoria
    errorNoFuncion:
        imprimir erNoFun
        call pausa
        jmp menuPrin

    ;Mostrar Derivada en memoria
    derMemoria:
        call limpPant
        cmp bandFunMem,00h                          ;compara si hay función almacenada
        je  errorNoFuncion                          ;si no hay función muestra error
        mov bandFunAGra,01h                         ;establece la bandera en 1, derivada
        mov iCoefs,00h 
        mov iDerivada,00h
        mov varAuxB,33h                             ;inicia la variable en grado 3
        mov CX,04h
        looderMemoria:
            mov SI,iCoefs
            mov DI,iDerivada
            call selecF                             ;selecciona el coeficiente indicado por SI
            cmp DL,64h                              ;compara el coeficiente con 100
            jb  CDpost                              ;si es menor, es positivo
            mov strDeriv[DI],2Dh                    ;si no es negativo, y almacena el -        
            inc iDerivada 
            mov DI,iDerivada
            neg DL                                  ;aplica complemento A2 al número
            jmp CDpost2
            CDpost:
                cmp DL,00h                          ;compara coeficiente con 0
                je incIndlooderMemoria              ;si es, sigue con el siguiente coeficiente
                mov strDeriv[DI],2Bh                ;agrega el signo +
                inc iDerivada
                CDpost2:
                xor DH,DH
                mov resultado,DX
                call aString                        ;convierte a String el coeficiente
                call movNumAuxAstrDeriv             ;guarda el String en el vector derivada
                cmp varAuxB,30h                     ;compara el exponente con 0 en ASCII
                je  incIndlooDerMemoria             ;si es no agrega la X
                mov DI,iDerivada                    
                mov strDeriv[DI],58h                ;Agrega la X al vector
                inc iDerivada                       
                cmp varAuxB,31h                     ;compara el exponente con 1 en ASCII
                je  espstrDeriv                     ;no agrega el 1 despues de la X
                mov DI,iDerivada
                mov DL,varAuxB
                mov strDeriv[DI],DL                 ;agrega el exponente al vector
                inc iDerivada
                espstrDeriv:
                mov DI,iDerivada
                mov strDeriv[DI],20h                ;agrega un espacio al vector
                inc iDerivada
            incIndlooDerMemoria:
                dec varAuxB
                inc iCoefs
        loop looderMemoria
        mov DI,iDerivada
        mov strDeriv[DI],24h                        ;agrega el final de cadena
        imprimir strDeriv
        call pausa
        jmp menuPrin

    ;Mostrar Integral en memoria
    intMemoria:
        call limpPant
        cmp bandFunMem,00h                          ;compara la bandera de función en memoria con 0
        je  errorNoFuncion                          ;si es igual, muestra error
        mov bandFunAGra,00h                         ;Establece la bandera en 0, coeficiente de la función
        mov iCoefs,00h
        mov iIntegral,00h
        mov varAuxB,35h
        mov CX,05h
        loopIntMem:
            mov SI,iCoefs
            mov DI,iIntegral
            call selecF                             ;selecciona el coeficiente indicado por SI
            cmp DL,0Ah                              ;compara el coeficiente con 10
            jb  CIpost                              ;si es menor, es positivo
            mov strInteg[DI],2Dh                    ;si no, agrega un signo -
            inc iIntegral       
            mov DI,iIntegral
            neg DL
            jmp CIpost2                     
            CIpost:
                cmp DL,00h                          ;compara el coeficiente con 0
                je incIndLoopIntMem                 ;si es, sigue con el siguiente coeficiente
                mov strInteg[DI],2Bh                ;si no, agrega el signo +
                inc iIntegral
                mov DI,iIntegral
                CIpost2:
                add DL,30h                          ;suma 30 al coeficiente, pasa a código ASCII
                mov strInteg[DI],DL                 ;guarda el coeficiente en el vector
                inc iIntegral
                cmp varAuxB,30h                     ;compara el exponente con 0
                je  incIndLoopIntMem                ;si es, no agrega la X
                mov DI,iIntegral
                mov strInteg[DI],2Fh                ;agrega el simbolo /
                inc iIntegral
                mov DI,iIntegral
                mov DL,varAuxB
                mov strInteg[DI],DL                 ;agrega el exponente como divisor
                inc iIntegral
                mov DI,iIntegral
                mov strInteg[DI],58h                ;agrega la X al vector
                inc iIntegral
                cmp varAuxB,31h                     ;compara el exponente con 1
                je  espstrInteg                     ;si es, no agrega el 1 después de la X
                mov DI,iIntegral
                mov DL,varAuxB
                mov strInteg[DI],DL                 ;agrega el exponente
                inc iIntegral
                espstrInteg:
                mov DI,iIntegral
                mov strInteg[DI],20h                ;agrega un espacio
                inc iIntegral
            incIndLoopIntMem:
                dec varAuxB
                inc iCoefs
        loop loopIntMem
        mov DI,iIntegral
        mov strInteg[DI],2Bh                        ;agrega el signo +
        inc iIntegral
        mov DI,iIntegral
        mov strInteg[DI],43h                        ;agrega la constante C
        inc iIntegral
        mov DI,iIntegral
        mov strInteg[DI],24h                        ;agrega el final de cadena
        imprimir strInteg
        call pausa
        jmp menuPrin

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
        imprimir strLInfX                           
        
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
        mov varAuxB,00h
        mov bandNumNeg,00h
        call limpPant
        imprimir strconsC
        constanteC:
            call leeTecla
            cmp Al,2Dh
            je ConsCNeg
            cmp AL,2Bh                              ;Compara si es el signo +
            je  constanteC                          ;Simplemente la ignora
            cmp AL,30h                              ;compara con 0 en ASCII
            jb errorConsC                           ;si es menor, es un error caracter invalido
            cmp AL,39h                              ;compara si es 9 en ASCII
            ja errorConsC                           ;si es mayor, es un error caracter invalido
            sub AL,30h                              ;resta 30, valor nominal
            cmp varAuxB,00h                         ;compara varAuxB con 0
            ja seguDig                              ;si es mayor es el segundo digito
            mov AH,AL                               ;mover el primer digito a AH                          
            mov DL,0Ah                              ;guarda 10 en DL
            mul DL                                  ;multiplica el primer digito por 10
            mov constC,AL                           ;guarda el resultado en constC
            inc varAuxB
            jmp constanteC
            seguDig:
            add constC,AL                           ;suma el segundo digito a constC
            xor DH,DH 
            mov DL,constC
            mov varAuxW,DX 
            call compA2                             ;verifica sí es necesario complemento A2
            mov DX,varAuxW 
            mov constC,DL                           ;constanteC tiene el valor de la constante de integración
            call pausa
        call limpPant
        mov AX,13h                                  ;modo video
        int 10h                               
        mov CX,28h                                  ;Inicia el loop en 40 en hexa
        mov X,0XFFEC                                ;inicia X en -20 en hexa
        mov bandFunAGra,02h                         ;bandera indica que se grafica la Integral
        mov numCoefs,05h                            ;Indica que tiene 4 coeficientes posibles
        mov SI,numCoefs
        mov DL,constC
        mov Integ[SI],DL                            ;Asignacion de la constante C
        call graficar                               ;Grafica la Integral
        call pausa                                  ;espera una pulsación para salir
        mov ax,03h                                  ;Modo texto
        int 10h
        jmp menuGra
    ;Levanta la bandera negativa
    ConsCNeg:
        mov bandNumNeg,01h
        jmp constanteC
    ;error al ingresar un caracter no valido
    errorConsC:
        imprimir erCarInv           
        jmp graInteg
    ;Generar Reporte
    Reporte:
        mov AH,3Ch                                  ;Crear Archivo
        mov CX,00                                   ;Fichero Normal
        lea DX,pathArchivoRep                       ;direccion del archivo a crear
        int 21h                                     ;llamada a la interrupcion
        jc  errorCrear                              ;salta si hay algun error
        mov handleRep,AX                            ;obtiene el handle devuelto por la interrupcion

        ;imprime en el archivo las cadenas del reporte
        escArch stringEncabezado,0xE5               ;Imprime en archivo el encabezado
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepFec,0x07
        call fechaSistema                           ;obtiene la fecha del sistema
        xor DH,DH
        mov DL,diaSis
        mov resultado,DX
        call aString                                ;convierte el día de la fecha a String
        escArch NumAux,SI                           ;Escribe el día en el reporte
        escArch strRepD,0x03                        ;Escribe una diagonal
        xor DH,DH
        mov DL,mesSis                   
        mov resultado,DX
        call aString                                ;convierte el mes de la fecha a string
        escArch NumAux,SI                           ;Escribe la fecha en el reporte
        escArch strRepD,0x03                        ;Escribe una diagonal
        mov DX,anioSis
        mov resultado,DX
        call aString                                ;convierte el año de la fecha en string
        escArch NumAux,SI                           ;escribe la fecha en el reporte
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea        
        call horaSistema                            ;obtiene la hora del sistema
        xor DH,DH
        mov DL,horasis              
        mov resultado,DX    
        call aString                                ;convierte la hora a String
        escArch strRepHor,0x06                      ;escribe la palabra hora
        escArch NumAux,SI                           ;escribe la Hora en el reporte
        escArch strRepDP,0x03                       ;escribe : en el reporte
        xor DH,DH
        mov DL,MinSis
        mov resultado,DX
        call aString                                ;convierte los minutos a String
        escArch NumAux,SI                           ;Escribe los minutos en el reporte
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepFun,0x14                      ;Imprime en archivo la entrada del archivo
        escArch strFunc,iFuncion                    ;Escribe la función original
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepDer,0x0C                      ;Escribe la palabra Derivada
        escArch strDeriv,iDerivada                  ;Escribe la Derivada de f
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepInt,0x0C                      ;Escribe la palabra Integral
        escArch strInteg,iIntegral                  ;escribe la integral
        
        mov handleRep,AX                            ;obtiene el handle devuelto por la interrupcion        
        mov BX,AX                                   ;mover Handle
        mov AH,3Eh                                  ;Cierre de archivo
        int 21h
        imprimir strRepCre
        call pausa
        jmp menuPrin
        errorCrear:
            imprimir erCreArch                      ;Imprime el mensaje de error al crear el archivo
            call pausa
            jmp menuPrin
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