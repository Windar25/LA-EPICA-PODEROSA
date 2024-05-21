; numero binario a decimal

section	.data
	binStr	db	"10101010"

section	.bss
	respuesta	resb	1
	

section .text
	global	_start

_start:
	
	mov r15,	binStr 
	mov	r14,	128
	mov	r13,	2
	mov	r12,	0
	
mulbuc:
	mov	al,		[r15]
	sub	al,		'0'
	mul	r14				; Equivalente a DX:RAX = RAX*R14, RAX contiene a AL en su parte menos significativa
	add	r12,	rax

sigpa:
	xor	rdx,	rdx
	mov	rax,	r14
	div	r13				; RDX:RAX = RDX:RAX / r13,	Cociente RAX,	Residuo RDX
	mov	r14,	rax
	inc	r15
	cmp	r14,	0
	jne	mulbuc

fin:
	mov[respuesta],	r12b
	
	mov	rax,	60
	mov	rdi,	0
	syscall

; Depurar programa
; nasm -f elf64 bin2dec.asm -o bin2dec.o -g
; ld bin2dec.o -o bin2dec	
; gdb bin2dec
; (gdb) b _start
; Breakpoint 1 at 0x401000: file bin2dec.asm, line 15.
;(gdb) b _start
;Breakpoint 1 at 0x401000: file bin2dec.asm, line 15.
;(gdb) b _mulbuc
;Function "_mulbuc" not defined.
;Make breakpoint pending on future shared library load? (y or [n]) n
;(gdb) b mulbuc
;Breakpoint 2 at 0x40101c: file bin2dec.asm, line 21.
;(gdb) info b
;Num     Type           Disp Enb Address            What
;1       breakpoint     keep y   0x0000000000401000 bin2dec.asm:15
;2       breakpoint     keep y   0x000000000040101c bin2dec.asm:21
;(gdb) delete 2
;(gdb) info b
;Num     Type           Disp Enb Address            What
;1       breakpoint     keep y   0x0000000000401000 bin2dec.asm:15
;(gdb) set disassembl
;disassemble-next-line  disassembler-options   disassembly-flavor     
;(gdb) set disassembly-flavor intel
;(gdb) run
;Starting program: /home/marcos/Documents/pucp/LaEpica/arqui/bin2dec 

;This GDB supports auto-downloading debuginfo from the following URLs:
;  <https://debuginfod.ubuntu.com>
;Enable debuginfod for this session? (y or [n]) y
;Debuginfod has been enabled.
;To make this setting permanent, add 'set debuginfod enabled on' to .gdbinit.
;Downloading separate debug info for system-supplied DSO at 0x7ffff7ffd000
                                                                                               
;Breakpoint 1, _start () at bin2dec.asm:15
;warning: Source file is more recent than executable.
;15		mov r15,	binStr 
;(gdb) disa
;disable      disassemble  
;(gdb) disassemble 
;Dump of assembler code for function _start:
;=> 0x0000000000401000 <+0>:	movabs r15,0x402000
;   0x000000000040100a <+10>:	mov    r14d,0x80
;   0x0000000000401010 <+16>:	mov    r13d,0x2
;   0x0000000000401016 <+22>:	mov    r12d,0x0
;End of assembler dump.
;(gdb) info r r15
;r15            0x0                 0
;(gdb) info r r15 r14 r13 r12
;r15            0x0                 0
;r14            0x0                 0
;r13            0x0                 0
;r12            0x0                 0
;(gdb) ni
;16		mov	r14,	128
;(gdb) info r r15 r14 r13 r12
;r15            0x402000            4202496
;r14            0x0                 0
;r13            0x0                 0
;r12            0x0                 0
;(gdb) b fin
;Breakpoint 3 at 0x40103c: file bin2dec.asm, line 36.
;(gdb) c
;Continuing.

;Breakpoint 3, fin () at bin2dec.asm:36
;36		mov[respuesta],	r12b
;(gdb) info r r12
;r12            0xaa                170
;(gdb) x/b &respuesta
;0x402008 <respuesta>:	0
;(gdb) ni
;38		mov	rax,	60
;(gdb) x/b &respuesta
;0x402008 <respuesta>:	-86
;(gdb) x/w &respuesta
;0x402008 <respuesta>:	170
;(gdb) ni
;39		mov	rdi,	0
;(gdb) ni
;40		syscall
;(gdb) ni
;[Inferior 1 (process 8783) exited normally]
;(gdb) ni
;The program is not being run.
;(gdb) ni
;The program is not being run.
;(gdb) 

