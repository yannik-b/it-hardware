$nomod51 $nosb
$nolist
$include(reg51.h)
$list

S1 bit P1.0
S2 bit P1.7

org 0000h
JMP start

start:	MOV P2, #00h
loop:	JB S1, sch1
		JB S2, mod3
		JMP mod1

sch1:	JB S2, mod4
		JMP mod2

mod1:	MOV R7, #00h
		MOV DPTR, #tab1
loop1:	MOV A, R7
		MOVC A, @A+DPTR
		MOV P2, A
		CALL wait
		INC R7
		CJNE R7, #08h, loop1
		JMP loop

mod2:	MOV R7, #00h
		MOV DPTR, #tab2
loop2:	MOV A, R7
		MOVC A, @A+DPTR
		MOV P2, A
		CALL wait
		INC R7
		CJNE R7, #04h, loop2
		JMP loop

mod3:	MOV R7, #00h
		MOV DPTR, #tab3
loop3:	MOV A, R7
		MOVC A, @A+DPTR
		MOV P2, A
		CALL wait
		INC R7
		CJNE R7, #06h, loop3
		JMP loop

mod4:	MOV R7, #00h
		MOV DPTR, #tab4
loop4:	MOV A, R7
		MOVC A, @A+DPTR
		MOV P2, A
		CALL wait
		INC R7
		CJNE R7, #0Eh, loop4
		JMP loop

wait:	MOV R2, #12d		 ; ca. 1 Sekunde
loopC: 	MOV R1, #255d
loopB:	MOV R0, #255d
loopA:	DJNZ R0, loopA
		DJNZ R1, loopB
		DJNZ R2, loopC
		RET

tab1:	db 00000001b
		db 00000010b
		db 00000100b
		db 00001000b
		db 00010000b
		db 00100000b
		db 01000000b
		db 10000000b

tab2:	db 00011000b
		db 00100100b
		db 01000010b
		db 10000001b

tab3:	db 00011000b
		db 00100100b
		db 01000010b
		db 10000001b
		db 01000010b
		db 00100100b

tab4:	db 00000001b
		db 00000011b
		db 00000111b
		db 00001111b
		db 00011111b
		db 00111111b
		db 01111111b
		db 11111111b
		db 01111111b
		db 00111111b
		db 00011111b
		db 00001111b
		db 00000111b
		db 00000011b

END