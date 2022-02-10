TITLE Fib Question C (Fib.asm)
;Maverun
;7/19/2018
;Assignment 3 Question C
INCLUDE Irvine32.inc

.data
f DWORD 0,2,1,4,2,25 dup(?)
fib DWORD 0,1, 28 dup(?)
next BYTE ", ",0

.code
main PROC
	mov edx,OFFSET next						;reverse it for printing comma.

	mov ecx,28								;setting counter as 28, since we already got first two
	mov esi,(TYPE fib * 2)					;getting third element (or index 3)

	fib_loop:								;since to get next number, it is done by fib(n-1) + fib(n-2)
		mov eax,fib[esi - TYPE fib]			;getting fib(n-1)
		mov ebx,fib[esi - (TYPE fib *2)]
		add eax,ebx							;getting fib(n-2) and then add it to eax
		mov fib[esi],eax					;put them into it
		add esi,TYPE fib					;next index
		LOOP fib_loop						;back to start if counter is not 0


	mov ecx, 5								;counter of first 4
	mov esi,0								;reset index at 0

	l1:										;run loop, move ele to eax then print dec and string for ,. repeat.
		mov eax,f[esi]						;getting element of it from esi which is index
		add esi,TYPE f						;adding for TYPE (1 for byte, 2 for word and 4 for dword)
		call WriteDec
		call WriteString
		LOOP l1								;jump back to l1 when counter (ecx) are not 0 yet
	
	mov ecx,25								;now final part.
	l2:										;Formula is F(n) = 2*F(n-1) + Fib(n-5)
		mov eax,f[esi - TYPE f]				;first part F(n-1)
		add eax,eax							;add it self as in 2*
		mov ebx,fib[esi - (TYPE fib * 5)]	;2nd part, fib(n-5)
		add eax,ebx							;now we will add those two together, 
		mov f[esi],eax						;assign values to fib[index]
		add esi,TYPE f						;adding type to esi.
		call WriteDec
		call WriteString

		LOOP l2								;back to start.

	exit
main ENDP
END main
