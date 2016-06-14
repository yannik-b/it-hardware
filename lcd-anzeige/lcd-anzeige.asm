$nomod51 nosb
$nolist
$include(reg51.h)
$list

org 0000h
JMP start

start:		
			LCD_PORT EQU P0
			call initLCD
			call loeschen
			MOV R0,#0
loop:		MOV A, R0
			CALL cursorhome
			
			MOV DPTR, #texta
			CALL textzeile1

			MOV DPTR, #textb
			MOV B, #17d
			MUL AB
			MOV P2, A
loopD:		INC DPTR
			DJNZ ACC, loopD
			
			CALL textzeile2

			call wait
			INC R0
			CJNE R0,#14,loop
			JMP start

wait:	
			MOV R7,#12
loop2:		MOV R6,#255
loop1:		MOV R5,#255
loop0:		DJNZ R5,loop0
			DJNZ R6,loop1
			DJNZ R7,loop2
			RET

texta:		db 'Spiel',0

textb:		db '#*             #',0
		db '# *            #',0
		db '#  *           #',0
		db '#   *          #',0
		db '#    *         #',0
		db '#     *        #',0
		db '#      *       #',0
		db '#       *      #',0
		db '#        *     #',0
		db '#         *    #',0
		db '#          *   #',0
		db '#           *  #',0
		db '#            * #',0
		db '#             *#',0


							  
;LCDhilf.a51 *******Jan2004 geänderte Version******************************************************
;***** Hilfsprogramme für die Text- und Zahlenausgabe an das LCD-Display 
;***** Vor der Verwendung initialisieren mit lcall initLCD 
;***** Anwendungsbeispiele in LCDtest.a51 und LCDeigeneZeichen.a51  
;***** Übergaberegister sind Akku und Datenpointer
;***** In Ihren Interrupt-Routinen müssen Sie a,b,r2 bis r7 vor der Verwendung retten mit push
;***** und am Schluss wieder herstellen mit pop
;***** Jan2004 geändert: alle Register werden wiederhergestellt, kein mov sp,#2f mehr notwendig
;*****                   Möglichkeit eigene Zeichen zu definieren, 4-zeilige Ausgabe möglich
;***** ********************************************************************************************                        

;#include "c51rd2.inc"	;Registeradressen einbinden

;Code    			;Codesegment. Code wird vom Linker hinter andere Datei gehängt
     
;LCD_PORT EQU P0 ; *** Hier den verwendeten Port einsetzen !!!!!!!!!!!! **** !!!!!!!!!!!!!!!!

; verfügbare Hilfsprogramme ***********************************************************************
public initLCD,loeschen,loeschzeile1,loeschzeile2,textzeile1,textzeile2,cursorpos,cursoran,cursoraus
public textaus,zifferaus,hexaus,dezaus,dualaus,dualaus1,dualaus2,charaus
public definierezeichen,loeschzeile3,loeschzeile4,textzeile3,textzeile4
;**************************************************************************************************

;---- 	Verwendung der Hilfsprogramme: --------------------------------------------------
;	EXTERN CODE initLCD,loeschzeile1,....
;	lcall	initLCD			;Initialiserung des LCD-Displays
;	lcall	loeschen			;gesamtes Diplay löschen
;	lcall	loeschzeile1	;nur Zeile 1 des Displays löschen
;	lcall	loeschzeile2	;nur Zeile 2 des Displays löschen

;***	Die 16 Zeichen belegen die Display-Adressen 00h-0Fh (Zeile1) und 40h-4Fh (Zeile2)
;	mov	a,#03				;Cursor auf die 4. Anzeigestelle setzen
;	lcall	cursorpos

;***	Textausgaben ************* die Anfangsadresse des Textes muß ***********
;***	im DPTR stehen und der Text muß mit einer 0 abgeschlossen werden!  *****
;	mov	dptr,#Text1		;Text ab der
;	lcall	textaus			;aktuellen Cursorposition ausgeben
;	mov	dptr,#Text1		;Text ab der 1.Stelle
;	lcall	textzeile1		;in Zeile 1 ausgeben
;	mov	dptr,#Text1		;Text ab der 1.Stelle
;	lcall	textzeile2		;in Zeile 2 ausgeben
;Text1:	db 'Hallo! Test...',0	;Angabe des auszugebenden Textes am Programmende

