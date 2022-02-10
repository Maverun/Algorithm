TITLE Floating Point Binary (FloatingBinary.asm)
;This program will take number in and create floating point binary
COMMENT @



@

INCLUDE Irvine32.inc

.data
values REAL4 ?
pass_data REAL4 ?
msg BYTE "Enter the number to show Single Float (0 to break): ",0
special_case BYTE "Now we will do special cases",0
.code

main PROC


	while_true:								;infinte loops till user enter 0
		mov edx,OFFSET msg					;set up question msg
		call WriteString					;print it
		call ReadFloat						;input from user
		fldz								;push zero to FPU
		fcomp								;compare it and pop
		FNSTSW AX							;mov FPU flag to ax
		SAHF								;copy ah to eflags register
		JE break							;if st(1) == 0 , we will break loop.


		FST values							;make copy to values
		call printdec						;print values
		call Crlf							;new line
		FFREE ST(0)							;free it
		jmp while_true						;back to start

	break:									;if user enter 0 in keys
	FFREE ST(0)								;free slot
	
	mov edx,OFFSET special_case				;info user that we are making special cases
	call WriteString						;print it out
	call Crlf

																;this is same for rest below but different number
	mov pass_data, 10000000000000000000000000000000b			;-zero
	FLD pass_data												;push values into stack
	call printdec												;we print it out
	call Crlf													;new line
	FFREE ST(0)													;new slot
																;just like that, repeat for below but with different number.
	mov pass_data, 00000000000000000000000000000000b			;+zero
	FLD pass_data
	call printdec
	call Crlf
	FFREE ST(0)

	mov pass_data, 01111111100000000000000000000000b			;+infinty
	FLD pass_data
	call printdec
	call Crlf
	FFREE ST(0)

	mov pass_data, 11111111100000000000000000000000b			;-infinty
	FLD pass_data
	call printdec
	call Crlf
	FFREE ST(0)

	mov pass_data, 01111111111111111111111111111111b			;SNaN
	FLD pass_data
	call printdec
	call Crlf
	FFREE ST(0)
	
	mov pass_data, 01111111111111111111111111111111b			;QNaN since both are similar so we just say it is NaN
	FLD pass_data
	call printdec
	call Crlf
	FFREE ST(0)

	call ShowFPUStack											;show that there is nothing in stack

	exit
main ENDP

;------------------------------------------
;printdec
;Print out Dec format from IEEE format.
;if Expo is 255 which mean it is special cases
;Receves: None
;Return: None
;------------------------------------------
printdec PROC
	LOCAL default_value:DWORD,holder:DWORD						;local variables
	fst default_value											;make copy of it
	mov ebx,0													;set ebx 0
	mov edx,0													;set edx 0
	mov ebx,default_value										;now we are passin values to ebx

	SHLD edx,ebx,1												;shift to left to get sign
	SHL ebx,1													;shift left of original values as well
																;- or +
	mov al,"+"													;assume it is positives
	cmp edx,0													;compare edx to 0
	JE skip_pos													; edx == 0, we skip this next line
	mov al,"-"													; edx != 0, we declare -
	skip_pos:													;skip if it already positives
	call WriteChar												;print it out
	
	mov edx,0													;reset edx to 0
	SHLD edx,ebx,8												;now we will shift to left by 8 to get EXPORENTS 
	SHL ebx,8													;same thing to original as we dont need it anymore

	mov holder,edx												;now pass edx to holder which are expo so we can check if it special cases or not
	cmp edx,255													;compare edx to 255
	JNE zero													;if it not 255 then we will jump to 0 that might be +0 or -0 OR not special cases
	cmp ebx,0													;if it, we will compare ebx to 0 to check if it infinite or just NaN
	JNE isNAN													;if ebx != 0 we jump to Nan
	mov al,236													;set up infite sign
	call WriteChar												;print
	jmp done													;skip to done
	isNAN:														;if it indeed Nan we will print NaN
		mov al,"N"
		call WriteChar
		mov al,"A"
		call WriteChar
		mov al,"N"
		call WriteChar
		jmp done
	zero:														;if it indeed 0 so we will check edx (msta) part to ensure
		cmp edx,0												;compare whole thing to 0
		JNE not_case											;if edx != 0, we skip to not_case
		mov al,"0"												;else we will just print 0
		call WriteChar
		jmp done
		JNE not_case

	not_case:


	mov eax,127													;mov eax to 127
	sub holder,eax												;to get unbiased number


																;print 1.xxxxxx
	mov al,"1"
	call WriteChar
	mov al,"."
	call WriteChar
	
	mov eax,ebx													;to print msta part (fractal which is 23 bit)
	call Writebin

																;for POWER 2^etc	
	mov al, " "
	call WriteChar
	mov al, "2"
	call WriteChar
	mov al, "^"
	call WriteChar
	mov eax,holder												;print out power.
	call Writeint
	done:
	ret

printdec ENDP



END main		