$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0x00
JMP hp

org 0x03
JMP isr0

org 0x0B
JMP tmr0

/*
    R0 - Personenzähler
    R1 - Durchlaufzähler Tmr0
    R2 - Sekundenzähler Tmr0
 */

hp:         CALL init
prog:       MOV A, R0
            MOV B, #10d
            DIV AB
            MOVC A, @A+DPTR
            MOV P2, A
            SETB P3.5
            CALL delay
            CLR P3.5
            MOV A, B
            MOVC A, @A+DPTR
            MOV P2, A
            SETB P3.4
            CALL delay
            CLR P3.4
            JMP prog

init:       SETB EX0
            SETB IT0
            SETB TR0
            SETB ET0
            SETB EA
            MOV DPTR, #ssegm
            MOV TH0, #3Ch
            MOV TL0, #11000000b
            MOV TMOD, #1h
            MOV R0, #20d
            RET

tmr0:       MOV TH0, #3Ch
            MOV TL0, #11000000b
            INC R1
            CJNE R1, #20d, ende

            MOV R1, #0d
            INC R2
            CJNE R2, #60d, ende

            MOV R2, #0d
            MOV R0, #21d

isr0:       CJNE R0, #0d, decr
            JMP ende

decr:       DEC R0
ende:       RETI

delay:      MOV R7, #20d
loopB:      MOV R6, #255d
loopA:      DJNZ R6, loopA
            DJNZ R7, loopB
            RET

ssegm:      db 01111110b
            db 00010010b
            db 10111100b
            db 10110110b
            db 11010010b
            db 11100110b
            db 11101110b
            db 00110010b
            db 11111110b
            db 11110110b



END