;***	Zahlenausgaben: Übergaberegister ist der Akku *******************************************
;	mov	a,p1			;Ausgabe des Portinhalts von P1
;	lcall	zifferaus	;mit nur einer Ziffer (Lownibbel) an das Display
;	mov	a,p1			;Ausgabe des Portinhalts von P1 als 2-stellige Hexzahl 
;	lcall	hexaus		;Es werden immer 2 Stellen mit führenden Nullen ausgegeben
;	mov	a,p1			;Ausgabe des Portinhalts von P1 als 3-stellige Dezimalzahl		 
;	lcall	dezaus		;Es werden immer 3 Stellen ausgegeben, führende Nullen sind dunkel
;	mov	a,p1			;Ausgabe des Portinhalts von P1 als 8-Bit-Dualzahl
;	lcall	dualaus		;Es werden immer 8 Stellen ausgegeben mit führenden Nullen
;	mov	a,p1			;Ausgabe des Portinhalts von P1 als 8-Bit-Dualzahl
;	lcall	dualaus1		;rechtsbündig in Zeile1
;	mov	a,p1			;Ausgabe des Portinhalts von P1 als 8-Bit-Dualzahl
;	lcall	dualaus2		;rechtsbündig in Zeile2

;**** eigenes Zeichen definieren **********************************************************
;	mov	a,#1					; Adresse des Zeichen festlegen
;	mov	dptr,#zeichen1		; Anfangsadresse der pixelweisen Zeichendefinition
;	lcall	definiereZeichen	; Hilfsprogramm, welches das selbstdefinierte Zeichen im CG-RAM 
;									; des LC-Displays ablegt
;  je 5 Pixel für die 8 Pixel-Zeilen eines Zeichens
;	Zeichen1:
;db 00100b, 00100b, 01110b, 01110b, 00100b, 00100b, 00100b, 00100b	,0	
;**** eignes Zeichen anzeigen **************************************************************
;	mov	a,#1			; Adresse des 2. unten definierten Zeichens
;	lcall	charaus		; ausgeben

;****** von LCDhilf verwendete Register der Bank0 ******************************************	
	reg2	data	02h	;Register der Bank0
	reg3	data	03h
	reg4	data	04h
	reg5	data	05h
	reg6	data	06h
	reg7	data	07h
; **************** Display initialisieren ****************
;
; Display arbeitet im 2*4-Bit Modus
; 
; Die 16 Zeichen belegen die Display-Adressen 00-0F und 40-4F (HEX!)
;
; Bit:    7       6       5       4       3       2      1      0
;      Register  Read/    0      Takt   D7/D3   D6/D2  D5/D1  D4/D0
;      Select    Write

;****************************** Display initialisieren ***********************
initLCD:	push	acc
			push	reg5
			push	reg4

			mov 	LCD_PORT,#00010011b   	; aufwecken! Takt=1
			mov 	LCD_PORT,#00000011b		;            Takt=0

			mov 	reg5,#10          		; ca. 5 msec warten     
w0:    	djnz 	reg4,w0
			djnz 	reg5,w0

			mov 	LCD_PORT,#00010011b  	; aufwecken! Takt=1
			mov 	LCD_PORT,#00000011b		;            Takt=0
w2:		djnz 	reg5,w2           		; wartet 100 usec

			mov 	LCD_PORT,#00010011b   	; aufwecken! Takt=1
			mov 	LCD_PORT,#00000011b		;            Takt=0
w3:		djnz 	reg5,w3						;  wartet 100 usec

			mov 	LCD_PORT,#00010010b   	; 8->4  BITS UMSCHALTEN, Takt=1
			mov 	LCD_PORT,#00000010b		;                       Takt=0
w4:		djnz 	reg5,w4
		
			mov 	A,#00101000b    			; Function set 4 bits  
			lcall LCDbefehl					; Ausgabe im 4Bit-Modus
		
			mov 	A,#00001100b    			; Display AN, Cursor AUS
			lcall LCDbefehl					; des Zeichens an der Cursorposition

			mov 	A,#00000110b    			; Not Shifted Display, Increment
			lcall LCDbefehl
			
			pop	reg4
			pop	reg5
			pop	acc
			ret									
		
;*********** eigene Zeichen im CG-RAM des LC-Display ablegen *********************
; Adresse des Zeichens zur im CG-Ram des LC-Displays muss im Akku stehen
; Anfangsadresse im Programmspeicher muss im dptr stehen								
definiereZeichen:
				push	acc							; Registerinhalte retten
				push	dph
				push	dpl
				push	b	
				push	reg4
				mov	b,#8							; Adresse CG-Ram = 8 x Adr. DD-Ram
				mul	ab							
				clr	acc.7							; Zugriff auf CG-RAM-Adresse
				setb	acc.6							; 
				lcall	LCDbefehl					; Anfangsadresse CG-Ram wählen
				mov 	reg4,#8						; Anzahl Pixelzeilen
