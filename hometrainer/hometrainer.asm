$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:	MOV P2, #01000000b
		MOV P0, #00000000b

abfrage:JB P3.2, up
		JB P3.3, down
		JMP abfrage

up:		JB P0.4, abfrage
		CLR C
		MOV A, P2
		RLC A
		MOV P2, A
		MOV A, P0
		RLC A
		MOV P0, A
		CALL wait
		JMP abfrage

down:	JB P2.0, abfrage
		CLR C
		MOV A, P0
		RRC A
		MOV P0, A
		MOV A, P2
		RRC A
		MOV P2, A
		CALL wait
		JMP abfrage

wait:	MOV R2, #2d
loop2:	MOV R1, #255d
loop1:	MOV R0, #255d
loop:	DJNZ R0, loop
		DJNZ R1, loop1
		DJNZ R2, loop2
		RET

END