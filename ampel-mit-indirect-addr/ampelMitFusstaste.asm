$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:	MOV P0, #11110011b ;i0
taste:	JNB P3.0, taste
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
		CALL wait1s
		MOV P0, #11101110b ;i8
		CALL wait1s
		MOV P0, #11101110b ;i9
		CALL wait1s
		MOV P0, #11101110b ;i10
		CALL wait1s
		MOV P0, #11101110b ;i11
		CALL wait1s
		MOV P0, #11101110b ;i12
		CALL wait1s
		MOV P0, #11101110b ;i13
		CALL wait1s
		MOV P0, #11110110b ;i14
		CALL wait1s
		MOV P0, #11110100b ;i15
		CALL wait1s
		JMP start

wait1s:	MOV R2, #13d
loop2: 	MOV R1, #255d
loop1:	MOV R0, #255d
loop:	DJNZ R0, loop
		DJNZ R1, loop1
		DJNZ R2, loop2
		RET

END