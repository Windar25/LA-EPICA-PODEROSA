; Mi hello world

; Seccion de variables con valor asignado
section .data
    message db "Pacheco es un bot", 10 ; El 10 representa '\n'
    len equ $ - message

; Seccion donde estara el codigo
section .text
    global _start

_start:

    mov rax,    1
    mov rdi,    1
    mov rsi,    message
    mov rdx,    len
    syscall


; Terminar el programa

    mov rax,    60
    mov rdi,    0
    syscall


