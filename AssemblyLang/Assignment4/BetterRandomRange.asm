TITLE RandomRange (BetterRadomRange.asm)
;Maverun
;7/27/2018
;Assignment 4 Question A, will ask user for low and high input number then random range them
;EBX is low, EAX is high.
;ask user for input low number
;get input and put it into ebx
;ask user for high number input
;check which one is large, if eax is smaller than ebx, xchange it
;have High number - Low number
;store copy of eax, which is default high number
;run loops
;generate random (it will generate random THEN it will add low number to it.)
;print it out, then print tab
;once loop done return to outer loops
;for nest loop work, we will need to use stack which is push ecx.

INCLUDE Irvine32.inc

.data

low_msg BYTE "Enter a low number: ",0		;setting message for low number
high_msg BYTE "Enter a high number: ",0		;setting message for high number

.code
main PROC
	call Randomize							;Initate random generator

		mov ecx,5							;we will be asking user 5 time 
	L1:
		mov edx,OFFSET low_msg				;setting for low number
		call WriteString					;asking user for low number input
		call ReadInt						;take input
		mov ebx,eax							;transfer it to ebx
		mov edx,OFFSET high_msg				;setting for high number
		call WriteString					;asking user for high number input
		call ReadInt						;Getting input for high number

		cmp eax,ebx							;compare eax and ebx
		jg done_size						;skip if EAX is already bigger then ebx
		xchg eax,ebx						;if not, excange them
		done_size:							
		
		sub eax,ebx
		inc eax								;inc by 1, since if user ask for 100, it will be 99.
		mov edx,eax							;transfer eax to ebx, so we can reused it

		push ecx							;saving loops counter to stack so we can do nest loop
		mov ecx,10							;print 10 random number
		L2:
			mov eax,edx						;eax = ebx, a default high number
			CALL Randint
			call WriteInt					;print it out
			mov al,9						;ASCI code, tab
			call WriteChar					;print it out
			LOOP L2							;loop it back to L2 till ECX is done then out of it
		call Crlf							;new line
		pop ecx								;restore ecx for first loop.
		LOOP L1

	exit
main ENDP

RandInt PROC
	call RandomRange						;generate number
	add eax,ebx								;add low number to it
	ret
RandInt ENDP

END main
