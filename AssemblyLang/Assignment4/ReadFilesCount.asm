TITLE Frequecy Digit/Letter Counter (ReadFilesCount.asm)
;Maverun
;7/28/2018
;Assignment 4 Question C
;This will ask user for filename
;once i get it, i will call method to read files, and then store them into values
;Then other method is for printing
;First method will do process char into buffer and count each
;Second method will print them out.
;first will use PUSH/POP
;Second will use USES 
;The way it work is that array have 255 elements so each element are values OF table
;we will get text, and add it to array for that area and INCREASE it by 1.
;before that, we will check if it digit OR is letter.


INCLUDE Irvine32.inc

.data

filename BYTE ?
filehandle HANDLE ?

buffer BYTE 100 dup(?)

array BYTE 255 DUP(0) ;max for ASCII table


asking BYTE "Please enter the name of the file: ",0
errormsg BYTE "I am sorry, there is something wrong ",
				"with this file you asked for",0
.code
main PROC
	
	mov edx, OFFSET asking								;asking user for their input
	call WriteString									;print it out
	mov edx, OFFSET filename							;edx = filename
	mov ecx, 255										;I am assuming it is gonna be shorter than that but in cases.
	call ReadString										;read file name
	mov edx,OFFSET filename								;start setting filename so we can open it
	call OpenInputFile									;open it
	cmp eax,INVALID_HANDLE_VALUE						;if there is error problem with this, we will quit
	JE quit												;if equal to it
	mov filehandle,eax									;transfer handle to it

	mov eax,fileHandle

	mov edi,OFFSET array								;set pointer but array to edi

	;while cf on
	While_loop:
		mov edx,OFFSET buffer								;pass buffer for text to it
		mov ecx,LENGTHOF buffer								;length of files
		call ReadFromFile									;read files
		mov edx,OFFSET buffer
		Call WriteString
		mov esi,OFFSET buffer								;deferences array buffer to esi
		mov ecx,LENGTHOF buffer								;size of buffer.
		CALL Count											;calling count methods
		add eax,100
		JMP While_loop
		;JC done_while
	done_while:
	mov esi,OFFSET array								;set derefences to  esi with Array
	mov ecx,LENGTHOF array

	call PrintLetter									;print result out
	jmp done											;we are done and will quit before it split out error
	quit:												;if there was any problem with files handle
	mov edx,OFFSET errormsg								;getting error message
	call WriteString									;print it out
	call Crlf											;New line
	done:												;done
	exit
main ENDP

Count PROC
	push esi											;save esi to stack
	push edi											;save edi to stack
	push ecx											;counter loops
	L1:
		mov eax,0										;set eax to 0
		mov ebx,0										;reset ebx to 0
		mov al,BYTE PTR [esi]							;transfer char to al
		call IsDigit									;checking if it digit
		JZ confirm										;if yes, go to confirm
		CALL isLetter									;else check if it letter,
		JNZ skip										;if not,skip it
	confirm:											;if conditons passed which mean it is digit OR letter
		add edi,eax										;passing values to it
		mov bl,BYTE PTR [edi]							;pass values to bl so that we can add it, this is ARRAY passing
		inc bl											;increase by 1 as it is counter
		mov [edi],BYTE PTR bl							;then we will pass total counter of that letter to array [edi]
		sub edi,eax										;return back to where it was.
	skip:
		inc esi											;go to next element
		LOOP L1											;loop

	pop ecx
	pop edi
	pop esi
	ret
Count ENDP

PrintLetter PROC USES ecx esi
	mov ebx, 0 
	L1:
		movzx eax,BYTE PTR [esi]
		cmp al,0
		je skip
		mov al,bl
		call WriteChar
		mov al," "
		call WriteChar
		mov al,[esi]
		call WriteDec
		call Crlf
	skip:
		inc ebx
		inc esi
		LOOP L1
	
	ret 
PrintLetter ENDP

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

END main
