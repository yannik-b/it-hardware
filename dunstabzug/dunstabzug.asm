$nomod51 $nosb
$nolist
$include(reg51.h)
$list

TL bit P3.3
TA bit P3.2

org 0000h
JMP start

start:	MOV P2, #0d
abfr:	JB TA, aus
		JB TL, mode
		JMP abfr
		
mode:	JB TL, mode ; Entprellen
		MOV A, P2
		JZ stuf1
		JB P2.3, stuf1
		RL A
		MOV P2, A
		JMP abfr

stuf1:	MOV P2, #1d
		JMP abfr

aus:	JB TA, aus ; Entprellen
		JMP start
			

END