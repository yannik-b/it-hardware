$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

S1 bit P1.0
S2 bit P1.7
	
start:			MOV P0, #00000000b
				CALL half
neu:			JB S1, s1an
				JB S2, mode3
				JMP mode1

s1an:			JB S2, mode4
				JMP mode2

mode4:			MOV P0, #00011000b
				CALL quarter
				MOV P0, #00100100b
				CALL quarter
				MOV P0, #01000010b
				CALL quarter
				MOV P0, #10000001b
				CALL quarter
				MOV P0, #01000010b
				CALL quarter
				MOV P0, #00100100b
				CALL quarter
				JMP neu

mode1:			MOV P0, #00000001b
				CALL half
				MOV P0, #00000010b
				CALL half
				MOV P0, #00000100b
				CALL half
				MOV P0, #00001000b
				CALL half
				MOV P0, #00010000b
				CALL half
				MOV P0, #00100000b
				CALL half
				MOV P0, #01000000b
				CALL half
				MOV P0, #10000000b
				CALL half
				JMP neu

mode2:			MOV P0, #01010101b
				CALL half
				MOV P0, #10101010b
				CALL half
				JMP neu

mode3:			MOV P0, #00000001b
				CALL quarter
				MOV P0, #00000011b
				CALL quarter
				MOV P0, #00000111b
				CALL quarter
				MOV P0, #00001111b
				CALL quarter
				MOV P0, #00011111b
				CALL quarter
				MOV P0, #00111111b
				CALL quarter
				MOV P0, #01111111b
				CALL quarter
				MOV P0, #11111111b
				CALL quarter
				MOV P0, #01111111b
				CALL quarter
				MOV P0, #00111111b
				CALL quarter
				MOV P0, #00011111b
				CALL quarter
				MOV P0, #00001111b
				CALL quarter
				MOV P0, #00000111b
				CALL quarter
				MOV P0, #00000011b
				CALL quarter
				JMP neu

half:			MOV R3, #2d
looph:			CALL quarter
				DJNZ R3, looph
				RET

quarter:		MOV R2, #6d
loop2:			MOV R1, #255d
loop1:			MOV R0, #255d
loop:			DJNZ R0, loop
				DJNZ R1, loop1
				DJNZ R2, loop2
				RET

END