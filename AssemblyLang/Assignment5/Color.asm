TITLE Color (Color.asm)
;This program will collect string and print them in colorish
COMMENT @
Get string input (max 40 char) from, user
Generate random gen 0-15 for about 2 time for fore and back.
have two var col, row to 10 
run loops 300 times 

so we need to set cursor at certain row/col
row is DH and COL is DL

then we will set color based of 0,15 foreground and background
then we will print text
once foreground hit 0, decrease background color
then we will rotate string to left, FIRST char is on end. so meaning we roate once?
as we continue, once we hit row 30, reset to 10 and inc column values
We then delay 1/5 sec then run loops again


Change of a plan a bit, as Jump is too far from loops

create setXY_Color
where it will set coord for xy and change color.

as for rotate string
we cannot use ROL or any of those as it wont work
So what i did is 

array = input

for x in range(0,len(array)):
	holder = array[x]
	next_ele = array[x+1]
	if next_ele == 0:
		break
	array[x] = next_ele
	array[x+1] = holder
	#back to start.

which mean, for each loops, we have two register holding them, current and NEXT one 
it will check next one, if it 0 which is null, it will stop there
other wise it will switch around positon. Continue toward end.

@

INCLUDE Irvine32.inc

.data

InputBuffer BYTE 40 dup(?),0


fore DWORD ?
default_fore DWORD ?
default_back DWORD ?
back DWORD ?
row BYTE 10
col BYTE 10

msg BYTE "Enter a string (max 40 char): ",0
.code

main PROC
	call Randomize							;Initate random generator
	mov edx,OFFSET msg						;asking user for input
	call WriteString						;print it
	mov edx,OFFSET InputBuffer				;set up buffer
	mov ecx,LENGTHOF InputBuffer			;set character limit
	call ReadString							;count

	mov eax,15								;setting high
	mov ebx,0								;setting low
	call RandomRange						;Get random number
	mov fore,eax							;setting foreground color
	mov default_fore, eax					;set it as default so we can reuse it
	mov eax,15								;reset eax to 15
	call RandomRange						;generate new number again
	mov back,eax							;setting background color
	mov default_back, eax					;default values

	call Clrscr								;clear screen.
	mov ecx,300								;as we will loop 300 time

	L1:
		call setXY_Color					;set coord for xy and color
		mov edx,OFFSET InputBuffer			;set up string
		call WriteString					;print out
		call rotate_string					;rotate it

		cmp row,31							;if compare row to 31
		JNE skip_row						;if it not 31 yet, we will skip
		mov row,9							;setting it 9 instead of 10, because at skip_row, it will increase 1 so.
		inc col								;and go to next column
	skip_row:
		inc row								;Go to next row.
		mov eax,200							;if done math correctly,1/5 sec is 200 ms
		call Delay							;Delay it.
		LOOP L1

	mov dh,35
	mov dl,0
	call Gotoxy

	exit
main ENDP

RandInt PROC
	sub eax,ebx								;substract eax to ebx, for etc, 100-50 for 50-100
	inc eax									;inc by 1 so we can get 100 as well instead of 99
	call RandomRange						;generate number
	add eax,ebx								;add low number to it, meaning (100-50+1) + 50, so rand give 20, we get 70 instead which fit in 50-100
	ret
RandInt ENDP

setXY_Color PROC
	mov edx,0								;reset edx to 0
	mov dh,row								;setting dh to row
	mov dl,col								;setting dl to col
	call Gotoxy								;move cursor to coord row:col
	mov eax, fore							;getting eax of foreground color
	mov ebx, back							;setting ebx of background color
	SHL ebx,4								;shift to left by 4 or as in * 16
	add eax,ebx								;add it up, that way we get two combine color
	call SetTextColor						;setting text color

	dec fore								;decrease by 1
	cmp fore,0								;compare it to 0
	JNE skip_color							;if it not 0, we will skip decrease back
	dec back								;if it 0, we will decrease back
	mov eax,default_fore					;then reset fore
	mov fore, eax							;reset it
	cmp back,0								;if back is 0
	JNE skip_color							;if it not 0, we skip
	mov eax,default_back					;get default values
	mov back,eax							;reset it
	skip_color:
	ret
setXY_Color ENDP

rotate_string PROC USES ecx esi
	mov ESI,OFFSET InputBuffer				;OFFSET string
	mov ecx,LENGTHOF InputBuffer			;set counter of total array

	L1:
		mov eax,0							;reset it in case
		mov ah,[esi]						;move current element to ah
		mov al,[esi+1]						;mov next element to al
		cmp al,0							;compare al to 0 (next element to 0)
		JE skip								;if it equal, this mean it is null and end of string so we skip
		mov [esi],al						;if okay, we will put next element to current element
		mov [esi+1],ah						;meanwhile we put current element to next element
		inc esi								;increase index
		LOOP L1								;back to start if ecx is not 0 yet.
	skip:
	ret
rotate_string ENDP

END main