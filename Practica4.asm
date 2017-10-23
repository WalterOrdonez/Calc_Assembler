; multi-segment executable file template.

data segment
    ;+++++++++++++++++++++++++++++++++++++++++++++ Mensajes ++++++++++++++++++++++++++++++++++++++++++++++
    pkey                db "Adios...$"
    ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"
    ;String ingresar dirección de bmp
    msgIngDir           db "Ingrese la direcci",0A2h,"n de la imagen BMP:",0Dh,0Ah,"$"
    strRepCre           db "Reporte Creado con Exito",0Dh,0Ah,"$"
    ;+++++++++++++++++++++++++++++++++++++++++ Mensajes de Error +++++++++++++++++++++++++++++++++++++++++
    msgErInvBMP         db "Archivo BMP invalido.",7,0Dh,0Ah,24h
    msgErAbrBMP         db "Error al abrir archivo.",7,0Dh,0Ah,24h
    ;mensaje de error al crear el archivo            
    erCreArch           db "No se pudo crear el archivo de Reporte","$"
    ;++++++++++++++++++++++++++++ String del encabezado y menús ++++++++++++++++++++++++++++++++++++++++++ 
    stringEncabezado    db "Universidad de San Carlos de Guatemala",0Dh,0Ah
                        db "Facultad de Ingenieria",0Dh,0Ah
                        db "Escuela de Ciencias y Sistemas",0Dh,0Ah
                        db "Arquitectura de computadores Y Ensambladores 1 A",0Dh,0Ah
                        db "Segundo Semestre 2017",0Dh,0Ah
                        db "Walter Alfredo Ordo",0A4h,"ez Garc",0A1h,"a",0Dh,0Ah
                        db "2007-14802",0Dh,0Ah
                        db "CUARTA PRACTICA",0Dh,0Ah,"$"
    stringMenPri        db "---------------------------------MENU PRINCIPAL--------------------------------",0Dh,0Ah
                        db "1- Imagen BMP",0Dh,0Ah          
                        db "2- Salir",0Dh,0Ah,"$"
    stringMenOpe        db "--------------------------------MENU OPERACIONES-------------------------------",0Dh,0Ah
                        db "1- Ver Imagen",0Dh,0Ah          
                        db "2- Girar",0Dh,0Ah
                        db "3- Voltear",0Dh,0Ah
                        db "4- Escala de Grises",0Dh,0Ah
                        db "5- Brillo",0Dh,0Ah
                        db "6- Negativo",0Dh,0Ah
                        db "7- Reporte",0Dh,0Ah
                        db "8- Salir",0Dh,0Ah,"$"
    stringMenGir        db "-----------------------------------MENU GIRAR---------------------------------",0Dh,0Ah
                        db "1- 90",0xF8," Derecha",0Dh,0Ah          
                        db "2- 90",0xF8," Izquierda",0Dh,0Ah
                        db "3- 180",0xF8,0Dh,0Ah,"$"
    stringMenVol        db "----------------------------------MENU VOLTEAR--------------------------------",0Dh,0Ah
                        db "1- Horizontalmente",0Dh,0Ah          
                        db "2- Verticalmente","$"
    ;++++++++++++++++++++++++++++++++++++++++++++++++++ Variables +++++++++++++++++++++++++++++++++++++++++
    iPathArchivo        db 0
    iBuffImg            dw 0
    filasOr             dw 0
    columnasOr          dw 0
    ancho               dw 0
    handle              dw ?
    header              dw ?
    bufferImg           db ?
    HeadBuff            db 54 dup('H')
    palBuff             db 1024 dup('P')
    ScrLine             db 320 dup(0)

    BMPStart            db 'BM'
    tamArch             dd 0
    PalSize             dw ?
    BMPHeight           dw ?
    BMPWidth            dw ?
    pathArchivo         db 20 dup(0)
    ruta                db "IMG.bmp",0
    temp                dw 0
    opcGrafi            db 0
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
    ;identificador del archivo de reporte 
    handleRep           dw ?
    NumAux              db 5 dup("$")
    ;Dirección del archivo de reporte
    pathArchivoRep      db "Reporte.rep",00h
    resultado           dw 0
