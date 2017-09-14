; multi-segment executable file template.

data segment
    pkey                db "Programa finalizado...$"
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$" 

    ;string del encabezado principal
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
    ;String del menu leer archivo
    strEncLeerArchivo   db "---------------------------------CARGAR ARCHIVO--------------------------------",0Dh,0Ah
                        db "Ingrese la direcci",0A2h,"n del archivo: ",0Dh,0Ah
                        db 22h,"El formato de la direcci",0A2h,"n es ##<direccion>.arq##",22h,"$"

    ;mensaje de error, formato de la direccion invalido
    erForInvDir         db "El formato de la direccion no es correcta",0Dh,0Ah
                        db "El formato correcto es ##<Direccion>##","$"
    
    ;mensaje de error al abrir el archivo
    erAbrArch           db "El archivo buscado no se encuentra...","$"

    ;Direccion del archivo
    pathArchivo         db 50 dup(0)
    ;Dirección del archivo de reporte
    pathArchivoRep      db 50 dup(0)
    ;datos del archivo
    datosArchivo        db 1000 dup(0)
ends

stack segment
    dw   128  dup(0)
ends

code segment
    ;Macro para imprimir una cadena, recibe un parametro
    imprimir macro str
        mov AH,09h                                  ;funcion para imprimir en pantalla
        mov DX,offset str
        int 21H
    endm

    ;Compara sí es una la tecla presionada
    esTecla macro tecla
        call pausa                                  ;llama a la interrupción para esperar una tecla
        cmp AL,offset tecla                         ;compara si el valor ingresado es la tecla del parametro
    endm

    ;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    pausa:
        mov AH, 07h                                 ;funcion 7, obtener caracter de pantalla, sin imprimir en pantalla(echo)
        int 21h                                     ;se llama a la interrupcion
    ret

    ;Limpia la pantalla, modo texto
    limpPant:
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

    ;muestra en la opción Leer Archivo
    leerArchivo:
        call limpPant
        imprimir strEncLeerArchivo
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
        mov DX, offset archivo                      ;offset lugar de memoria donde esta la variable
        mov AH, 3Dh                                 ;se intenta abrir el archivo
        int 21h                                     ;llamada a la interrupcion DOS
        jc  error                                   ; si se prendio la bandera c ir a error
        mov [handle], AX                            ;si no paso, mover a lo que le dio el SO
        
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
        call validaArchivo
        cmp hayError,0
        ja  menuPrin
        jmp menuOpe
        error:
            imprimir erAbrArch                      ;Muestra el mensaje de error al cargar el archivo  
            call pausa
            jmp menuPrin

    ;Valida el Archivo, que no tenga errores
    validaArchivo proc
        mov SI,00h                                  ;inicia el indice SI en 0    
        loopValidar:
            
            cmp datosArchivo[SI],20h                ;compara si es un espacio
            je  incSILoopValidar                    ;si es espacio sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],09h                ;compara si es una tabulacion
            je  incSILoopValidar                    ;si es tabulacion sigue con la siguiente iteracion 
            
            cmp datosArchivo[SI],0Dh                ;compara si es Retorno de carro
            je  incSILoopValidar                    ;si es retorno de carro sigue con la siguiente iteracion
            
            cmp datosArchivo[SI],0Ah                ;compara si es Nueva linea
            je  incSILoopValidar                    ;si es nueva linea continua con el loop
            
            cmp datosArchivo[SI],00h                ;Salta si es NULL, sale y valida el fin de archivo
            je  salirValidar
            
            cmp finArchivo,00h                      ;Si no es fin de archivo y está levantada la bandera
            ja  errorFinArchivo                     ;salta a error que no finalizo el archivo despues de ;
            
            cmp datosArchivo[SI],2Bh                ;Salta si es + a validar los numeros
            je incSILoopValidar
                
            cmp datosArchivo[SI],3Bh                ;Salta si es punto y coma, y levanta la bandera
            je validarFinArchivo    
            
            call errorCaracter                      ;Cualquier otra opción es un error
            
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
;Etiqueta Principal 
start:
    ; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    jmp menuPrin
            
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