holez:		clr	a
				movc 	A,@A+DPTR					; Pixelzeile holen
				lcall charaus                 ; und im CG-RAm ablegen, Adr CG-Ram wird um 1 erhöht
				inc	dptr							; nächste Pixelzeile
				djnz	reg4,holez					; 8 Pixelzeilen holen
			
				clr	a								; Cursor in Position 0
				lcall	cursorpos					; dadurch auch auf DD-RAM umschalten, wo man
														; die Zeichen nun abholen kann
				pop	reg4
				pop	b
				pop	dpl
				pop	dph
				pop	acc							; Registerinhalte wiederherstellen
				ret

;*********** Loeschen Display *****************************************
loeschen:	push	acc
				mov 	A,#00000001b    		;Display clear                                                     
				lcall LCDbefehl	
				pop	acc																						
				ret	
;*********** Cursor AN ************************************************
cursorAN:	push	acc
				mov 	A,#00001110b			;Cursor und Display AN
				lcall LCDbefehl
				pop	acc
				ret
;*********** Cursor AUS ***********************************************
cursorAUS:	push	acc
				mov 	A,#00001100b			;Cursor AUS, Display AN
				lcall LCDbefehl
				pop	acc
				ret

;*********** Cursorposition *******************************************
cursorpos:  push	acc
				orl 	a,#10000000b			;Kennung für DD RAM address set
				lcall LCDbefehl
				pop	acc
				ret
;*********** Cursorhome ***********************************************
cursorhome:	push	acc
				mov 	A,#00000010b			;Cursor home
				lcall LCDbefehl
				pop	acc
				ret
				
;**********************************************************************
textloesch:	DB '                ',0						
;*********** Zeile 1 löschen ******************************************
loeschzeile1: push acc
				mov	a,#0
				sjmp	loeschzeile
;*********** Zeile 2 löschen ******************************************
loeschzeile2: push acc	
				mov 	a,#40h
				sjmp	loeschzeile
;*********** Zeile 3 löschen ******************************************
loeschzeile3:	push acc	
				mov	a,#10h 
				sjmp	loeschzeile
;*********** Zeile 4 löschen ******************************************
loeschzeile4:  push acc	
				mov 	a,#50h
				sjmp	loeschzeile
				
loeschzeile:push	dph
				push	dpl
				mov	dptr,#textloesch 
				lcall	textzeile
				pop	dpl
				pop	dph 
				pop	acc                                                                       
				ret	
;*********** Text an Zeile 1 ausgeben *********************************
textzeile1:	push	acc
				mov 	A,#0		
				lcall	textzeile 
				pop	acc
				ret                                                                                   
;*********** Text an Zeile 2 ausgeben *********************************
textzeile2:	push	acc
				mov 	a,#40h
				lcall	textzeile
				pop	acc
				ret
;*********** Text an Zeile 3 ausgeben *********************************
textzeile3:	push	acc
				mov 	A,#10h			
				lcall	textzeile
				pop	acc
				ret
;*********** Text an Zeile 4 ausgeben *********************************
textzeile4:	push	acc
				mov 	a,#50h
				lcall	textzeile
				pop	acc
				ret
								
;*********** Text an auszugebende Adresse steht im Akku ****************
textzeile:	lcall	cursorpos
			   sjmp	textaus                                                                                    
;********** Text ab aktueller Cursorposition ausgeben
textaus:		push	acc
				push	reg4
				mov 	reg4,#0					;0 ins r4 => Buchstabe 0
textloop:  	mov 	A,reg4					;Nr des Buchstabens in den Akku
				inc 	reg4
				cjne 	a,#10h,holbuchst		;schon Maximalzahl an Buchstaben?
				sjmp 	textende					;für eine Zeile => ja => Ende
holbuchst:  movc 	A,@A+DPTR				;Text Buchstabenweise holen
				jz 	textende					;falls 0 => Ende, sonst ausgeben
ausgeben:	lcall charaus
				sjmp 	textloop
textende:  	pop	reg4
				pop	acc
				ret

