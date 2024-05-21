; Para ejecutar hagan 'cd' hasta la carpeta donde este archivo, luego:
; nasm -f elf64 -g SumaCuadratica_HyperVer.asm -o SumaCuadratica_HyperVer.o
; ld SumaCuadratica_HyperVer.o -o SumaCuadratica_HyperVer
; ./SumaCuadratica_HyperVer
section .data
    MsgEntrada      db  "Ingrese el valor 'n': "
	medM_Entrada    equ $ - MsgEntrada
    MsgResultado    db  "La suma de cuadrados hasta el valor de 'n' es: "
    Num             dq  0                   ; EJM: Num = 9 => Resultado = 285 | 0 0 0 0 => '2' '8' '5' '\n' 
	medM_Resultado  equ $ - MsgResultado
    MsgErrorLim     db  "ERROR: El valor de 'n' debe ser mayor a '0' y menor a '10'.",10,"PSDT: Recuerde que no debe ingresar espaciadores antes del numero.",10
	medM_ErrorLim   equ $ - MsgErrorLim
section .text
    	global _start
_start:                                     ; INICIO DEL PROGRAMA ; Cabe resaltar que este programa esta adaptado para valores de entrada y salida de hasta 2 bytes por el caso de 'n = 9'.
    MOV RAX, 1
    MOV RDI, 1
    MOV RSI, MsgEntrada
    MOV RDX, medM_Entrada
    syscall                                 ; Impresion de Mensaje de Entrada
    MOV RAX, 0
    MOV RDI, 0
    MOV RSI, Num
    MOV RDX, 2
	syscall                                 ; Lectura del Valor N
    _ValidarN:                              ; Validacion de Numero Ingresado
        MOV RCX,[Num]
        CMP CL, 48
        JLE _ErrorDeDatos
        CMP CH, 48
        JGE _ErrorDeDatos
    _CalcularResultado:                     ; Calculo de Suma Cuadratica con limite 'N'
        XOR CH,CH
        SUB CL,'0'
        MOV AL,CL
        INC CL
        MUL CL
        SHL CL,1
        DEC CL
        MUL CX
        MOV CL,6
        DIV CX                              ; Con esto el resultado esta almacenado en 'AX'
    _ParticionarPorAscii:                   ; Particionamiento de resultado hacia Ascii | Es decir: Num = 9 => Resultado = 285 | 0 0 0 0 => '2' '8' '5' '\n' 
        MOV RBX,Num+3
        XOR RCX,RCX
        AND [Num],RCX                       ; Se pone en Nulo TODO el registro de 'n', pues se necesita delimitar el resultado particionado. Además, ya no es necesario almacenar el valor de 'n'..
        MOV CL,10
        MOV [RBX],CL                        ; Caracter '\n' = 10
        _TranscribirParticionado:           ; Proceso de Transcripción de valor particionado hacia memoria
            CMP AX,0
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
        MOV RSI, MsgResultado
        MOV RDX, medM_Resultado
        syscall
        JMP _Fin
    _ErrorDeDatos:                          ; Impresion de Error de Datos
        MOV RAX, 1
        MOV RDI, 1
        MOV RSI, MsgErrorLim
        MOV RDX, medM_ErrorLim
        syscall
        JMP _Fin
    _Fin:                                   ; Salida del Programa
        MOV RAX, 60
        MOV RDI, 0
        syscall