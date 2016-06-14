$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0x00
JMP HP

org 0x03
JMP einfahrt

org 0x13
JMP ausfahrt

HP:			CALL init
loop:		CALL anzeige
			JMP loop

init:		SETB EX0
			SETB IT0
			SETB EX1
			SETB IT1
			SETB EA

			MOV R0, #25d
			MOV P2, #0d
			MOV DPTR, #bcd
			RET

anzeige:	MOV A, R0

			MOV B, #10d
			DIV AB
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.5
			CALL wait2
			CLR P3.5

			MOV A, B
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.4
			CALL wait1
			CLR P3.4
			CJNE R0, #0d, belegt
			SETB P2.1
			CLR P2.0
			RET

belegt:		SETB P2.0
			CLR P2.1
			RET

einfahrt:	CJNE R0, #0d, decR0
			RETI

decR0:		DEC R0
			RETI

ausfahrt:	CJNE R0, #25d, incR0
			RETI

incR0:		INC R0
			RETI

wait1:		MOV R2, #40d
loop2:		MOV R3, #70d
loop1:		DJNZ R3, loop1
			DJNZ R2, loop2
			RET

wait2:	MOV R4, #2d
loop4:		CALL wait1
			DJNZ R4, loop4
			RET

bcd:		db 01111110b ;0
			db 00010010b ;1
			db 10111100b ;2
			db 10110110b ;3
			db 11010010b ;4
			db 11100110b ;5
			db 11101110b ;6
			db 00110010b ;7
			db 11111110b ;8
			db 11110110b ;9

END