;********* Befehl für LCD-Display im Akku ausgeben an LCD_PORT **************                                     
;*************** RS  R/W  D7  D6  D5  D4  D3  D2  D1  D0
;*************** 0    0   x   x   x   x   x   x   x   x
LCDbefehl:
			push	reg2
			push	reg3	
			push	ACC
			push 	ACC
			swap 	a							;High- und Low-Nibbel tauschen
			anl 	A,#00001111b			;4 Bits maskieren
			orl 	A,#00010000b			;Übergabetakt = 1, High-Nibbel senden
			mov 	LCD_PORT,A
			anl 	A,#00001111b			;Takt = 0
			mov 	LCD_PORT,A
			pop 	ACC
			anl 	A,#00001111b			;Low-Nibble
			orl 	A,#00010000b			;Takt = 1
			mov 	LCD_PORT,A
			anl 	A,#00001111b			;Takt = 0
			mov 	LCD_PORT,A
			sjmp 	wbusy						;warten bis Bearbeitung beendet

;********* Zeichen für LCD-Display im Akku ausgeben an LCD_PORT **************
;*************** RS  R/W  D7  D6  D5  D4  D3  D2  D1  D0                                                           
;*************** 1    0   x   x   x   x   x   x   x   x
charaus: push	reg2
			push	reg3 
			push	ACC  
			push 	ACC
			swap 	a							;Nibbel vertauschen
			anl 	A,#00001111b			;4 Bits maskieren
			orl 	A,#10010000b			;Übergabetakt = 1, RS = 1 (Befehl!)
			mov 	LCD_PORT,A
			anl 	A,#10001111b			;Takt = 0
			mov 	LCD_PORT,A
			pop 	ACC
			anl 	A,#00001111b			;Low-Nibble
			orl 	A,#10010000b			;Takt = 1, RS = 1
			mov 	LCD_PORT,A
			anl 	A,#10001111b			;Takt = 0
			mov	LCD_PORT,A
	;************** warten bis Bearbeitung im Display beendet **********
wbusy:  	mov 	LCD_PORT,#01011111b  ; Busy lesen, Takt=1, RS = 0
			mov 	A,LCD_PORT           ; und holen
			mov 	LCD_PORT,#01001111b  ;             Takt=0
			nop
			mov 	LCD_PORT,#01011111b  ; Low-Byte holen (ohne Bedeutung)
			mov 	LCD_PORT,#01001111b
                                                                                                                   
			mov 	reg2,#100            ;Zeitverzögerung 2ms
warteR2:	mov 	reg3,#10             ;statt auf busy warten
warteR3:	djnz 	reg3,warteR3         ;wenn LCD an p0
			djnz 	reg2,warteR2		
	
;			jb 	ACC.3,wbusy     		; Busy? warten , geht nicht mit LCD an p0
			pop	ACC
			pop	reg3
			pop	reg2
			ret 

;*********************** dezaus *********************************************
;+++++++++ Die Zahl im Akku wird als Dezimalzahl ausgegeben +++++++++++++++++
;--------- Es werden immer 3 Stellen ausgegeben, führende Nullen sind dunkel                                        
dezaus:	push	acc
			push	reg4
			push	reg5
			push	reg7
			push	b
			mov 	b,#100	      ;der in A stehende Wert wird durch 100
			div 	ab	        		;geteilt und die Hunderter-Ziffer in
			mov 	reg7,a	      ;r7 gegeben
			mov 	a,b	        	;die verbleibende Zehnerzahl
			mov 	b,#10	        	;wird durch 10
			div 	ab	        		;geteilt
			swap 	a	        		;Die Zehnerziffer wird das High-Nibbel,
			add 	a,b	        	;die Einerziffer das Low-Nibbel
			mov 	reg5,a	      ;diese BCD-Zahl wird in r5 gespeichert        
			mov 	a,reg7         ;die vorderste BCD-Ziffer
			mov 	reg4,a			;wird in r4 gesichert und
			jnz 	ausg1				;wird normal ausgegeben, falls sie nicht 0 ist
			mov 	a,#31				;leere Anzeige
			lcall charaus			;falls null
			sjmp 	Ziff2
ausg1:	lcall sendascii		;1.Ziffer ausgeben
Ziff2:	mov a,reg5 				;2. u. 3. Ziffer zurückholen
hex0:		mov reg7,a 				;zwischenspeichern in r7
			anl a,#0f0h				;High-Nibbel maskieren
			swap a					;und zur Ziffer im Low-Nibbel machen
			jnz ausg2				;wird normal ausgegeben, falls sie nicht 0 ist
			cjne a,reg4,ausg2		;nur 0 unterdrücken falls 1.Ziffer auch 0 war
			mov a,#31				;leere Anzeige
			lcall charaus			;falls null
			sjmp Ziff3
