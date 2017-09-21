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

    ;++++++++++++++++++++++++++++++++++++++++ String Modo Calculadora +++++++++++++++++++++++++++++++++++++++++
    strEncModCal        db "--------------------------------MODO CALCULADORA-------------------------------",0Dh,0Ah,"$"
    strModCalcNum       db "Ingrese un n",0A3h,"mero: ","$"
    strModCalcOpe       db "Ingrese el Operador: ","$"
    strModCalcRes       db "Resultado: ","$"
    strModCalcSal       db 0A8h,"Desea salir del modo Calculadora?",0Dh,0Ah
                        db "1- S",0A1h,0Dh,0Ah
                        db "2- No",0Dh,0Ah,"$"
    strANS              db " ANS ","$"


    ;++++++++++++++++++++++++++++++++++++++++ String Modo Calculadora +++++++++++++++++++++++++++++++++++++++++
    strEncFactor        db "-----------------------------------FACTORIAL-----------------------------------",0Dh,0Ah
                        db "--> Rango Aceptado entre 00 y 08 <--",0Dh,0Ah,"$"
    strFactOpera        db "! =","$"

    ;++++++++++++++++++++++++++++++++++++++++ String Reporte +++++++++++++++++++++++++++++++++++++++++
    strNoRep            db "REPORTE PRACTICA NO. 2",0Dh,0Ah,"$"
    strRepEnt           db "Entrada: ","$"
    strRepRes           db "Resultado: ","$"
    strRepPF            db "Notaci",0A2h,"n Postfija: ","$"
    strRepPreF          db "Notaci",0A2h,"n Prefija: ","$"
    strRepFac           db "Factorial: ","$"
    strRepHor           db "Hora: ","$"
    strRepFec           db "Fecha: ","$"
    strRepDP            db " : "
    strRepD             db " / "
    strRepCre           db "Reporte Creado con Exito",0Dh,0Ah,"$"
    ;++++++++++++++++++++++++++++++++++++++++ Mensajes de Error +++++++++++++++++++++++++++++++++++++++++++++++
    ;mensaje de error, formato de la direccion invalido
    erForInvDir         db "El formato de la direccion no es correcta",0Dh,0Ah
                        db "El formato correcto es ##<Direccion>##","$"
    ;mensaje de error al crear el archivo            
    erCreArch           db "No se pudo crear el archivo de Reporte","$"
    ;mensaje de error al abrir el archivo
    erAbrArch           db "El archivo buscado no se encuentra...","$"
    ;mensaje de error, Caracter Invalido
    erCarInv            db "Caracter Invalido: ","$"
    ;mensaje de error, Número Invalido
    erNumInv            db "Error Caracter Invalido en el Número: ","$"
    ;mensaje de error, se esperaba fin de archivo 
    erFinArch           db "Se esperaba fin de archivo despues de punto y coma: ","$"
    ;mensaje de error al ingresar el número modo Calculadora
    erMCNum             db "Error: se esperaba un n",0A3h,"mero","$"
    ;mensaje de error, no se encontro el fin de archivo ;
    erNoFinArch         db "Se esperaba fin de archivo ;","$"

    ;mensaje de error, el número no está dentro del Rango
    erRangFact          db "El número no está dentro del rango","$"

    ;+++++++++++++++++++++++++++++++++++++++++++++ Variables ++++++++++++++++++++++++++++++++++++++++++++++++++
    ;------- Variables Indice --------
    ;Indice para el Tamaño leído del archivo
    iDatosArch          dw 0
    ;Indice Actual lista OPERACIONES
    iListOpe            dw 0
    ;Indice digito Actual del Numero concatenado
    iDigNum             dw 0
    ;Indice del vector postFijo
    iPosFijo            dw 0
    ;Indice del vector preFijo
    iPreFijo            dw 0
    ;Indice Auxiliar
    iAux                dw 0
    ;Indice Factorial
    iFactorial          dw 0
    ;numero negativos
    numOpNeg            db 0
    ;Signo Operador 1
    sigOpe1             db 0
    ;contador Factorial
    contFact            db 0
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
    ;Direccion del archivo
    pathArchivo         db 50 dup(0)
    ;Dirección del archivo de reporte
    pathArchivoRep      db 50 dup(0)
    ;datos del archivo
    datosArchivo        db 500 dup(0)
    ;identificador del arhivo de entrada
    handle              dw ?
    ;identificador del archivo de reporte 
    handleRep           dw ?
    ;Lista de ponderaciones para pasar string a int
    listaPond           dw 0x0001,0x000A,0x0064,0x03E8,0x2710
    ;Lista de operaciones
    listOpera           db 300 dup(0)
    ;Arreglo Postfijo
    postFijo            db 300 dup('$')
    ;arreglo PreFijo
    preFijo             db 150 dup('$')
    ;Cadena para Imprimir Postfijo
    RepPostFijo         db 300 dup('$')
    ;cadena para imprimir preFijo
    RepPreFijo          db 150 dup('$')
    ;cadena para imprimir Factorial
    RepFactorial        db 150 dup('$')
    ;Var Tope de Pila
    topPila             db 0
    ;Memoria ANS modo Calculadora
    ANS                 dw 0
    ;Numero Auxiliar
    NumAux              db 7 dup('$')
    ;Total
    numTotal            db 7 dup(0)
    ;largo del resultado
    larNumTotal         dw 0
    ;largo postFijo
    larPostFijo         dw 0
    ;largo Prefijo
    larPreFijo          dw 0
    ;-------- Variables bandera ----------
    ;hubo error
    hayError            db 0
    ;ya se ingresó el fin de archivo
    finArchivo          db 0
    ;Bandera signo
    flagSig             db 0
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

    limpVar proc
        mov CX,500
        xor SI,SI
        loopLimpVar:
            cmp SI,12Bh
            ja  Qui
            cmp SI,95h
            ja  Tres
            cmp SI,31h
            ja  CCinc
            cmp SI,06h
            ja  Cinc
            mov NumAux[SI],24h
            mov numTotal[SI],00h
            Cinc:
            mov pathArchivo[SI],00h
            mov pathArchivoRep[SI],00h
            CCinc:
            mov preFijo[SI],24h
            mov RepPreFijo[SI],24h
            mov RepFactorial[SI],24h
            Tres:
            mov postFijo[SI],24h
            mov RepPostFijo[SI],24h
            mov listOpera[SI],00h
            Qui:
            mov datosArchivo[SI],00h
            inc SI
        loop loopLimpVar
        ret
    endp
    ;limpia la variable numero Auxiliar
    limpNumAux proc
        mov CX,07h
        mov iAux,00h
        loopLimpNumAux:
            mov SI,iAux
            mov NumAux[SI],24h
            inc iAux
        loop loopLimpNumAux
        ret
    endp

    llenaTotal proc
        mov CX,07h
        mov iAux,00h
        mov larNumTotal,00h
        loopLlenaNumTot:
            mov SI,iAux
            mov BL,NumAux[SI]
            mov numTotal[SI],BL
            cmp BL,24h
            je  salirLlenaTot
            inc larNumTotal
            salirLlenaTot:
            inc iAux
        loop loopLlenaNumTot
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
        cmp AL,32h                                  ;compara si es la opción dos
        je  modoCalc                                ;si es, salta al modo calculadora
        cmp AL,33h                                  ;compara si es la opción tres
        je  factorial                               ;si es, salta al modo factorial
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  reporte                                 ;si es, salta a generar el reporte            
        cmp AL,35h                                  ;compara si es la opción cinco
        je  salirApp                                ;si es la opción 5 salta a la salida de la aplicación
        jmp menuPrin                                ;Si no es ninguna opcion, se mantiene en el menu




    ;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Lectura de Archivo ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

    ;muestra en pantalla la opción Leer Archivo
    leerArchivo:
        call limpVar
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
            mov AL,pathArchivo[SI+2]                ;corre dos posiciones el 3er caracter de la dirección
            mov pathArchivo[SI],AL                  
            mov pathArchivoRep[SI],AL
            inc SI
        loop loopValDir
        mov pathArchivo[SI],00h                     ;agrega nulo al final del path del archivo de entrada
        mov pathArchivoRep[SI-1],70h                ;cambia la extensión del nombre del archivo R
        mov pathArchivoRep[SI-2],65h                ;cambia la extensión del nombre del archivo E
        mov pathArchivoRep[SI-3],72h                ;cambia la extensión del nombre del archivo P
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
        mov iDatosArch,00h
        loopValidar:
            
            cmp datosArchivo[SI],20h                ;compara si es un espacio
            je  incSILoopValidar                    ;si es espacio sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],09h                ;compara si es una tabulacion
            je  incSILoopValidar                    ;si es tabulacion sigue con la siguiente iteracion 
            
            cmp datosArchivo[SI],0Dh                ;compara si es Retorno de carro
            je  incSILoopValidar                    ;si es retorno de carro sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],0Ah                ;compara si es Nueva linea
            je  incSILoopValidar                    ;si es nueva linea continua con el loop
            inc iDatosArch
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
            dec iDatosArch
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
        mov iDatosArch,00h
        mov iListOpe,00h
        mov iPosFijo,00h
        mov iAux,00h

        mov numOpNeg,00h
        call agregarMatriz
        call inFPosF
        call calcularResultado
        dec iListOpe
        call inFPreF
        mosMenuOpe:    
            call limpPant                               
            imprimir stringMenOp
            call pausa                               
            cmp AL,31h                              ;compara si es la tecla 1
            je  imprimirRes                         ;si es la tecla 1, muestra el Resultado de las operaciones
            cmp AL,32h                              ;compara si es la tecla 2
            je  imprimirPreFija                     ;si es la tecla 2, muestra la notación prefija
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
            mov iDatosArch,SI
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
        call aString                                ;convierte el resultado a String
        imprimir NumAux                             ;imprime el resultado
        call llenaTotal
        call pausa                                  ;hace una pausa
        jmp mosMenuOpe                              ;regresa al menú operaciones

    ;convierte el resultado a una variable
    ;tipo String
    aString proc
        mov AX,resultado                            ;inicia AX con el resultado
        mov DX,resultado                            ;inicia DX con el resultado
        xor SI,SI                                   ;inicia SI en 0
        cmp flagSig,00h                             ;compara si la variable bandera signo es 0
        je  resPositivo                             ;si es 0 la respuesta es positiva, salta
        mov AL,2Dh                                  ;Guarda en AL el signo -
        mov NumAux[SI],AL                           ;Guarda el signo - en el numero Auxiliar
        inc SI                                      ;incrementa SI
        mov AX,resultado                            ;Guarda el resultado en AX
        neg AX                                      ;Aplica complemento A2 al resultado
        neg DX                                      ;Aplica complemento A2 al resultado
        resPositivo:
            cmp resultado,2710h                     ;compara si el resultado con 10,000
            jb  uMiles                              ;si es menor salta a las Unidades de Mil
            xor DX,DX                               ;si no, inicia DX en 0
            mov BX,2710h                            ;Guarda 10,000 en BX
            idiv BX                                 ;divide el resultado entre 10,000
            add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
            mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
            inc SI                                  ;incrementa SI
            mov AX,DX                               ;mueve el residuo a AX
        uMiles:
            cmp resultado,3E8h                      ;compara si el resultado con 1,000
            jb  centenas                            ;si es menor salta a las centenas
            xor DX,DX                               ;si no, inicia DX en 0
            mov BX,3E8h                             ;Guarda 1,000 en BX
            idiv BX                                 ;divide el resultado entre 1,000
            add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
            mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
            inc SI                                  ;incrementa SI
            mov AX,DX                               ;mueve el residuo a AX
        centenas:
            cmp resultado,064h                      ;compara si el resultado con 1,000
            jb  decenas                             ;si es menor salta a las centenas
            xor DX,DX                               ;si no, inicia DX en 0
            mov BX,64h                              ;Guarda 1,000 en BX
            idiv BX                                 ;divide el resultado entre 1,000
            add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
            mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
            inc SI                                  ;incrementa SI
            mov AX,DX
        decenas:
            cmp resultado,0Ah                       ;compara si el resultado con 1,000
            jb  unidades                            ;si es menor salta a las centenas
            xor DX,DX                               ;si no, inicia DX en 0
            mov BX,0Ah                              ;Guarda 1,000 en BX
            idiv BX                                 ;divide el resultado entre 1,000
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

    ;imprimir la notación Postfija
    imprimirPostFija:
        mov CX,300
        xor SI,SI
        mov larPostFijo,00h
        mov iAux,00h
        loopImpPostFija:
            cmp postFijo[SI],00h
            je  agregaEspa
            cmp postFijo[SI],24h
            je  salirloopImpPostF
            mov iAux,00h
            mov AL,postFijo[SI]
            mov DI,larPostFijo
            mov RepPostFijo[DI],AL
            inc larPostFijo
            jmp IncSILoopImpPost
            agregaEspa:
                cmp iAux,00h
                jne IncSILoopImpPost
                mov DI,larPostFijo
                mov RepPostFijo[DI],20h
                inc larPostFijo
                inc iAux
            IncSILoopImpPost:
                inc SI
        loop loopImpPostFija
        salirloopImpPostF:
        inc larPostFijo
        mov SI,larPostFijo
        dec larPostFijo
        mov RepPostFijo[SI],24h
        imprimir RepPostFijo                        ;imprime el vector con la notación postFijo
        imprimir saltoLin                           ;Imprime un salto de linea 
        call pausa                                  ;hace una pausa
        jmp mosMenuOpe                              ;regresa al menu de operaciones

    ;convierte de notación infija a postfija
    ;creando un vector con la notación postfija
    inFPosF proc
        xor SI,SI
        mov iListOpe,00h
        mov topPila,00h                             ;Inicia el Tope de la pila en 0
        loopInFPosF:
            mov AX,iListOpe                         ;guarda la posición i en AX
            mov BX,00h                              ;guarda la posición j en AX
            mov DX,06h                              ;guarda el tamaño de la fila
            call localizar                          ;Devuelve la posición lineal de la matriz
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
            cmp topPila,00h                         ;compara si la pila tiene elementos
            ja  vaciarPila                          ;si aún hay elementos en la pila los saca
        ret
    endp

    ;mete a la pila el operando
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

    ;********************************************* infijo a preFijo **************************************************
    ;convierte de notación infija a prefija
    ;creando un vector con la notación prefija
    inFPreF proc
        xor SI,SI
        mov topPila,00h                             ;Inicia el Tope de la pila en 0
        loopInFPreF:
            mov AX,iListOpe                         ;guarda la posición i en AX
            mov BX,00h                              ;guarda la posición j en AX
            mov DX,06h                              ;guarda el tamaño de la fila
            call localizar                          ;Devuelve la posición lineal de la matriz
            mov SI,BX            
            js salirInFPreF                         ;si es el final se sale del loop         
            cmp listOpera[SI],30h                   ;Compara si el caracter es 0 en ASCII
            jb  pushPilaOpePre                      ;si es menor es un operador, va a la pila
            jmp  pushPre                            ;si es mayor es un operando, va al vector postfijo
            incSILoopInFPreF:
                dec iListOpe 

        loop loopInFPreF
        salirInFPreF:
            cmp topPila,00h                         ;compara si la pila tiene elementos
            ja  vaciarPilaPre                       ;si aún hay elementos en la pila los saca
        ret
    endp

    ;mete a la pila el operando
    pushPilaOpePre:
        mov prioTopCar,00h                          ;inicia la variable de prioridad del Caracter leído en 0
        mov prioTopPila,00h                         ;inicia la variable de prioridad del top de la pila en 0
        cmp topPila,00h                             ;compara si el contador de la pila es 0 
        je  metePilaPre                             ;si es 0 (está vacia), hace un push del caracter leído en la pila
        pop AX                                      ;saca el caracter de la cima de la pila
        cmp AL,listOpera[SI]                        ;compara si la cima de la pila es igual que el caracter leído
        je  meterPreFijo                            ;si son iguales, mete la cima de la pila en el vector prefijo
        ;calcula la prioridad del
        ;operando en la cima de
        ;la pila
        cmp AL,2Bh                                  ;compara si la cima de la pila es el signo +
        je  prioCarPre                              ;si es el signo +, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo +, aumenta la variable prioridad de la cima de la pila
        cmp AL,2Dh                                  ;compara si la cima de la pila es el signo -
        je  prioCarPre                              ;si es el signo -, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo -, aumenta la variable prioridad de la cima de la pila
        cmp AL,2Ah                                  ;compara si la cima de la pila es el signo *
        je  prioCarPre                              ;si es el signo *, salta a calcular la prioridad del caracter leído
        inc prioTopPila                             ;si no es el signo *, aumenta la variable prioridad de la cima de la pila
        ;calcula la prioridad del
        ;operando leido 
        prioCarPre:
            cmp listOpera[SI],2Bh                   ;compara si el operando leído es el signo +                  
            je  ComparaPrioridadesPre                  ;si es el signo +, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo +, aumenta la variable prioridad del operando leido
            cmp listOpera[SI],2Dh                   ;compara si el operando leído es el signo -
            je  ComparaPrioridadesPre                  ;si es el signo -, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo -, aumenta la variable prioridad del operando leido
            cmp listOpera[SI],2Ah                   ;compara si el operando leído es el signo *
            je  ComparaPrioridadesPre                  ;si es el signo *, salta a comparar prioridades
            inc prioTopCar                          ;si no es el signo *, aumenta la variable prioridad del operando leido
        ComparaPrioridadesPre:
            mov DL,prioTopPila
            cmp prioTopCar,DL                       ;compara las prioridades de los dos operandos, leído y de pila
            ja  meteAmbosPre                           ;si la prioridad del leído es mayor que el de la pila, mete ambos
        meterPreFijo:
            mov DI,iPreFijo                         ;Inicia DI con el indice del vector preFijo
            mov preFijo[DI],AL                      ;mete la cima de la pila en el vector preFijo
            inc iPreFijo                            ;incrementa el indice del vector
            dec topPila                             ;decrementa el contador de la pila 
            jmp pushPilaOpePre                      ;regresa a comparar el resto de la pila con el operador leído
        meteAmbosPre:
            mov AH,00h
            push AX                                 ;mete nuevamente la cima de la pila a la pila
        metePilaPre:
            mov DH,00h
            mov DL,listOpera[SI]
            push DX                                 ;mete a pila el operando leído
            inc topPila                             ;incrementa el top de la pila
        jmp incSILoopInFPreF                        ;regresa a leer el resto de la cadena

    ;mete en el vector postFijo
    ;todo el operando leído
    pushPre:
        xor DI,DI                                   ;inicia DI en 0
        add SI,05h
        mov CX,06h
        loopPushPre:
            mov DI,iPreFijo                         ;inicia DI con el valor del indice del vector postfija
            mov AL,listOpera[SI]                    ;guarda en AL el operando Leído
            cmp AL,00h
            je  decLoopPushPre
            mov preFijo[DI],AL                      ;guarda en el vector el contenido de AL
            inc iPreFijo                            ;incrementa el indice del vector postFijo
            decLoopPushPre:
            dec SI                                  ;incrementa SI, para leer el siguiente operador
        loop loopPushPre
        salirPushPre:
            mov DI,iPreFijo                         ;inicia DI con el valor del indice del vector postfija
            mov preFijo[DI],20h                     ;guarda en el vector el contenido de AL
            inc iPreFijo
        jmp incSILoopInFPreF                        ;regresa a leer el siguiente operador

    ;vacia la pila, metiendo su contenido
    ;en el vector
    vaciarPilaPre:
        loopVaciarPilaPre:
            cmp topPila,00h                         ;compara si el top de la pila es 0
            je  salirInFPreF                        ;si es 0, la pila ya está vacía y sale
            pop AX                                  ;saca de la pila y lo guarda en AX
            mov DI,iPreFijo                         ;Inicia DI con el indice del vector postFijo
            mov preFijo[DI],AL                      ;mete la cima de la pila en el vector postFijo
            inc iPreFijo                            ;incrementa el indice del vector postFijo
            mov DI,iPreFijo                         ;Inicia DI con el indice del vector postFijo
            mov preFijo[DI],20h                     ;mete la cima de la pila en el vector postFijo
            inc iPreFijo
            dec topPila                             ;decrementa el top de la pila
        loop loopVaciarPilaPre


    imprimirPreFija:
        mov CX, iPreFijo
        xor SI,SI
        mov larPreFijo,00h
        dec iPreFijo
        loopImpPreFijo:
            mov DI,iPreFijo
            mov SI,larPreFijo
            imprimirChar preFijo[DI]
            mov AL,preFijo[DI]
            mov RepPreFijo[SI],AL
            dec iPreFijo
            inc larPreFijo
        loop loopImpPreFijo
        call pausa
    jmp mosMenuOpe
    ;*************************************************************************************************************************

    ;calcula el resultado basado en
    ;la notación postfija
    calcularResultado proc
        mov iPosFijo,00h                            ;inicia el indice del vector postfijo en 0
        mov topPila,00h                             ;inicia el top de la pila en 0
        loopCalcRes:
            mov AX,iPosFijo                         ;guarda en AX, la poscición i de la matriz
            mov BX,00h                              ;guarda en BX, la poscición j de la matriz
            mov DX,06h                              ;Guarda en DX, el tamaño de las filas de la matriz
            call localizar                          ;Calcula la posición lineal de la matriz
            cmp postFijo[BX],24h                    ;verifica sí es fin de cadena
            je  salirCalcRes                        ;si es fin de cadena, sale del loop
            cmp postFijo[BX],30h                    ;compara si es 0 en ASCII
            jb  hacerOperacion                      ;si es menor a 0, salta a realizar una operacion
            call concatNumAux                       ;si no es menor a 0, concatena el numero
            call aEntero                            ;convierte el numero concatenado en Entero
            push BX                                 ;mete en la pila el número
            inc topPila                             ;incrementa el top de la pila
            incILoopCalcRes:
                inc iPosFijo                        ;incrementa el indice a la siguiente posición a leer
        loop loopCalcRes
        salirCalcRes:
            pop resultado                           ;saca el último resultado de la pila
            
        ret
    endp

    ;Realiza la operacion
    ;basado en el operador leído
    ;sacando los dos ultimos operandos
    ;almacenados en la pila
    hacerOperacion:
        cmp topPila,02h                             ;compara si el top de la pila tiene 2
        jb  salirCalcRes                            ;si tiene menos de 2 no hace la operacion
        pop Opera2                                  ;saca el 2do operando de la pila
        dec topPila                                 ;decrementa el top de la pila
        pop Opera1                                  ;saca el 1er opearando de la pila
        dec topPila                                 ;decrementa el top de la pila 
        mov DL,postFijo[BX]                         ;guarda el operador en DL
        mov operador,DL                             ;guarda en la variable operador DL
        call operar                                 ;realiza la operación
        push AX                                     ;mete el resultado en la pila
        inc topPila                                 ;incrementa el top de la pila
        jmp incILoopCalcRes                         ;regresa a leer el siguiente operando u operador
    
    ;selecciona la operación a realizar
    ;basado en lo contenido en la 
    ;variable operador
    operar proc
        cmp operador,2Bh                            ;compara si el operador es +
        je  hacerSuma                               ;si es igual, salta y hace la suma
        cmp operador,2Dh                            ;compra si el operador es -
        je  hacerResta                              ;si es igual, salta y hace la resta
        cmp operador,2Ah                            ;compara si el operador es *
        je  hacerMulti                              ;si es igual, salta y hace la multiplicación
        cmp operador,2Fh                            ;compara si el operador es /
        je  hacerDivi                               ;si es igual, salta y hace la divición
        salirOperar:
            mov resultado,AX                        ;guarda el resultado en AX
        ret
    endp
    ;realiza una suma entre las
    ;variables Opera
    hacerSuma:
        mov AX,Opera1                               ;guarda el valor del primer operando en AX
        add AX,Opera2                               ;suma a AX el segundo operando
        mov flagSig,00h                             ;inicia la variable bandera Signo, en 0
        jns salirOperar                             ;si la bandera signo no está levantada sale
        call esNegativo                             ;si la bandera signo está levantada, flagSig vale 1
        jmp salirOperar                             ;regresa

    ;realiza una resta entre las
    ;variables Opera
    hacerResta:
        mov AX,Opera1                               ;guarda el valor del primer operando en AX
        sub AX,Opera2                               ;resta a AX, el segundo operando
        mov flagSig,00h                             ;inicia la variable bandera Signo, en 0
        jns salirOperar                             ;si la bandera signo no está levantada sale
        call esNegativo                             ;si la bandera signo está levantada, flagSig vale 1
        jmp salirOperar                             ;regresa

    ;realiza una multiplicación entre las
    ;variables Opera
    hacerMulti:
        mov AX,Opera1                               ;guarda el valor del primer operando en AX
        imul Opera2                                 ;realiza una mumltipliación entre los operandos
        mov flagSig,00h                             ;inicia la variable bandera Signo, en 0
        cmp numOpNeg,01h                            ;Compara la var de operandos negativos con 1
        jne salirOperar                             ;si no es igual a 1, se sale
        call esNegativo                             ;si es igual a 1, levanta variable bandera de signo
        jmp salirOperar                             ;regresa

    ;realiza una divición entre las
    ;variables Opera
    hacerDivi:
        xor DX,DX                                   ;inicia el registro en 0
        cmp numOpNeg,01h                            ;Compara la var de operandos negativos con 1
        jne diviPositiva                            ;si no es igual la divición es positiva
        cmp sigOpe1,00h
        je  diviPositiva
        mov DX,0xFFFF                               ;si es igual a 1, la división es negativa, inicia
                                                    ;la word alta en FFFFF
        diviPositiva:
        mov AX,Opera1                               ;guarda el primer operando en AX
        idiv Opera2                                 ;realiza la división con signo, de los operandos
        mov flagSig,00h                             ;inicia la variable bandera signo, en 0
        cmp numOpNeg,01h                            ;Compara la var de operandos negativos con 1
        jne salirOperar                             ;si no es igual a 1, se sale
        call esNegativo                             ;si es igual a 1, levanta variable bandera de signo
        jmp salirOperar                             ;regresa

    ;levanta la variable bandera
    ;de signo a 1
    esNegativo proc
        mov flagSig,01h
        ret
    endp
    ;concatenar un numero en la
    ;Variable Numero Auxiliar
    concatNumAux proc
        call limpNumAux                             ;limpia la variable Numero Auxiliar
        mov SI,BX                                   ;guarda el indice, BX, del caracter leído, en SI
        mov iAux,00h                                ;inicia el indice auxiliar en 0
        mov CX,06h                                  ;fija el loop en 6
        loopConNumAux:
            mov AL,postFijo[SI]                     ;guarda el digito leído en AL
            cmp AL,00h                              ;compara si es nulo el caracter leído
            je  salirConNumAux                      ;si es nulo sale del metodo concatenar
            mov DI,iAux                             ;si no, guarda el indice en DI
            mov NumAux[DI],AL                       ;guarda el digito leído en la variable numero auxiliar
            inc SI                                  ;mueve el indice a la siguiente posición
            inc iAux                                ;incrementa el indice auxiliar
        loop loopConNumAux
        salirConNumAux:
            nop
        ret
    endp

    ;Procedimineto para pasar a Entero un String
    aEntero proc
        mov CX,iAux                                 ;establece el loop al tamaño del numero numAux
        mov DI,iAux                                 ;inicia el indice DI, en el tamaño del numero
        dec DI                                      ;decrementa DI
        xor SI,SI                                   ;Inicia SI en 0
        xor BX,BX                                   ;inicia BX en 0
        loopEntero:  
            mov AH,00h                              ;inicia AH en 0
            mov AL,NumAux[DI]                       ;guarda en AL un digito del numero
            sub AL,30h                              ;resta 30 al digito en ASCII
            mul listaPond[SI]                       ;multiplica el digito por una ponderación Unidad, decena, centena..
            add BX,AX                               ;acumula los valores en BX
            inc SI                                  ;incrementa SI se mueve un byte
            inc SI                                  ;incrementa SI nuevamente, se mueve un byte más. Total un word
            dec DI                                  ;decrementa DI
        loop loopEntero 
        ret
    endp

    ;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Modo Calculadora ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ;muestra el modo Calculadora
    modoCalc:
        mov sigOpe1,00h
        mov numOpNeg,00h                            ;inicia el contador de operadores negativos
        xor SI,SI                                   ;inicia SI en 0
        mov iAux,00h                                ;inicia el indice auxiliar en 0
        mov flagSig,00h                             ;inicia la variable bandera signo en 0
        call limpPant                               ;limpia la pantalla
        imprimir strEncModCal                       ;muestra el encabezado del modo calculadora
        call ingresoNum                             ;ingresa un numero y lo guarda en BX
        mov Opera1,BX                               ;guarda el numero en Opera1
        cmp numOpNeg,00h
        je  opePos
        mov sigOpe1,01h
        opePos:
        xor SI,SI                                   ;reinicia SI
        mov iAux,00h                                ;reinicia el indice auxiliar
        mov flagSig,00h                             ;reinicia la variable bandera de signo
        imprimir saltoLin                           ;imprime un salto de línea
        imprimir strModCalcOpe                      ;imprime la solicitud de operador
        xor AX,AX                                   ;limpia el registro AX
        mov AH,01h                                  ;Asigna la funcion para leer un caracter de teclado
        int 21h                                     ;llama a la interrupcion
        mov operador,AL                             ;Guarda el operador Leído
        imprimir saltoLin                           ;imprimie un salto de linea
        call ingresoNum                             ;ingresa un número y lo guarda en BX
        mov Opera2,BX                               ;guarda el numero en Opera2
        imprimir saltoLin                           ;imprime un salto de linea
        call operar                                 ;realiza la operación
        mov DX,resultado
        mov ANS,DX
        call aString                                ;convierte el resultado a String
        imprimir strModCalcRes                      ;imprime el resultado
        imprimir NumAux                             ;imprime el resultado
        imprimir saltoLin                           ;imprime un salto de linea
        imprimir strModCalcSal                      ;imprime la pregunta de salir
        call pausa                                  ;espera un caracter, la opación elegida
        cmp AL,32h                                  ;compara si es la opción 2
        je  modoCalc                                ;si es la opción 2 muestra nuevamente esta etiqueta
    jmp menuPrin                                    ;si no regresa al menú principal

    ;solicita y guarda un número
    ingresoNum proc
        inicioInNum:
        imprimir strModCalcNum                          ;imprime la solicitud de un número
        loopLeerNum:
            mov SI,iAux                                 ;inicia SI con el indice Auxiliar
            mov AX,0000h                                ;limpia el registro AX
            mov AH,01h                                  ;Asigna la funcion para leer un caracter de teclado
            int 21h                                     ;llama a la interrupcion
            
            cmp AL,41h
            je  callANS
            cmp AL,61h
            je  callANS
            cmp AL,0Dh                                  ;compara si es la tecla Enter
            je  salirLeerNum                            ;si es Enter, sale del loop
            cmp Al,2Dh                                  ;compara si es el signo -                             
            je  mCNumNeg                                ;si no es el signo menos, salta
            cmp AL,39h
            ja  erMDCacl
            cmp AL,30h
            jb  erMDCacl
            jmp mCNumPos
            mCNumNeg:
            call esNegativo                             ;si es el signo, cambia la variable bandera signo
            inc numOpNeg                                ;incrementa el contador de operadores negativos
            jmp loopLeerNum                             ;regresa
            mCNumPos:                                   
            mov NumAux[SI],AL                           ;guarda la tecla leída en el numero auxiliar
            inc iAux                                    ;incrementa el indice
        loop loopLeerNum
        salirLeerNum:
        mov NumAux[SI],00h                              ;agrega un nulo al final del número
        call aEntero                                    ;convierte el número auxiliar a entero
        cmp flagSig,00h                                 ;compara si la variable bandera signo está en 0
        je  numPositivo                                 ;si está en 0 salta
        neg BX                                          ;si no es 0, aplica complemento A2 al número
        numPositivo:
            nop
        ret
    endp
    ;Llamada a ANS
    callANS:
        mov BX,ANS
        imprimir strANS
    jmp numPositivo
    ;error al ingresar un número
    erMDCacl:
        xor SI,SI
        mov iAux,00h
        imprimir saltoLin
        imprimir erMCNum
        imprimir saltoLin
        call pausa
        jmp inicioInNum
    ;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Modo Factorial ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ;muestra el modo Factorial
    factorial: 
        mov flagSig,00h
        mov iAux,00h
        mov contFact,31h
        call limpPant
        imprimir strEncFactor
        call ingresoNum
        imprimir saltoLin
        mov Opera1,BX                                   ;guarda el numero en Opera1
        cmp Opera1,09h
        jb  rangoCorrecto
        imprimir erRangFact
        call pausa
        jmp factorial
        rangoCorrecto:
        xor AX,AX
        mov BX,01h
        mov iAux,01h
        mov resultado,00h
        mov Opera2,01h
        call aString
        mov iFactorial,00h
        xor SI,SI
        call AddNumFac
        mov DI,iFactorial
        mov RepFactorial[DI],21h 
        inc iFactorial
        mov DI,iFactorial
        mov RepFactorial[DI],3Dh
        inc iFactorial
        mov resultado,01h
        call aString
        xor SI,SI
        call AddNumFac
        mov DI,iFactorial
        mov RepFactorial[DI],0Dh 
        inc iFactorial
        mov DI,iFactorial
        mov RepFactorial[DI],0Ah
        inc iFactorial
        mov CX,Opera1
        loopFactorial:
            mov contFact,31h
            mov DX,iAux 
            mov resultado,DX
            call aString
            xor SI,SI
            call AddNumFac
            mov DI,iFactorial
            mov RepFactorial[DI],21h 
            inc iFactorial
            mov DI,iFactorial
            mov RepFactorial[DI],3Dh
            inc iFactorial
            loopFac:
                sub contFact,30h
                mov BX,iAux
                cmp contFact,BL
                ja  salirloopFac
                add contFact,30h
                mov DI,iFactorial
                mov BL,contFact
                mov RepFactorial[DI],BL
                inc iFactorial
                mov DI,iFactorial
                mov RepFactorial[DI],2Ah
                inc iFactorial
                inc contFact
                jmp loopFac
                salirloopFac:
                dec iFactorial
                mov RepFactorial[DI],3Dh
                inc iFactorial
            mov AX,Opera2
            mov DX,iAux 
            mul DX
            mov Opera2,AX
            mov resultado,AX
            call aString
            xor SI,SI
            call AddNumFac
            mov DI,iFactorial
            mov RepFactorial[DI],0Dh 
            inc iFactorial
            mov DI,iFactorial
            mov RepFactorial[DI],0Ah
            inc iFactorial
            inc iAux
        loop loopFactorial
        imprimir RepFactorial
        call pausa
        jmp menuPrin

    AddNumFac proc
            mov BL,numAux[SI]
            cmp BL,24h
            je saliAddNumFac
            mov DI,iFactorial
            mov RepFactorial[DI],BL
            inc iFactorial
            inc SI
            jmp AddNumFac
            saliAddNumFac:
            ret
    endP
    ;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Generación de Reporte ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ;Genera el archivo de Reporte
    Reporte:
        mov AH,3Ch                                  ;Crear Archivo
        mov CX,00                                   ;Fichero Normal
        lea DX,pathArchivoRep                       ;direccion del archivo a crear
        int 21h                                     ;llamada a la interrupcion
        jc  errorCrear                              ;salta si hay algun error
        mov handleRep,AX                            ;obtiene el handle devuelto por la interrupcion

        ;imprime en el archivo las cadenas del reporte
        escArch stringEncabezado,0xD4               ;Imprime en archivo el encabezado
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strNoRep,0x18                       ;Imprime en archivo el numero de reporte
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepFec,0x07
        call fechaSistema
        xor DH,DH
        mov DL,diaSis
        mov resultado,DX
        call aString
        escArch numAux,SI
        escArch strRepD,0x03
        xor DH,DH
        mov DL,mesSis
        mov resultado,DX
        call aString
        escArch numAux,SI
        escArch strRepD,0x03
        mov DX,anioSis
        mov resultado,DX
        call aString
        escArch numAux,SI

        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea        
        call horaSistema
        xor DH,DH
        mov DL,horasis
        mov resultado,DX
        call aString
        escArch strRepHor,0x06
        escArch numAux,SI
        escArch strRepDP,0x03
        xor DH,DH
        mov DL,MinSis
        mov resultado,DX
        call aString
        escArch numAux,SI
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepEnt,0x09                      ;Imprime en archivo la entrada del archivo
        escArch datosArchivo,iDatosArch
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepRes,0x0B
        escArch numTotal,larNumTotal
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepPF,0x13
        escArch RepPostFijo,larPostFijo
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepPreF,0x13
        escArch RepPreFijo,larPreFijo
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepFac,0x0B
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch RepFactorial,iFactorial
        
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