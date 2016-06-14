$nomod51 $nosb
$nolist
$include(reg51.h)
$list

TL bit P3.3
TA bit P3.2

org 0000h
JMP start

start:	MOV P2, #0d
		MOV P0, #0d
abfr:	JB TA, aus
		JB TL, mode
		JMP abfr
		
mode:	JB TL, mode ; Entprellen
		CLR C
		MOV A, P2
		ADDC A, P0
		JZ stuf1
		JB P0.1, stuf1
		
		MOV A, P2
		RLC A
		MOV P2, A
		MOV A, P0
		RLC A
		MOV P0, A
		JMP abfr

stuf1:	MOV P2, #1d
		MOV P0, #0d
		JMP abfr

aus:	JB TA, aus ; Entprellen
		JMP start
			

END