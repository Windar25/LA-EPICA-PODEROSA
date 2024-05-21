# La Epica Segunda parte con Marquitos 

-   Para esta parte del curso, es necesario entender que tendremos que usar algunos comandos basicos de Linux, es por eso que despues de cada programa estaran los codigos a copiar en la terminal

-  Para esta ocasion, se usaran `nasm` y el ensamblador de Intel.
- Los programas tienes la siguiente estuctura

    - `.data` donde los datos iniales son **declarados y definidos**
    - `.bss` donde se declaran y definen **variables sin valor inicial**
    - `.text` donde se colocan las **instrucciones de codigo**

---
### Seccion `.data`
- Aqui se colocan las variables iniciales

|Declaración|Significado|
|-----------|-----------|
|db	|Variable de 8 bits|
|dw	|Variable de 16 bits|
|dd	|Variable de 32 bits|
|dq	|Variable de 64 bits|
---
### Seccion `.bss`
- Variables sin valores iniciales, siguen las mismas reglas que `.data`

|Declaración|Significado|
|-----------|-----------|
|resb	|Variable de 8 bits|
|resw	|Variable de 16 bits|
|resd	|Variable de 32 bits|
|resq	|Variable de 64 bits|
---
### Seccion `.text`
- Aqui se especifican las instrucciones

```asm
    section .text
        global _start
    

    _start
```
> Ojo, esto es asumiendo que el enlazador es `ld`, caso contrario, esta parte cambiara

- Los Registros y banderas no los tocare aqui

## Modos de direccionamiento

- Los modos de direccionamiento es una exprecion para calcular una direccion de memoria para leer o escribir.  

- Existen varios modos como por ejemplo: 

```asm
    mov 0x604892,      1 ; modo directo (la dirección es un valor constante)
    mov [rax],         1 ; modo indirecto (la dirección está en un registro)
    mov [rbp-24],      1 ; modo indirecto con desplazamiento
    mov [rsp+8+4*rdi], 1 ; modo indirecto con desplazamiento y escalamiento
    mov [rsp+4*rdi],   1 ; modo indirecto con desplazamiento 0
    mov [8+4*rdi],     1 ; modo indirecto con base 8
    mov [rsp+8+rdi],   1 ; modo indirecto con escalamiento 1 
```
> Explican mas cosas, pero vole y no los considero importante para la parte practica.
> En un futuro lo escribire

## Instrucciones

- Ahora es la parte interesante

### Mover datos

- Comando `mov`

```asm
    mov rax, 100 ; rax <- 100
    mov rax, a   ; rax <- a
    mov rax, [a] ; rax <- el contenido de la dirección a
    mov [a], rax ; el valor de rax se escribe en el contenido de la dirección a 
    mov rax, rbx ; rax <- rbx
```
### Aritmeticas


```asm
    inc rax      ; rax <- rax + 1
    add rax, rbx ; rax <- rax + rbx
    dec rax      ; rax <- rax - 1
    sub rax, rbx ; rax <- rax - rbx
```

### Control

#### Saltos sin condicion
    
```asm
    jmp loopStart ; saltar a la etiqueta loopStart
    jmp ifDone    ; saltar a la etiqueta ifDone
    jmp end       ; saltar a la etiqueta end
```

#### Saltos con condicion

- Importante usar `cmp`

|Instrucción|	Resultado de cmp a, b|
|-----------|------------------------|
|je	|a == b|
|jne	|a != b|
|jg	|a > b|
|jge|	a >= b|
|jz	|a == 0|
|jnz|	a != 0|

```asm
    ; si rax es menor o igual que rbx
    ; saltar a la etiqueta notNewMax
    cmp rax, rbx
    jle notNewMax
```

### Iteraciones

- Para crear lazos iterativos se puede implementar un bucle

```asm
    cant    dq  15      ; cantidad de iteraciones
    suma    dq  0       ; suma

    ; Codigo

    mov     rcx,    qword [cant]    ; contador de iteraciones
    mov     rax,    1               ; registro de impares
sumLoop:
    add     qword [suma], rax       ; acumulando
    add     rax,    2               ; siguiente impar
    dec     rcx
    cmp     rcx,    0               ; 
    jne     sumLoop
```

