$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0x00
JMP HP

org 0x03
JMP versuchen

HP:		SETB EX0
		SETB IT0
		SETB EA
		MOV R0, #0d
		MOV R1, #0d
		MOV R6, #0d
		MOV R7, #0d
		MOV P0, #0d
		MOV A, #0d
		MOV DPTR, #ssegm
		CALL ausgeben
loop:	MOV P0, #00000001b
		CALL wait_100ms
		MOV P0, #00000010b
		CALL wait_100ms
		MOV P0, #00000100b
		CALL wait_100ms
		MOV P0, #00001000b
		CALL wait_100ms
		MOV P0, #00010000b
		CALL wait_100ms
		MOV P0, #00001000b
		CALL wait_100ms
		MOV P0, #00000100b
		CALL wait_100ms
		MOV P0, #00000010b
		CALL wait_100ms
		JMP loop

versuchen:	CJNE R7, #9d, inkr
			CLR EX0
			RETI
inkr:		INC R7
			JB P0.2, treffen
			RETI
treffen:	INC R6
			MOV A, R6
			CALL ausgeben
			RETI

ausgeben:	MOVC A,@A+DPTR
			MOV P2, A
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

wait_100ms:	MOV R2, #2d
loopC:		MOV R0, #255d
loopB:		MOV R1, #255d
loopA:		DJNZ R1, loopA
			DJNZ R0, loopB
			DJNZ R2, loopC
			RET

END
		
		 