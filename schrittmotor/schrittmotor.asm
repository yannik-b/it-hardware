$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:	MOV A, #00h
		MOV R0, #00h
		MOV DPTR, #tab
		MOV A, R0

ausg:	MOVC A, @A+DPTR
		MOV P2, A
		CALL wait

stop:	JB P1.7, stop
		JB P1.0, links

		INC R0
		JMP next

links:	DEC R0

next:	MOV A, R0
		ANL A, #00000011b
		JMP ausg

wait:	MOV R6, #255d
loop1:	MOV R5, #255d
loop:	DJNZ R5, loop
		DJNZ R6, loop1
		RET

tab:	db 00000000b
		db 00000001b
		db 00000011b
		db 00000010b

END