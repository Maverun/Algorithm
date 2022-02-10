TITLE 2D Array Menu (ArrayMenu.asm)
;This program will be like menu with Array.
COMMENT @
For more explain and how I thoughts of process
https://poly.google.com/u/2/view/3bnM4QULz2P

to print 2D array is straight forward
for i in range(row):
	for j in range(col):
		print(array[i][j])

Altho for most function, it only used one loops which is total of columns since there is math for each 

I used one loops of col and have 3-4 index reg for values

While True:
	Print(menu)
	answer = input
	if answer == "A":
		RandomArray(array,col,row)
	elif answer == "B":

Using switch cases inside true loop unless one of cases trigger then back to start unless user enter "G" to exit program.

@

INCLUDE Irvine32.inc
PrintRow PROTO, array:PTR SDWORD,row:DWORD,col:DWORD
PrintArray PROTO, array:PTR SDWORD,row:DWORD,col:DWORD
AddArray PROTO, array:PTR SDWORD,row:DWORD,col:DWORD

RandInt Proto, low_number:PTR SDWORD,high_number:PTR SDWORD
.data 
column DWORD 8
row_data DWORD 6

array_data SDWORD 6*8 DUP(0)

randommsg BYTE "Generate Random done",0
Initialmsg BYTE "Initial 2D-table Values",0

addmsg BYTE "Done adding A and B",0
multimsg BYTE "Done Multiply B and C then divide with 3",0
dividemsg BYTE "Done Divide D and A also mod D and A",0


Row1 BYTE "Random A      ",0
Row2 BYTE "Random B      ",0
Row3 BYTE "C = A + B     ",0
Row4 BYTE "D = B * C / 3 ",0
Row5 BYTE "E = D / A     ",0
Row6 BYTE "F = D % A     ",0

menumsg BYTE "A:Generate Random A and B",13,10,
			"B: Print Inital tables",13,10,
			"C:C = A + B",13,10,
			"D:D = B * C / 3",13,10,
			"E:E = D / A and D % A",13,10,
			"F:Printing tables",13,10,
			"G:E to exit",0
.code 


main PROC
	call Randomize
	
	while_loop:
		call Clrscr							;clearing out screen
		mov edx,OFFSET menumsg				;setting up menu text
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
		call isLetter						;checking if it letter
		JNZ while_loop						;if it not letter AND not digit then we will reset loops
		AND al,11011111b					;to upper case, al.upper()
		cmp al,"G"							;checking if it not A-D
		JE quit
		JA while_loop

		caseA:								;This is for generate random
			cmp eax,"A"						;compare eax to its case
			jne caseB						;if it not equal, we check next
			mov esi,OFFSET array_data
			mov ecx,column
			mov edx,row_data
			call RandomArray				;call function
			jmp done						;jump to done once done
		caseB:								;same as case A but for artimetic shift left
			cmp eax,"B"
			jne caseC
			push OFFSET array_data
			push column
			push row_data
			call ShowInitialArray
			jmp done
		caseC:							;same as case B but for rotate right
			cmp eax,"C"
			jne caseD
			invoke AddArray,ADDR array_data,row_data,column
			jmp done
		caseD:							;same as case C but for rotate left
			cmp eax,"D"
			jne caseE
			push OFFSET array_data
			push column
			push row_data
			call MultiArray
			jmp done
		caseE:							;same as case E but for rotate left
			cmp eax,"E"
			jne caseF
			push OFFSET array_data
			push column
			push row_data
			call DivideArray
			jmp done
		caseF:							;same as case E but for rotate left
			cmp eax,"F"
			jne done
			invoke PrintArray,ADDR array_data,row_data,column
		done:
			mov eax,2500					;set 2.5 second
			call Delay						;Delay it.
			jmp while_loop
		
		quit:

	exit
main ENDP

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
;RandArray
;Generate random number in first two rows
;Receves:eci:OFFSET Array|ecx:columns|edx:row
;Return: None but array of first two rows will be generate -250 to 500
;------------------------------------------
RandomArray PROC
	push esi		;array
	push ecx		;columns
	push edx		;row
		
	call ClearArray	;reset everything from array.

	xchg ecx,edx	;as we need to start with row first.

	mov ecx,2		;as we will be only creating random values in first two row.
	mov edi,0
	L1:
		push ecx
		mov ecx,edx	;getting column values
		L2:
			INVOKE RandInt,-250,500				;generate random from -250 to 500
			mov [esi + edi * TYPE DWORD],eax	;put it into array
			inc edi								;next index
			LOOP L2								;if ecx not 0 then back to L2
		pop ecx									;get outer loop counter
		LOOP L1

	mov edx,OFFSET randommsg					;to let user it done create random
	call WriteString
	call Crlf

	pop edx
	pop ecx
	pop esi
	ret
