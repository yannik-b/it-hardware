$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP HP

org 0003h
JMP zaehlen

HP:			CALL init
loop:		CALL anzeige
			JMP loop

init:		SETB EX0
			SETB EA
			SETB IT0
			MOV R0, #0d
			MOV DPTR, #table
			RET
			
anzeige:	MOV A, R0
			MOVC A,@A+DPTR
			MOV P0, A
			RET	

zaehlen:	CJNE R0, #9d, inkrement
			MOV R0, #0d
			RETI

inkrement:	INC R0
			RETI

table:		db 01111110b ;0
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