TITLE Color (Color.asm)
;This program will collect string and print them in colorish
COMMENT @
So this program has 12-13 select to do task.

first we will ask user for low and high number
once we do that


MENU:
1: Print Array
2: Sum Array
3: Average value
4: Maximum value
5: Minimum value 
6: Multiply array
7: Divide array 
8: Mod array
A: Arithmetic Shift the array to right
B: Arithmetic Shift the array to left
C: Rotate the array to left
D: Rotate the array to right

1: "[1,2,3,4]"
6,7,8: we ask user for number to be used
A,B,C,D: we ask user for number to switch.

I am unsure about Question Part D, i assume it is shifting values itself inside array.

ask user for low and high
if low > high
switch it around

then we will run function call array_create
where inside it will run loops of len(array) and generate number between low and high from user input
then put them into array. Using ESI as a pointer.

run a while loops
inside while loops
we clear out screen
change cursor to certain positon asking for input
once we read it, check if it 0, if it, we exist
if not
we compare it to 5,
if eax <= 5:
	first_5()
else:
	after_5()

for both cases,
it will have like switch cases
where we will do something like this

Casen:
	cmp eax,n
	JNE casen+1
	call function
	JMP done

where n is number of cases, if we press 1 which is print array, cases will be 1
the reason I did first_5 and after_5, since any options after 5 will ask user for number, so we can do task. like multiply, divide, shift etc



@

INCLUDE Irvine32.inc

.data
low_msg BYTE "Enter the low number: ",0				;since we will be asking user for low number
high_msg BYTE "Enter the high number: ",0			;we will also ask for high number to generate random range
asking_number BYTE "Please enter the number: ",0	;this is for 6-8 and A-D options where we will ask user for number in order to do something in array such as multi
menu_msg BYTE "1: Print Array",13,10,				;menu to print out so user can select
"2: Sum Array",13,10,
"3: Average value",13,10,
"4: Maximum value",13,10,
"5: Minimum value",13,10,
"6: Multiply array",13,10,
"7: Divide array",13,10,
"8: Mod array",13,10,
"A: Arithmetic Shift the array to right",13,10,
"B: Arithmetic Shift the array to left",13,10,
"C: Rotate the array to left",13,10,
"D: Rotate the array to right",13,10,
"0: Exit the program",13,10,0


array SDWORD 10 DUP(0)


.code

main PROC
	call Randomize							;Initate random generator
	mov edx,OFFSET low_msg					;setting for low number
	call WriteString						;asking user for low number input
	call ReadInt							;take input
	mov ebx,eax								;transfer it to ebx
	mov edx,OFFSET high_msg					;setting for high number
	call WriteString						;asking user for high number input
	call ReadInt							;Getting input for high number

	cmp eax,ebx								;compare eax and ebx
	jg done_size							;skip if EAX is already bigger then ebx
	xchg eax,ebx							;if not, excange them
	done_size:							
	

	mov esi,OFFSET array					;setting up pointer
	mov ecx,LENGTHOF array					;len(array) or array.length
	call array_create						;create random values and store them to array.

	while_loop:
		call Clrscr							;clearing out screen
		mov edx,OFFSET menu_msg				;setting up menu text
		call WriteString					;print it off

											;Now we will go to cursor positons
		mov edx,0							;reset edx to 0
		mov dh,16							;setting dh to row
		mov dl,0							;setting dl to col
		call Gotoxy							;move cursor to coord row:col

											;Prompt user for input
		mov al,">"							;setting up > so we can tell user start type in
		call WriteChar						;print it out
		mov eax,0							;set eax to 0
		call ReadChar						;await for user enter char
		call WriteChar						;write it down, since the moment user enter key, it will be invisble and transfer char to al
		call Crlf							;new line
		mov ah,0							;reset ah to 0, some reason there is garbage in, we only want al.

											;double checking as it is char, we only want digit or certain letter.
		call isDigit						;ensuring it is digit
		JZ confirm_digit					;if it, we can sub 48 to it
		call isLetter						;checking if it letter
		JNZ while_loop						;if it not letter AND not digit then we will reset loops
		AND al,11011111b					;to upper case, al.upper()
		cmp al,"E"							;checking if it not A-D
		JAE while_loop						;if al E or above E which is E-Z we will go back to start. or if eax >= 69: skip
		jmp switch							;jump to switch as next line is for digit
	
		confirm_digit:
		sub al,48							;since in char, '0' is 48, if '1' , then 49-48 give 1 dec

		switch:
		cmp eax,0							;compare eax to 0
		JE exit_program						;if it indeed 0, we will quit

		cmp eax,5							;compare eax to 5
		JA next								;if it above 5, we will skip first 5
		call first_5						;call first_5 function for 1-5 menu
		jmp done_case						;to bottom of loops for delay.
		next:								;if it above 5, we will make copy then get input from user so we can use ebx for multi etc
		mov ebx,eax							;copy for a temp
		call get_number						;get input for 6+ options menu
		xchg eax,ebx						;xchange them around
		call after_5						;call after_5 where it will do case for function
	
		done_case:
			mov eax,2500					;set 2.5 second
			call Delay						;Delay it.

		jmp while_loop

	exit_program:
	exit
