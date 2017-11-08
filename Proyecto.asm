;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. SEGMENTO DE DATOS -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
data segment
	;++++++++++++++++++++++++++++++++++++++++ Mensajes +++++++++++++++++++++++++++++++++++++++++++
    pkey 				db "Adios...$"
    basura             	db 20 dup($)
    msgVictoria			db "VICTORIA$"
    msgDerrota 			db "DERROTA$"
    msgNivel 			db "NIVEL$"
    msgLogin 			db "Ingrese su usuario: $"
    msgPass				db "Ingrese su contrase",0A4h,"a: $"
    msgRestPass			db "La contrase",0A4h,"a debe ser de 4 digitos",0Dh,0Ah,"$"
    msgRegExi			db "Registro exitoso :D$"
    msgUsuario 			db "USUARIO$"
    msgPuntos 			db "PUNTOS$"
    msgTiempo 			db "TIEMPO$"
    msgTop		 		db "TOP 10$"
    coma 				db ","
    puntCom 			db ";"
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"
    ;String de una tabulación
    tab 				db 09h,"$"
    ;++++++++++++++++++++++++++++++++++++ Mensajes de Error ++++++++++++++++++++++++++++++++++++++
    errMsgAbrArch 	 	db "Hubo un error al abrir el archivo$"
    errLoginIncorr 		db "La contrase",0A4h,"a es incorrecta$"
    errUsuNoReg 		db "El usuario no est",0A0h," registrado$"
    errCaraInvPass 		db "La contrase",0A4h,"a debe contener solo digitos$"
    errPassLargInv 		db "La contrase",0A4h,"a debe ser de 4 digitos$"
    ;mensaje de error al crear el archivo            
    erCreArch           db "No se pudo crear el archivo de Reporte","$"
    ;+++++++++++++++++++++++++++++ String del encabezado y menús +++++++++++++++++++++++++++++++++
    stringEncabezado    db "Universidad de San Carlos de Guatemala",0Dh,0Ah
                        db "Facultad de Ingenieria",0Dh,0Ah
                        db "Escuela de Ciencias y Sistemas",0Dh,0Ah
                        db "Arquitectura de computadores Y Ensambladores 1 A",0Dh,0Ah
                        db "Segundo Semestre 2017",0Dh,0Ah
                        db "Walter Alfredo Ordo",0A4h,"ez Garc",0A1h,"a",0Dh,0Ah
                        db "2007-14802",0Dh,0Ah
                        db "Proyecto 2",0Dh,0Ah,"$"
    stringMenPri        db "---------------------------------MENU PRINCIPAL--------------------------------",0Dh,0Ah
                        db "1- Ingresar",0Dh,0Ah          
                        db "2- Registrar",0Dh,0Ah
                        db "3- Salir",0Dh,0Ah,"$"
    stringMenAdm 		db "-------------------------------MENU ADMINISTRADOR------------------------------",0Dh,0Ah
    					db "1- Top 10 puntos",0Dh,0Ah          
                        db "2- Top 10 tiempo",0Dh,0Ah
                        db "3- Salir",0Dh,0Ah,"$"
    ;+++++++++++++++++++++++++++++++++++++++ Variables +++++++++++++++++++++++++++++++++++++++++++ 
    ;......................................... Número ............................................
    ;Cantidad Bloques Destruidos
    blockDest 			db 0
    aparPel2 			db 0
    aparPel3 			db 0
    ;dirección actual de las pelotas
    dirPel1 			db 07h
    dirPel2 			db 01h
    dirPel3 			db 07h
    ;Fila del centro de las pelotas
    filPel1				db 98h
    filPel2				db 98h
    filPel3				db 0
    ;columna del centro de las pelotas
    colPel1 			db 09Fh
    colPel2 			db 09Fh
    colPel3 			db 0
    ;nivel del juego
    nivel 				db 1
    puntos 				db 0
    CXNivel 			dw 0
    DXNivel 			dw 0
    ciclosNivel 		db 0
    ;Pasos de la pelota
    pasos 				db 2
    resultado           dw 0
    ;variables temp
    tempWA 				dw 0
    tempWB				dw 0
    tempBA 				db 0
    tempBB 				db 0
    ;Número de Ciclos
    ciclos 				db 0
    ;Tiempo jugado
    tiempo 				dw 0
    ;manejador de archivo
    handle 				dw ?
    handleRep			dw ?
    ;......................................... String ............................................
    dirArchUsu          db "Usuarios.arq",0
    dirArchTopPun 		db "puntos.rep",0
    dirArchTopTmp 		db "tiempos.rep",0
    dirArchTopEs 		db "stad.arq",0
    ;........................................ Banderas ...........................................
    camDir 				db 0
    gano 				db 0
    punteo 				db 0
    usuCorr 			db 0
    UsuEnco 			db 0
    bandError 			db 0
    reporteVer 			db 0
    ;......................................... Vector ............................................
    posCI             	db 13 dup(0)
    posCF 				db 13 dup(0)
    posFI 				db 13 dup(0)
    posFF 				db 13 dup(0)
    colBlock 			db 13 dup(0)
    estadoBlock 		db 13 dup(1)
    NumAux              db 5 dup("0")
    usuario         	db 10 dup(0)
    password 			db 10 dup(0)
    stringTemp 			db 20 dup(0)
    idPuntosRep			dw 15 dup(0)
    puntosRep 			dw 15 dup(0)
    idTiemposRep		dw 15 dup(0)
    TiemposRep 			dw 15 dup(0)
    ;Lista de ponderaciones para pasar string a int
    listaPond           dw 0x0001,0x000A,0x0064,0x03E8,0x2710
    ;......................................... Indice ............................................
    iEstat 	 			dw 0
    iBlock 				dw 0
    iUsuario 			db 0
    iPass 				db 0
    BlockChoque 		dw 0
    ;++++++++++++++++++++++++++++++++++++ String Reporte +++++++++++++++++++++++++++++++++++++++++

ends

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. SEGMENTO DE PILA -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

stack segment
    dw   128  dup(0)
ends

