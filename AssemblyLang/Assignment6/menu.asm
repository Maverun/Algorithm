TITLE Menu (Menu.asm)
;This program will take input from users and do something in 5 options that user select. This program is created for testing advanced producre 
COMMENT @
1 – Populate the array with random numbers (user supplied range) 
2 – Multiply the array with a user provided multiplier 
3 – Divide the array with a user provided divisor 
4 – Mod the array with a user provided divisor 
5 – Print the array 
0 - Exit 

Each options will have their own functions
in option 5 where we print out array, other procedure will also print in their own message, such as Populate array, return message "Done populate array between {low} and {high}

option 1 must be using Invoke and param accept without using local
option 2,3,4 get number for user to use it and make it as unnamed stack param. result of it is store in dword.
stack parameters must be remove when it is return.

as for 5, it should be print in sign with {}, so {+1,-2,+12} and parameters is passed with name(invoke) OR parametes in stack.


Before we start loops, we will store 3 stuff to stack
Array
LengthOF array (len(array) for ecx)
TYPE Array (to get type in order to go next element

The reason for doing this before loops is that all function for those menu options are same common. 
then for 2-4, common is number that they will use to multi/mod/divide.
for 5th, nothing, just those 3 common one.
for first one, it has two more params which are low and high number for random generate.

@

INCLUDE Irvine32.inc
RandInt PROTO, low_number: PTR sdword,high_number:PTR sdword 

.data
InputBuffer BYTE 40 dup(?),0
array SDWORD 12 DUP(0)


low_msg BYTE "Enter the low number: ",0				;since we will be asking user for low number
high_msg BYTE "Enter the high number: ",0			;we will also ask for high number to generate random range
asking_number BYTE "Please enter the number: ",0	;this is for 6-8 and A-D options where we will ask user for number in order to do something in array such as multi

menu_msg BYTE "1: Populate the array",13,10,		;menu to print out so user can select
			  "2: Multiply array",13,10,
		   	  "3: Divide array",13,10,
			  "4: Mod array",13,10,
			  "5: Print the array",13,10,
			  "0: Exit the program",13,10,0
.code

main PROC
	call Randomize							;Initate random generator

	push OFFSET array						;storing them in stack "forever", it should be 8 + 4*amount of local param. OFFSET of array
	push LENGTHOF array						;storing them in stack "forever", it should be 4 + 4*amount of local param. len(array)
	push TYPE array							;but we also will need type of it so we can add element. As we can see, all function have 3 common parameters.
											;This is what those 3 are for.

	while_loop:
		call Clrscr							;clear out screen.
		mov edx,OFFSET menu_msg				;Function that show menu
		call WriteString					;print it out

		mov edx,0							;reset edx to 0
		mov dh,10							;setting dh to row
		mov dl,0							;setting dl to col
		call Gotoxy							;move cursor to coord row:col

		call Crlf
											;Prompt user for input
		mov al,">"							;setting up > so we can tell user start type in
		call WriteChar						;print it out
		call ReadDec
		cmp eax,0							;checking eax == 0
		JE done								;if eax == 0, end program.

		CMP eax,5
		JA while_loop						;if it greater than 5.
											;From here, this is switch cases
		Case1:								;making array
			cmp eax,1						;eax == 1
			JNE Case2						;eax != 1 go to next case
			call AskRandom
			push eax						;+12 in stack
			push ebx						;+8 in stack
			call array_create
			jmp next_loop
		Case2:								;Multi it by. At this point, Array,Size,N for rest of cases 2-4.
			cmp eax,2						;eax == 2
			JNE Case3						;eax != 2 go next cases
			call get_number					;asking user.
			push eax						;now we will put this number to stack that we will use it for multi or divide or mod etc.
			call multi						;multi each element
			jmp next_loop
		Case3:
			cmp eax,3
			JNE Case4
			call get_number					;asking user.
			push eax						;now we will put this number to stack that we will use it for multi or divide or mod etc.
			call divide
			jmp next_loop

		Case4:
			cmp eax,4
			JNE Case5
			call get_number					;asking user.
			push eax						;now we will put this number to stack that we will use it for multi or divide or mod etc.
			call mod_array
			jmp next_loop

		Case5:
			cmp eax,5						;compare eax to 5
			JNE while_loop					;if not equal to 5 or below we will go back to start.
			call print_array				

		next_loop:							;go to next loop.
			mov eax,1000
			call Delay


			JMP while_loop

	done:



	exit
main ENDP

;------------------------------------------
;AskRandom
;Ask user for input
;Receves: none
;Return; ebx as low, eax as high
;------------------------------------------
AskRandom PROC USES edx
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
	ret

AskRandom ENDP

;------------------------------------------
;RandInt
;Generate random number
;Receves: low and high number params.  This is Invoke method.
;Return: EAX = Random number between eax-ebx
;------------------------------------------
RandInt PROC,
	low_number:PTR SDWORD,					;Integer low number
	high_number:PTR SDWORD					;Integer high number

	mov eax,high_number
	sub eax,low_number						;substract eax to ebx, for etc, 100-50 for 50-100
	inc eax									;inc by 1 so we can get 100 as well instead of 99
	call RandomRange						;generate number
	add eax,low_number						;add low number to it, meaning (100-50+1) + 50, so rand give 20, we get 70 instead which fit in 50-100
	ret
RandInt ENDP

;------------------------------------------
;array_create
;Generate array with random number in
;Receves: stack. +24 is pointer to array, +20 is counter, +16 is Type of array, +12 is high number and +8 is low number.
;Return: ESI pointer of array has created
;------------------------------------------
array_create PROC
	.data
		msg BYTE "Array has created between ",0
	.code
	push ebp								;saving ebp.
	mov ebp, esp
	pushad

	mov esi,[ebp+24]						;getting array one
	mov ecx,[ebp+20]						;counter
	L1:
		INVOKE RandInt,[ebp+8],[ebp+12]		;generate number, +8 is low number and +12 is high number
		mov [esi],eax						;transfer to esi
		add esi,[ebp+16]					;next element, +16 is type of data.
		LOOP L1

	mov edx, OFFSET msg
	call WriteString
	mov eax,[ebp+8]
	call WriteInt
	mov al,'&'
	call WriteChar
	mov eax,[ebp+12]
	call WriteInt
	call Crlf

	popad
	mov esp,ebp
	pop ebp
	ret 8									;removing 12 which is 2 parameters and 2 remain parameters wont be touch which are pointer of array and size of it

array_create ENDP

;------------------------------------------
;print_array
;Print all element in array, format [n1,n2,n3]
;Receves: Stack, +16 is pointer to array, +12 is counter and +8 is type of array
;Return: None
;------------------------------------------
print_array PROC 
	push ebp
	mov ebp, esp
	pushad
	mov esi,[ebp + 16]						;getting values from params, 20 - Array, 16 - ECX, and +8 is type of array.
	mov ecx,[ebp + 12]

	mov al, "{"								;set { to al
	call WriteChar							;print out {
	L1:
		mov eax,[esi]
		add esi,[ebp+8]						;next element
		call WriteInt						;print it out
		cmp ecx,1							;compare ecx to 1,
		JE break							;if it equal to 1, we will skip to avoid printing ,
		mov al,","							;if not we will set up "," to it
		call WriteChar						;print out comma
		LOOP L1
	Break:									;break of loop
	mov al,"}"								;last thing to do is adding } to it
	call WriteChar							;print
	
	popad
	mov esp,ebp
	pop ebp
	ret 									;remove type of array from stack.
print_array ENDP

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
;Multi
;Multiply each of element from array
;Receves: Stack, +20 is pointer to array, +16 is counter and +12 is type of array, and +8 is number we will use it for.
;Return: None,however it wil modify array from ESI
;------------------------------------------
multi PROC
	.data
		multi_msg BYTE "Array has multi by ",0
	.code

	push ebp								;saving ebp so we can use "esp"
	mov ebp, esp
	pushad
	mov esi,[ebp + 20]						;getting values from params, 20 - Array, 16 - ECX, ebx is values to be multi by
	mov ecx,[ebp + 16]
	mov ebx,[ebp + 8]

	L1:
		mov eax, [esi]						;make copy of element to eax
		IMUL EBX							;multi it by ebx that user input
		mov [esi],eax						;move product to array 
		add esi, [ebp+12]					;go to next element
		LOOP L1
	mov edx,OFFSET multi_msg
	call WriteString
	mov eax,ebx
	call WriteInt
	call Crlf

	popad									;restore registers AND restore esp.
	mov esp,ebp	
	pop ebp

	ret 4
multi ENDP

;------------------------------------------
;Divide
;Divide each of element from array
;Receves: Stack, +20 is pointer to array, +16 is counter and +12 is type of array, and +8 is number we will use it for.
;Return: None,however it wil modify array from ESI
;------------------------------------------
divide PROC
	.data
		divide_msg BYTE "Array has divided by ",0
	.code

	push ebp								;saving ebp so we can use "esp"
	mov ebp, esp
	pushad
	mov esi,[ebp + 20]						;getting values from params, 20 - Array, 16 - ECX, ebx is values to be divide by
	mov ecx,[ebp + 16]
	mov ebx,[ebp + 8]

	L1:
		mov eax, [esi]						;make copy of element to eax
		CDQ									;covert dword to qword
		IDIV EBX							;multi it by ebx that user input
		mov [esi],eax						;move quotuit to array 
		add esi, [ebp+12]					;go to next element
		LOOP L1

	mov edx,OFFSET divide_msg				;getting msg to let user know it work fine.
	call WriteString
	mov eax,ebx								;print number what it was used
	call WriteInt
	call Crlf
	popad									;restore registers AND restore esp.
	mov esp,ebp
	pop ebp

	ret 4
divide ENDP

;------------------------------------------
;Mod_array
;Mod each of element from array
;Receves: Stack, +20 is pointer to array, +16 is counter and +12 is type of array, and +8 is number we will use it for.
;Return: None,however it wil modify array from ESI
;------------------------------------------
mod_array PROC
	.data
		mod_msg BYTE "Array has been mod by ",0
	.code
	push ebp								;saving ebp so we can use "esp"
	mov ebp, esp
	pushad
	mov esi,[ebp + 20]						;getting values from params, 20 - Array, 16 - ECX, ebx is values to be mod by
	mov ecx,[ebp + 16]
	mov ebx,[ebp + 8]
	L1:
		mov eax, [esi]						;make copy of element to eax
		CDQ									;covert dword to qword
		IDIV EBX							;multi it by ebx that user input
		mov [esi],edx						;move remainder to array 
		add esi, [ebp+12]					;go to next element and +12 is type of array.
		LOOP L1

	mov edx,OFFSET mod_msg					;getting msg to let user know it work fine.
	call WriteString
	mov eax,ebx								;print number what it was used
	call WriteInt
	call Crlf
	popad									;restore registers AND restore esp.
	mov esp,ebp
	pop ebp
	ret 4
mod_array ENDP



END main