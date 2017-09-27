; multi-segment executable file template.

data segment
    ;+++++++++++++++++++++++++++++++++++++++++++++ Mensajes ++++++++++++++++++++++++++++++++++++++++++++++
    pkey                db "press any key...$"
     ;String de un salto de linea                    
    saltoLin            db 0Dh,0Ah,"$"
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
                        db "1- Ingresar funci",0A4h,"n f(x)",0Dh,0Ah          
                        db "2- Funci",0A4h,"n en Memoria",0Dh,0Ah
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
    ;Hace una pausa en la ejecución del código,
    ;espera una pulsación de tecla para continuar
    pausa proc
        mov AH, 07h                                 ;funcion 7, obtener caracter de pantalla, sin imprimir en pantalla(echo)
        int 21h                                     ;se llama a la interrupcion
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
        ;je  ingFun                                  ;salta a Ingresar la función f
        cmp AL,32h                                  ;compara si es la opción dos
        ;je  funMemoria                              ;si es, salta a mostrar la función en memoria
        cmp AL,33h                                  ;compara si es la opción tres
        ;je  derivada                                ;si es, salta a calcular la derivada
        cmp AL,34h                                  ;compara si es la opción cuatro
        ;je  integral                                ;si es, salta a calcular la integral de f
        cmp AL,35h                                  ;compara si es la opción cinco
        je  menuGra                                 ;si es, salta al Menu Graficar
        cmp AL,36h                                  ;compara si es la opción seis
        ;je  reporte                                 ;si es, salta a generar el reporte            
        cmp AL,37h                                  ;compara si es la opción Siete
        je  salirApp                                ;si es la opción 7 salta a la salida de la aplicación
        jmp menuPrin                                ;Si no es ninguna opcion, se mantiene en el menu

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
