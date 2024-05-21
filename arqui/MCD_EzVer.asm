; Para ejecutar hagan 'cd' hasta la carpeta donde este archivo, luego:
; nasm -f elf64 -g MCD_EzVer.asm -o MCD_EzVer.o
; ld MCD_EzVer.o -o MCD_EzVer
; ./MCD_EzVer
section .data
    MsgError        db  "Todos los numeros deben ser mayores a 0.",10
    medM_Error      equ $ - MsgError
    MsgSalida       db  "El maximo comun divisor entre los numeros almacenados es: "
    MCD             dq  0                   ; EJM: MCD = 255 | 0 0 0 0 => '2' '5' '5' '\n' 
    medM_Salida     equ $ - MsgSalida
    Valores         db  50,25,100
    NumValores      db  3                   ; Con esto, el programa esta generalizado para multiples valores
section .text
    global _start
_start:                                     ; INICIO DEL PROGRAMA ; Cabe resaltar que este programa esta adaptado para valores de entrada y salida de solo 1 byte.
    MOV RBX,Valores
    MOV CL,[Valores]
    MOV DL,[NumValores]
    _ValidarInicializarDatos:               ; Validacion de Numeros Ingresados
        CMP BYTE[RBX],0
        JLE _ErrorDeDatos
        CMP BYTE[RBX],CL
        JGE  _ValidarProximo
        MOV CL,[RBX]                        ; Se almacena el menor de los numeros en CL
        _ValidarProximo:
            INC RBX
            DEC DL
            CMP DL,0
            JNE _ValidarInicializarDatos
    _CalcularMCD:
        MOV RBX,Valores
        MOV DL,[NumValores]
        _ProcesarDivisones:
            MOV AL,[RBX]
            DIV CL
            CMP AH,0
            JNE _DecrementarDivisor
            INC RBX
            DEC DL
            CMP DL,0
            JE  _ParticionarPorAscii
            JMP _ProcesarDivisones
        _DecrementarDivisor:
            DEC CL
            JMP _CalcularMCD
    _ParticionarPorAscii:                   ; Particionamiento de resultado hacia Ascii | Es decir: MCD = 255 | 0 0 0 0 => '2' '5' '5' '\n' 
        MOV AL,CL                           ; El MCD se almaceno en CL
        MOV RBX,MCD+3
        MOV CL,10
        MOV [RBX],CL                        ; Caracter '\n' = 10
        _TranscribirParticionado:           ; Proceso de Transcripción de valor particionado hacia memoria
            CMP AL,0
            JE  _ImprimirResultado
            DEC RBX
            DIV CL
            ADD AH,'0'
            MOV [RBX],AH
            XOR AH,AH
            JMP _TranscribirParticionado
    _ImprimirResultado:                     ; Impresion de resultado obtenido
        MOV RAX, 1
        MOV RDI, 1
        MOV RSI, MsgSalida
        MOV RDX, medM_Salida
        syscall
        JMP _Fin
    _ErrorDeDatos:                          ; Impresion de Error de Datos
        MOV RAX, 1
        MOV RDI, 1
        MOV RSI, MsgError
        MOV RDX, medM_Error
        syscall
    _Fin:                                   ;  Salida del Programa
        MOV RAX, 60
        MOV RDI, 0
        syscall
