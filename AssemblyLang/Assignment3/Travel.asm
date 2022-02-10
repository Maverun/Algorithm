TITLE Travel Distances (Travel.asm)
;Maverun
;7/19/2018
;Assignment 3 Question 2
INCLUDE Irvine32.inc

.data
speed DWORD ?;
min_hour DWORD ?;
max_hour DWORD ?;
total DWORD ?;
counter DWORD ?;

smsg BYTE "Please enter your average speed(km/hour): ",0
minmsg BYTE "Please enter the minimum number of ",
			"hours you intend to drive: ",0
maxmsg BYTE "Please enter the maximum number of ",
			"hours you intend to drive: ",0

output_title BYTE "Hours		Distance Driven",
				0dh,0ah,"---------------------------",0
space BYTE "                    ",0

.code
main PROC
	mov edx, OFFSET smsg									;Move smsg to edx
	call WriteString										;printing it off
	call ReadInt											;read it
	mov speed,eax											;speed = eax (from ReadInt ^)
	
	mov edx, OFFSET minmsg									
	call WriteString
	call ReadInt
	mov min_hour,eax										;min_hour = eax
	
	mov edx, OFFSET maxmsg
	call WriteString
	call ReadInt
	mov max_hour,eax										;max_hour = eax

	mov ecx,min_hour										;setting counter to min_hour

	mov ebx,speed											;moving speed to ebx since we cant do add mem-mem

	l1:
		add total,ebx										;total += ebx (speed)
		LOOP l1												;back to start
		
	mov ecx,max_hour										;now counter is equal to max_hour
	sub ecx,min_hour										;since loop start from top to 0, so we are doing max_hour - min_hour (e.g 10-6 = 4 for 4 loop time)
	inc ecx													;increase it by 1 yeh. (esx <= max_hour)
	mov eax,min_hour										;moving min_hour to eax so we can move it to counter (cannot do mem-mem)
	mov counter,eax

	mov edx, OFFSET output_title							;table header.
	call WriteString										;print it out
	call Crlf												;new line
	mov edx, OFFSET space									;have space in reverse

	l2:
		mov eax,counter										;we are moving counter to eax so we can print
		call WriteDec
		inc counter											;then we will increase it by 1
		call WriteString									;print space.
		mov eax,total										;now then we move total to eax.
		call WriteDec										;print it out
		call Crlf											;new line
		add total,ebx										;finally we will add it up. (ebx is speed)
		LOOP l2												;back to start till it is finish

	exit
main ENDP
END main