- Existe la instruccion especial `loop <etiqueta>` la cual hara la misma funcion de decrementar rcx e igualarla con 0. Si es cero no repite el bucle.

```asm
    mov     rcx,    qword [cant]    ; contador de iteraciones
    mov     rax,    1               ; registro de impares
sumLoop:
    add     qword [suma], rax       ; acumulando
    add     rax,    2               ; siguiente impar
    loop     sumLoop                ; Hasta que sea 0
```
> La instruccion loop no es recomendada para lazos anidados

## Codigos utiles

### Hello world

```asm
; Programa helloworld.asm
; Para ensamblar ejecutar:
; nasm -f elf64 helloworld.asm -o helloworld.o
; Para enlazar ejecutar:
; ld helloworld.o -o helloworld
; Para correr el ejecutable:
; ./helloworld

; SEGMENTO DE DATOS
; Se empleara la etiqueta message y se reservaran elementos de 8 bits
; Cada letra de la cadena se corresponde con un elemento de 8 bits
; El numero 10 se corresponde con el caracter \n
section .data                   
	message db "Hello World",10 
	len equ $ - message

; SEGMENTO DE TEXTO
section .text
	global _start

_start:
; LLAMADA AL SISTEMA
; rax => ID <= 1 : sys_write
; rdi => Primer parametro   : output
; rsi => Segundo parametro  : direccion del mensaje
; rdx => Tercer parametro  : longitud del mensaje
	mov rax, 1
	mov rdi, 1
	mov rsi, message
	mov rdx, len
	syscall
; LLAMADA AL SISTEMA
; rax => ID <= 60  : sys_exit
; rdi => Primer parametro   : 0 <= sin errores
	mov rax, 60
	mov rdi, 0
	syscall
```

### Calcular longitud de cadena

```asm
; Programa helloworldlen.asm
; Para ensamblar ejecutar:
; nasm -f elf64 helloworldlen.asm -o helloworldlen.o
; Para enlazar ejecutar:
; ld helloworldlen.o -o helloworldlen
; Para correr el ejecutable:
; ./helloworldlen

; SEGMENTO DE DATOS
; Se empleara la etiqueta message y se reservaran elementos de 8 bits
; Cada letra de la cadena se corresponde con un elemento de 8 bits
; El numero 10 se corresponde con el caracter \n
; El numero 0 se emplea como fin de cadena
section .data
	message db "Hello World",10,0

; SEGMENTO DE TEXTO
section .text
	global _start

; rax apunta al principio de la cadena
; rbx se empleara como contador
; nos desplazamos a lo largo de la cadena hasta encontrar un cero
; cuando rax vale cero dejamos de iterar
; en rbx se encuentra la longitud de la cadena
_start:
	mov	rax, message
	mov	rbx, 0

_countLoop:
	inc	rax
	inc	rbx
	mov	cl, [rax]
	cmp	cl, 0
	jne	_countLoop

; SYS_WRITE
	mov 	rax, 1
	mov 	rdi, 1
	mov 	rsi, message
	mov	rdx, rbx
	syscall

; SYS_EXIT
	mov	rax, 60
	mov	rdi, 0
	syscall
```

### Lee cadena

```asm
; Programa getname.asm
; Para ensamblar ejecutar:
; nasm -f elf64 getname.asm -o getname.o
; Para enlazar ejecutar:
; ld getname.o -o getname
; Para correr el ejecutable:
; ./getname

; SEGMENTO DE DATOS
section .data
	question db "What is your name? "
	lenq equ $ - question
	greet db "Hello, "
	leng equ $ - greet

; SEGMENTO BSS (Block Started by Symbol)
; Reservamos 16 bytes para el nombre que sera ingresado 
section .bss
	name resb 16

; SEGMENTO DE TEXTO
section .text
	global _start

; SYS_WRITE
_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, question
	mov rdx, lenq
	syscall

; SYS_READ
	mov rax, 0
	mov rdi, 0
	mov rsi, name
	mov rdx, 16
	syscall

; SYS_WRITE
	mov rax, 1
	mov rdi, 1
	mov rsi, greet
	mov rdx, leng
	syscall

; SYS_WRITE
	mov rax, 1
	mov rdi, 1
	mov rsi, name
	mov rdx, 16
	syscall

; SYS_EXIT
	mov rax, 60
	mov rdi, 0
	syscall
```
























































































































































