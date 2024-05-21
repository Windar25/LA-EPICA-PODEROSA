; Seccion de datos
section .data
    message db "Pacheco bot", 10,  0; salto de linea '\n' y fin de cadena `0`

; Segmento de texto

section .text
    global _start

_start:

    mov rax,    message ; rax apunta al inicio de la cadena
    mov rbx,    0       ; contador

_countloop:

        inc rax             ; recorre el arreglo
        inc rbx             ; incrementa la cantidad de caracteres
        mov cl, [rax]       ; asigna a cl el valor de caracter
        cmp cl, 0           ; si es 0, significa que la cadena termino
        jne _countloop      

; Imprimimos el valor

    mov rax,    1
    mov rdi,    1
    mov rsi,    message
    mov rdx,    rbx         ; vemos que funciona, por que imprime el mensaje sin problemas
    syscall

; Salimos
    mov rax,    60
    mov rdi,    0
    syscall 