RandomArray ENDP

;------------------------------------------
;ClearArray
;Reset array, which mean makinge everything 0
;Receves:eci:OFFSET Array|ecx:columns|edx:row
;Return: None but array will be reset
;------------------------------------------
ClearArray PROC
	push edi
	push edx
	push ecx

	mov eax,0
	mov edi,0
	L1:
		push ecx
		mov ecx,edx			;some how, just directly col will make it 0 instead of original values
		L2:
			mov [esi + edi * TYPE DWORD],eax ;set it to 0.
			inc edi
			LOOP L2
		pop ecx
		LOOP L1

	pop ecx
	pop edx
	pop edi

	ret
ClearArray ENDP

;------------------------------------------
;AddArray
;Add first two row and store them in third row
;Receves:eci:OFFSET Array|ecx:columns|edx:row via Invoke
;Return: None
;------------------------------------------
AddArray PROC,
	array:PTR SDWORD,
	row:DWORD,
	col:DWORD

	mov ecx,3								;as we will be only adding first two rows and add result to third

	mov eax,col								;passing col to it so we can get at certain row to add values into it
	mov ebx,2								;3rd row 
	mul ebx									;get coord to there so we can add values into it
	mov edi,0								;first row 
	mov ebx,col								;2nd row.

	mov edx,eax								;3rd row

	mov ecx,col								;run loops total of column, no need for rows. 
	L1:
		mov eax,[esi+edi * TYPE DWORD]		;get first row
		add eax,[esi+ebx * TYPE DWORD]		;add with 2nd row
		mov [esi + edx * TYPE DWORD],eax	;transfer to 3rd row
		inc edi								;incease each by 1
		inc ebx
		inc edx
		LOOP L1

	mov edx,OFFSET addmsg					;info user that it has done additions.
	call WriteString
	call Crlf

	ret
AddArray ENDP

;------------------------------------------
;MultiArray
;Multi 2nd and 3rd row them divide them by 3 and store it into 4th row
;Receves:eci:OFFSET Array|ecx:columns|edx:row via Invoke
;Return: None
;------------------------------------------
MultiArray PROC
	Enter 8,0
	mov DWORD PTR [ebp-8],3					;number to be divide

	mov ecx,[ebp+8]							;rows
	mov esi,[ebp+16]						;array

	mov eax,[ebp+12]						;getting 3rd row for multi
	mov ecx,2								;to get 3rd row, index start at 0 reminder.
	mul ecx									;multi it by 2
	mov ebx,eax								;now we can put 3rd row int oit

	mov eax,[ebp+12]						;getting 4th row for result
	mov ecx,3								;getting 4th row, remember index start at 0 not 1
	mul ecx									;multi it
	mov [ebp-4],eax							;using local variables, so copy it into it
	
	mov edi,[ebp+12]						;geting 2nd row instead of first row, so column is enough.

	mov ecx,[ebp+12]						;run loops total of column, no need for rows. 
	L1:


		mov eax,[esi+edi * TYPE DWORD]		;get second row values
		imul DWORD PTR [esi+ebx * TYPE DWORD];multi with 3rd row
		idiv DWORD PTR [ebp-8]
		mov edx,[ebp-4]
		mov [esi + edx * TYPE DWORD],eax	;transfer to 4th row
		inc edi								;incease each by 1
		inc ebx
		inc DWORD PTR [ebp-4]
		LOOP L1
		
	mov edx,OFFSET multimsg					;info user that it has done multi and divide.
	call WriteString
	call Crlf
	Leave
	ret
MultiArray ENDP