main ENDP

first_5 PROC
	case1:							;case one
		cmp eax,1					;compare to case 1
		jne case2					;if eax != 1, jump to case 2
		call print_array			;call function
		jmp done					;jump to done.
	case2:							; This is same as case 1 step but for sum
		cmp eax,2
		jne case3
		call sum
		call WriteInt
		jmp done
	case3:							; This is same as case 1 step but for average
		cmp eax,3
		jne case4
		call average
		call WriteInt
		jmp done
	case4:							; This is same as case 1 step but for max
		cmp eax,4
		jne case5
		call max
		call WriteInt
		jmp done
	case5:							; This is same as case 1 step but for min
		call min
		call WriteInt
	done:
	ret
first_5 ENDP

after_5 PROC
	case6:							;case 6
		cmp eax,6					;compare eax to its case
		jne case7					;if it not equal, we check next
		call multi					;call function
		jmp done					;jump to done once done
	case7:							;same as case 6 but for divide
		cmp eax,7
		jne case8
		call divide
		jmp done
	case8:							;same as case 6 but for mod
		cmp eax,8
		jne caseA
		call mod_array
		jmp done
	caseA:							;same as case 6 but for artimetic shift right
		cmp eax,"A"
		jne caseB
		call artimetic_shr
		jmp done
	caseB:							;same as case 6 but for artimetic shift left
		cmp eax,"B"
		jne caseB
		call artimetic_shl
		jmp done
	caseC:							;same as case 6 but for rotate right
		cmp eax,"C"
		jne caseC
		call rotate_right
		jmp done
	caseD:							;same as case 6 but for rotate left
		cmp eax,"D"
		jne done
		call rotate_left
		jmp done
	
	done:

	ret
after_5 ENDP

;------------------------------------------
;get_number
;asking user for number to input
;Receves: edx
;Return: EAX = input from user
;------------------------------------------
get_number PROC
	mov edx,OFFSET asking_number		;asking user for a number to enter, this is for 6-8, A-D
	call WriteString					;print it out
	call ReadInt						;get input
	ret
get_number ENDP


;------------------------------------------
;isLetter
;Checking ACII values to ensure it is a letter
;Receves: al
;Return: None but zero flag will set.
;------------------------------------------
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

;------------------------------------------
;RandInt
;Generate random number
;Receves: EAX,EBX
;Return: EAX = Random number between eax-ebx
;------------------------------------------
RandInt PROC
	sub eax,ebx								;substract eax to ebx, for etc, 100-50 for 50-100
	inc eax									;inc by 1 so we can get 100 as well instead of 99
	call RandomRange						;generate number
	add eax,ebx								;add low number to it, meaning (100-50+1) + 50, so rand give 20, we get 70 instead which fit in 50-100
	ret
RandInt ENDP

;------------------------------------------
;Transfer
;Mov eax,[esi] based on its size.
;Receves: EAX,EBX
;Return: EAX = [esi]
;------------------------------------------
transfer PROC USES ebx
	mov bl,TYPE array					;getting types of array
	mov eax,0							;reset eax 0
	cmp bl,1							;if it BYTE
	JE isByte							;jump if it BYTE
	cmp bl,2
	JE isWord							;jump if it WORD
	mov eax,[esi]						;pass element to eax if it dword
	jmp next

	isByte:								;is byte, so we will use al
		mov al,[esi]
		jmp next
	isWord:								;is word so we will use ax
		mov ax,[esi]
			
	next:

	ret
