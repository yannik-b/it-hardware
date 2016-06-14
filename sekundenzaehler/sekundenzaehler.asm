$nomod51 $nosb
$nolist
$include(reg51.h)
$list

E2 bit P3.5
E1 bit P3.4

org 0000h
JMP start

start:	MOV R1, #00h	; Zaehler auf 0 setzen
		MOV R0, #00h
loop:	CALL ausg
		INC R0
		CJNE R0, #0Ah, loop
		CLR P0.0
		MOV R0, #00h
		INC R1
		CJNE R1, #06h, loop
		MOV R1, #00h
		JMP start

ausg:	MOV A, R0
		MOV DPTR, #muster
		MOVC A, @A+DPTR
		MOV P2, A
		SETB E1
		CALL wait
		
		MOV A, R1
		MOVC A, @A+DPTR
		MOV P2, A
		CLR E1
		SETB E2
		CALL wait
		CLR E2
		RET
		

muster:	db 01111110b ;0
		db 00010010b ;1
		db 10111100b ;2
		db 10110110b ;3
		db 11010010b ;4
		db 11100110b ;5
		db 11111110b ;6
		db 00110010b ;7
		db 11111110b ;8
		db 11110110b ;9

wait: 	MOV R4, #5d
loopC:	MOV R3, #255d
loopB:	MOV R2, #255d
loopA:	DJNZ R2, loopA
		DJNZ R3, loopB
		DJNZ R4, loopC
		RET

END