;------------------------------------------
;DivideArray
;Divide 4th row with first row and store / in 5th and finally mod in 6th row
;Receves:eci:OFFSET Array|ecx:columns|edx:row via Invoke
;Return: None
;------------------------------------------
DivideArray PROC
	push ebp
	mov ebp, esp
	pushad

	sub esp,16									;getting 4 local variables.
												;16 is array, 12 is col, 8 is row
												;-4 is A, -8 is D, -12 is D/A and -16 is D%A
	mov esi,[ebp+16]
	mov eax,[esi]
	
	mov DWORD PTR [ebp-4],0						;A as it is first row
	
	mov eax,[ebp+12]							;D	as it is on 4th row
	mov ebx,3
	mul ebx
	mov DWORD PTR [ebp-8],eax					;D
	
	mov eax,[ebp+12]							;E as it is on 5th row
	mov ebx,4
	mul ebx
	mov DWORD PTR [ebp-12],eax					;E

	mov eax,[ebp+12]							;F as it is on last row which is 6th
	mov ebx,5
	mul ebx
	mov DWORD PTR [ebp-16],eax					;F


	mov esi,[ebp+16]							;set up array so easier to used it
	mov ecx,[ebp+12]							;counter loops of Column.
	L1:
		mov edi,[ebp-8]							;Getting D
		mov eax,[esi + edi * TYPE DWORD]


		mov edi,[ebp-4]							;getting A
		mov edx,0
		cmp edx,0
		JE go_next
		CDQ
		idiv DWORD PTR [esi + edi * TYPE DWORD]	;eax is / and edx is %
		
		mov edi,[ebp-12]						;getting D/A row
		mov [esi + edi * TYPE DWORD],eax		;saving / into array


		mov edi,[ebp-16]						;getting D%A row
		mov [esi + edi * TYPE DWORD],edx		;saving % into array
		
		go_next:

			inc DWORD PTR [ebp-4]					;increase index of col by 1 for each row (A,D,E,F)
			inc DWORD PTR [ebp-8]
			inc DWORD PTR [ebp-12]
			inc DWORD PTR [ebp-16]

		LOOP L1

	
	
	mov edx,OFFSET dividemsg					;info user that it has done multi and divide.
	call WriteString
	call Crlf
	
	add esp,16									;remove local
	popad										;restore everything
	mov esp,ebp									;restore stack
	pop ebp
	ret 12										;remove 3 params
DivideArray ENDP

;------------------------------------------
;PrintRow
;Printing only on that row.
;Receves: 3 params. ADDR array, row, col
;Return: None
;------------------------------------------
PrintRow PROC USES edi esi ecx,
	array:PTR SDWORD,
	row:DWORD,
	col:DWORD

	mov esi,array

	mov eax,col					;getting col 
	mul row						;multi it by row, if it first row which is 0, so it will be at array[0][0] etc
	mov edi,eax					

	mov al,"["
	call WriteChar

	mov ecx,col
	L1:
		mov eax,[esi + edi * TYPE DWORD] ; esi is base, edi is where index as 2D or 3D array are actually 1D.
		call WriteInt
		
		cmp ecx,1
		JE skip							;if ecx is equal to 1which mean it is last index so we will skip ,
		mov al,","
		call WriteChar
		mov al," "
		call WriteChar
		
		inc edi
		LOOP L1
	skip:
	mov al,"]"
	call WriteChar
	call Crlf
	
	ret
PrintRow ENDP

;------------------------------------------
;ShowInitialArray
;Print first two row
;Receves:eci:OFFSET Array|ecx:columns|edx:row via Invoke
;Return: None
;------------------------------------------
ShowInitialArray PROC
	push ebp
	mov ebp,esp
										;we wont need one for row since we only want to print first two row.
	mov edx,OFFSET Initialmsg
	call WriteString
	call Crlf

	Invoke PrintRow,[ebp+16],0,[ebp+12]	;first row
	Invoke PrintRow,[ebp+16],1,[ebp+12]	;second row
	
	mov esp,ebp
	pop ebp
	ret 12
ShowInitialArray ENDP

;------------------------------------------
;PrintArray
;Print whole thing with label in.
;Receves:eci:OFFSET Array|ecx:columns|edx:row via Invoke
;Return: None
;------------------------------------------
PrintArray PROC,
	array:PTR SDWORD,
	row:DWORD,
	col:DWORD
	mov esi,array
	mov ecx,row
	mov edi,0

	mov edx,OFFSET Row1			;for rest below, we are printing label then print row with row index, 0 then 1 etc
	call WriteString
	Invoke PrintRow,esi,0,col
	
	mov edx,OFFSET Row2
	call WriteString
	Invoke PrintRow,esi,1,col
	

	mov edx,OFFSET Row3
	call WriteString
	Invoke PrintRow,esi,2,col
	
	mov edx,OFFSET Row4
	call WriteString
	Invoke PrintRow,esi,3,col
	
	mov edx,OFFSET Row5
	call WriteString
	Invoke PrintRow,esi,4,col
	
	mov edx,OFFSET Row6
	call WriteString
	Invoke PrintRow,esi,5,col
	
	ret
PrintArray ENDP

END main		