transfer ENDP

;------------------------------------------
;array_create
;Generate array with random number in
;Receves: EAX,esi,ecx, and edx will be used temp
;Return: ESI pointer of array has created
;------------------------------------------
array_create PROC
	push esi								;saving them to stack of esi
	push ecx								;saving them to stack of ecx

	mov edx,eax								;temp holder so we can reuse it
	L1:
		mov eax,edx							;reset eax
		call RandInt						;generate number
		mov [esi],eax						;transfer to esi
		add esi,TYPE array					;next element
		LOOP L1
	pop ecx									;restore ecx and esi
	pop esi
	ret
array_create ENDP

;------------------------------------------
;print_array
;Print all element in array, format [n1,n2,n3]
;Receves: esi,ecx
;Return: None
;------------------------------------------
print_array PROC 
	push esi								;save them to stack of esi and ecx
	push ecx
	mov al, "["								;set [ to al
	call WriteChar							;print out [
	L1:
		call transfer						;transfer element to eax due to size.
		add esi,TYPE array					;next element
		call WriteInt						;print it out
		cmp ecx,1							;compare ecx to 1,
		JE break							;if it equal to 1, we will skip to avoid printing ,
		mov al,","							;if not we will set up "," to it
		call WriteChar						;print out comma
		LOOP L1
	Break:									;break of loop
	mov al,"]"								;last thing to do is adding ] to it
	call WriteChar							;print
	
	pop ecx									;restore ecx and esi values
	pop esi
	ret
print_array ENDP

;------------------------------------------
;sum
;Sum of array
;Receves: esi,ecx
;Return: EAX = Sum
;------------------------------------------
sum PROC
	push esi								;save values to stack
	push ecx
	mov eax,0								;reset it
	L1:
		add eax,[esi]						;add element to eax
		add esi,TYPE array					;next element
		LOOP L1								;back to start if ecx not 0
	pop ecx									;restore values of ecx and esi
	pop esi
	ret										;return eax of sum
sum ENDP

;------------------------------------------
;Average
;Getting average from array
;Receves: esi,ecx
;Return: EAX = average values
;------------------------------------------
average PROC
	push esi								;save values to stack
	push ecx
	call sum								;calling sum, as we are finding average
	cdq										;covert dword to qword
	mov ebx,LENGTHOF array					;len(array)
	idiv ebx								;divide it by len(array)
	pop ecx									;restore values of ecx and esi
	pop esi
	ret										;return eax of average values
average ENDP

;------------------------------------------
;Max
;Max values from array, highest is positives
;Receves: esi,ecx
;Return: EAX = highest values
;------------------------------------------
max PROC
	push esi								;save esi and ecx to stack
	push ecx
	mov eax,[esi]							;first element to eax
	add esi,TYPE array						;next element
	dec ecx									;decrease counter by 1 since we just did put one in ^
	L1:
		cmp eax,[esi]						;compare eax to element
		JGE next							;if it greater or equal, we skip to next (SIGN)
		mov eax,[esi]						;mov element to eax which mean this is bigger
		next:
			add esi,TYPE array				;next element
		LOOP L1

	pop ecx
	pop esi
	ret
max ENDP

;------------------------------------------
;Min
;Minimun from array, negative is lowest you could get.
;Receves: esi,ecx
;Return: EAX = lowest values
;------------------------------------------
min PROC
	push esi
	push ecx								;save esi and ecx to stack
	mov eax,[esi]							;first element to eax
	add esi,TYPE array						;next element since ^
	dec ecx									;decrease by 1 as ^
	L1:
		cmp eax,[esi]						;compare eax to esi,
		JLE next							;if it less or equal to SIGN, we skip
		mov eax,[esi]						;else this is lowest values
		next:
			add esi,TYPE array				;next element
		LOOP L1

	pop ecx
	pop esi
	ret
min ENDP

;------------------------------------------
;Multi
;Multiply each of element from array
;Receves: esi,ecx and ebx for number to be multi by.
;Return: None,however it wil modify array from ESI
;------------------------------------------
multi PROC USES esi ecx
	L1:
		mov eax, [esi]						;make copy of element to eax
		IMUL EBX							;multi it by ebx that user input
		mov [esi],eax						;move product to array 
		add esi, TYPE array					;go to next element
		LOOP L1

	ret
multi ENDP

;------------------------------------------
;Divide
;Divide each of element from array
;Receves: esi,ecx and ebx for number to be divide by.
;Return: None,however it wil modify array from ESI
;------------------------------------------
divide PROC USES esi ecx 

	L1:
		mov eax, [esi]						;make copy of element to eax
		CDQ									;covert dword to qword
		IDIV EBX							;multi it by ebx that user input
		mov [esi],eax						;move quotuit to array 
		add esi, TYPE array					;go to next element
		LOOP L1

	ret
divide ENDP

;------------------------------------------
;Mod_array
;Mod each of element from array
;Receves: esi,ecx and ebx for number to be divide by to get mod.
;Return: None,however it wil modify array from ESI
;------------------------------------------
mod_array PROC USES esi ecx 

	L1:
		mov eax, [esi]						;make copy of element to eax
		CDQ									;covert dword to qword
		IDIV EBX							;multi it by ebx that user input
		mov [esi],edx						;move remainder to array 
		add esi, TYPE array					;go to next element
		LOOP L1

	ret
mod_array ENDP

;------------------------------------------
;Aritmetic_SHR
;Aritmetic shift to right of each of element from array
;Receves: esi,ecx and ebx for number to shift 
;Return: None,however it wil modify array from ESI
;------------------------------------------
artimetic_shr PROC USES esi ecx 
	L1:
		push ecx							;saving ecx to stack
		mov ecx,ebx							;getting bit to shift as shift instruction cannot be used reg-reg
		mov eax, [esi]						;getting copy to eax
		SAR eax,cl							;start shifting
		mov [esi],eax						;return back to array as  new values
		add esi, TYPE array					;to next element
		pop ecx								;restore ecx counter.
		LOOP L1

	ret
artimetic_shr ENDP

;------------------------------------------
;Artimetic_SHL
;Artimetic shift to left for each of element
;Receves: esi,ecx and ebx for number to be shift left
;Return: None,however it wil modify array from ESI
;------------------------------------------
artimetic_shl PROC USES esi ecx 
	L1:
		push ecx							;saving ecx to stack
		mov ecx,ebx							;getting bit to shift as shift instruction cannot be used reg-reg
		mov eax, [esi]						;getting copy to eax
		SAL eax,cl							;start shifting
		mov [esi],eax						;return back to array as  new values
		add esi, TYPE array					;to next element
		pop ecx								;restore ecx counter.
		LOOP L1

	ret
artimetic_shl ENDP

;------------------------------------------
;Rotate_right
;Roate to right for each of element from array
;Receves: esi,ecx and ebx for number to rotate right
;Return: None,however it wil modify array from ESI
;------------------------------------------
rotate_right PROC USES esi ecx 
	L1:
		push ecx							;saving ecx to stack
		mov ecx,ebx							;getting bit to shift as shift instruction cannot be used reg-reg
		mov eax, [esi]						;getting copy to eax
		ROR eax,cl							;start shifting
		mov [esi],eax						;return back to array as  new values
		add esi, TYPE array					;to next element
		pop ecx								;restore ecx counter.
		LOOP L1

	ret
rotate_right ENDP

;------------------------------------------
;Rotate Left
;Roate to left for each of element from array
;Return: None,however it wil modify array from ESI
;------------------------------------------
rotate_left PROC USES esi ecx 
	L1:
		push ecx							;saving ecx to stack
		mov ecx,ebx							;getting bit to shift as shift instruction cannot be used reg-reg
		mov eax, [esi]						;getting copy to eax
		ROL eax,cl							;start shifting
		mov [esi],edx						;return back to array as  new values
		add esi, TYPE array					;to next element
		pop ecx								;restore ecx counter.
		LOOP L1

	ret
rotate_left ENDP

END main
