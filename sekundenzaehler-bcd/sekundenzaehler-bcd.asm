$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP HP

HP:			; initialisieren
			MOV R0, #0d
loop:		CALL ausgabe
			CALL inkr
			CALL wait1s
			JMP loop
			
				
ausgabe:	; Aufteilen in Zehner und Einer
			MOV A, R0
			MOV B, #10d
			DIV AB
			SWAP A			
			ORL A, B
			MOV P0, A
			RET	

inkr:		CJNE R0, #59d, inkrDO
			MOV R0, #0d
			RET

inkrDO:		INC R0
			RET

wait1s:		MOV R7, #12d
loopC:		MOV R6, #255d
loopB:		MOV R5, #255d
loopA:		DJNZ R5, loopA
			DJNZ R6, loopB
			DJNZ R7, loopC
			RET

END