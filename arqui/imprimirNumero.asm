section .data
    num db 42          ; Almacena el número 42 como un byte

section .bss
    buffer resb 16     ; Reserva 16 bytes para el buffer

section .text
    global _start

_start:
    ; Convertir el número a cadena de caracteres
    movzx eax, byte [num]  ; Cargar el valor de 'num' en eax y extenderlo a 32 bits
    lea rdi, [buffer + 15] ; Apunta al último byte del buffer
    mov byte [rdi], 0x0A   ; Carácter de nueva línea (newline)

convert:
    dec rdi                ; Retrocede un byte en el buffer
    xor edx, edx           ; Limpiar edx
    mov ecx, 10            ; Divisor 10
    div ecx                ; Divide eax por 10, resultado en eax, resto en edx
    add dl, '0'            ; Convierte el dígito en carácter ASCII
    mov [rdi], dl          ; Almacena el carácter en el buffer
    test eax, eax          ; Comprueba si eax es 0
    jnz convert            ; Si no es 0, continuar la conversión

    ; Calcular la longitud de la cadena convertida
    mov rax, buffer + 16   ; Dirección del final del buffer
    sub rax, rdi           ; Calcular la longitud de la cadena
    mov rdx, rax           ; Longitud de la cadena en rdx

    ; Escribir la cadena en la consola
    mov rax, 1             ; syscall número 1 - sys_write
    mov rdi, 1             ; descriptor de archivo 1 - salida estándar (stdout)
    mov rsi, rdi           ; Dirección del inicio de la cadena
    syscall                ; Llamada al sistema

    ; Salir del programa
    mov eax, 60            ; syscall número 60 - sys_exit
    xor edi, edi           ; Código de salida 0
    syscall                ; Llamada al sistema
