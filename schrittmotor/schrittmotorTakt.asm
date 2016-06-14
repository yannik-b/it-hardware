$nomod51 $nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

d bit P2.1
t bit P2.0

start:	MOV A, #00h
		MOV R0, #00h
		MOV DPTR, #tab
		MOV A, R0
		CLR d
begin:	JNB P3.3, begin

ausg:	MOV A, R4
		MOVC A, @A+DPTR
		MOV R7, A
		CJNE R7, #0d, next
		JMP start
next:	CALL takt
		DJNZ R7, next
		CPL d
		INC R4
		JMP ausg

takt:	SETB t	; Positive Taktflanke erzeugen
		CALL wait
		CLR t
		RET

wait:	MOV R6, #255d
		CPL P2.7
loop1:	MOV R5, #255d
loop:	DJNZ R5, loop
		DJNZ R6, loop1
		RET

tab:	db 10d
		db 7d
		db 6d
		db 10d
		db 0d

END