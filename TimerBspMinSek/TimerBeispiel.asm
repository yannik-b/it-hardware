$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0x00
JMP hp

org 0x03
JMP ctrl

org 0x0B
JMP isr

org 0x13
JMP reset

hp:			CALL init

prog:		MOV A, R1
			MOV B, #10d
			DIV AB
			MOVC A, @A+DPTR
			MOV P0, A

			MOV P2, #0d

			SETB P3.5
			CALL delay
			CLR P3.5

			MOV A, B
			MOVC A, @A+DPTR
			MOV P0, A

			MOV A, R2
			MOVC A, @A+DPTR
			MOV P2, A

			SETB P3.4
			CALL delay
			CLR P3.4


			JMP prog

init:		MOV TMOD, #1h
			MOV TH0, #3Ch
			MOV TL0, #11000000b
			SETB ET0
			SETB EA
			SETB TR0
			SETB EX0
			SETB IT0
			SETB EX1
			SETB IT1
			MOV R2, #0d
			MOV R1, #0d
			MOV R0, #0d
			MOV DPTR, #ssegm
			RET

ctrl:		JB TR0, gesetzt
			SETB TR0
			JMP ende
gesetzt:	CLR TR0
			RETI

reset:		JB TR0, ende
			MOV R2, #0d
			MOV R1, #0d
			MOV R0, #0d
			RETI

isr:		MOV TH0, #3Ch
			MOV TL0, #11000000b

			INC R0 ;Überlaufzähler inkrementieren
			CJNE R0, #20d, ende

			;1 Sekunde ist abgelaufen
			MOV R0, #0d
			INC R1
			CJNE R1, #60d, ende

			MOV R1, #0d
			INC R2

ende:		RETI

delay:		MOV R7, #20d
loopB:		MOV R6, #255d
loopA:		DJNZ R6, loopA
			DJNZ R7, loopB
			RET

ssegm:		db 01111110b ;0
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