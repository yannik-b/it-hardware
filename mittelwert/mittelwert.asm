$nomod51 nosb
$nolist
$include(reg51.h)
$list

; Register
; R0 = Adressregister für INT1
; R1 = 				  für INT0
; R6 = Mittelwert für Ausgabe
; R7 = Eingabewert

org 0x00
JMP HP

org 0x03 ; ISR INT0
JMP auswahl

org 0x13 ; ISR INT1
JMP eingabe

HP:			CALL init
loop:		CALL auswertung
			CALL anzeige
			JMP loop
		

init:		SETB EX0
			SETB EX1
			SETB EA
			SETB IT0
			SETB IT1
			MOV R7, #0d
			MOV DPTR, #bcd
			MOV R0, #30h
			RET


; ISR INT1
; Speichern der Eingabe
eingabe:	CJNE R0, #34h, inkr
			CLR EA
			RETI

inkr:		MOV A, R7
			MOV @R0, A
			INC R0
			MOV R7, #0d
			RETI
   

; ISR INT0
; Erhoehen
auswahl:	CJNE R7, #9d, erhoehe
			MOV R7, #0d 
			RETI

erhoehe:	INC R7
			RETI



auswertung:	MOV A, #0d
			MOV R1, #30h
nochmal:	ADDC A, @R1
			INC R1
			CJNE R1, #34h, nochmal
			MOV B, #4d
			DIV AB
			MOV R6, A
			RET



anzeige:	; Anzeige auf linker Anzeige für Eingabe
			MOV A, R7
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.5
			CALL wait10ms
			CLR P3.5
			; Anzeige auf rechter Anzeige für Mittelwert
			MOV A, R6
			MOVC A,@A+DPTR
			MOV P0, A
			SETB P3.4
			CALL wait10ms
			CLR P3.4
			RET

wait10ms:	MOV R3, #5d
loopB:		MOV R4, #255d
loopA:		DJNZ R4, loopA
			DJNZ R3, loopB
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