; Para ejecutar hagan 'cd' hasta la carpeta donde este archivo, luego:
; nasm -f elf64 -g MCD.asm -o MCD.o
; ld MCD.o -o MCD
; ./MCD
section .data
    MsgError        db  "Todos los numeros deben ser mayores a 0.",10
    medM_Error      equ $ - MsgError
    MsgSalida       db  "El maximo comun divisor entre los numeros almacenados es: "
    MCD             dq  1                   ; EJM: MCD = 255 | 0 0 0 0 => '2' '5' '5' '\n'
    medM_Salida     equ $ - MsgSalida
    Valores         db  50,25,100
    NumValores      db  3                   ; Con esto, el programa esta generalizado para multiples valores
section .text
    global _start
_start:                                     ; INICIO DEL PROGRAMA ; Cabe resaltar que este programa esta adaptado para valores de entrada y salida de solo 1 byte.
    MOV RBX,Valores
    MOV DL,[NumValores]
    _ValidarInicializarDatos:               ; Validacion de Numeros Ingresados
        CMP BYTE[RBX],0
        JLE _ErrorDeDatos
        INC RBX
        DEC DL
        CMP DL,0
        JNE _ValidarInicializarDatos
        MOV CL,2                            ; CL se inicializa en 2 como primer divisor a probar
    _CalcularMCD:                           ; Calculo del MCD
        XOR AX,AX
        MOV RBX,Valores
        MOV DL,[NumValores]
        _ProcesarDivisiones:                ; División de valores | AX = Valor a dividir | BX = Puntero a Direccion de Memoria de los valores | CX = Divisor | DX = Numero de Valores a Analizar
            MOV AL,[RBX]
            CMP CL,AL
            JG  _ParticionarPorAscii
            DIV CL
            CMP AH,0
            JNE _IncrementarDivisor
            PUSH AX                         ; Dado que se tiene que validar que todos los valores sean divisibles, la actualizacion de los registros debe hacerse después. Por eso, guardamos los resultados en el STACK
            INC RBX
            DEC DL
            CMP DL,0
            JNE _ProcesarDivisiones
            MOV RBX,Valores
            MOV DL,[NumValores]
        _ActualizarRegistros:               ; Actualizacion de Valores desde el STACK
            POP AX
            MOV [RBX],AL
            INC RBX
            DEC DL
            CMP DL,0
            JNE _ActualizarRegistros
        _ActualizarMCD:                     ; Actualización del nuevo MCD
            MOV AL,[MCD]
            MUL CL
            MOV [MCD],AL
            JMP _CalcularMCD
        _IncrementarDivisor:                ; Incremento del divisor
            INC CL
            JMP _CalcularMCD
    _ParticionarPorAscii:                   ; Particionamiento de resultado hacia Ascii | Es decir: ; MCD = 255 | 0 0 0 0 => '2' '5' '5' '\n' 
        MOV AL,[MCD]
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
