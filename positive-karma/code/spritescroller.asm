
init_scroll			
					lda #$00
					sta $FF 			; store 0 in fd which is our counter for the y pos of the scroller

					ldx #$0900/64		;Startadresse berechnen
					stx $07F8+SPR_ADD
					inx
					stx $07F9+SPR_ADD
					inx
					stx $07FA+SPR_ADD
					inx
					stx $07FB+SPR_ADD
					inx
					stx $07FC+SPR_ADD
					inx
					stx $07FD+SPR_ADD


					lda #$40				;X-Position für alle Sprites setzen
					sta $D000
					lda #$70
					sta $D002
					lda #$a0
					sta $D004
					lda #$d0
					sta $D006
					lda #$00
					sta $D008


					lda #%00010000			;X-Pos für Sprite 5 & 6 > 255
					sta $D010

					lda #$b0				;Y-Position für alle Sprites setzen					
					
					sta $D001				; links
					sta $D003
					sta $D005
					sta $D007
					sta $D009

					lda #$01				; farbe
					sta $D027
					;lda #$01
					sta $D028
					;lda #$01					
					sta $D029
					;lda #$01					
					sta $D02A
					;lda #$0f
					sta $D02B

					lda #%00011111			; spiegelverkehrt zum bildschirm
					sta $D01D						;in der Breite
					sta $D017						;und Höhe verdoppeln
					sta $D015						;und zum Schluß sichtbar schalten

		            lda #0              ;Variablen initialisieren
		            sta infotextbitpos

		            lda #<(infotext-1)  ;Pointer auf nulltes Zeichen vom Infotext setzen
		            sta Text_Pointer    ;weil "infotextbitpos" gleich beim ersten Durchlauf
		            lda #>(infotext-1)  ;unterläuft und den Pointer inkrementiert
		            sta Text_Pointer+1

					rts								;Endlosschleife

play_scroll		

					ldx $FF				;Y-Position für alle Sprites setzen
					lda sinus,x
					cmp #$00
					bne goon					
					sta $FF
					jmp play_scroll

goon
				
					sta $D001				; links				
					sta $D003								
					sta $D005							
					sta $D007
					sta $D009
					inc $FF
					
rasterirq
  					dec infotextbitpos  	;wurden bereits 8-Bits 'verschoben'
	  				bpl shiftall				  ;falls nein, alle Spritedaten 'shiften'
		  			lda #$07				  		;sonst Zähler zurücksetzen
			  		sta infotextbitpos  	;und dann nächstes Zeichen holen
				  	inc Text_Pointer  	  ;Zeiger aufs nächste Zeichen erhöhen
           			bne go_on2
            		inc Text_Pointer+1

go_on2:     		ldy #0
  					lda (Text_Pointer),Y	;Zeichen in den Akku
	  				bne getChar				  	;falls kein Textende ($00) weiter bei getChar
		  			lda #<(infotext)      ;sonst Zeiger aufs erste Zeichen
			  		sta Text_Pointer		  ;zurückstellen
				  	lda #>(infotext)
            		sta Text_Pointer+1
            		jmp go_on2

getChar   				 ;ein Zeichen aus dem Char-ROM holen
					asl
					sta ZP_HELPADR
					lda #$1a
					rol
					asl ZP_HELPADR
					rol
					asl ZP_HELPADR
					rol
					sta ZP_HELPADR+1



					lda #%11111011			;E/A-Bereich abschalten, um aufs Char-ROM
					and $01							;zugreifen zu können
					sta $01

					ldy #$00				;Y-Reg. für die Y-nach-indizierte-Adressierung
					lda (ZP_HELPADR),Y	;jeweils ein BYTE aus dem Char-ROM
					sta sprite_5+20 		;ganz nach rechts in Sprite-7 kopieren
					iny									;Y fürs nächste BYTE erhöhen
					lda (ZP_HELPADR),Y
					sta sprite_5+26
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+32 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+38 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+44 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+50 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+56 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_5+62 

					lda #%00000100				;E/A-Bereich wieder aktivieren
					ora $01
					sta $01

shiftall
					ldx #3*20							;eine Zeile hat 3 BYTEs; ein Zeichen 8 Zeilen
					
loop2
					clc											;Carry löschen
					
					rol sprite_5+2,X
					;rol sprite_5+1,X				; keine ahnung warum
					;rol sprite_5,X					; aber anscheinend kann ich die weglassen
					rol sprite_4+2,X
					rol sprite_4+1,X
					rol sprite_4,X
					rol sprite_3+2,X
					rol sprite_3+1,X
					rol sprite_3,X
					rol sprite_2+2,X
					rol sprite_2+1,X
					rol sprite_2,X
					rol sprite_1+2,X
					rol sprite_1+1,X
					rol sprite_1,X
					rol sprite_0+2,X
					rol sprite_0+1,X
					rol sprite_0,X

					dex										;das X-Register dreimal verringern
					dex										;da wir oben immer drei BYTEs auf einmal 
					dex	
																				;'shiften'
					
					bpl loop2							;solange positiv -> wiederholen



					rts									;Interrupt verlassen

