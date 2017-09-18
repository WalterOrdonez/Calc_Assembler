; multi-segment executable file template.

data segment
    ;++++++++++++++++++++++++++++++++++++++++++++++++ Mensajes +++++++++++++++++++++++++++++++++++++++++++++
    ;Mensaje Final
    pkey                db "Programa finalizado...$"
    
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"

    ;Mensaje de Archivo Analizado
    stringArchAna       db "Se Termin",0A2h," de Analizar el Archivo.","$"

    ;++++++++++++++++++++++++++++ String del encabezado y menú principal +++++++++++++++++++++++++++++++++
    stringEncabezado    db "Universidad de San Carlos de Guatemala",0Dh,0Ah
                        db "Facultad de Ingenieria",0Dh,0Ah
                        db "Escuela de Ciencias y Sistemas",0Dh,0Ah
                        db "Arquitectura de computadores Y Ensambladores 1 A",0Dh,0Ah
                        db "Segundo Semestre 2017",0Dh,0Ah
                        db "Walter Alfredo Ordo",0A4h,"ez Garc",0A1h,"a",0Dh,0Ah
                        db "2007-14802",0Dh,0Ah,"$"  
    stringMenPri        db "---------------------------------MENU PRINCIPAL--------------------------------",0Dh,0Ah
                        db "1- Cargar Archivo",0Dh,0Ah          
                        db "2- Modo Calculadora",0Dh,0Ah
                        db "3- Factorial",0Dh,0Ah
                        db "4- Reporte",0Dh,0Ah
                        db "5- Salir",0Dh,0Ah,"$"
    ;++++++++++++++++++++++++++++++++++++++++ String del menu leer archivo +++++++++++++++++++++++++++++++++++
    strEncLeerArchivo   db "---------------------------------CARGAR ARCHIVO--------------------------------",0Dh,0Ah
                        db "Ingrese la direcci",0A2h,"n del archivo: ",0Dh,0Ah
                        db 22h,"El formato de la direcci",0A2h,"n es ##<direccion>.arq##",22h,"$"

    ;++++++++++++++++++++++++++++++++++++++++ String del Menu de operaciones ++++++++++++++++++++++++++++++++++
    ;string Menu operaciones
    stringMenOp         db "--------------------------------MENU OPERACIONES-------------------------------",0Dh,0Ah
                        db "1- Resultado",0Dh,0Ah
                        db "2- Notaci",0A2h,"n Prefija",0Dh,0Ah
                        db "3- Notaci",0A2h,"n Posfija",0Dh,0Ah                 
                        db "4- Salir",0Dh,0Ah,"$"
    ;++++++++++++++++++++++++++++++++++++++++ Mensajes de Error +++++++++++++++++++++++++++++++++++++++++++++++
    ;mensaje de error, formato de la direccion invalido
    erForInvDir         db "El formato de la direccion no es correcta",0Dh,0Ah
                        db "El formato correcto es ##<Direccion>##","$"
    
    ;mensaje de error al abrir el archivo
    erAbrArch           db "El archivo buscado no se encuentra...","$"
    ;mensaje de error, Caracter Invalido
    erCarInv            db "Caracter Invalido: ","$"
    ;mensaje de error, Número Invalido
    erNumInv            db "Error Caracter Invalido en el Número: ","$"
    ;mensaje de error, se esperaba fin de archivo 
    erFinArch           db "Se esperaba fin de archivo despues de punto y coma: ","$"

    ;mensaje de error, no se encontro el fin de archivo ;
    erNoFinArch         db "Se esperaba fin de archivo ;","$"

    ;+++++++++++++++++++++++++++++++++++++++++++++ Variables ++++++++++++++++++++++++++++++++++++++++++++++++++
    ;------- Variables Indice --------
    ;Indice Actual lista OPERACIONES
    iListOpe            dw 0
    ;Indice digito Actual del Numero concatenado
    iDigNum             dw 0
    ;Indice del vector postFijo
    iPosFijo            dw 0
    ;Indice Auxiliar
    iAux                dw 0

    ;Variable prioridad top Pila
    prioTopPila         db 0
    ;Variable prioridad caracter leido
    prioTopCar          db 0
    ;Variable Operardor 1
    Opera1              dw 0
    ;variable Operardor 2
    Opera2              dw 0
    ;variable Resultado
    Resultado           dw 0
    ;variable operador
    Operador            db 0
    ;Direccion del archivo
    pathArchivo         db 50 dup(0)
    ;Dirección del archivo de reporte
    pathArchivoRep      db 50 dup(0)
    ;datos del archivo
    datosArchivo        db 1000 dup(0)
    ;identificador del arhivo de entrada
    handle              dw ?
    ;Lista de ponderaciones para pasar string a int
    listaPond           dw 0x0001,0x000A,0x0064,0x03E8,0x2710
    ;Lista de operaciones
    listOpera           db 300 dup(0)
    ;Arreglo Postfijo
    postFijo            db 300 dup('$')
    ;Var Tope de Pila
    topPila             db 0
    ;Numero Auxiliar
    NumAux              db 6 dup('$')
    ;-------- Variables bandera ----------
    ;hubo error
    hayError            db 0
    ;ya se ingresó el fin de archivo
    finArchivo          db 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
    
    ;++++++++++++++++++++++++++++++++++++++++++ Macros ++++++++++++++++++++++++++++++++++++++++++++++++
    ;imprime un caracter en pantalla
    imprimirChar macro char
         mov DL, offset char                        ;valor del parametro char a DL
         mov AH, 02h                                ;funcion 2, imprimir byte en pantalla
         int 21h                                    ;se llama a la interrupcion
    endm

    ;Macro para imprimir una cadena, recibe un parametro
    imprimir macro str
        mov AH,09h                                  ;funcion para imprimir en pantalla
        mov DX,offset str   
        int 21H
    endm
    
    ;Posición en memoria de la casilla matriz[i][j]
    ;la respuesta queda en BX
    localizar proc
        mul DX
        add BX,AX
        ret
    endp

    ;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    pausa proc
        mov AH, 07h                                 ;funcion 7, obtener caracter de pantalla, sin imprimir en pantalla(echo)
        int 21h                                     ;se llama a la interrupcion
        ret
    endp


    ;limpia la variable numero Auxiliar
    limpNumAux proc
        mov CX,06h
        mov iAux,00h
        loopLimpNumAux:
            mov SI,iAux
            mov NumAux[SI],24h
            inc iAux
        loop loopLimpNumAux
        ret
    endp

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

    ;Muestra en pantalla el menú principal
    menuPrin:
        call limpPant
        imprimir stringEncabezado
        imprimir saltoLin
        imprimir saltoLin
        imprimir stringMenPri
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        je  leerArchivo                             ;salta al menú Leer Archivo
        cmp AL,35h                                  ;compara si es la opción cinco
        je  salirApp                                ;si es la opción 5 salta a la salida de la aplicación
        jmp menuPrin                                ;Si no es ninguna opcion, se mantiene en el menu

    ;muestra en pantalla la opción Leer Archivo
    leerArchivo:
        call limpPant
        imprimir strEncLeerArchivo
        imprimir saltoLin
        call obtDirArch
        jmp validarDireccion
        sinErLeerArch:
            call limpPant
            jmp cargarArchivo

    ;Obtiene la dirección del archivo ingresada por el usuario
    obtDirArch proc        
        ;Carga de Direccion al buffer
        mov SI,00h                                  ;inicia el indice SI en 0
        leerDireccion:
            mov AX,0000h                            ;limpia el registro AX
            mov AH,01h                              ;Asigna la funcion para leer un caracter de teclado
            int 21h                                 ;llama a la interrupcion
            
            mov pathArchivo[SI],AL                  ;Guarda en el buffer en el indice SI, la tecla leida, guardada en AL
            inc SI                                  ;Se incrementa en 1 el indice SI
            
            ;Se Repite el Proceso de Carga Caracter
            ;por Caracter hasta que se Ingrese un Enter
            cmp AL,0Dh                              ;Compara si es un salto de linea
            je salirLeerDireccion                   ;Si es salto de linea sale del loop
        loop leerDireccion
        salirLeerDireccion:
        dec SI                                      ;Resta uno a SI
        mov pathArchivo[SI],0                       ;quita el salto de linea del buffer y deja un null (0) 
        ret
    endp

    ;valida que la dirección del archivo tiene
    ;el formato correcto
    validarDireccion: 
        cmp pathArchivo[0],23h                      ;compara la posición 0 de la dirección con #
        jne errorDir
        cmp pathArchivo[1],23h                      ;compara la posición 1 de la dirección con #
        jne errorDir
        cmp pathArchivo[SI-1],23h                   ;compara la penultima posición de la dirección con #
        jne errorDir
        cmp pathArchivo[SI-2],23h                   ;compara la última posición de la dirección con #
        jne errorDir
        sub SI,04h
        mov CX,SI
        mov SI,00h
        loopValDir:
            mov AL,pathArchivo[SI+2]
            mov pathArchivo[SI],AL
            mov pathArchivoRep[SI],AL
            inc SI
        loop loopValDir
        mov pathArchivo[SI],00h
        mov pathArchivoRep[SI-1],70h
        mov pathArchivoRep[SI-2],65h
        mov pathArchivoRep[SI-3],72h
        jmp sinErLeerArch

    ;muestra el mensaje de error en la dirección
    errorDir:
        call limpPant
        imprimir erForInvDir
        call pausa 
        jmp menuPrin

    ;carga el archivo, muestra un mensaje 
    ;de error en caso contrario
    cargarArchivo:
        mov AL, 00h                                 ;modo de acceso para abrir archivo, modo lectura/escritura
        lea DX, pathArchivo                         ;offset lugar de memoria donde esta la variable
        mov AH, 3Dh                                 ;se intenta abrir el archivo
        int 21h                                     ;llamada a la interrupcion DOS
        jc  error                                   ;si se prendio la bandera c ir a error
        mov [handle], AX                            ;mover lo que le dio el SO
        
        mov BX,handle                               ;Asigna el handle (apuntador) del archivo a BX
        mov CX,1000                                 ;Lee 1000 caracteres del archivo de entrada 
        lea DX,datosArchivo                         ;Asigna el buffer, donde se guardaran los datos, a DX
        mov AH,3Fh                                  ;asigna la funcion leer archivo a AH
        int 21h                                     ;llama a la interrupcion

        mov BX, handle                              ;cargar el Handler del archivo
        mov AH,3Eh                                  ;funcion para cerrar el archivo
        int 21h                                     ;llamada a la interrupcion

        mov finArchivo,0
        mov hayError,0
        call validaArchivo                          ;Valida lexicamente el archivo
        cmp hayError,0                              ;compara la variable hayerror con 0
        ja  menuPrin                                ;si hay un error o más regresa al menú
        jmp menuOpe                                 ;si no salta a error, muestra el menu de operaciones

    ;Error al Abrir el archivo
    error:
        imprimir erAbrArch                          ;Muestra el mensaje de error al cargar el archivo  
        call pausa
        jmp menuPrin

    ;Valida el Archivo, que no tenga errores
    validaArchivo proc
        xor SI,SI                                   ;inicia el indice SI en 0    
        loopValidar:
            
            cmp datosArchivo[SI],20h                ;compara si es un espacio
            je  incSILoopValidar                    ;si es espacio sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],09h                ;compara si es una tabulacion
            je  incSILoopValidar                    ;si es tabulacion sigue con la siguiente iteracion 
            
            cmp datosArchivo[SI],0Dh                ;compara si es Retorno de carro
            je  incSILoopValidar                    ;si es retorno de carro sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],0Ah                ;compara si es Nueva linea
            je  incSILoopValidar                    ;si es nueva linea continua con el loop

            cmp datosArchivo[SI],2Bh                ;compara si es + 
            je incSILoopValidar                     ;si es + sigue con la siguiente iteracion

            cmp datosArchivo[SI],2Dh                ;compara si es -
            je incSILoopValidar                     ;si es - sigue con la siguiente iteracion

            cmp datosArchivo[SI],2Fh                ;compara si es /
            je incSILoopValidar                     ;si es / sigue con la siguiente iteracion

            cmp datosArchivo[SI],2Ah                ;compara si es *
            je incSILoopValidar                     ;si es * sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],00h                ;Salta si es NULL, sale y valida el fin de archivo
            je  salirValidar
            
            cmp finArchivo,00h                      ;Si no es fin de archivo y está levantada la bandera
            ja  errorFinArchivo                     ;salta a error que no finalizo el archivo despues de ;
                
            cmp datosArchivo[SI],3Bh                ;Salta si es punto y coma, y levanta la bandera
            je validarFinArchivo    
            
            cmp datosArchivo[SI],30h                ;Compara con 0
            jb  errorCaracter                       ;Si es menor de 0 es un caracter invalido

            cmp datosArchivo[SI],39h                ;compara con 9
            ja  errorCaracter                       ;Si es mayor de 9 es un caracter invalido
            
            incSILoopValidar:
                inc SI
        loop loopValidar
        salirValidar:
            call errorNoFinArch 
            call pausa
        ret
    endp

    ;Levanta la bandera de fin de archivo
    validarFinArchivo:
        inc finArchivo
        jmp incSILoopValidar

    ;error de Caracter invalido
    errorCaracter:
        imprimir erCarInv
        imprimirChar datosArchivo[SI]
        imprimir saltoLin
        inc hayError
        jmp incSILoopValidar
    ;Error no termino el archivo despues de ;
    errorFinArchivo:     
        imprimir erFinArch
        imprimirChar datosArchivo[SI]
        imprimir saltoLin
        inc hayError
        jmp incSILoopValidar
    ;Procedimineto Error No existe el fin de archivo
    errorNoFinArch proc
        cmp finArchivo,00h
        jne salirErNoFin
        imprimir erNoFinArch
        imprimir saltoLin
        inc hayError
        salirErNoFin:
            imprimir stringArchAna
    ret 

    ;Menu de operaciones
    menuOpe:
        call agregarMatriz
        call inFPosF
        call calcularResultado
        mosMenuOpe:    
            call limpPant                               
            imprimir stringMenOp
            call pausa                               
            cmp AL,31h                              ;compara si es la tecla 1
            je  imprimirRes                         ;si es la tecla 1, muestra el Resultado de las operaciones
            ;cmp AL,32h                              ;compara si es la tecla 2
            ;je  imprimirPreFija                     ;si es la tecla 2, muestra los numeros Impares
            cmp AL,33h                              ;compara si es la tecla 3
            je  imprimirPostFija                    ;si es la tecla 3, muestra la notación postfija
            cmp AL,34h                              ;compara si es la tecla 4
            je  menuPrin                            ;si es la tecla 4, regresa al menu principal
            jmp mosMenuOpe                          ;Si no es ninguna opcion, se mantiene en el menu de operaciones    

    agregarMatriz proc
        xor SI,SI
        loopAgreMatriz:
            cmp datosArchivo[SI],20h                ;compara si es un espacio
            je  incSILoopAgrMat                     ;si es espacio sigue con la siguiente iteracion

            cmp datosArchivo[SI],09h                ;compara si es una tabulacion
            je  incSILoopAgrMat                     ;si es tabulacion sigue con la siguiente iteracion

            cmp datosArchivo[SI],00h                ;Compara si es nulo el caracter Analizado
            je  salirAgreMatriz                     ;Si es nulo, es el fin de los datos y sale del loop

            cmp datosArchivo[SI],30h                ;Compara si es 0 en codigo ASCII
            jb  agregaListOpe                       ;lo agrega a la lista de operaciones 

            cmp datosArchivo[SI],3Bh                ;compara si es punto y coma
            je  salirAgreMatriz                     ;si es punto y coma, sale del loop

            cmp datosArchivo[SI],29h                ;compara si es 0 u otro digito en ASCII
            ja  concatNum                           ;si es un digito salta a concatenar
            incSILoopAgrMat:
                inc SI
        loop loopAgreMatriz
        salirAgreMatriz:
            nop
        ret
    endp

    ;Agregar a la Lista de operaciones el simbolo de operacion
    agregaListOpe:
        mov AX,iListOpe                             ;Asignar la fila de la casilla a buscar en la matriz
        mov BX,00h                                  ;Asignar la columna de casilla a buscar en la matriz
        mov DX,0006h                                ;Asignar el tamaño de las filas de la matriz                             
        call localizar                              ;Devuelve en BX la casilla buscada
        mov AL,datosArchivo[SI]
        mov listOpera[BX],AL
        inc iListOpe
        jmp incSILoopAgrMat
    ;concatenar los digitos de un Número
    concatNum:
        mov iDigNum,00h
        loopConcatNum:
            push SI                                 ;Guarda en la Pila la posición del caracter que se está leyendo
            mov AX,iListOpe                         ;Asignar la fila de la casilla a buscar en la matriz
            mov BX,iDigNum                          ;Asignar la columna de casilla a buscar en la matriz
            mov DX,0006h                            ;Asignar el tamaño de las filas de la matriz                             
            call localizar                          ;Devuelve en BX la casilla buscada
            mov AL,datosArchivo[SI]                 ;Guarda el caracter leido en el registro AL
            mov listOpera[BX],AL                    ;Guarda en la posición vacia del vector, el caracter leído
            inc iDigNum                             ;mueve el indice a la siguiente posición del vector
            pop SI                                  ;Devuelve el valor inicialde SI, posición del caracter leído
            inc SI                                  ;mueve al siguiente caracter leído
            cmp datosArchivo[SI],30h                ;compara si el caracter es 0 en ASCII
            jb  salirConcatNum                      ;Sale del ciclo si no es un numero
            cmp datosArchivo[SI],39h                ;compara si el caracter es 9 en ASCII
            ja  salirConcatNum                      ;Sale del ciclo si no es un numero
        loop loopConcatNum
        salirConcatNum:
            inc iListOpe
        jmp loopAgreMatriz

    ;imprime la respuesta del archivo de entrada
    imprimirRes:
        cmp resultado,064h
        jb  decenas
        
        decenas:
        cmp resultado,0Ah
        jb  unidades
        unidades:
        call pausa
        jmp mosMenuOpe

    ;imprimir la notación Postfija
        imprimir postFijo[0]
        imprimir saltoLin
        call pausa
        jmp mosMenuOpe

    ;convierte de notación infija a postfija
    ;creando un vector con la notación postfija
    inFPosF proc
        xor SI,SI
        mov iListOpe,00h
        mov topPila,00h                             ;Inicia el Tope de la pila en 0
        loopInFPosF:
            mov AX,iListOpe
            mov BX,00h
            mov DX,06h
            call localizar
            mov SI,BX
            cmp listOpera[SI],00h                   ;compara si se llegó al final del vector
            je salirInFPosF                         ;si es el final se sale del loop         
            cmp listOpera[SI],30h                   ;Compara si el caracter es 0 en ASCII
            jb  pushPilaOpe                         ;si es menor es un operador, va a la pila
            jmp  pushPost                           ;si es mayor es un operando, va al vector postfijo
            incSILoopInFPosF:
                inc iListOpe
        loop loopInFPosF
        salirInFPosF:
            cmp topPila,00h
            ja  vaciarPila
        ret
    endp

    ;mete a la pila el valor
    pushPilaOpe:
        mov prioTopCar,00h                          ;inicia la variable de prioridad del Caracter leído en 0
        mov prioTopPila,00h                         ;inicia la variable de prioridad del top de la pila en 0
        cmp topPila,00h                             ;compara si el contador de la pila es 0 
        je  metePila                                ;si es 0 (está vacia), hace un push del caracter leído en la pila
        pop AX                                      ;saca el caracter de la cima de la pila
        cmp AL,listOpera[SI]                        ;compara si la cima de la pila es igual que el caracter leído
        je  meterPosFijo                            ;si son iguales, mete la cima de la pila en el vector posfijo
        ;calcula la prioridad del
        ;operando en la cima de
        ;la pila
        cmp AL,2Bh                                  ;compara si la cima de la pila es el signo +
        je  prioCar                                 ;si es el signo +, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo +, aumenta la variable prioridad de la cima de la pila
        cmp AL,2Dh                                  ;compara si la cima de la pila es el signo -
        je  prioCar                                 ;si es el signo -, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo -, aumenta la variable prioridad de la cima de la pila
        cmp AL,2Ah                                  ;compara si la cima de la pila es el signo *
        je  prioCar                                 ;si es el signo *, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo *, aumenta la variable prioridad de la cima de la pila
        ;calcula la prioridad del
        ;operando leido 
        prioCar:
            cmp listOpera[SI],2Bh                   ;compara si el operando leído es el signo +                  
            je  ComparaPrioridades                  ;si es el signo +, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo +, aumenta la variable prioridad del operando leido
            cmp listOpera[SI],2Dh                   ;compara si el operando leído es el signo -
            je  ComparaPrioridades                  ;si es el signo -, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo -, aumenta la variable prioridad del operando leido
            cmp listOpera[SI],2Ah                   ;compara si el operando leído es el signo *
            je  ComparaPrioridades                  ;si es el signo *, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo *, aumenta la variable prioridad del operando leido
        ComparaPrioridades:
            mov DL,prioTopPila
            cmp prioTopCar,DL                       ;compara las prioridades de los dos operandos, leído y de pila
            ja  meteAmbos                           ;si la prioridad del leído es mayor que el de la pila, mete ambos
        meterPosFijo:
            mov DI,iPosFijo                         ;Inicia DI con el indice del vector postFijo
            mov postFijo[DI],AL                     ;mete la cima de la pila en el vector postFijo
            inc iPosFijo                            ;incrementa el indice del vector
            ;llena el resto de espacios
            ;de la Casilla con 0      
            mov CX,05h  
            loopMeterPosFijo:
                mov DI,iPosFijo
                mov postFijo[DI],00h
                inc iPosFijo
            loop loopMeterPosFijo
            dec topPila                             ;decrementa el contador de la pila 
            jmp pushPilaOpe                         ;regresa a comparar el resto de la pila con el operador leído
        meteAmbos:
            mov AH,00h
            push AX                                 ;mete nuevamente la cima de la pila a la pila
        metePila:
            mov DH,00h
            mov DL,listOpera[SI]
            push DX                                 ;mete a pila el operando leído
            inc topPila                             ;incrementa el top de la pila
        jmp incSILoopInFPosF                        ;regresa a leer el resto de la cadena

    ;mete en el vector postFijo
    ;todo el operando leído
    pushPost:
        xor DI,DI                                   ;inicia DI en 0
        mov CX,06h                                  ;fija en 6 la cantidad de veces que se ejecuta el ciclo
        loopPushPos:
            mov DI,iPosFijo                         ;inicia DI con el valor del indice del vector postfija
            mov AL,listOpera[SI]                    ;guarda en AL el operando Leído
            mov postFijo[DI],AL                     ;guarda en el vector el contenido de AL
            inc SI                                  ;incrementa SI, para leer el siguiente operador
            inc iPosFijo                            ;incrementa el indice del vector postFijo
        loop loopPushPos
        jmp incSILoopInFPosF                        ;regresa a leer el siguiente operador

    ;vacia la pila, metiendo su contenido
    ;en el vector
    vaciarPila:
        loopVaciarPila:
            cmp topPila,00h                         ;compara si el top de la pila es 0
            je  salirInFPosF                        ;si es 0, la pila ya está vacía y sale
            pop AX                                  ;saca de la pila y lo guarda en AX
            mov DI,iPosFijo                         ;Inicia DI con el indice del vector postFijo
            mov postFijo[DI],AL                     ;mete la cima de la pila en el vector postFijo
            inc iPosFijo                            ;incrementa el indice del vector postFijo
            mov CX,05h                              ;inicia el contador del loop en 5
            ;llena las otras posiciones
            ;con 0 o nulo
            loopVaciarPushPost:
                mov DI,iPosFijo                     ;Indice del vector postfijo en DI
                mov postFijo[DI],00h                ;guarda en la posicion DI, 0 o nulo
                inc iPosFijo                        ;incrmenta el indice del vector
            loop loopVaciarPushPost
            dec topPila                             ;decrementa el top de la pila
        loop loopVaciarPila


    ;calcula el resultado basado en
    ;la notación postfija
    calcularResultado proc
        mov iPosFijo,00h
        mov topPila,00h
        loopCalcRes:
            mov AX,iPosFijo
            mov BX,00h
            mov DX,06h
            call localizar
            cmp postFijo[BX],24h
            je  salirCalcRes
            cmp postFijo[BX],30h
            jb  hacerOperacion
            call concatNumAux
            call aEntero
            push BX
            inc topPila
            incILoopCalcRes:
                inc iPosFijo
        loop loopCalcRes
        salirCalcRes:
            pop resultado
            
        ret
    endp

    ;Realiza la operacion
    ;basado en el operador leído
    ;sacando los dos ultimos operandos
    ;almacenados en la pila
    hacerOperacion:
        cmp topPila,02h
        jb  salirCalcRes
        pop Opera2
        dec topPila
        pop Opera1
        dec topPila
        mov DL,postFijo[BX]
        mov operador,DL
        call operar
        push AX
        inc topPila
        jmp incILoopCalcRes

    operar proc
        cmp operador,2Bh                            ;+
        je  hacerSuma
        cmp operador,2Dh                            ;-
        je  hacerResta
        cmp operador,2Ah                            ;*
        je  hacerMulti
        cmp operador,2Fh                            ;/
        je  hacerDivi
        salirOperar:
            mov resultado,AX
        ret
    endp

    hacerSuma:
        mov AX,Opera1
        add AX,Opera2
        jmp salirOperar

    hacerResta:
        mov AX,Opera1
        sub AX,Opera2
        jmp salirOperar

    hacerMulti:
        mov AX,Opera1
        imul Opera2
        jmp salirOperar

    hacerDivi:
        xor DX,DX
        mov AX,Opera1
        idiv Opera2
        jmp salirOperar

    ;concatenar un numero en la
    ;Variable Numero Auxiliar
    concatNumAux proc
        call limpNumAux
        mov SI,BX
        mov iAux,00h
        mov CX,06h
        loopConNumAux:
            mov AL,postFijo[SI]
            cmp AL,00h
            je  salirConNumAux
            mov DI,iAux
            mov NumAux[DI],AL
            inc SI
            inc iAux
        loop loopConNumAux
        salirConNumAux:
            nop
        ret
    endp

    ;Procedimineto para pasar a Entero un String
    aEntero proc
        mov CX,iAux
        mov DI,iAux
        dec DI
        mov SI,00h 
        mov BX,00h
        loopEntero:  
            mov AH,00h
            mov AL,NumAux[DI]
            sub AL,30h 
            mul listaPond[SI]
            add BX,AX
            inc SI
            inc SI
            dec DI
        loop loopEntero 
        ret
    endp
;Etiqueta Principal 
start:
    ; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    jmp menuPrin
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
