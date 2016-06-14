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
		CALL wait1s
		MOV P0, #11110011b ;i1
		CALL wait1s
		MOV P0, #11110011b ;i2
		CALL wait1s
		MOV P0, #11110101b ;i3
		CALL wait1s
		MOV P0, #11110101b ;i4
		CALL wait1s
		MOV P0, #11110110b ;i5
		CALL wait1s
		MOV P0, #11110110b ;i6
		CALL wait1s
		MOV P0, #11101110b ;i7
		CALL wait7s
		MOV P0, #11110110b ;i14
		CALL wait1s
		MOV P0, #11110100b ;i15
		CALL wait1s
		JMP start

blink:	SETB P2.2
		MOV P0, #11110101b
		CALL waiths
		MOV P0, #11110111b
		CALL waiths
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

END