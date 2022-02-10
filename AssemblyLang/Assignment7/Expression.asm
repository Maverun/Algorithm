TITLE Expression (Expression.asm)
;This program will take number in and create ((A + B) / C) * ((D - A) + E) answer
COMMENT @

for i in range(3):
	letter = "A"
	for j in range(len(array)):
		print("enter number for ",letter,": ")
		array[j] = input()
		letter += 1
	calcFPU() #((A + B) / C) * ((D - A) + E)
	print("result is ",Float)


@

INCLUDE Irvine32.inc

.data
array REAL8 5 DUP(0.0)
holder REAL8 0.0
index BYTE 0
letter BYTE "A"
asking_number BYTE "Please enter the number for ",0	;this is for A-E options where we will ask user for number in order to do something in array such as multi
formula BYTE "((A + B) / C) * ((D - A) + E) = "


.code

main PROC
	mov ecx,3								;we will be asking user 3 time for 5 input to caculate formula
	L1:
		push ecx							;save it to stack
		mov esi,0							;set index to 0
		mov ecx, LENGTHOF array				;size of array which is normally 5
		mov letter,"A"						;set char at "A"
		L2:
			mov edx,OFFSET asking_number	;asking user
			call WriteString				;print it
			mov al,letter					;set letter we need for formula
			call WriteChar					;print it
			mov al,":"						;set : into it
			call WriteChar					;print
			mov al," "						;set space into it
			call WriteChar					;print space
			call ReadFloat					;read input
			fstp array[esi]					;pop it and save it into array
			inc letter						;get char to next letter, e.g A to B
			add esi,TYPE REAL8				;next index
			LOOP L2
		
		call CalcFPU						;call functions
		mov edx,OFFSET formula				;set up formula message
		call WriteString					;print formula
		call WriteFloat						;print result
		call Crlf							;new line
		FFREE ST(0)							;free values in stack
		pop ecx								;restore first loops
		LOOP L1

	call ShowFPUStack						;prove it that there is nothing.


	exit
main ENDP

;------------------------------------------
;calcFPU
;Caclulate ((A + B) / C ) * ((D-A) + E)
;Receves: none
;Return: none
;------------------------------------------
calcFPU PROC
							;((A + B) / C) * ((D - A) + E)

							;(A+B)
	fld array[0]			;get A
	fld array[TYPE REAL8]	;get B
	fadd 

							;((A+B)/C)
	fld array[TYPE REAL8 * 2];get C
	fdiv
	fstp holder

							;((D-A)
	fld array[Type REAL8 * 3];get D
	fld array[0]			 ;get A
	fsub					 ;st(1) - st(0) and pop rest but result. 


	fld array[TYPE REAL8*4]	;get E
	fadd					;add it to othert

	fld holder				;add result to stack, first part before *
	fmul					;finally multi them.
	ret
calcFPU ENDP


END main