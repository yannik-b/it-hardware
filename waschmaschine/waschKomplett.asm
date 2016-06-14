$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP clearausg

; Ports
; P0.0   O   Heizer
; P0.1   I   Temp 60 Sensor
; P0.2   I   Temp 90 Sensor
; P0.3   I   Temp Wähler
; P0.7   I   Ein/Aus-Schalter

; P2.7   I   Wasserstand W1 Sensor
; P2.6   I   Wasserstand W2 Sensor
; P2.5   O   Wasserhahn
; P2.4   O   Motor


clearausg:	CLR P0.0 ; clear Heizer
			CLR P2.5 ; clear Wasserzulauf
			CLR P2.4 ; clear Motor

start:		JNB P0.7, start
wasseran:	SETB P2.5 ; Wasser an
			JNB P2.6, wasseran ; Warten bis Wasserstand W2 erreicht
			CLR P2.5 ; Wasser aus
tempwahl:	JB P0.3, neunzig
			JB P0.1, heizaus ;60 Grad gewählt
heizan:		SETB P0.0		 ;Aktiviert Heizung
			JMP tempwahl
neunzig:	JB P0.2, heizaus ;Prüfe auf >=90 Grad
			JB P0.1, neunzig ;Prüfe auf >=60 Grad
			JMP heizan		 ;Schalte Heizung an

heizaus:	CLR P0.0

motoran:    SETB P2.4
			JMP clearausg


END