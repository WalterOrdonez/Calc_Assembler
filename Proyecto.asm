;-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. SEGMENTO DE DATOS -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
data segment
	;++++++++++++++++++++++++++++++++++++++++ Mensajes +++++++++++++++++++++++++++++++++++++++++++
    pkey db "Adios...$"
    ;++++++++++++++++++++++++++++++++++++ Mensajes de Error ++++++++++++++++++++++++++++++++++++++

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
    ;+++++++++++++++++++++++++++++++++++++++ Variables +++++++++++++++++++++++++++++++++++++++++++ 
    ;......................................... Número ............................................
    ;......................................... String ............................................
    ;......................................... Vector ............................................
    ;......................................... Indice ............................................

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
    ;Abrir Archivo en modo lectura
    ;DS:DX: direccion del nombre del archivo
    ;Carry Flag en cero sin error
    ;AX = manejador de archivo
    ;Carry Flag en 1 con error
    ;AX = codigo de error
    abrirArch proc
        mov AX,3D00h                            ;abrir un archivo AL=0 modo lectura; AH=3D abrir archivo
        int 21h
        ret
    endp
    ;Cerrar el archivo handle como parametro
    cerrarArch proc
        mov ah,3eh                              ;Peticion para salir
        int 21h
        ret
    endp
	;+++++++++++++++++++++++++++++++++++++++ Etiquetas +++++++++++++++++++++++++++++++++++++++++++
	;Menu principal de la aplicación
    menuPrin proc
    	iniMenuPrin:
        call limpPant
        imprimir stringEncabezado
        imprimir saltoLin
        imprimir saltoLin
        imprimir stringMenPri
        call pausa
        cmp AL,31h                         		;compara si es la opción uno 
        ;je  ingDir                              ;salta a Ingresar la dirección de la imagen
        cmp AL,32h                              ;compara si es la opción dos
        ;je  salirApp                            ;si es la opción 2 salta a la salida de la aplicación
        cmp AL,33h                              ;compara si es la opción dos
        je  salirMenuPrin                       ;si es la opción 2 salta a la salida de la aplicación
        jmp iniMenuPrin                         ;Si no es ninguna opcion, se mantiene en el menu
        salirMenuPrin:
        ret
    endp
	;++++++++++++++++++++++++++++++++++++++++ Reporte ++++++++++++++++++++++++++++++++++++++++++++

	;+++++++++++++++++++++++++++++++++++ Etiqueta Principal ++++++++++++++++++++++++++++++++++++++
start:
	;Iniciar los Registros 
    mov AX, data
    mov DS, AX
    mov AX, 0A000h                              ;apunta segmento de memoria de video, ES = A000h 
    mov ES, AX
    

    call menuPrin 								;Salta al menú principal

    imprimir pkey 								;Muestra el mensaje de Salida        								
       
    mov AH,01h 									;Lectura de tecla
    int 21h
    
    mov AX, 4C00h 								;Salir al sistema operativo
    int 21h    
ends
end start
