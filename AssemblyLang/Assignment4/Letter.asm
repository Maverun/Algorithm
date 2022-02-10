TITLE Letter (Letter.asm)
;Maverun
;7/27/2018
;Assignment 4 Question B
; For isLetter method
;it will compare al, since al is 8 bit or byte which is for char.
; so we will compare them to ascii values,so meaning eax >= A AND eax <= Z OR eax >= a AND eax <= z
;if it true, we will set zf to 1 else 0
;for toLowerCase and toUpperCase, we will need to use AND and OR
;lowercase is 5 bit on with OR and it will turn off upper
;while upper must be using 5 bit off AND which is 1101 1111
;while lower must be using 5 bit on OR which is 0010 0000

INCLUDE Irvine32.inc

.data
buffer BYTE 250 DUP(?)					;setting up Buffer for input

array1 BYTE LENGTHOF buffer DUP(?)		;dupe of buffer
array2 BYTE LENGTHOF buffer DUP(?)		;same as above
count BYTE 0							;counter to count how many letter

msg BYTE "Total letter is ",0
.code
main PROC
	mov edx,OFFSET buffer				;set up Buffer like in java, System.in(Scanner) something like that
	mov ecx,LENGTHOF buffer				;getting size of buffer, ALSO it allow you to type in for input.
	call ReadString						;read input from user
	mov esi,0

	L1:
		mov al,buffer[esi]				;getting char from buffer
		mov bl,al						;make copy to bl
		cmp al, 0						;compare null terminate to al
		je done							;if there is ending, skip
		call isLetter					;checking if it letter
		jnz not_letter					;if it not letter, skip this process to not_letter.

		call toLowerCase				;covert to lower case
		mov bl,al						;copy to bl after it changed, so it can pass to array1 for lower case
		call toUpperCase				;covert to upper case
		
		inc count						;increased counter
		
		not_letter:
		mov array1[esi],bl				;transfer lower case to array1
		mov array2[esi],al				;transfer upper case to array2
		inc esi							;increase index
		LOOP L1							;back to L1 if ECX not done
	done:

	mov edx,OFFSET msg					;setting out message
	call WriteString					;print out
	movzx eax,count						;transfer total count to eax
	call WriteDec						;print it out
	call Crlf							;new line
	
	mov edx,OFFSET array1				;passing string to EDX of array1 that was lowercase
	call WriteString					;print it out
	call Crlf							;new line
	mov edx,OFFSET array2				;same as last 3 line, this time is uppercase
	call WriteString
	call Crlf
	
	exit
main ENDP

isLetter PROC
	cmp al,'a'							;we are compare al to 'a'
	jb orlabel							;if below 'a', so next conditons
	cmp al,'z'							;compare al to z
	ja orlabel							;if above z, so next conditons
	test al,0							;if it true, then we will set zf to 1
	jmp done							;skip to done
	orlabel:							;if first AND conditons failed, this will run
	cmp al,"A"							;compare al to "A"
	jb done								;if it below "A", then we will skip since it is false
	cmp al,"Z"							;compare al to "Z"
	ja done								;if it failed, then we will skip to false
	test al,0							;if true for AND, then we will set zf to 1
	done:
	ret
isLetter ENDP

toUpperCase PROC
	AND al,11011111b					;covert to upper as 11011111b is pattern for each
	ret
toUpperCase ENDP

toLowerCase PROC
	OR al,00100000b						;covert to lower as 00100000b is pattern to lower case
	ret
toLowerCase ENDP

END main
