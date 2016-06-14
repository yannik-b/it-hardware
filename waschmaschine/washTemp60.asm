$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:		
heizaus:	CLR P0.0
wahl:		JB P0.3, neunzig
			JB P0.1, heizaus ;60 Grad gewählt
heizan:		SETB P0.0		 ;Aktiviert Heizung
			JMP wahl
neunzig:	JB P0.2, heizaus ;Prüfe auf >=90 Grad
			JB P0.1, neunzig ;Prüfe auf >=60 Grad
			JMP heizan		 ;Schalte Heizung an

END