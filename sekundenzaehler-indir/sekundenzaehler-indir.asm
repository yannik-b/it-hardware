$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:		MOV DPTR, #list
nullen:		MOV R0, #0d
			MOV P0, #01111110b
warten:		JNB P3.3, warten
			CJNE R0, #60d, weiter
			JMP nullen

weiter:		INC R0
			MOV A, R0
			MOV B, #10d
			DIV AB
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.5
			CALL wait500ms
			CLR P3.5
			MOV A, B
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.4
			CALL wait500ms
			CLR P3.4

			JMP warten



wait10ms:	MOV R3, #25d
loopB:		MOV R2, #255d
loopA:		DJNZ R2, loopA
			DJNZ R3, loopB
			RET

wait500ms:	MOV R4, #50d
loopC:		CALL wait10ms
			DJNZ R4, loopC
			RET

list:		db 01111110b ;0
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