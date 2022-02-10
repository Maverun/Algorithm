TITLE Print Question D (PrintByte.asm)
;Maverun
;7/19/2018
;Assignment 3 Question D
INCLUDE Irvine32.inc

.data
data SBYTE 32,123,-32,12,-126,20,-45,20,15,-20,0,12

next BYTE ", ",0
cmsg BYTE "Total sum of this array is ",0

.code
main PROC
	
	mov edx,OFFSET next						;reverse it for printing comma.
	mov ecx,LENGTHOF data					;total loops counter
	mov esi, 0								;set index at 0
	mov eax,0								;to reset whole thing. IN case....

	l1:
		movsx eax,data[esi]					;assign element to eax

		call WriteInt						;Print INT
		call WriteString					;adding ", "
		add esi,TYPE data					;adding type to data (as in new index for next element)
		LOOP l1
	
	call Crlf								;new line
	mov ecx,LENGTHOF data					;reset counter to max 
	mov esi,0								;reset index
	l2:
		movsx eax,data[esi]					;assign element to eax
		call WriteHex						;PRINT HEX
		call WriteString					;adding ", "
		inc esi								;increase index
		LOOP l2								;back to start if ecx not 0


	call Crlf								;new line
	mov ecx,LENGTHOF data					;reset counter to max again
	mov esi,0								;reset index
	mov eax,0								;reset eax to 0

	l3:
		movsx ebx, data[esi]
		add eax,ebx							;adding it to eax
		add esi,TYPE data					;go to next dereference.
		LOOP l3

	mov edx,OFFSET cmsg						;getting message
	call WriteString						;print 
	call WriteInt							;print out answer
	call Crlf
	

	exit
main ENDP
END main
