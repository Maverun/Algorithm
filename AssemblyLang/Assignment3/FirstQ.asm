TITLE Question 1 (FirstQ.asm)
;Maverun
;7/19/2018
;Assignment 3 Question 1
INCLUDE Irvine32.inc

.data
P DWORD ?
R DWORD ?
T DWORD ?
S SDWORD ?
Q SDWORD ?

pmsg BYTE "Enter a unsigned value for P:",0		;Those are not ideal solutions, need to improve on string.
rmsg BYTE "Enter a unsigned value for R:",0
tmsg BYTE "Enter a unsigned value for T:",0
smsg BYTE "Enter a signed value for S:",0
qmsg BYTE "Enter a signed value for Q:",0		
answer1 Byte "(P+R) - (Q+S) + T = ",0
answer2 Byte "T + (P-R) - (S+Q) = ",0
answer3 Byte "(S+Q) + (T-P) - R = ",0

.code
main PROC

												;Asking user
	mov edx, OFFSET pmsg						;getting message to edx
	call WriteString							;Printing it off from edx
	call ReadDec								;getting input from user
	mov p,eax									;move p = eax
	
	mov edx, OFFSET rmsg						;getting message to edx
	call WriteString							;Printing it off from edx
	call ReadDec								;getting input from user
	mov r,eax									;move r = eax
	
	mov edx, OFFSET tmsg						;getting message to edx
	call WriteString							;Printing it off from edx\
	call ReadDec								;getting input from user
	mov t,eax									;move t = eax
	
	mov edx, OFFSET smsg						;getting message to edx
	call WriteString							;Printing it off from edx
	call ReadInt								;getting input from user
	mov s,eax									;move s = eax
	
	mov edx, OFFSET qmsg						;getting message to edx
	call WriteString							;Printing it off from edx
	call ReadInt								;getting input from user
	mov q,eax									;move q = eax

												;calculate time
												;Answer 1									
												; (p+r)
	mov eax,p									;making eax = p
	add eax,r									;eax += r
	mov ebx,q									;ebx = q
	add ebx,s									;ebx += s
	sub eax,ebx									;eax -= ebx
	add eax,t									;eax += t
	mov edx, OFFSET answer1						;moving answer1 to ebx
	call WriteString							;to print it off
	call WriteInt								;print answer 1
	call Crlf									;new line

												;Answer 2
	mov eax,t									; eax = t
	mov ebx,p									; ebx = p
	sub ebx,r									; ebx -= r
	add eax,ebx									; eax += ebx
	mov ebx,s									; ebx = s
	add ebx,q									; ebx += q
	sub eax,ebx									; eax -= ebx
	mov edx, OFFSET answer2						;moving answer 2 to ebx
	call WriteString							;printing out string
	call WriteInt								;printing out answer
	call Crlf									;new line

												;Answer 3
	mov eax,s									;eax = s
	add eax,q									;eax += q
	mov ebx,t									;ebx = t
	sub ebx,p									;ebx -= p
	add eax,ebx									;eax += ebx
	sub eax,r									;eax -= ebx
	mov edx, OFFSET answer3
	call WriteString
	call WriteInt
	call Crlf									;new line

	exit
main ENDP
END main
