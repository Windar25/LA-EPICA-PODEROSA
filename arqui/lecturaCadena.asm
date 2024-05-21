; Datos
section .data
    pregunta    db  "dime tu nombre: "  
    lenPregunta equ $ - pregunta

    respuesta   db  "tu nombre es "
    lenRespuesta    equ     $ - respuesta

; Variables sin valores asignados
section .bss
    nombre  resw    32  ; resb de 16 bytes, osea 16 caracteres

; Empieza el programa
section .text
    global _start

_start:

    ; Impresion de la pregunta
    mov rax,    1
    mov rdi,    1
    mov rsi,    pregunta
    mov rdx,    lenPregunta
    syscall

    ; Lectura de los caracteres
    mov rax,    0
    mov rdi,    0
    mov rsi,    nombre
    mov rdx,    32
    syscall

    ; Impresion de la respuesta
    mov rax,    1
    mov rdi,    1
    mov rsi,    respuesta
    mov rdx,    lenRespuesta
    syscall

    ; Impresion del nombre
    mov rax,    1
    mov rdi,    1
    mov rsi,    nombre
    mov rdx,    32
    syscall

    ; Fin del programa
    mov rax,    60
    mov rdi,    0
    syscall
