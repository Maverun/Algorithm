TITLE Merge String (MergeString.asm)
;This program will take two string and merge them.
COMMENT @

string1 = input()
string2 = input()
string3 = ""

for i in range(len(string1)+len(string2)):
	string3[i] = string1[i]
	string3[i+1] = string2[i]

print("Merged String 1 and String 2: ",string3)
#repeat for string 2 and string1 merge.
@

INCLUDE Irvine32.inc
StringMerge Proto, str1:PTR BYTE, str2:PTR BYTE, str3:PTR BYTE, strsize:DWORD


.data 
prompt1 BYTE "Enter string 1: ", 0				;set message to ask user about string
prompt2 BYTE "Enter string 2: ", 0 

msg1 BYTE "Merged String 1 and String 2: ", 0	;info user a result of merge.
msg2 BYTE "Merged String 2 and String 1: ", 0 

string1 BYTE 250 DUP(0)							;String1 of 250 char
string2 BYTE 250 DUP(0)							;String2 of 250 char
string3 BYTE 500 DUP(?)							;combine of string1 and string2 so meaning 500

.code 


main PROC
	
	mov edx,OFFSET prompt1				;setting up message
	call WriteString					;print of asking user for string 1
	mov edx,OFFSET string1				;set up Buffer like in java, System.in(Scanner) something like that
	mov ecx,LENGTHOF string1			;getting size of buffer, ALSO it allow you to type in for input.
	call ReadString						;read input from user

	mov edx,OFFSET prompt2				;setting up message
	call WriteString					;print of asking user for string 2
	mov edx,OFFSET string2				;set up Buffer like in java, System.in(Scanner) something like that
	mov ecx,LENGTHOF string2			;getting size of buffer, ALSO it allow you to type in for input.
	call ReadString						;read input from user
	
	INVOKE StringMerge,					;StringMerge(string1,string2,string3,len(string3))
			ADDR string1,
			ADDR string2,
			ADDR string3,
			LENGTHOF string3
	
	mov edx, OFFSET msg1				;Setting up message and then show user the result of merge string2 into string1
	call WriteString
	mov edx, OFFSET string3 
	call WriteString 
	call Crlf 

	INVOKE StringMerge,					;StringMerge(string2,string1,string3,len(string3))
			ADDR string2,
			ADDR string1,
			ADDR string3,
			LENGTHOF string3

	mov edx, OFFSET msg2				;Setting up message and then show user the result of merge string2 into string1
	call WriteString
	mov edx, OFFSET string3 
	call WriteString 
	call Crlf


	exit
main ENDP

;------------------------------------------
;StringMerge
;Merging string2 into string1
;E.G string1: "Hello", string2:"There"
;Result: HTehleroe
;Receves: 4 params, first 3 params are address of array, last param is size of string 3 that is result of merge
;str1 will be first char while str2 will be 2nd char to put into it.
;Return: None
;------------------------------------------
StringMerge PROC,
	str1:PTR BYTE,						;Parameters.
	str2:PTR BYTE,
	str3:PTR BYTE,
	strsize:DWORD

	mov ecx,strsize						;setting merge string size
	mov esi,str1						;offset to esi
	mov edi,str2						;offset to edi
	mov edx,str3						;offset to edx
	L1:
		start:							;starting body.
			mov al,[esi]				;first string
			cmp al,0					;checking if it null
			JE skip_first				;if al == null: skip to string 2
			mov BYTE PTR [edx],al		;add values to merge string
			inc esi						;go next element of string1
			inc edx						;next element of string3 (merge) for string2


		skip_first:						;second string
			mov al,BYTE PTR [edi]		;second string of char
			cmp al,0					;compare al to 0 which is null
			JE skip						;if al == null: skip to end of loops
			mov BYTE PTR [edx],al		;add values to merge string
			inc edi						;next element of string2
			inc edx						;next element of string3 (merge) for string3

		skip:
			LOOP L1						;back to start if ecx != 0
	ret
StringMerge ENDP

END main		