ausg2:	lcall sendascii		;2.Ziffer ausgeben
Ziff3:	mov a,reg7				;Zwischengespeicherte Zahl zurck
			anl a,#0fh				;Low-Nibbel ausblenden
			lcall sendascii		;und ausgeben
dezend:	pop	b
			pop	reg7
			pop	reg5
			pop   reg4
			pop   acc
			ret

;*********************** hexaus *****************************************
;+++++++++ Die Zahl im Akku wird hexadezimal ausgegeben +++++++++++++++++															a,reg7
;--------- Es werden immer 2 Stellen mit führenden Nullen ausgegeben ---- 
hexaus:	push acc
			push	reg7
			mov 	reg7,a			;zwischenspeichern in r7
			anl 	a,#0f0h			;High-Nibbel maskieren
			swap 	a					;und zur Ziffer im Low-Nibbel machen
;			cjne 	a,#0,ausg2Z		;zur Unterdrückung der führenden Null   
;			mov 	a,#20				;leere Anzeige
;			lcall 	charaus		;       
;			sjmp 	weit2				;
ausg2Z:	lcall sendascii      ;
weit2:	mov 	a,reg7			;Zwischengespeicherte Zahl zurck
			anl 	a,#0fh			;Low-Nibbel ausblenden
			lcall sendascii		;und ausgeben
			pop	reg7
			pop 	acc
			ret

;****************** dualaus (Zahl im Akku als 8-Bit-Dualzahl ausgeben) ********													a,reg5,reg7
dualaus:
			push	acc
			push	reg5
			push	reg7
			mov	reg5,#8			;Zähler
dloop:	mov	reg7,a			;Zahl zwischenspeichern
			jb		acc.7,d1				;Sprung zur "1"-Ausgabe wenn Bit=1
			mov	a,#0				;Null ausgeben
			lcall	sendascii		;
			sjmp	d2					;
d1:		mov	a,#1				;Eins ausgeben
			lcall	sendascii		;
d2:		mov	a,reg7			;zwischengespeicherte Zahl zurück
			rl	a						;nächstes Bit
			djnz	reg5,dloop		;von vorne falls noch nicht alle 8 Bit
			pop	reg7
			pop	reg5
			pop	acc
			ret

;***************** Duale Ausgabe rechtsbündig in Zeile 1 *********************													a
dualaus1:
			push	acc
			mov	a,#08
			lcall	cursorpos
			pop	acc
			push	acc
			lcall	dualaus
			pop	acc
			ret
;***************** Duale Ausgabe rechtsbündig in Zeile 2 *********************
dualaus2:
			push	acc
			mov	a,#48
			lcall	cursorpos
			pop	acc
			push	acc
			lcall	dualaus
			pop	acc
			ret

;************** sendascii (1 Hexziffer als Ascii-Zeichen senden) *********															a,reg6
sendascii: 
			push	acc
			push	reg6
			mov 	reg6,a
			subb 	a,#0Ah
			mov 	a,reg6
			jc 	zahl
Buchst:	add 	a,#37h
			sjmp 	weit1
zahl:		clr 	c             ;Carry zurcksetzen, sonst Fehler bei add
			add 	a,#30h
weit1:	lcall charaus
			pop	reg6
			pop	acc
			ret

;*************** zifferaus (eine Ziffer 0 bis 9 ausgeben *****************																	a
zifferaus: 
			push 	acc
			anl 	a,#0Fh
			lcall sendascii                      
			pop 	acc
			ret

;****** PIN-Belegung für LCD-Display LTN 214 R-10 am LCD_PORT **************
; * Uebertragung eines Bytes als 2 * 4 Bits.
; * Ansicht von oben auf Display
; * 1 GND--------------------------------------------------> GND
; * 2 +5Volt-----------------------------------------------> +5V
; * 3 V0: Steuerspannung Kontrast 0..5 Volt erlaubt,-------> V0 
; *       Arbeitspunkt ca. 0.6 V (am besten Spindeltrimmer zum Einst.)
; * 4 RS: Registersatz (Display oder Befehl)---------------> LCD_PORT.7
; * 5 R/W: Schreiben oder lesen----------------------------> LCD_PORT.6
; * 6 E: Uebergabetakt-------------------------------------> LCD_PORT.4
; * 7-10: frei (eigentlich D0 - D3, wird aber nicht verwendet)
; * 11: D4/D0----------------------------------------------> LCD_PORT.0
; * 12: D5/D1----------------------------------------------> LCD_PORT.1
; * 13: D6/D2----------------------------------------------> LCD_PORT.2
; * 14: D7/D3----------------------------------------------> LCD_PORT.3
; *******************************************************










END
