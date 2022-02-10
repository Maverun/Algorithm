TITLE Printing your own hex (MyHex.asm)
;This program will get number and covert it to hex and print it
INCLUDE Irvine32.inc

.data
prompt BYTE "Please enter a number: ",0
HexBuffer BYTE 19 DUP(0),'h',0
Counter BYTE 0
.code

main PROC
	;mov edx,OFFSET prompt ;Ask the question
	;call WriteStrings
	;call ReadInt ;collect the first num
	;mov ebx,eax
	call DumpRegs
	mov edx,0
	mov eax,12345678h
	mov bl,3
	call MyWriteHex
	;call MyWriteBin
	call Crlf
	mov edx,12345678h
	mov eax,9ABCDEF0h
	call MyWriteHex
	call Crlf
	
	exit
main ENDP

MyWriteHex PROC
	mov esi,OFFSET HexBuffer
	xchg eax,edx
	call CustomWriteHex
	xchg eax,edx
	call CustomWriteHex

	mov EDX,OFFSET HexBuffer
	call WriteString
	call Crlf

	ret
MyWriteHex ENDP

CustomWriteHex PROC
	mov ecx,8
	L1:
		mov ebx,0								;reset ebx
		SHLD EBX,EAX,4							;shift left by 4 from eax most bit to ebx
		SHL EAX,4								;remove first 4 of eax
		CMP BL,10								;compare if it letter or digit
		JAE setLetter							;if it above 10 we will mov to set letter
		add BL,"0"								;else if we will add with char "0"
		jmp PrintDigit							;skip to print
	setLetter:								;make letter
		add BL,'A' - 10							;adding 'A' - 10 (character) to BL where "A" is 65, so 55 total
	PrintDigit:
		mov [esi],bl							;adding bl to buffer
		inc esi
		inc counter
		cmp counter,4
		JNE next_loop
		mov bl,' '
		mov [esi],bl
		inc esi
		mov counter,0
	next_loop:
		LOOP L1
	ret
CustomWriteHex ENDP

myWriteBin PROC
;	mov esi, OFFSET binBuffer
	mov ecx,32
	L1:
		shl eax,1
		mov BYTE PTR [esi],'0'
		jnc nextDigit
		mov BYTE PTR [esi],'1'
	nextDigit:
		inc esi
		loop L1
;	mov edx,offset binBuffer
	call WriteString
	mov al,'b'
	call WriteChar
	ret
myWriteBin ENDP

END main