;++++++++++++++++++++++++++++++++++++++++ String Reporte +++++++++++++++++++++++++++++++++++++++++
    strRepHor           db "Hora: ","$"
    strRepFec           db "Fecha: ","$"
    strRepDP            db " : "
    strRepD             db " / "
    strRepNomBMP        db "Nombre de la Imagen: ","$"
    strRepAncho         db "Ancho de la Imagen: ","$"
    strRepAlto          db "Alto de la Imagen: ","$"
    strRepTam           db "Tama",0xA4,"o de la Imagen: ","$"
    strRepPix           db " pixeles","$"
    strRepByte          db " Bytes","$"

ends

stack segment
    dw   128  dup(0)
ends

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
    aString proc
        mov AX,resultado                            ;inicia AX con el resultado
        mov DX,resultado                            ;inicia DX con el resultado
        xor SI,SI                                   ;inicia SI en 0
        cmp resultado,2710h                         ;compara si el resultado con 10,000
        jb  uMiles                                  ;si es menor salta a las Unidades de Mil
        xor DX,DX                                   ;si no, inicia DX en 0
        mov BX,2710h                                ;Guarda 10,000 en BX
        idiv BX                                     ;divide el resultado entre 10,000
        add AX,30h                                  ;toma el cociente le agrega 30, pasa a ASCII
        mov NumAux[SI],AL                           ;agrega el digito en la variable numero auxiliar
        inc SI                                      ;incrementa SI
        mov AX,DX 
        uMiles:
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
        mov AX,SI
        mov iPathArchivo,AL
        ret
    endp
    ; Inicia Modo Video
    ; registro ES apunta a la memoria de video
    modVid proc
        mov AX,13h                                  ;modo video 13h, 320x200x256
        int 10h
        mov AX, 0A000h                              ;apunta segmento de memoria de video, ES = A000h 
        mov ES, AX
        ret
    endp
    ;Abrir Archivo en modo lectura
    ;DS:DX: direccion del nombre del archivo
    abrirModLec proc
        mov AX,3D00h                                ;abrir un archivo AL=0 modo lectura; AH=3D abrir archivo
        int 21h
        ;CF Carry Flag en cero (operacion exitosa)
        ;con AX = manejador de archivo.
        ;CF Carry Flag en 1 (operacion fallida)
        ;con AX = codigo de error.
        ret
    endp
    ;Cerrar el archivo handle como parametro
    cerrarArch proc
        mov ah,3eh                                  ;Peticion para salir
        int 21h
        ret
    endp
    ; Este procedimiento revisa el encabezado del archivo para 
    ; asegurarse de que es un archivo tipo BMP valido
    ; y obtiene la informacion necesaria del mismo.
    leerHeader proc
        xor SI,SI
        mov BX,handle                               ;handle del archivo BMP
        mov AH,3fh                                  ;lectura de archivo
        mov CX,36h                                  ;54 (36h) bytes a leer
        mov DX,offset header                        ;buffer para el encabezado
        int 21h
        jc salirLeeH                                ;Si hay error en el encabezado, salir
        mov AX,header[02h]
        mov tamArch[SI],AX
        inc SI
        inc SI
        mov AX,header[04h]
        mov tamArch[SI],AX

                                                    ;lee el byte 0Ah del header, direccion donde
        mov AX,header[0Ah]                          ;inician los datos de cada pixel 
        sub AX,36h                                  ;Restar la longitud del encabezado de la imagen
        shr AX,2                                    ;Dividir el resultado entre 4
        
        mov PalSize,AX                              ;Obtener el numero de colores del BMP
        
        mov AX,header[12h]
        mov BMPWidth,AX                             ; Guardar el ancho del BMP en BMPWidth
        
        mov AX,header[16h]    
        mov BMPHeight,AX                            ; Guardar la altura del BMP en BMPHeight

        salirLeeH:
        ret
    endp
    ; Recorre el buffer de la paleta y 
    ; envia informacion de la paleta a los registros de 
    ; video. Se envia un byte a traves del puerto 3C8h que 
    ; contiene el primer indice a modificar de la paleta  
    ; de colores. Despues, se envia informacion acerca de 
    ; los colores (RGB) a traves del puerto 3C9h
    ReadPal proc
        mov BX,handle                               ;handle del archivo BMP
        
        mov AH,3fh 
        mov CX,PalSize                              ;Numero de colores de la paleta en CX
        shl CX,2                                    ;multiplicar por 4, tamaño en bytes
        mov DX,offset palBuff                       ;Poner la paleta en el buffer
        int 21h

        
        mov SI,offset palBuff                       ;SI apunta al buffer que contiene a la paleta
        mov CX,PalSize                              ;Numero de colores a enviar en CX
        mov DX,3c8h                             
        mov AL,00h                                  ;Comenzar en el color 0
        out DX,AL
        inc DX                                      ;DX = 3C9h
        LoopLeerPal:
            ;Los colores en un archivo BMP se guardan como
            ;BGR y no como RGB
            mov AL,[SI+2]                           ;Obtener el valor para el rojo
            ;El maximo permitido es 255
            ;modo video permite valores hasta 63
            ;dividir entre 4 para un valor valido
            shr AL,2
            cmp opcGrafi,08h
            jne rojoNeg
            add AL,16h
            cmp AL,3FH
            jbe rojoNormal
            mov AL,3FH
            rojoNeg:
            cmp opcGrafi,09h
            jne rojoNormal
            not AL
            rojoNormal:
            out DX,AL                               ;Mandar el valor del rojo por el puerto 3C9h
            mov AL,[SI+1]                           ;Obtener el valor para el verde
            shr AL,2                                ;Obtener el valor para el verde
            cmp opcGrafi,08h
            jne verdeNeg
            add AL,16h
            cmp AL,3FH
            jbe verdeNormal
            mov AL,3FH
            verdeNeg:
            cmp opcGrafi,09h
            jne verdeNormal
            not AL
            verdeNormal:
            out DX,AL                               ;Mandar el valor del verde por el puerto
            mov AL,[si]                             ;Obtener el valor para el azul
            shr AL,2
            cmp opcGrafi,08h
            jne azulNeg
            add AL,16h
            cmp AL,3Fh
            jbe azulNormal
            mov AL,3Fh
            azulNeg:
            cmp opcGrafi,09h
            jne azulNormal
            not AL
            azulNormal:
            out DX,AL                               ;Enviarlo por el puerto
            add SI,04h                              ;Apuntar al siguiente color
                                                    ;se avanzan cuatro, por el caracter nulo al final del color
        loop LoopLeerPal
        ret
    endp

    ;Recorre la memoria, obteniendo los datos a pintar
    ;la imagen se almacena de abajo hacia arriba
    LoadBMP proc
        mov temp,01h
        cmp opcGrafi,07h                            ;compara si es la opción 7
        jne imgNormal                               ;si no lo es sigue
        mov AX,101Bh                                ;si es, cambia la paleta de colores, a grises
        xor BX,BX                                   ;color donde inicia
        mov CX,255                                  ;numero de colores a cambiar
        int 10h
        imgNormal:
        mov BX,handle                               ;handle del archivo BMP
        mov CX,BMPHeight                            ;Numero de lineas a desplegar
        LoopImpLinea:
            push CX
            cmp opcGrafi,04h                        ;compara si es la opción 4
            je  calcDI                              ;si es, rota 180, usando temp en lugar de CX
            cmp opcGrafi,06h                        ;compara si es la opción 6
            je  calcDI                              ;si es, voltea Verticalmente usandando temp
            mov temp,CX                             ;si no es ninguna, usa CX, para las demas opciones
            calcDI:
            push temp
            mov DI,temp                             ; Hacer una copia de CX en DI
            shl temp,6                              ; Multiplicar CX por 64
            shl DI,8                                ; Multiplicar DI por 256
            ;DI apunta al primer pixel
            ;de la linea deseada en la pantalla
            add DI,temp                             ;DI = CX * 320
            lineaBuff:
            ;Copia del archivo bmp una linea
            ;en un buffer temporal (SrcLine).
            mov     AH,3fh                          ;lee del archivo
            mov     CX,BMPWidth                     ;cantidad de pixeles el ancho de la imagen
            mov     DX,offset ScrLine               ;buffer donde se guardará
            int     21h                             ;Colocar una linea de la imagen en el buffer

            ;Limpiar la bandera de 
            ;direccion par usar movsb
            cld                                     ;limpiar la bandera Dirección DF=0
            mov CX,BMPWidth                         ;inicia CX con ancho de bandera
            mov SI,offset ScrLine                   ;SI en el buffer
            cmp opcGrafi,04h                        ;compara si es la opción 4, 180 grados
            je  dereIzq                             ;si es, salta a leer de derecha a izquierda
            cmp opcGrafi,05h                        ;compara si es la opción 5, voltea Horiz
            jne loopRot                             ;si no es, lee de izquierda a derecha
            dereIzq:                                ;lee de dereca a izquierda el buffer
            add SI,BMPWidth
            dec SI
            loopRot:
            ; Instruccion movsb: 
            ; Mover el byte en la direccion DS:SI a la direccion 
            ; ES:DI. Despues de esto, los registros SI y DI se 
            ; incrementan o decrementan automaticamente de acuerdo
            ; con el valor que contiene la bandera de direccion
            ; (DF). Si la bandera DF esta puesta en 0, los 
            ; registros SI y DI se incrementan en 1. Si la bandera 
            ; DF esta puesta en 1, los registros SI y DI se
            ; decrementan en 1.

            ; Instruccion rep: repite cx times una operacion
            ; Copiar en la pantalla la linea que esta en el buffer
            
            cmp opcGrafi,04h                        ;compara si es la opción 4, 180 grados
            je  rot180                              ;si es, salta a 180
            cmp opcGrafi,05h                        ;compara si es la opción 5, volt Horiz
            jne voltNormal                          ;si no es ninguna, dibuja normal la imagen
            rot180:
            mov AL,[SI]                             ;mueve DS:SI a AL
            mov ES:[DI],AL                          ;mueve AL a ES:DI
            dec SI                                  ;decrementa SI
            inc DI                                  ;incrementa DI
            jmp salirLoopRot
            ;rep movsb
            voltNormal:
            movsb                                   ;mueve DS:SI a ES:DI incrementa SI y DI
            salirLoopRot:
            loop loopRot                            
            pop CX
            mov temp,CX                            ;Saca el valor de temp original
            pop CX                                 ;Regresar el valor guardado de CX
            inc temp                               ;incrementa temp
        loop LoopImpLinea
        ret
    endp
    ;Recorre la memoria, obteniendo los datos a pintar
    ;la imagen se almacena de abajo hacia arriba
    LoadBMPRot proc
        ; Numero de lineas a desplegar
        mov     cx,BMPHeight
        mov iBuffImg,00h
        mov filasOr,0
        mov columnasOr,0
        loopFil:
            push    cx
            ; Copia del archivo bmp una linea de la imagen en un
            ; buffer temporal (SrcLine).
            mov     ah,3fh
            mov     cx,BMPWidth
            mov     dx,offset ScrLine
            ; Colocar una linea de la imagen en el buffer
            int     21h

            mov     cx,BMPWidth
            mov     si,offset ScrLine
            cmp CX,0C8h
            jbe loopCol
            mov CX,0C8h
            loopCol:
                mov AL,[SI]                             ;mueve DS:SI a AL, byte que representa el pixel

                cmp opcGrafi,03h                        ;
                je rotIzq
                mov DX,ColumnasOr
                mov DI,DX
                shl DX,06h
                shl DI,08h
                add DI,DX
                add DI,filasOr
                jmp PasarMemVideo
                rotIzq:
                mov DX,0C8h
                sub DX,ColumnasOr
                mov DI,DX
                shl DX,06h
                shl DI,08h
                add DI,DX
                mov DX,BMPHeight
                sub DX,filasOr
                add DI,DX
                PasarMemVideo:
                mov ES:[DI],AL                          ;mueve AL a ES:DI
                inc SI                                  ;decrementa SI
                inc ColumnasOr
            loop loopCol
            salirLoopFilas:
            mov columnasOr,00h
            inc filasOr
            pop     cx
        loop    loopFil
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
    menuPrin:
        call limpPant
        imprimir stringEncabezado
        imprimir saltoLin
        imprimir saltoLin
        imprimir stringMenPri
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        je  ingDir                                  ;salta a Ingresar la dirección de la imagen
        cmp AL,32h                                  ;compara si es la opción dos
        je  salirApp                                ;si es la opción 2 salta a la salida de la aplicación
        jmp menuPrin                                ;Si no es ninguna opcion, se mantiene en el menu

    menuOpe:
        mov opcGrafi,01h                            
        call limpPant
        imprimir stringMenOpe
        call pausa
        cmp AL,31h                                  ;compara si es la opción uno 
        je  llamaMosImag                            ;salta a mostrar la imagen
        cmp AL,32h                                  ;compara si es la opción dos
        je  menGira                                 ;salta a Menú Girar
        inc opcGrafi
        cmp AL,33h                                  ;compara si es la opción tres
        je  menVolt                                 ;salta a Menú voltear
        mov opcGrafi,07h
        cmp AL,34h                                  ;compara si es la opción cuatro
        je  llamaMosImag                            ;salta a mostrar la imagen
        mov opcGrafi,08h
        cmp AL,35h                                  ;compara si es la opción cinco 
        je  llamaMosImag                            ;salta a mostrar la imagen
        mov opcGrafi,09h
        cmp AL,36h                                  ;compara si es la opción seis
        je  llamaMosImag                            ;salta a mostrar la imagen
        cmp AL,37h                                  ;compara si es la opción siete
        je  Reporte                                 ;salta a la generación de reporte
        cmp AL,38h                                  ;compara si es la opción ocho
        je  menuPrin                                ;salta a Menú principal
        jmp menuOpe                                 ;si no es ninguna, muestra el menú operaciones 
        llamaMosImag:
        call mosImagen                              ;llamada al método mostrar imagen
        jmp menuOpe                                 ;al terminar el método mostrar imagen, muestra el menú

    ;Menú con la opciones de Girar
    menGira:
        mov opcGrafi,02h                            ;establece la opción a graficar en 2, Girar Derecha
        call limpPant
        imprimir stringMenGir
        call pausa                                  ;captura la tecla presionada
        cmp AL,31h                                  ;compara la tecla presionada con 1 en ASCII
        je llamaMosImg                              ;si es la tecla 1, llama el método mostrar imagen
        inc opcGrafi                                ;establece la opción a graficar en 3, Girar Izquierda
        cmp AL,32h                                  ;compara la tecla presionada con 2 en ASCII
        je llamaMosImg                              ;si es la tecla 2, llama el método motrar imagen
        inc opcGrafi                                ;establece la opción a graficar en 4, Girar 180
        cmp AL,33h                                  ;si es la tecla 3, llama el método mostrar imagen
        je llamaMosImg                              ;si es la tecla 3, llama el método motrar imagen
        cmp AL,67h                                  ;compara la tecla presionada con G
        je menuOpe                                  ;si es la tecla G, regresa al menú operaciones
        jmp menGira                                 ;si no es ninguna de las teclas anteriores, muestra nuevamente el menú
        llamaMosImg:
        call mosImagen                              ;llamada al método mostrar imagen
        jmp menGira
    ;Menú con las opciones de votear
    menVolt:
        mov opcGrafi,05h                            ;establece la opción a graficar en 5, voltear 
        call limpPant
        imprimir stringMenVol
        call pausa                                  ;captura la tecla presionada
        cmp AL,31h                                  ;compara si la tecla es 1 en ASCII
        je  llamaMosIg                              ;si es la tecla 1, llama al método mostrar imagen
        inc opcGrafi                                ;si no incrementa la opción a graficar
        cmp AL,32h                                  ;compara si la tecla es 2 en ASCII
        je  llamaMosIg                              ;si es la tecla 2, llama al método mostrar imagen
        cmp AL,76h                                  ;compara si la tecla es V en ASCII
        je  menuOpe                                 ;si es la tecla V, regresa al menú Operaciones 
        jmp menVolt                                 ;cualquier otra tecla, muestra nuevamente el menú voltear 
        llamaMosIg:
        call mosImagen                              ;llamada al metodo mostrar imagen
        jmp menVolt                                 ;al terminar el metodo mostrar imagen, muestra el menú voltear 
    ;petición y verificación del path
    ingDir:
        call limpPant                               
        imprimir msgIngDir
        call obtDirArch                             ;llamada al metodo obtener dirección
        jmp verifPath                               ;salta a verificar la dirección ingresada
    ;metodo para verificar el path
    verifPath:
        dec SI
        cmp pathArchivo[SI],70h                     ;compara si el último caracter es P
        jne ingDir                                  ;si no lo es muestra error
        dec SI                                      
        cmp pathArchivo[SI],6Dh                     ;compara si el caracter es M
        jne ingDir                                  ;si no es muestra error
        dec SI
        cmp pathArchivo[SI],62h                     ;compara si el caracter es B
        jne ingDir                                  ;si no es muestra error
        dec SI                                      
        cmp pathArchivo[SI],2Eh                     ;compara si el caracter es el .
        jne ingDir                                  ;si no es igual muestra error
        jmp menuOpe                                 ;si llega a este punto, muestra el menú de operaciones

    ;Mostrar imagen
    mosImagen proc
        call modVid                                 ;modo video resolucion de 320x200
        lea DX,pathArchivo                          ;Ruta de la imagen

        ; Guardar los registros en la pila
        push AX
        push CX
        push DX
        push BX
        push SP
        push BP
        push SI
        push DI
      
        call abrirModLec                            ;Abrir el archivo        
        jc errorAbrirIMG                            ;Mostrar mensaje de error y salir
        mov handle,AX                               ;Colocar el manejador del archivo en BX
        call leerHeader                             ;Leer el encabezado con la información del BMp
        jc InvalidBMP                               ;mostrar mensaje error, BMP invalido
        call ReadPal                                ;Leer la paleta del BMP y cargarla en el buffer
        push ES                                     ;Guardar el Extra Segment en la Pila
        cmp opcGrafi,03h                            ;Compara si la opción seleccionada fue la 3, Rotar Derecha
        je  rotada                                  ;si es igual, salta a rotada
        cmp opcGrafi,02h                            ;compara si la opción seleccionada fue la 2, Rotar izquierda
        jne cargaNormal                             ;si no es igual salta a la carga normal de la imagen
        rotada:
        call LoadBMPRot                             ;llama al metodo para rotar la imagen, izquierda o derecha
        jmp finCarga                                ;al terminar salta a cerrar el archivo
        cargaNormal:
        call LoadBMP                                ;Cargar la imagen y desplegarla
        finCarga:
        pop ES

        ; Cerrar el archivo
        mov BX,handle
        call cerrarArch
        jmp ProcDone

        errorAbrirIMG:
        imprimir msgErAbrBMP                        ;imprime en pantalla el mensaje de error, al abrir el archivo
        jmp ProcDone

        InvalidBMP:
        imprimir msgErInvBMP                        ;imprime en pantalla el mensaje de que es un BMP invalido
        jmp ProcDone

        ProcDone:
        ; Restaurar los registros
        pop DI
        pop SI
        pop BP
        pop SP
        pop BX
        pop DX
        pop CX
        pop AX
        call pausa                                  ;hace una pausa, espera el ingreso de una tecla
        call limpPant
        ret
    endp

    ;[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Generación de Reporte ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
    ;Generar Reporte
    Reporte:
        mov AH,3Ch                                  ;Crear Archivo
        mov CX,00                                   ;Fichero Normal
        lea DX,pathArchivoRep                       ;direccion del archivo a crear
        int 21h                                     ;llamada a la interrupcion
        jc  errorCrear                              ;salta si hay algun error
        mov handleRep,AX                            ;obtiene el handle devuelto por la interrupcion

        ;imprime en el archivo las cadenas del reporte
        escArch stringEncabezado,0xE4               ;Imprime en archivo el encabezado
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
        
        escArch strRepNomBMP,0x15
        xor DH,DH
        mov DL,iPathArchivo
        escArch pathArchivo,DX
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepAncho,0x14
        mov DX,BMPWidth
        mov resultado,DX
        call aString
        escArch NumAux,SI
        escArch strRepPix,0x08
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepAlto,0x13
        mov DX,BMPHeight
        mov resultado,DX
        call aString
        escArch NumAux,SI
        escArch strRepPix,0x08
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea
        escArch strRepTam,0x15
        mov SI,02h
        mov DX,tamArch[SI]
        cmp DX,00h
        je  SigWord

        mov resultado,DX
        call aString
        escArch NumAux,SI
        SigWord:
        xor SI,SI
        mov DX,tamArch[SI]
        mov resultado,DX
        call aString
        escArch NumAux,SI
        escArch strRepByte,0x06
        escArch saltoLin,0x02                       ;Imprime en archivo un salto de linea


        
        ;mov handleRep,AX                            ;obtiene el handle devuelto por la interrupcion        
        mov BX,handleRep                            ;mover Handle
        mov AH,3Eh                                  ;Cierre de archivo
        int 21h
        imprimir strRepCre
        call pausa
        jmp menuOpe
        errorCrear:
            imprimir erCreArch                      ;Imprime el mensaje de error al crear el archivo
            call pausa
            jmp menuOpe
start:
; set segment registers:
    mov AX, data
    mov DS, AX
    mov ES, AX

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