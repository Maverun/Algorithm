TITLE Icosahedron (Icosahedron.asm)
;This program will take number in and caculate Area and Volume of Icosahedron
COMMENT @

while True:
	print("please enter the number")
	edge = input()
	if edge == 0:
		break
	elif edge < 0:
		abs(edge)							#use function for this.

	area = 5 * math.sqrt(3) * math.pow(e,2) #use function for this
	print("area is : ", area)

	volume = (5/12) * (3 + math.sqrt(5)) * math.pow(e,3)#use function for this as well.
	print("volume is :",volume)
@

INCLUDE Irvine32.inc
AreaFPU Proto e:REAL4
VolumeFPU Proto e:REAL4
.data
edge REAL4 0.0
asking_number BYTE "Please enter the number(0 to exit):  ",0	
output_area BYTE "Surface area is ",0
output_volume BYTE "Volume is ",0

.code

main PROC

	while_loop:
		mov edx,OFFSET asking_number
		call WriteString
		call ReadFloat
		
		fldz								;pushing 0 to stack
		fcomp								;compare it
		FNSTSW AX							;mov FPU flag to ax
		SAHF								;copy ah to eflags register
		JE quit								;if st(1) == 0 , we will quit.
		
		fabs								;make it positives.
		fst edge							;make copy to edge so we can reused it

		invoke AreaFPU,edge					;call function  while pasing edge as params
		mov edx,OFFSET output_area			;set up message
		call WriteString					;print it out
		call WriteFloat						;print out result
		call Crlf							;new line
		FFREE st(0)							;remove values as there is only one in

		invoke VolumeFPU,edge				;call function  while pasing edge as params
		mov edx,OFFSET output_volume		;set up message
		call WriteString					;print it out
		call WriteFloat						;print out result
		call Crlf							;new line
		FFREE st(0)							;remove values as there is only one in
		JMP while_loop						;endless loops.
	
	quit:
	FFREE st(0)								;the moment we press 0, we need to remove this.
	call ShowFPUStack
	
	exit
main ENDP


;------------------------------------------
;AreaFpu
;Caculate Area, 5*sqrt(3) * e^2
;Final result will be in ST(0)
;Receves: params e, a length/edge of icosahedron
;Return: None
;------------------------------------------
AreaFPU PROC,
	e:REAL4

	local holder:DWORD

	fmul e								;calculate area first, e^2

	mov holder, 3						;transfer 3 to holder
	fild holder							;load it to FPU

	fsqrt								;sqrt(3)


	mov holder, 5						;transfer 5 to holder
	fild holder							;load it to fpu

	fmul								;5* sqrt(3)
	fmul								;result * edge

	ret
AreaFPU ENDP

;------------------------------------------
;VolumeFPU
;Caculate Volume, 5/12(3+sqrt(5))*e^3
;Final result will be in ST(0)
;Receves: params e, a length/edge of icosahedron
;Return: None
;------------------------------------------
VolumeFPU PROC,
	e:REAL4

	local holder:DWORD


	fld e								;now caculate volume
	fmul e	
	fmul e								;done edge^3

	mov holder,5						;set holder as 5
	fild holder							;put holder to fpu
	fsqrt								;sqrt(5)

	mov holder,3						;set holder as 3
	fild holder							;put it into stack
	fadd								;add it up which is 3 +sqrt(5)

	mov holder,5						;add 5 to holder
	fild holder							;put it into stack

	mov holder,12						;put 12 into it
	fidiv holder						;finally 5/12
	fmul								;5/12 * (3+sqrt(5))
	fmul								;^ * 3^3
	ret
VolumeFPU ENDP

END main