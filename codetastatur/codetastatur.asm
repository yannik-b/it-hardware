$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:	MOV P2, #00000000b
		MOV P0, #11111110b
abfr1:	JNB P0.4, ausg1
abfr2:	JNB P0.5, ausg2
abfr3:	JNB P0.6, ausg3
		MOV P0, #11111101b
abfr4:	JNB P0.4, ausg4
abfr5:	JNB P0.5, ausg5
abfr6:	JNB P0.6, ausg6
		MOV P0, #11111011b
abfr7:	JNB P0.4, ausg7
abfr8:	JNB P0.5, ausg8
abfr9:	JNB P0.6, ausg9
		MOV P0, #11110111b
abfrS:  JNB P0.4, ausgS
abfr0:	JNB P0.5, ausg0
abfrR:	JNB P0.6, ausgR
		JMP start

ausg1:	MOV P2, #00010010b
		JMP abfr1
ausg2:	MOV P2, #10111100b
		JMP abfr2
ausg3:	MOV P2, #10110110b
		JMP abfr3
ausg4:	MOV P2, #11010010b
		JMP abfr4
ausg5:	MOV P2, #11100110b
		JMP abfr5
ausg6:	MOV P2, #11101110b
		JMP abfr6
ausg7:	MOV P2, #00110010b
		JMP abfr7
ausg8:	MOV P2, #11111110b
		JMP abfr8
ausg9:	MOV P2, #11110110b
		JMP abfr9
ausgS:	MOV P2, #10001110b
		JMP abfrS
ausg0:	MOV P2, #01111110b
		JMP abfr0
ausgR:	MOV P2, #11111010b
		JMP abfrR

END