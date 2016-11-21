$nomod51 nosb
$nolist
$include(reg51.h)
$include(lcdhilf.a51)
$list

org 0x00
JMP hp

org 0x03
JMP btnPlay

org 0x0B
JMP tmr0

org	0x13
JMP btnNext

/*
 * R0 - Titel
 * R1 - Durchlaufzähler
 * R2 - Sekunden
 * R3 - Minuten
 *
 *
 * R6 - Delay Nr. 1
 * R7 - Delay Nr. 2 
 */

hp:         CALL init
prog:       MOV A, #03h
            LCALL cursorpos
            MOV A, ':'
            LCALL textaus


init:       MOV TH0, #3Ch
            MOV TL0, #11000000b
            
            ; Initialisiere Timer0
            MOV TMOD, #1h
            SETB ET0
            SETB TR0

            ; Initialisere Interrupt0
            SETB IT0
            SETB EX0

            ; Initialisere Interrupt1
            SETB IT1
            SETB EX1

            SETB EA

            LCALL initLCD
            RET
            
tmr0:       MOV TH0, #3Ch
            MOV TL0, 11000000b
            INC R1
            CJNE R1, #40d, ende
            
            ; 1 Sekunde ist abgelaufen
            MOV R1, #0d
            INC R2
            CJNE R2, #60d, ende
            
            ; 1 Minute ist abgelaufen
            MOV R2, #0d
            INC R3
            CJNE R3, #60d, ende

            ; 1 Stunde ist abgelaufen - springe zu nächstem Titel
            MOV R3, #0d
            JMP btnNext
            RETI
            
btnPlay:    JB TR0, laeuft
            SETB TR0
            JMP ende
laeuft:     CLR TR0
ende:       RETI

btnNext:    MOV R1, #0d
            MOV R2, #0d
            MOV R3, #0d
            INC R0
            CJNE R0, #10d, ende
            MOV R0, #0d
            RETI
            
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