;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.- SEGMENTO DE CÓDIGO -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
code segment
	;+++++++++++++++++++++++++++++++++++++++++ Macros ++++++++++++++++++++++++++++++++++++++++++++ 
	;Macro para imprimir una cadena, recibe un parametro
    imprimir macro str
        mov AH,09h                        	 	;funcion para imprimir en pantalla
        mov DX,offset str   
        int 21H
    endm
    ;Escribir en modo video, un String
    imprimirModVid macro string, largo, fila, columna, color
    	push AX
    	push BX
    	push CX
    	push DX
    	push SP
    	push BP
    	push SI
    	push DI
    	push ES
    	mov AX,data
    	mov ES,AX
    	mov AH,13h 								;Interrupción para escribir en pantalla
    	mov AL,01h 								;Asignas a todos los caracteres el color BL
    	mov BH,00h 								;Número de página de la pantalla a imprimir
    	mov BL,color							;Color del texto
    	mov BP,offset string 					;String a imprimir
    	mov CX,largo							;largo del String
    	mov DH,fila 							;Fila donde se imprimirá el texto
    	mov DL,columna							;Columna donde se imprimirá el texto
    	int 10h 								;Llamada a la Interrupción
    	pop ES
    	pop DI
    	pop SI
    	pop BP
    	pop SP
    	pop DX
    	pop CX
    	pop BX
    	pop AX
    endm
    ;escribir en archivo
    ;BX: handle del archivo
    escArch macro dato,largo
        push AX                                     ;Guarda el Valor de AX en la pila
        mov AH,40h                                  ;Escritura en archivo
        mov CX,largo                                ;cantidad de bytes a escribir
        lea DX,dato                                 ;los datos a escribir
        int 21h                                     ;llamada a la interrupcion
        pop AX                                      ;Regresar el valor de AX    
    endm
	;+++++++++++++++++++++++++++++++++++++ Procedimientos ++++++++++++++++++++++++++++++++++++++++
	;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    pausa proc
        mov AH, 07h                         	;obtener caracter teclado, no imprime en pantalla
        int 21h                                 
        ret
    endp
    ;espera una pulsación de tecla con ECO
    leeTecla proc
        mov AH,01h                              ;Leer un caracter de teclado,imprime en pantalla
        int 21h                                 
    endp
    ;Inicia Modo Video
    modVid proc
        mov AX,13h                              ;modo video 13h, 320x200x256
        int 10h
        ret
    endp
    ;Limpia la pantalla, modo texto
    limpPant proc
        mov AH, 00h
        mov AL, 03h                             ;modo texto
        int 10h                                 ;Interrupción
        mov AH,02h                              ;funcion posicionar cursor
        mov DX,0000h                            ;cordenadas 0,0
        int 10h                                 ;Interrupción
        mov AX,0600h                            ;AH 06(es un recorrido), AL 00(pantalla completa)
        mov BH,07h                              ;fondo negro(0), sobre blanco(7)
        mov CX,0000h                            ;es la esquina superior izquierda reglon: columna
        mov DX,184Fh                            ;es la esquina inferior derecha reglon: columna
        int 10h                                 ;Interrupción
        ret
    endp
    ;limpiar buffer de teclado
    limpBuffTecl proc
    	mov AH,08h              				;Limpiar el buffer de teclado
		int 21h 								;llamada a la Interrupción
    	ret
    endp
    ;Convierte el número guardado
    ;en resultado a String
    ;Resultado: entero a convertir
    ;NumAux: String del número
    aString proc
    	push AX
    	push BX
    	push DX
    	push SI
        mov AX,resultado                     	;inicia AX con el resultado
        mov DX,resultado                        ;inicia DX con el resultado
        xor SI,SI                               ;inicia SI en 0
        cmp resultado,2710h                     ;compara si el resultado con 10,000
        jb  uMiles                              ;si es menor salta a las Unidades de Mil
        xor DX,DX                               ;si no, inicia DX en 0
        mov BX,2710h                            ;Guarda 10,000 en BX
        idiv BX                                 ;divide el resultado entre 10,000
        add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
        inc SI                                  ;incrementa SI
        mov AX,DX 
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
        jb  centCero                            ;si es menor salta a las centenas
        xor DX,DX                               ;si no, inicia DX en 0
        mov BX,64h                              ;Guarda 100 en BX
        idiv BX                                 ;divide el resultado entre 100
        add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
        inc SI                                  ;incrementa SI
        mov AX,DX
        jmp decenas
        centCero:
        mov NumAux[SI],30h                      ;agrega el digito en la variable numero auxiliar
        inc SI                                  ;incrementa SI
        decenas:
        cmp resultado,0Ah                       ;compara si el resultado con 10
        jb  deceCero                            ;si es menor salta a las centenas
        xor DX,DX                               ;si no, inicia DX en 0
        mov BX,0Ah                              ;Guarda 10 en BX
        idiv BX                                 ;divide el resultado entre 10
        add AX,30h                              ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                       ;agrega el digito en la variable numero auxiliar
        inc SI
        jmp unidades
        deceCero:
        mov NumAux[SI],30h                      ;agrega el digito en la variable numero auxiliar
        inc SI                                  ;incrementa SI
        unidades:
        add DL,30h                              ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],DL                       ;agrega el digito en la variable numero auxiliar
        inc SI
        mov NumAux[SI],24h                      ;agrega el fin de cadena al numero auxiliar
        mov tempWA,SI
        pop SI
        pop DX
        pop BX
        pop AX
        ret
    endp
    ;Abrir Archivo en modo lectura
    ;DS:DX: direccion del nombre del archivo
    ;AL: modo de trabajo con el archivo
    ; AL=00h Solo lectura
    ; AL=01h Solo escritura
    ; AL=02h Lectura y escritura
    ;AH=3D abrir archivo
    ;Carry Flag en cero sin error
    ;AX = manejador de archivo
    ;Carry Flag en 1 con error
    ;AX = codigo de error
    abrirArch proc
        mov AH,3Dh
        int 21h
        ret
    endp
    ;Cerrar el archivo handle como parametro
    ;BX:Handle
    cerrarArch proc
        mov AH,3Eh                              ;Peticion para salir
        int 21h
        ret
    endp
    ;lee un byte del archivo
    ;y lo guarda en tempBA
    ;BX:Handle
    leerByteArch proc
    	push CX
    	mov AH,3fh                          	;lee del archivo
        mov CX,01h                     			;cantidad de bytes
        mov DX,offset tempBA               		;buffer donde se guardará
        int 21h                             	;colocar un byte en el buffer
        pop CX
    	ret
    endp
    ;Mover puntero de archivo
    ;contando desde el final
    ;del archivo hacia el principio
    ;AL: código del desplazamiento
    ; AL=00h Desde el inicio
    ; AL=01h Desde la posición actual
    ; AL=02h Desde el final
    ;BX: Handle del archivo
    ;CX: Word más significativo despla.
    ;DX: Word menos significativo despla.
    moverPuntArch proc
    	mov AH,42h
    	int 21h
    	ret
    endp
    ;Guarda todo lo que está antes de la coma
    ;en la variable stringTemp
    ;handle: handle del archivo
    buscarComa proc
    	xor SI,SI
    	mov bandError,00h
    	loopBusComa:
    		mov BX,handle 						;Handle del archivo de usuarios
    		call leerByteArch 					;Lee un byte del archivo
    		cmp AL,00h 							;compara si AL es 0 (fin del archivo)
    		jne sinErrBusComa					;si no hubo error continua
    		mov bandError,01h 					;si hubo error levanta la bandera error
    		jmp salirBusComa 					;sale del procedimiento
    		sinErrBusComa:
    		mov AL,tempBA 						;AL=byte leído de archivo
    		cmp AL,0Ah 							;compara si el byte es nueva línea
    		je loopBusComa 						;si es lo ignora
    		cmp AL,0Dh 							;compara si el byte es retorno de carro
    		je loopBusComa 						;si es lo ignora
    		cmp AL,20h 							;compara si el byte es un espacio
    		je loopBusComa 						;si es lo ignora
    		cmp AL,09h 							;compara si el byte es una tabulación
    		je loopBusComa 						;si es lo ignora
    		cmp AL,2Ch 							;compara si el byte es la coma
    		je salirBusComa						;si es, salta a verificar el usuario
    		mov stringTemp[SI],AL 				;guarda el caracter leído en la var temporal
    		inc SI 								;incrementa el índice
    	jmp loopBusComa 						;continua el ciclo
    	salirBusComa:
    	ret
    endp
    ;Guarda todo lo que está antes
    ;del punto y coma,
    ;en la variable stringTemp
    ;handle: handle del archivo
    buscarPuntoComa proc
    	xor SI,SI 		
    	mov bandError,00h					
    	loopBusPuntComa:
    		mov BX,handle 						;Handle del archivo de usuarios 
    		call leerByteArch 					;Lee un byte del archivo
    		cmp AL,00h 							;compara si AL es 0 (fin de archivo)			
    		jne sinErrBusPyC 	 				;si no hubo error continua
    		mov bandError,01h 					;levanta la bandera error
    		jmp salirBusPunYComa 				;sale del procedimiento
    		sinErrBusPyC:
    		mov AL,tempBA 						;Guarda en AL el caracter leído
    		cmp AL,3Bh 							;compara si el caracter es punto y coma (;)
    		je salirBusPunYComa					;si es, verifica la contraseña
    		mov stringTemp[SI],AL 				;Guarda el caracter leído en la var temporal
    		inc SI
    	jmp loopBusPuntComa 					;continua el ciclo
    	salirBusPunYComa:
    	ret
    endp
    ;Guarda el estado del juego en los reportes
   	archEst proc
   		lea DX,dirArchTopEs
    	mov AL,01h 								;AL=01h modo Escritura
    	call abrirArch 							;Abre el archivo usuario en modo escritura
    	mov handle,AX  							;mover handle
    	jc errorAbrArch 	 					;si hubo error saltar a mostrar error
    	mov AL,02h
    	xor CX,CX
    	xor DX,DX
    	mov BX,handle
    	call moverPuntArch
    	jc errorAbrArch
    	escArch saltoLin,02h
    	mov AL,iUsuario
    	xor AH,AH
    	mov tempWA,AX
    	escArch usuario,tempWA
    	escArch coma,01h
    	mov AL,puntos
    	xor AH,AH
    	mov resultado,AX
    	call aString
    	escArch NumAux,tempWA
    	escArch coma,01h
    	mov AX,tiempo
    	mov resultado,AX
    	call aString
    	escArch NumAux,tempWA
    	escArch coma,01h
    	mov AL,nivel
    	xor AH,AH
    	mov resultado,AX
    	call aString
    	escArch NumAux,tempWA
    	escArch puntCom,01h
    	call cerrarArch
   		ret
   	endp
   	;Cargar Estadisticas desordenados
   	;Puntos y Tiempos
   	cargEstat proc
   		mov iEstat,00h
   		mov tempWB,00h
   		lea DX,dirArchTopEs
   		mov AL,00h
   		call abrirArch
   		mov handle,AX
   		loopLeerEsta:
			call buscarComa
			cmp bandError,01h
			je salirLoopLeerEsta
			call buscarComa
			mov CX,SI
			call aEntero
			mov SI,tempWB
			mov AX,iEstat
			mov idPuntosRep[SI],AX
			mov idTiemposRep[SI],AX
			mov puntosRep[SI],BX
			call buscarComa
			mov CX,SI
			call aEntero
			mov SI,tempWB
			mov TiemposRep[SI],BX
			call buscarPuntoComa
			inc tempWB
			inc tempWB
			inc iEstat
			jmp loopLeerEsta
		salirLoopLeerEsta:
		mov BX,handle
		call cerrarArch
   		ret
   	endp
   	;Ordenar Puntos
   	ordenarPuntos proc
   		xor SI,SI 								;Pibote
   		mov CX,iEstat
   		dec CX
   		burbuPuntos:
   			push CX
   			mov DI,SI
   			inc DI
   			inc DI
   			burbuPuntos2:
   				mov DX,puntosRep[SI]
   				mov AX,puntosRep[DI]
   				cmp AX,DX
   				jb SalirBurbuPuntos2
   				mov AX,puntosRep[DI]
   				mov puntosRep[DI],DX
   				mov puntosRep[SI],AX
   				mov DX,idPuntosRep[SI]
   				mov AX,idPuntosRep[DI]
   				mov idPuntosRep[SI],AX
   				mov idPuntosRep[DI],DX
   				SalirBurbuPuntos2:
   				inc DI
   				inc DI
   			loop burbuPuntos2
   			inc SI
   			inc SI
   			pop CX
   		loop burbuPuntos	
   		ret
   	endp
   	;Ordena los Tiempos
   	ordenarTiempos proc
   		xor SI,SI 								;Pibote
   		mov CX,iEstat
   		dec CX
   		burbuTiempos:
   			push CX
   			mov DI,SI
   			inc DI
   			inc DI
   			burbuTiempos2:
   				mov DX,TiemposRep[SI]
   				mov AX,TiemposRep[DI]
   				cmp AX,DX
   				jb SalirBurbuTiempos2
   				mov AX,TiemposRep[DI]
   				mov TiemposRep[DI],DX
   				mov TiemposRep[SI],AX
   				mov DX,idTiemposRep[SI]
   				mov AX,idTiemposRep[DI]
   				mov idTiemposRep[SI],AX
   				mov idTiemposRep[DI],DX
   				SalirBurbuTiempos2:
   				inc DI
   				inc DI
   			loop burbuTiempos2
   			inc SI
   			inc SI
   			pop CX
   		loop burbuTiempos	
   		ret
   	endp
   	;Mostrar reportes
   	mostrarRepo proc
   		call crearArchRepo
   		mov tempWB,00h
   		mov tempWA,00h
   		lea DX,dirArchTopEs
   		mov AL,00h
   		call abrirArch
   		mov handle,AX
   		mov CX,iEstat
   		loopBuscarIdPuntos:
   			push CX
   			mov tempwA,00h
	   		loopMostRepoPuntos:
				mov SI,tempWB
				cmp reporteVer,00h
				jne repoTiempo
				mov AX,idPuntosRep[SI]
				jmp imprimeRepo
				repoTiempo:
				mov AX,idTiemposRep[SI]
				imprimeRepo:
				mov CX,03
				cmp tempWA,AX
				jne noImprimePuntos
				imprimirComas:
					push CX
					call buscarComa
					mov stringTemp[SI],24h
					mov BX,handleRep
					escArch stringTemp,SI
					escArch tab,01h
					escArch tab,01h
					imprimir stringTemp
					imprimir tab
					imprimir tab
					pop CX
				loop imprimirComas
				call buscarPuntoComa
				mov stringTemp[SI],24h
				mov BX,handleRep
				escArch stringTemp,SI
				escArch saltoLin,02h
				imprimir stringTemp
				imprimir saltoLin
				jmp salirLoopMostRepoPuntos
				noImprimePuntos:
				call buscarComa
				cmp bandError,01h
				je salirLoopMostRepoPuntos
				call buscarComa
				call buscarComa
				call buscarPuntoComa

				inc tempWA
				jmp loopMostRepoPuntos
			salirLoopMostRepoPuntos:
			mov AL,00h
			mov BX,handle
			xor CX,CX
			xor DX,DX
			call moverPuntArch
			inc tempWB
			inc tempWB
			pop CX
		loop loopBuscarIdPuntos
		mov BX,handle
		call cerrarArch
		mov BX,handleRep
		call cerrarArch
   		ret
   	endp
   	;crear Archivo reporte
    crearArchRepo proc
    	mov AH,3Ch                                  ;Crear Archivo
        mov CX,00                                   ;Fichero Normal
        cmp reporteVer,00h
        jne direArcTiempo
        lea DX,dirArchTopPun                        ;direccion del archivo a crear
        jmp interrCrearRepo
        direArcTiempo:
        lea DX,dirArchTopTmp                        ;direccion del archivo a crear
        interrCrearRepo:
        int 21h                                     ;llamada a la interrupcion
        jc  errorCrear                              ;salta si hay algun error
        mov handleRep,AX                           	;obtiene el handle devuelto por la interrupcion
        mov BX,handleRep
        call escEncaRepo
        jmp salirCrearRepoPun
        errorCrear:
        	imprimir erCreArch
        	call cerrarArch
        salirCrearRepoPun:
    	ret
    endp
    ;encabezado del reporte
    escEncaRepo proc
    	escArch stringEncabezado,0xE0
    	escArch tab,01h
        escArch tab,01h
        escArch tab,01h
        escArch tab,01h
        escArch tab,01h
        escArch msgTop,06h
        escArch saltoLin,02h
        escArch saltoLin,02h
        escArch msgUsuario,07h
        escArch tab,01h
        escArch tab,01h
        escArch msgPuntos,06h
        escArch tab,01h
        escArch msgTiempo,06h
        escArch tab,01h
        escArch msgNivel,05h
        escArch saltoLin,02h
    	ret
    endp
   	;Para pasar a Entero un String
   	;CX: tamaño del string
   	;BX= Número resultado
    aEntero proc
        mov DI,CX                            	;inicia el indice DI, en el tamaño del numero
        dec DI                                  ;decrementa DI
        xor SI,SI                               ;Inicia SI en 0
        xor BX,BX                               ;inicia BX en 0
        loopEntero:  
            mov AH,00h                         	;inicia AH en 0
            mov AL,stringTemp[DI]          		;guarda en AL un digito del numero
            sub AL,30h                     		;resta 30 al digito en ASCII
            mul listaPond[SI]            		;multiplica el digito por una ponderación Unidad, decena, centena..
            add BX,AX              				;acumula los valores en BX
            inc SI                     			;incrementa SI se mueve un byte
            inc SI                             	;incrementa SI nuevamente, se mueve un byte más. Total un word
            dec DI                             	;decrementa DI
        loop loopEntero 
        ret
    endp
    ;Mover pelota en la direccion
    ;AL: Fila del centro de la pelota
    ;AH: Columna del centro de la pelota
    ;DL: Dirección de la pelota
    moverPel proc
    	mov punteo,00h
    	arrDer:
	    	cmp DL,01h 							;compara si la dirección es 1 (Arriba Derecha)
	    	jne derAba							;si no es igual, continua comparando con otras direcciones
	    	add AH,pasos 						;mueve el centro de la pelota
	    	sub AL,pasos 						;mueve el centro de la pelota
	    	call verifChoqueBlock 				;Verifica si hubo choque con un bloque
	    	cmp camDir,01h 						;compara si hubo choque vertical (01h)
	    	je camDirArrDerDerAba 				;si hubo choque vertical, cambiar dirección. Derecha Abajo
	    	cmp camDir,02h 						;compara si hubo choque horizontal (02h)
	    	je camDirArrDerArrIzq 				;si hubo choque vertical, cambiar dirección. Arriba Izquierda
	    	arrDerLimSup:
	    	cmp AL,14h 							;evalua el límite, superior
	    	ja  limArrDer 						;si no ha llegado al límite, evalua el límite derecho
	    	camDirArrDerDerAba:
	    	mov DL,03h 							;cambia dirección Derecha Abajo
	    	add AL,pasos 						;regresa el centro de la pelota
	    	sub AH,pasos 						;regresa el centro de la pelota
	    	jmp derAba 							;salta a evaluar los límites en la dirección Derecha Abajo
	    	limArrDer:
	    	cmp AH,0EFh 						;evalua el límite, derecho
	    	jb	salirMoverPel 					;si no ha llegado al límite, sale del procedimiento
	    	camDirArrDerArrIzq:
	    	mov DL,07h 							;cambia dirección Arriba Izquierda
	    	sub AH,pasos 						;regresa el centro de la pelota
	    	add AL,pasos 						;regresa el centro de la pelota
	    	jmp arrIzq 							;salta a evaluar los límites en la dirección Arriba Izquierda
    	derAba:
	    	cmp DL,03h 							;compara si la dirección es 3 (Derecha Abajo)
	    	jne izqAba 							;si no es igual, continua comparando con otras direcciones
	    	add AL,pasos 						;mueve el centro de la pelota
	    	add AH,pasos 						;mueve el centro de la pelota
	    	call verifChoqueBlock 				;Verifica si hubo choque con un bloque
	    	cmp camDir,01h 						;compara si hubo choque vertical (01h)
	    	je camDirDerAbaArrDer 				;si hubo choque vertical, cambiar dirección. Arriba Derecha
	    	cmp camDir,02h 						;compara si hubo choque horizontal (02h)
	    	je camDirDerAbaIzqAba 				;si hubo choque vertical, cambiar dirección. Izquierda Abajo
	    	cmp AL,0B3h 						;evalua el límite, inferior
	    	jae salirMoverPel 					;si ha llegado al límite, sale del procedimiento
	    	cmp AH,0EFh 						;evalua el límite, derecho
	    	jb 	salirMoverPel 					;si ha llegado al límite, sale del procedimiento
	    	camDirDerAbaIzqAba:
	    	sub AH,pasos 						;regresa el centro de la pelota
	    	sub AL,pasos 						;regresa el centro de la pelota
	    	mov DL,05h 							;cambia dirección Izquierda Abajo
	    	jmp izqAba 							;salta a evaluar los límites en la dirección Izquierda Arriba
	    	camDirDerAbaArrDer:
	    	sub AH,pasos 						;regresa el centro de la pelota
	    	sub AL,pasos 						;regresa el centro de la pelota
	    	mov DL,01h 							;cambia dirección Izquierda Abajo
	    	jmp ArrDer 							;salta a evaluar los límites en la dirección Izquierda Arriba
    	izqAba:
	    	cmp DL,05h 							;compara si la dirección es 5 (Izquierda Abajo)
	    	jne arrIzq 							;si no es igual, continua comparando con otras direcciones
	    	add AL,pasos 						;mueve el centro de la pelota
	    	sub AH,pasos  						;mueve el centro de la pelota
	    	call verifChoqueBlock 				;Verifica si hubo choque con un bloque
	    	cmp camDir,01h 						;compara si hubo choque vertical (01h)
	    	je camDirIzqAbaArrIzq 				;si hubo choque vertical, cambiar dirección. Arriba Izquierda
	    	cmp camDir,02h 						;compara si hubo choque horizontal (02h)
	    	je camDirIzqAbaDerAba 				;si hubo choque vertical, cambiar dirección. Derecha Abajo
	    	cmp AL,0B3h 						;evalua el límite, inferior
	    	jae salirMoverPel 					;si ha llegado al límite, sale del procedimiento
	    	cmp AH,4Fh 							;evalua el límite, izquierdo
	    	ja 	salirMoverPel 					;si no ha llegado al límite, sale del procedimiento
	    	camDirIzqAbaDerAba:
	    	sub AL,pasos 						;regresa el centro de la pelota
	    	add AH,pasos 						;regresa el centro de la pelota
	    	mov DL,03h 							;cambia dirección Derecha Abajo
	    	jmp derAba 							;salta a evaluar los límites en la dirección Derecha Abajo
	    	camDirIzqAbaArrIzq:
	    	sub AL,pasos 						;regresa el centro de la pelota
	    	add AH,pasos 						;regresa el centro de la pelota
	    	mov DL,07h 							;cambia dirección Derecha Abajo
	    	jmp arrIzq 							;salta a evaluar los límites en la dirección Derecha Abajo
    	arrIzq:
	    	cmp DL,07h 							;compara si la dirección es 7 (Arriba Izquierda)
	    	jne salirMoverPel 					;si no es igual, continua comparando con otras direcciones
	    	sub AH,pasos 						;mueve el centro de la pelota
	    	sub AL,pasos 						;mueve el centro de la pelota
	    	call verifChoqueBlock 				;Verifica si hubo choque con un bloque
	    	cmp camDir,01h 						;compara si hubo choque vertical (01h)
	    	je camDirArrIzqIzqAba 				;si hubo choque vertical, cambiar dirección. Izquierda Abajo
	    	cmp camDir,02h 						;compara si hubo choque horizontal (02h)
	    	je camDirArrIzqArrDer 				;si hubo choque vertical, cambiar dirección. Arriba Derecha
	    	cmp AH,4Fh 							;evalua el límite, izquierdo
	    	ja 	limArrIzq 						;si no ha llegado al límite, evalua el límite superior
	    	camDirArrIzqArrDer:
	    	add AH,pasos 						;regresa el centro de la pelota
	    	add AL,pasos 						;regresa el centro de la pelota
	    	mov DL,01h 							;cambia dirección Arriba Derecha
	    	jmp arrDer 							;salta a evaluar los límites en la dirección Arriba Derecha
	    	limArrIzq:
	    	cmp AL,14h 							;evalua el límite, superior
	    	ja salirMoverPel 					;si no ha llegado al límite, sale del procedimiento
	    	camDirArrIzqIzqAba:
	    	add AH,pasos 						;regresa el centro de la pelota
	    	add AL,pasos 						;regresa el centro de la pelota
	    	mov DL,05h 							;cambia dirección Izquierda Abajo
	    	jmp izqAba 							;salta a evaluar los límites en la dirección izquierda Abajo
    	salirMoverPel:
    	ret
    endp
    ;verifica si la pelota choca con
    ;un bloque, cambia el estado 
    ;del bloque a 00h (deshabilitado)
    ;AL: Fila del centro de la pelota
    ;AH: Columna del centro de la pelota
    verifChoqueBlock proc
    	push CX
    	mov gano,01h
    	mov camDir,00h 						
    	mov BlockChoque,00h
    	mov iBlock,00h
    	mov CX,0Dh 								;Recorre los 13 bloques, incluida la barra
    	loopVerifChoqueBlock:
    		mov SI,iBlock 						
    		cmp estadoBlock[SI],00h 			;Compara si el bloque actual está activo
    		je salirLoopVerChoBlo 				;Si no lo está, continua con los siguientes bloques
    		cmp CX,01h
    		je VerifChoque
    		mov gano,00h
    		VerifChoque:
    		mov DH,posCI[SI] 					
    		dec DH
    		cmp AH,DH 							;compara la columna de la pelota, con la columna inicial
    		jbe	salirLoopVerChoBlo 				;si es menor o igual, no está dentro del bloque. Sale
    		mov DH,posCF[SI] 					
    		inc DH
    		cmp AH,DH 							;Compara la columna de la pelota, con la columna final
    		jae	salirLoopVerChoBlo 				;si es mayor o igual, no está dentro del bloque. Sale
    		mov DH,posFF[SI]
    		inc DH
    		cmp AL,DH 							;Compara la fila de la pelota, con la fila final
    		jae	salirLoopVerChoBlo 				;si es mayor o igual, no está dentro del bloque. Sale
    		mov DH,posFI[SI]
    		dec DH
    		cmp AL,DH 							;Compara la fila de la pelota, con la fila Inicial
    		jbe salirLoopVerChoBlo 				;si es menor o igual, no está dentro del bloque. Sale
    		
    		;Está dentro del bloque
    		;Chocó con el bloque
    		mov BlockChoque,SI 					;Guarda el índice del bloque donde chocó
    		cmp DL,01h 							;compara si la dirección es 1 (Arriba Derecha)
    		jne choqueDerAba 					;sino compara otras direcciones
    		mov DH,AH 							
    		inc DH
    		sub DH,posCI[SI]
    		mov tempBA,DH 						;calcula la diferencia de columnas
    		mov DH,posFF[SI]
    		inc DH
    		sub DH,AL 							;calcula la diferencia de filas
    		jmp DiferenciaDistancia
    		choqueDerAba:
    		cmp DL,03h 							;compara si la dirección es 3 (Derecha Abajo)
    		jne choqueIzqAba 					;sino compara otras direcciones
    		mov DH,AH
    		inc DH
    		sub DH,posCI[SI]
    		mov tempBA,DH 						;calcula la diferencia columnas
    		mov DH,AL
    		inc DH
    		sub DH,posFI[SI]					;calcula la diferencia de filas
    		jmp DiferenciaDistancia
    		choqueIzqAba:
    		cmp DL,05h 							;compara si la dirección es 5 (Izquierda Abajo)
    		jne choqueArrIzq 					;sino compara otras direcciones
    		mov DH,posCF[SI]
    		inc DH
    		sub DH,AH
    		mov tempBA,DH 						;calcula la diferencia columnas
    		mov DH,AL
    		inc DH
    		sub DH,posFI[SI]					;calcula la diferencia de filas
    		jmp DiferenciaDistancia
    		choqueArrIzq:
    		mov DH,posCF[SI]
    		inc DH
    		sub DH,AH
    		mov tempBA,DH 						;calcula la diferencia columnas
    		mov DH,posFF[SI]
    		inc DH
    		sub DH,AL 							;calcula la diferencia de filas
    		;Compara diferencias de columnas
    		;y filas, la diferencia más pequeña
    		;indica donde chocó la pelota
    		DiferenciaDistancia:
    		cmp tempBA,DH 						;compara la diferencia de columnas con la de las filas
    		jb choqueHorizontal 				;si el de columnas es menor que el de las columnas, salta
    		mov camDir,01h 						;es un choque vertical
    		call desBlock 						;destruye el bloque actual
    		jmp salirLoopVerChoBlo 				
    		choqueHorizontal:
    		mov camDir,02h 						;es un choque horizontal
    		call desBlock 						;destruye el bloque actual	
    		salirLoopVerChoBlo: 		
    		inc iBlock
    	loop loopVerifChoqueBlock
    	pop CX
    	ret
    endp
    ;Desaparecer Bloque
    desBlock proc
    	cmp BlockChoque,0Ch 					;compara si el choque es con la barra
    	je salirDesBlock 						;si es, se sale
    	push CX
    	push AX
    	push DX
    	mov BL,00h 								;Color para pintar el bloque, negro
    	mov SI,BlockChoque 						;Guarda el índice, del bloque de choque, en SI
    	mov AH,posCI[SI] 						;Columna inicial del bloque
    	mov AL,posCF[SI] 						;Columna final del bloque
    	mov DH,posFI[SI] 						;Fila inicial del bloque
    	mov DL,posFF[SI] 						;Fila final del bloque
    	call pintarBlock 						;Pinta el bloque
    	mov estadoBlock[SI],00h					;deshabilita el bloque, 00h
    	inc blockDest
    	cmp nivel,03h
    	jne puntNivel2
    	inc puntos
    	puntNivel2:
    	cmp nivel,02h
    	jne puntNivel1
    	inc puntos
    	puntNivel1:
    	inc puntos
    	mov AL,puntos
    	xor AH,AH
    	mov resultado,AX
    	call aString
    	mov punteo,01h
    	pop DX
    	pop AX
    	pop CX
    	salirDesBlock:
    	ret
    endp
    ;Calcular la dirección de memoria
    ;donde se pintará, utilizando
    ;la formula TamFil*j + i para
    ;la linealización de una matriz
    ;DX: Filas
    ;AX: Columnas
    ;BL: Color
    ;DI: Dirección de memoria de video
    pintPix proc
    	push DX
    	push AX
		mov DI,DX 								;una copia de DX en DI
        shl DX,06h 								;se multiplica DX*64
        shl DI,08h 								;se multiplica DI*256
        add DI,DX 								;se suma DX + DI, DI=j*320
        add DI,AX 								;DI=j*320 + i
        mov ES:[DI],BL 							;se pinta el pixel 
        pop AX
        pop DX
    	ret
    endp
    ;Pinta el Marco del juego
    ;160px x 160px
    pintarMarco proc
    	mov AX,0EFh 							;columna de la pantalla donde se pintará
    	mov BL,07h 								;color Gris, para el pixel a pintar
    	mov CX,0A0h 							;160 pixeles a pintar, ancho marco
    	loopPintLHor: 							;Lineas Horizontales
    		mov DX,0B3h							;fila de la pantalla, donde se pintará
    		call pintPix 						;se pinta la posición de memoria de video
	        mov DX,13h 							;fila de la pantalla, donde se pintará
	        call pintPix 						;se pinta la posición de memoria de video
	        dec AX 								;se decrementan la columna
        loop loopPintLHor

        mov DX,0B3h								;fila de la pantalla, donde se pintará
        mov CX,0A1h 							;160 pixeles a pintar, ancho marco
        mov BX,07h 								;color Gris, para el pixel a pintar
        loopPintLVer: 							;Lineas Verticales
    		mov AX,0EFh 						;columna de la pantalla donde se pintará
    		call pintPix 						;se pinta la posición de memoria de video
	        mov AX,4Fh 							;columna de la pantalla, donde se pintará
	        call pintPix 						;se pinta la posición de memoria de video
	        dec DX 								;se decrementan la fila
        loop loopPintLVer
    	ret
    endp
    ;Pinta la pelota
    ;BL: Color
    ;AL: Fila del centro de la pelota
    ;AH: Columna del centro de la pelota
    ;pelota de 3pix x 3pix
    pintarPelota proc
    	xor DH,DH
    	mov DL,AL 								;mover la fila del centro, a la fila a pintar
    	mov AL,AH 								;mover la columna del centro, a la col a pintar
    	xor AH,AH
    	call pintPix 							;Pintar el centro de la pelota
    	dec DX 									;pintar el radio de la pelota
    	dec AX 									
    	call pintPix 							;pintar el radio de la pelota
    	inc AX 									
    	call pintPix 							;pintar el radio de la pelota
    	inc AX
    	call pintPix 							;pintar el radio de la pelota
    	inc DX
    	call pintPix 							;pintar el radio de la pelota
    	inc DX
    	call pintPix 							;pintar el radio de la pelota
    	dec AX
    	call pintPix 							;pintar el radio de la pelota
    	dec AX
    	call pintPix 							;pintar el radio de la pelota
    	dec DX
    	call pintPIX 							;pintar el radio de la pelota
    	ret
    endp
    ;Pintar Bloque de color
    ;BL: Color
    ;AH: Columna Inicial
    ;AL: Columna Final
    ;DH: Fila Inicial
    ;DL: Fila Final
    pintarBlock proc
    	mov tempBA,AH 							;tempBA: Columna Inicial
    	mov tempBB,DH 							;tempBB: Fila Inicial
    	sub AL,AH 								;AH: número de columnas
    	sub DL,DH 								;DH: número de filas
    	xor AH,AH 								;AX: Número de columnas
    	xor DH,DH 								;DX: Número de filas
    	mov tempWA,DX 							;tempWA cantidad de filas a pintar
    	mov tempWB,AX  							;tempWB cantidad de columnas a pintar
    	mov DL,tempBB 							;DL: Fila Inicial
    	xor DH,DH 								;DX: Fila Inicial
    	mov CX,tempWA 							;CX: cantidad de filas a pintar
    	loopPintBlockFil:
    		push CX
    		mov CX,tempWB 						;CX: número de columnas
    		mov AL,tempBA 						;AL: Columna Inicial
    		xor AH,AH 							;AX: Columna Inicial
    		loopPintBlockCol:
    			call pintPix 					;Pintar un pixel, en la posición AX,DX
    			inc AX 							;mover a la siguiente Columna
    		loop loopPintBlockCol
    		inc DX 								;mover a la siguiente Fila
    		pop CX
    	loop loopPintBlockFil
    	ret
    endp
    ;Crea las posiciones y colores
    ;de los bloques usados en los
    ;niveles del juego
    creaBlocks proc
    	cmp nivel,03h
    	jne creaBlockNivel2
    	mov estadoBlock[0Bh],01h
    	mov estadoBlock[0Ah],01h
    	jmp iniciaCreacion
    	creaBlockNivel2:
    	cmp nivel,02h
    	jne creaBlockNivel1
    	mov estadoBlock[0Bh],00h
    	mov estadoBlock[0Ah],01h
    	jmp iniciaCreacion
    	creaBlockNivel1:
    	mov estadoBlock[0Bh],00h
    	mov estadoBlock[0Ah],00h
    	iniciaCreacion:
    	mov iBlock,00h 							;inicia el indice de vector en 00h 
    	mov AH,54h 								;Columna Inicial del primer bloque
    	mov DH,19h 								;Fila inicial del primer bloque
    	mov AL,72h 								;Columna final del primer bloque
    	mov DL,23h 								;Fila final del primer bloque
    	mov BL,01h 								;Color del primer bloque
    	mov CX,05h 								;Cantidad de bloques en la fila 1
    	loopCrearBlocksF1: 						;Guarda los datos de la primera fila de bloques
    		mov SI,iBlock 						;SI: indice de vector de bloques
    		mov estadoBlock[SI],01h 			;Habilita el bloque
    		call llenaVectBlock 				;Guarda los datos del bloque en el vector
    		inc iBlock 							;mueve el indice a la siguiente posición
    		inc BL 								;cambia de color
    		add AH,1Eh 							;Se mueve a la columna inicial del siguiente bloque
    		add AL,1Eh 							;Se mueve a la columna final del siguiente bloque
    	loop loopCrearBlocksF1
    	mov AH,72h 								;Columna Inicial del primer bloque, 2da fila
    	mov DH,24h 								;Fila inicial del primer bloque
    	mov AL,90h 								;Columna final del primer bloque
    	mov DL,2Eh 								;Fila final del primer bloque
    	mov CX,03h 								;Cantidad de bloques en la fila 2
    	loopCrearBlocksF2:
    		mov SI,iBlock 						;SI: indice de vector de bloques
    		mov estadoBlock[SI],01h 			;Habilita el bloque
    		call llenaVectBlock 				;Guarda los datos del bloque en el vector
    		inc iBlock 							;mueve el indice a la siguiente posición
    		inc BL 								;cambia de color
    		add AH,1Eh 							;Se mueve a la columna inicial del siguiente bloque
    		add AL,1Eh 							;Se mueve a la columna final del siguiente bloque
    	loop loopCrearBlocksF2
    	;Los dos bloques de la
    	;tercera fila
    	;Primer Bloque
    	mov AH,54h 								;Columna Inicial del primer bloque
    	mov DH,2Fh 								;Fila inicial del primer bloque
    	mov AL,72h 								;Columna final del primer bloque
    	mov DL,39h 								;Fila final del primer bloque
    	mov SI,iBlock 							;SI: indice de vector de bloques
    	mov estadoBlock[SI],01h 				;Habilita el bloque
		call llenaVectBlock 					;Guarda los datos del bloque en el vector
		inc iBlock 								;mueve el indice a la siguiente posición
		inc BL 									;cambia de color
		;Segundo Bloque 
		mov AH,0CCh 							;Columna Inicial del segundo bloque
    	mov DH,2Fh 								;Fila inicial del segundo bloque
    	mov AL,0EAh 							;Columna final del segundo bloque
    	mov DL,39h 								;Fila final del segundo bloque
    	mov SI,iBlock
    	mov estadoBlock[SI],01h 				;Habilita el bloque
		call llenaVectBlock
		inc iBlock
		inc BL
		;Bloque 2do Nivel
		mov AH,73h 								;Columna Inicial del segundo bloque
    	mov DH,39h 								;Fila inicial del segundo bloque
    	mov AL,91h 								;Columna final del segundo bloque
    	mov DL,43h 								;Fila final del segundo bloque
    	mov SI,iBlock
		call llenaVectBlock
		inc iBlock
		inc BL
		;Bloque 3er Nivel
		mov AH,91h 								;Columna Inicial del segundo bloque
    	mov DH,43h 								;Fila inicial del segundo bloque
    	mov AL,0AFh 							;Columna final del segundo bloque
    	mov DL,4Dh 								;Fila final del segundo bloque
    	mov SI,iBlock
		call llenaVectBlock
    	ret
    endp
    ;BL: Color
    ;AH: Columna Inicial
    ;AL: Columna Final
    ;DH: Fila Inicial
    ;DL: Fila Final
    llenaVectBlock proc
    	mov posCI[SI],AH 						;Columna Inicial en la posición SI del vector
		mov posFI[SI],DH 						;Fila Inicial en la posición SI del vector
		mov posCF[SI],AL 						;Columna final en la posición SI del vector
		mov posFF[SI],DL 						;Fila final en la posición SI del vector
		mov colBlock[SI],BL 					;Color en la posición SI del vector
    	ret
    endp
    ;Pinta todos los bloques del nivel
    pintarBlocksNivel proc
    	mov iBlock,00h 							;Indice del vector de bloques en 00h, el primero
    	mov CX,0Ch 								;pinta los primeros 12 bloques
    	loopPintBlocks:
    		mov SI,iBlock 						;SI: índice del vector de bloques
    		cmp estadoBlock[SI],00h 			;compara si el bloque está inactivo
    		je 	salirLoopPintBlock 				;si lo está, continua con el siguiente
    		mov AH,posCI[SI] 					;lee la columna inicial del bloque
    		mov DH,posFI[SI] 					;lee la fila inicial del bloque
    		mov AL,posCF[SI] 					;lee la columna final del bloque
    		mov DL,posFF[SI] 					;lee la fila final del bloque
    		mov BL,colBlock[SI] 				;lee el color del bloque
    		push CX 							;CX en la pila, porque pintarBlock destruye su valor
    		call pintarBlock 					;Pinta el bloque
    		pop CX 								;Recupera el valor de CX, de la pila
    		salirLoopPintBlock:
    		inc iBlock 							;Mueve el índice al siguiente bloque
    	loop loopPintBlocks
    	ret
    endp
    ;Pinta la barra del juego
    ;Almacenada en la posicón 0Ch del vector
    ;BL: Color
    ;AH: Columna Inicial
    ;AL: Columna Final
    ;DH: Fila Inicial
    ;DL: Fila Final
    pintarBarra proc
    	mov AH,posCI[0Ch] 						;Columna inicial de la barra
    	mov AL,posCF[0Ch] 						;Columna final de la barra
    	mov DH,posFI[0Ch] 						;Fila inicial de la barra
    	mov DL,posFF[0Ch] 						;Fila final de la barra
    	mov BL,colBlock[0Ch] 					;Color de la barra
    	call pintarBlock 						;pinta la barra
    	ret 
    endp
    ;mover la barra a la derecha
    moverBarraDer proc
    	mov AH,08h              				;Limpiar el buffer de teclado
		int 21h 								;llamada a la Interrupción
    	cmp posCF[0Ch],0EEh 					;compara si llegó al límite derecho
    	jae salirMovBarrDer 					;si llegó, no mueve la barra
    	push CX  								;Guarda el valor de CX
    	mov colBlock[0Ch],00h 					;asigna color 0 (Negro), a la barra
    	call pintarBarra 						;pinta la barra de Negro (Borrar) 
    	add posCI[0Ch],04h 						;aumenta en 4 la columna inicial de la barra
    	add posCF[0Ch],04h 						;aumenta en 4 la columna final de la barra
    	mov colBlock[0Ch],0Eh 					;cambia el color de la barra
    	call pintarBarra 						;pinta nuevamente la barra
    	pop CX 									;recupera el valor de CX, de la pila
    	salirMovBarrDer:
    	ret
    endp
    ;mover la barra a la izquierda
    moverBarraIzq proc
    	mov AH,08h              				;Limpiar el buffer de teclado
		int 21h 								;llamada a la Interrupción
    	cmp posCI[0Ch],50h 	 					;compara si llegó al límite izquierdo
    	jbe salirMovBarrIzq 					;si llegó, no mueve la barra
    	push CX 								;Guarda el valor de CX
    	mov colBlock[0Ch],00h 					;asigna color 0 (Negro), a la barra
    	call pintarBarra 						;pinta la barra de Negro (Borrar)
    	sub posCI[0Ch],04h 						;resta 4 la columna inicial de la barra
    	sub posCF[0Ch],04h 						;resta 4 la columna final de la barra
    	mov colBlock[0Ch],0Eh 					;cambia el color de la barra
    	call pintarBarra 						;pinta nuevamente la barra
    	pop CX 									;recupera el valor de CX, de la pila
    	salirMovBarrIzq:
    	ret
    endp
    ;convierte los segundos a string
    ;reinicia el contador de ciclos
    ;20 cilos = 1 seg
    segundos proc
    	push AX
    	inc tiempo
    	mov AX,tiempo
    	mov resultado,AX
    	call aString
    	mov ciclos,00h
    	pop AX
    	ret
    endp
    ;Obtiene el nombre de usuario
    obtUsuario proc
        ;Carga de usuario al buffer
        mov SI,00h                                  ;inicia el indice SI en 0
        guardarUsuario:
            mov AX,0000h                            ;limpia el registro AX
            mov AH,01h                              ;Asigna la funcion para leer un caracter de teclado
            int 21h                                 ;llama a la interrupcion
            
            mov usuario[SI],AL                  	;Guarda en el buffer en el indice SI, la tecla leida, guardada en AL
            inc SI                                  ;Se incrementa en 1 el indice SI
            
            ;Se Repite el Proceso de Carga Caracter
            ;por Caracter hasta que se Ingrese un Enter
            cmp AL,0Dh                              ;Compara si es un salto de linea
            je salirGuardarUsuario                 	;Si es salto de linea sale del loop
        loop guardarUsuario
        salirGuardarUsuario:
        dec SI                                      ;Resta uno a SI
        mov usuario[SI],0                       	;quita el salto de linea del buffer y deja un null (0) 
        mov AX,SI
        mov iUsuario,AL
        ret
    endp
    ;Obtiene la contraseña
    obtPass proc
    	inicioPass:
        ;Carga la password al buffer
        xor SI,SI                                   ;inicia el indice SI en 0
        mov CX,01h
        guardarPass:
            call pausa
            cmp CX,05
            jb largoMenor
            cmp AL,0Dh
            je contiGuarPass
            jmp passLargInco
            largoMenor:
            cmp AL,0Dh
            je passLargInco
            contiGuarPass:
            cmp AL,0Dh
            je caracterValid
            cmp AL,30h
            jb caracInva
            cmp AL,39h
            ja caracInva
            caracterValid:
            mov password[SI],AL                  	;Guarda en el buffer en el indice SI, la tecla leida, guardada en AL
            inc SI                                  ;Se incrementa en 1 el indice SI
            inc CX
            ;Se Repite el Proceso de Carga Caracter
            ;por Caracter hasta que se Ingrese un Enter
            cmp AL,0Dh                              ;Compara si es un salto de linea
            je salirGuardarPass                		;Si es salto de linea sale del loop
        jmp guardarPass
        passLargInco:
        imprimir saltoLin
        imprimir errPassLargInv
        imprimir saltoLin
        imprimir msgPass
        jmp inicioPass
        caracInva:
        imprimir saltoLin
        imprimir errCaraInvPass
        imprimir saltoLin
        imprimir msgPass
        jmp inicioPass
        salirGuardarPass:
        dec SI                                      ;Resta uno a SI
        mov password[SI],0                       	;quita el salto de linea del buffer y deja un null (0) 
        mov AX,SI
        mov iPass,AL
        ret
    endp
	;+++++++++++++++++++++++++++++++++++++++ Etiquetas +++++++++++++++++++++++++++++++++++++++++++
	;Menu principal de la aplicación
    menuPrin:
        mov blockDest,00h
        mov tiempo,00h
        mov puntos,00h
        mov filPel1,98h 						;fila inicial de la primer pelota 
        mov colPel1,09Fh 						;columna inicial de la primer pelota
        mov dirPel1,07h 						;Dirección de la pelota 1
        mov nivel,01h 							;primer nivel del juego
        mov posCI[0Ch],90h 						;Columna inicial de la barra
    	mov posCF[0Ch],0AEh 					;Columna final de la barra
    	mov posFI[0Ch],9Ah 						;Fila inicial de la barra
    	mov posFF[0Ch],9Dh 						;Fila final de la barra		
    	mov colBlock[0Ch],0Eh	
    	mov CXNivel,01h
    	mov DXNivel,1558h 
    	mov ciclosNivel,0Eh						
    	mov ciclos,01h				
        call limpPant
        imprimir stringEncabezado
        imprimir saltoLin
        imprimir saltoLin
        imprimir stringMenPri
        call pausa
        cmp AL,31h                         		;compara si es la opción uno 
        je  loginUsuario                        ;salta al login del usuario
        cmp AL,32h                              ;compara si es la opción dos
        je  registroUsuario                     ;si es la opción 2 salta al registro de usuario
        cmp AL,33h                              ;compara si es la opción tres
        je  salirApp                       		;si es la opción 3 sale de la aplicación
        jmp menuPrin                            ;Si no es ninguna opcion, se mantiene en el menu
    
    ;Login de usuario
    loginUsuario:
    	call limpPant
    	imprimir msgLogin
    	call obtUsuario 						;Obtiene el usuario ingresado
    	imprimir saltoLin
    	imprimir msgRestPass
    	imprimir msgPass
    	call obtPass 							;Obtiene la contraseña ingresado
    	jmp VerifLogin

    ;verificar Usuario y contraseña
    ;leyendo del archivo de usuarios
    ;cada usuario y comprobando con el que
    ;se ingreso
    VerifLogin:
    	mov UsuEnco,00h
    	mov tempBB,00h
    	lea DX,dirArchUsu 						;dirección del archivo usuarios
    	xor AL,AL 								;AL=0 Archivo en modo lectura 
    	call abrirArch 							;abrir en modo lectura el archivo
    	mov handle,AX
    	jc errorAbrArch 	                  	;Mostrar mensaje de error y salir
    	leerUsuario:
    	inc tempBB
    	mov usuCorr,00h 						;Bandera para el ingreso de usuario correcto
    	call buscarComa
    	cmp bandError,01h 						;compara si hubo error
    	je loginIncor    	 					;si lo hubo login incorrecto
    	verfUsuario:
    		xor AH,AH
    		mov AL,iUsuario
    		cmp SI,AX 							;compara largos de cadena
    		jne leerPass 						;si no son iguales ya no comprueba
    		mov CX,SI 							;ciclo del tamaño de la cadena leída
    		xor SI,SI
    		loopVerfUsuario:
    			mov AL,usuario[SI] 				
    			cmp stringTemp[SI],AL 			;compara caracteres de usuario ingresado y del leído
    			jne leerPass 					;si no son iguales salta a leer pass
    			inc SI 							;incrementa el índice
    		loop loopVerfUsuario
    		mov usuCorr,01h 					;bandera usuario correcto se prende
    		mov UsuEnco,01h
    	leerPass:
    		call buscarPuntoComa
    		cmp bandError,01h
    		je errorAbrArch 	
    	verfPass:
    		xor AH,AH
    		mov AL,iPass
    		cmp SI,AX 	 						;compara largos de cadena
    		jne leerUsuario 					;si no son iguales, ya no verifica. Siguiente usuario
    		mov CX,SI
    		xor SI,SI
    		loopVerfPass:
    			mov AL,password[SI] 			
    			cmp stringTemp[SI],AL 			;compara caracteres de la contraseña ingresada y de la leída
    			jne leerUsuario 				;si no son iguales, continua con el siguiente usuario
    			inc SI
    		loop loopVerfPass
    		cmp usuCorr,01h 					;si termina el ciclo, compara la bandera usuario correcto
    		jne leerUsuario 					;si no son iguales, continua con el siguiente usuario
    		mov BX,handle 						;si son iguales, cierra el archivo. Handle del archivo abierto
    		call cerrarArch 					;cierra el archivo
    		cmp tempBB,01h
    		je menuAdmin
    		jmp jugar 							;inicial el Juego
    	loginIncor:
    		mov BX,handle 						;Handle del archivo usuarios
    		call cerrarArch 					;cierra el archivo
    		call limpPant 		
    		cmp UsuEnco,01h
    		je passInco				
    		imprimir errUsuNoReg
    		jmp salirLogInc
    		passInco:
    		imprimir errLoginIncorr 			;Mensaje de login incorrecto
    		salirLogInc:
    		call pausa
    	jmp loginUsuario 						;volver a pedir el usuario
    ;Muestra el mensaje de error al abrir
    ;el archivo Usuarios.arq y regresa
    ;Al menú principal
    errorAbrArch:
    	call limpPant 							
    	imprimir errMsgAbrArch 	
    	mov BX,handle
    	call cerrarArch
    	call pausa
    	jmp menuPrin
    ;Etiqueta principal, lógica del juego
    jugar:
    	call modVid 							;Iniciar modo video
    	call pintarMarco 						;Pintar el marco del juego
    	call creaBlocks 						;Crea las posiciones, colores y estados de los bloques
    	call pintarBlocksNivel 					;Pintar los bloques del nivel actual
    	call pintarBarra 						;Pinta la barra
    	;Imprime el texto nivel en pantalla
    	imprimirModVid msgNivel,05h,05h,02h,07h 
    	;Imprime el nivel actual en pantalla
    	mov AH,nivel 
    	add AH,30h 								;Pasa el Nivel a código ASCII
    	mov tempBA,AH 
    	imprimirModVid tempBA,01h,06h,02h,07h
    	mov CL,iUsuario
    	xor CH,CH
    	imprimirModVid usuario,CX,0Ah,1Fh,0Bh
    	call limpBuffTecl 						;Limpiar el buffer de teclado
    	loopJuego:
    		mov AH,01h 							;Leer buffer de teclado
    		int 16h 							;Llamada a interrupción
    		cmp AL,1Bh 							;compara si se presionó la tecla ESC (ASCII 1Bh)
    		je  pausaJuego 						;salta a pausar el juego
    		playJuego:
    		cmp AH,4Bh 							;Compara si el código Hexa es 4Bh (flecha izquierda)
    		jne movDer 							;si no, salta a comparar si fue la flecha derecha
    		call moverBarraIzq 					;mueve la barra a la izquierda
    		movDer:
    		cmp AH,48h 							;compara si el código Hexa es 48h (flecha arriba)
    		jne noTeclaPress 					;si no es igual, se ignora la tecla
    		call moverBarraDer
    		noTeclaPress:
    		
	    	mov AL,filPel1 						
	    	mov AH,colPel1
	    	mov BL,03h
	    	call pintarPelota 					;pinta la pelota 1

	    	cmp nivel,02h 						;compara si el nivel actual es el 2
	    	jb delayMovimiento 					;si es menor no pinta la pelota 2
	    	mov DH,aparPel2
	    	cmp blockDest,DH
	    	jb delayMovimiento

	    	mov AL,filPel2 						
	    	mov AH,colPel2
	    	mov BL,0Ch
	    	call pintarPelota 					;pinta la pelota 2

	    	cmp nivel,03h 						;compara si el nivel actual es el 3
	    	jb delayMovimiento 					;si es menor no pinta la pelota 3
	    	mov DH,aparPel3
	    	cmp blockDest,DH
	    	jb delayMovimiento
	    	mov AL,filPel3 						
	    	mov AH,colPel3
	    	mov BL,0Eh
	    	call pintarPelota 					;pinta la pelota 3

	    	delayMovimiento:
	    	mov AH,86h 							;Función Wait
	    	mov CX,CXNivel						;Word Alta del tiempo en MicroSegundos
	    	mov DX,DXNivel 						;Word Baja del tiempo en MicroSegundos
	    	int 15H 							;Interrupción 15h, de Bios
	    	mov AL,filPel1
	    	mov AH,colPel1
	    	mov BL,00h
	    	call pintarPelota 					;despinta la pelota (pinta de negro)
	    	mov DL,dirPel1
	    	mov AL,filPel1
	    	mov AH,colPel1
	    	call moverPel 						;mueve la pelota 1
	    	mov filPel1,AL
	    	mov colPel1,AH
	    	mov dirPel1,DL
	    	cmp AL,0B3h 						;si la pelota sale por la parte inferior
	    	jae salirJuego 						;se sale del juego (el usuario perdió)
	    	cmp punteo,01h 						;comprueba si el usuario hizo puntos
	    	jne despintarPel2
	    	imprimirModVid NumAux,03h,01h,02h,05h
	    	despintarPel2:
	    	cmp nivel,02h 						;compara si el nivel actual es el 2
	    	jb contCiclos 						;si es menor, no despinta la pelota 2
	    	mov DH,aparPel2
	    	cmp blockDest,DH
	    	jb contCiclos
	    	mov AL,filPel2
	    	mov AH,colPel2
	    	mov BL,00h
	    	call pintarPelota 					;despinta la pelota (pinta de negro)
	    	mov DL,dirPel2
	    	mov AL,filPel2
	    	mov AH,colPel2
	    	call moverPel 						;mueve la pelota 2
	    	mov filPel2,AL
	    	mov colPel2,AH
	    	mov dirPel2,DL
	    	cmp AL,0B3h 						;si la pelota sale por la parte inferior
	    	jae salirJuego 						;se sale del juego (el usuario perdió)
	    	cmp punteo,01h 						;comprueba si el usuario hizo puntos
	    	jne despintarPel3					;sino no actualiza los puntos del usuario en pantalla
	    	;imprime los puntos del usuario
	    	imprimirModVid NumAux,03h,01h,02h,05h
	    	despintarPel3:
	    	cmp nivel,03h 						;compara si el nivel actual es el 2
	    	jb contCiclos 	 					;si es menor, no despinta la pelota 2
	    	mov DH,aparPel3
	    	cmp blockDest,DH
	    	jb contCiclos
	    	mov AL,filPel3
	    	mov AH,colPel3
	    	mov BL,00h
	    	call pintarPelota 					;despinta la pelota (pinta de negro)
	    	mov DL,dirPel3
	    	mov AL,filPel3
	    	mov AH,colPel3
	    	call moverPel 						;mueve la pelota 2
	    	mov filPel3,AL
	    	mov colPel3,AH
	    	mov dirPel3,DL
	    	cmp AL,0B3h 						;si la pelota sale por la parte inferior
	    	jae salirJuego 						;se sale del juego (el usuario perdió)
	    	cmp punteo,01h 						;comprueba si el usuario hizo puntos
	    	jne contCiclos 						;sino no actualiza los puntos del usuario en pantalla
	    	imprimirModVid NumAux,03h,01h,02h,05h
	    	;Al llegar a 20 ciclos
	    	;se cumple un segundo
	    	;Función Wait tarda 50 milisegundos
	    	;50*20 = 1000 milisegundos = 1 seg
	    	;se desprecia el tiempo de las
	    	;otras instrucciones, son muy 
	    	;pequeñas para tomar en cuenta
	    	contCiclos:
	    	mov AH,ciclosNivel
	    	cmp ciclos,AH 						;compara si llegó a 20 (14h) ciclos 
	    	jb verifGano 						;si no, continua sin acutalizar el tiempo en pantalla
	    	call segundos 						;convierte los segundos en string
	    	;actualiza los segundos
	    	;en pantalla
	    	imprimirModVid NumAux,03h,03h,02h,06h
	    	verifGano:
	    	inc ciclos
	    	cmp gano,01h 						;compara si la bandera gano está activa
	    	je SiguienteNivel 					;si lo está, cambia de nivel
	    	cmp AL,0B3h 						;compara si la pelota sale por la parte inferior
	    	jb loopJuego 						;sino continua el ciclo del juego
	    salirJuego:
	    cmp gano,01h
	    je saleJuegoGanado
	    imprimirModVid msgDerrota,07h,00h,0Ah,0Fh
	    saleJuegoGanado:
	    call limpBuffTecl
    	call pausa
    	cmp AL,20h
    	jne saleJuegoGanado
    	call archEst
    	jmp menuPrin
    ;Genera una pausa en el juego
    pausaJuego:
    	call limpBuffTecl
    	call pausa
    	cmp AL,1Bh 								;Si es la tecla ESC, sale de la pausa
    	je playJuego
    	cmp AL,20h
    	je menuPrin
    	jmp pausaJuego
    ;Sube al siguiente nivel del juego
    SiguienteNivel:
    	mov blockDest,00h
    	call limpBuffTecl 						;limpia el buffer del teclado
    	inc nivel
    	cmp nivel,04h 							;compara si el siguiente nivel es 3
    	je juegoGanado 							;si lo es, muestra el mensaje VICTORIA
    	;Actualiza el nivel del juego
    	;en pantalla
    	mov AH,nivel
    	add AH,30h
    	mov tempBA,AH
    	imprimirModVid tempBA,01h,06h,02h,07h
    	call creaBlocks 						;Habilita los bloques del nivel actual
    	call pintarBlocksNivel 					;pinta los bloques del nivel actual
    	;posiciona las pelotas
    	mov filPel1,60h 						
    	mov colPel1,09Fh
    	mov dirPel1,07h
    	mov filPel2,98h
    	mov colPel2,09Fh
    	mov dirPel2,01h
    	mov filPel3,60h
    	mov colPel3,09Fh
    	mov dirPel3,07h
    	cmp nivel,02h
    	ja tiempoNivel3
    	mov aparPel2,05h
    	mov CXNivel,00h
    	mov DXNivel,0C350h 
    	mov ciclosNivel,14h
    	jmp contJuego
    	tiempoNivel3:
    	mov aparPel2,04h
    	mov aparPel3,08h
    	mov CXNivel,00h
    	mov DXNivel,9088h 
    	mov ciclosNivel,1Bh
    	contJuego:
    	call pausa
    	jmp loopJuego 							;continua el juego
    ;Mensaje de Juego Ganado
    juegoGanado:
    	call limpBuffTecl          				;Limpiar el buffer de teclado
    	imprimirModVid msgVictoria,08h,00h,0Ah,05h
    	jmp salirJuego

    ;Sesión de Administrador
    menuAdmin:
    	call cargEstat
    	call ordenarPuntos
    	call ordenarTiempos
    	call limpPant
        imprimir stringMenAdm
        call pausa
        cmp AL,31h                         		;compara si es la opción uno 
        je  tops 		                        ;salta a motrar Top 10 puntos
        cmp AL,32h                              ;compara si es la opción dos
        je  tops 		                    	;si es la opción 2 salta a motrar Top 10 tiempo
        cmp AL,33h                              ;compara si es la opción tres
        je  menuPrin                       		;si es la opción 3 regresa al menú principal
    jmp menuAdmin
    ;Muestra el Top 10
    tops:
    	cmp AL,31h
    	jne topTiempo
    	mov reporteVer,00h
    	jmp verRepo
    	topTiempo:
    	mov reporteVer,01h
    	verRepo:
    	call limpPant
    	imprimir msgUsuario
    	imprimir tab
    	imprimir tab
    	imprimir msgPuntos
    	imprimir tab
    	imprimir tab
    	imprimir msgTiempo
    	imprimir tab
    	imprimir tab
    	imprimir msgNivel
    	imprimir saltoLin
    	call mostrarRepo
    	call pausa
    jmp menuAdmin
    ;Registro de nuevos usuarios
    registroUsuario:
    	call limpPant
    	imprimir msgLogin
    	call obtUsuario 						;Obtiene el usuario ingresado
    	imprimir saltoLin
    	imprimir msgRestPass
    	imprimir msgPass
    	call obtPass 							;Obtiene la contraseña ingresado
    	lea DX,dirArchUsu
    	mov AL,01h 								;AL=01h modo escritura
    	call abrirArch 							;Abre el archivo usuario en modo escritura
    	jc errorAbrArch 	 					;Si hubo error salta a mostrar error
    	mov BX,AX  								;mover handle a BX
    	mov AL,02h 								;Mover puntero de archivo desde el final
    	xor CX,CX 								;Word alta, desplazamiento
    	mov DX,00h 								;Word baja, desplazamiento
    	call moverPuntArch 						;mover el puntero
    	jc errorAbrArch 	 					;si hubo error saltar a mostrar error
    	escArch saltoLin,02h 					;Escribe un salto del línea en el archivo
    	xor AH,AH 								
    	mov AL,iUsuario 						;AX: largo del nombre de usuario
    	mov tempWA,AX 							;tempWA largo del nombre de usuario
    	escArch usuario,tempWA 					;Escribe el usuario en el archivo
    	escArch coma,01h 						;agrega una coma despues del usuario
    	xor AH,AH
    	mov AL,iPass 							;AX: largo de la contraseña de usuario
    	mov tempWA,AX 							;tempWA largo del nombre de usuario
    	escArch password,tempWA 				;escribe la contraseña en el archivo
    	escArch puntCom,01h 					;agrega el punto y como despues de la contraseña
    	call cerrarArch 						;cierra el archivo
    	call limpPant 				
    	imprimir msgRegExi 						;Mensaje registro exitoso
    	call pausa
    	jmp menuPrin
	;+++++++++++++++++++++++++++++++++++ Etiqueta Principal ++++++++++++++++++++++++++++++++++++++
start:
	;Iniciar los Registros 
    mov AX, data
    mov DS, AX
    mov AX, 0A000h                              ;apunta segmento de memoria de video, ES = A000h 
    mov ES, AX

    call menuPrin 								;Salta al menú principal
    salirApp:
    imprimir pkey 								;Muestra el mensaje de Salida        								
       
    mov AH,01h 									;Lectura de tecla
    int 21h
    
    mov AX, 4C00h 								;Salir al sistema operativo
    int 21h    
ends
end start