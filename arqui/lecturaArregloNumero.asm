section .data
    numbers db 10, 20, 30, 40, 50   ; Array de números
    len equ 5

section .text
    global _start

_start:
    mov r15, numbers
    mov r14, len

for:
    


    dec r14
    cmp r14, 0
    jnz for

fin:
    mov rax,    60
    mov rdi,    0
    syscall