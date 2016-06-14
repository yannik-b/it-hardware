$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:	MOV P2, #0d
		JB P1.2, blink
		MOV P0, #11110011b ;i0
modus:	JB P1.0, direkt
		
		JNB P1.1, start
		SETB P2.1
taste:	JNB P3.2, taste
		

direkt:	SETB P2.0
		MOV R7, #00h
		MOV DPTR, #tabAmp
loopDi:	MOV A, R7
		MOVC A, @A+DPTR
		MOV P0, A
		CALL waiths
		INC R7
		CJNE R7, #0Fh, loopDi
		JMP start

blink:	SETB P2.2
		MOV DPTR, #tabBli
		MOV R6, #00000000b
loopBl:	MOV A, R6
		MOVC A, @A+DPTR
		MOV P0, A
		CALL waiths
		INC R6
		CJNE R6, #00000010b, loopBl
		JMP start 

wait7s: MOV R4, #7d
loop4:	CALL wait1s
		DJNZ R4, loop4
		RET

wait1s:	MOV R3, #2d
loop3:	CALL waiths
		DJNZ R3, loop3
		RET

waiths:	MOV R2, #6d
loop2: 	MOV R1, #255d
loop1:	MOV R0, #255d
loop:	DJNZ R0, loop
		DJNZ R1, loop1
		DJNZ R2, loop2
		RET

tabAmp:	db 01110011b
		db 11110011b
		db 01110101b
		db 11110101b
		db 01110110b
		db 11110110b
		db 01101110b
		db 11101110b
		db 01101110b
		db 11101110b
		db 01101110b
		db 11101110b
		db 01101110b
		db 11110110b
		db 01110100b

tabBli:	db 11110101b
		db 11110111b

END