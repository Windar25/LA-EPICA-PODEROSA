section .data
	;Mensajes
    firstMsg db "Ingrese la cantidad de menores a quitar: " 
	lenf equ $ - firstMsg
	secondMsg db "La media calculada es: " 
	lens equ $ - secondMsg
    ;Variables
    arreglo dq 5, 3, 4, 8, 9, 7
    lenArr dq 6
    numMenores dq 0
    ;Auxiliares


	solution dq 0
    char dq 10 ;ASCII del cambio de linea
    
section .text          ;Code Segment
    global _start

_start:
    mov rax, 1
	mov rdi, 1
	mov rsi, firstMsg
	mov rdx, lenf
	syscall

    mov rax, 0
	mov rdi, 0
	mov rsi, numMenores
	mov rdx, 1
	syscall

    mov rax, 0
	mov rdi, 0
	mov rsi, char
	mov rdx, 1
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, secondMsg
	mov rdx, lens
	syscall


inicio:
    ; Limpiar los registros a utilizar
    xor rax,rax
    xor rbx,rbx
    xor rcx,rcx
    xor rdx,rdx
	xor r8,r8 ;i = 0
	xor r9,r9
	xor r10,r10
	xor r11,r11 ; N
    ;********************
    ; INICIO DEL CÓDIGO
    ;********************


guardamos_longitud_arreglo:
	mov r11, [lenArr]
	dec r11
	;en la condicion del buble sort del primer for, se requiere que mi contador sea menor a N-1


;Iniciamos el bubble sort
ordenamos_elementos:
	cmp r8,r11
	je salirOrdenamiento; i<=N-1
	;inc r8
	xor r9,r9 ;k = 0
	mov r10, r11;N-1
	sub r10, r8;N-i-1
	;dec r10;N-i-2
	recorremos_intercambios:
		cmp r9,r10
		je salirIntercambios; k<=N-i-2
		xor r12,r12 
		mov r12,[arreglo + 8*r9];arr[k]
		xor r13,r13 
		mov r13,[arreglo + 8*(r9+1)] ;arr[k+1]
		cmp r12,r13 ;si no cumple con arr[k]>arr[k+1]
		jle asignacion 
			mov [arreglo + 8*r9],r13 ;como ya tengo los valores que quiero evaluar en registros
			mov [arreglo + 8*(r9+1)],r12 ;ya estoy guardando como si fuera variables auxiliares
		asignacion:
		
		inc r9;k++
		jmp recorremos_intercambios
	salirIntercambios:
	inc r8;i++
	jmp ordenamos_elementos

salirOrdenamiento:
    
char_a_numero:
	mov r10, [numMenores]
	sub r10, '0'
	xor r13,r13
	mov r13,r10
	inc r11
	;dec r10 ;como voy a contar desde 0 al momento de iterar
	; i = numMenores-1
limpio_variables:
	xor r9,r9 ;acumulo suma
	xor r12,r12

recorro_los_elementos_permitidos:
	cmp r10,r11
	je salir_sumarotia; 
	add r9,[arreglo + 8*r10]
	inc r10
	jmp recorro_los_elementos_permitidos
salir_sumarotia:

realizo_division:
	;N (cantidad de elementos | r11) = permitidos + nopermitidos
	;r13 = nopermitidos
	;permitidos = r11 - r13
	;resultado = sumarotia/permitidos
	sub r11,r13
	xor rax,rax
	xor rdx,rdx
	mov rax,r9
	div r11
	;en rax esta mi media aritmetica
	mov r12, rax
imprimir_resultado: ;asumo que solo hay una cifra
	add r12, '0'
	mov [solution],r12
	
	mov rax, 1
	mov rdi, 1
	mov rsi, solution
	mov rdx, 1
	syscall


final:
    mov rax, 1
	mov rdi, 1
	mov rsi, char
	mov rdx, 1
	syscall

    mov rax, 60
	mov rdi, 0
	syscall