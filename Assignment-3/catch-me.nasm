; Filename: catch-me.nasm

global _start			

section .text
_start:

	; egg (token) 0x40904090 twice :) 
    nop
    inc eax 
    nop
    inc eax 
    nop 
    inc eax 
    nop 
    inc eax 

	; write mesg 'found me :))\n' to standard output
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	xor edx, edx

	mov al, 4 		; write() syscall number

	inc bl ; stdout

	; found me :))\n
	push byte 0x0a 	; newline
	push 0x29293a20
	push 0x656d2064
	push 0x6e756f66

	mov ecx, esp 	; address for 'found me :))\n' 

	mov dl, 12
	int 0x80

	; exit(0)
	xor eax, eax
	add al, 1 		; exit() syscall
	dec bl 			; decrement bl from 1 to 0 (exit code)
	int 0x80
