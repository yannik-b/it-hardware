$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP wuerfel

wuerfel:	MOV P0, #11111110b
stop1:		JB P3.3, stop1
			MOV P0, #11111101b
stop2:		JB P3.3, stop2
			MOV P0, #11111100b
stop3:		JB P3.3, stop3
			MOV P0, #11111001b
stop4:		JB P3.3, stop4
			MOV P0, #11111000b
stop5:		JB P3.3, stop5
			MOV P0, #11110001b
stop6:		JB P3.3, stop6
			JMP wuerfel

END