
init_scroll			
					lda #$00
					sta $FF 			; store 0 in fd which is our counter for the y pos of the scroller

					ldx #$0b00/64		;Startadresse berechnen
					inx
					inx
					inx
					stx $07FB+SPR_ADD
					inx
					stx $07FC+SPR_ADD
					inx
					stx $07FD+SPR_ADD

					;X-Position für alle Sprites setzen

					lda #$50
					sta $D006
					lda #$68
					sta $D008
					lda #$80
					sta $D00a

					;Y-Position für alle Sprites setzen	

					lda #$a7				
					sta $D007
					sta $D009
					sta $D00B

					; farbe

					lda #$0f													
					sta $D02A	
					lda #$01				
					sta $D02B
					lda #$0f
					sta $D02C

		            lda #0              ;Variablen initialisieren
		            sta infotextbitpos

		            lda #<(infotext-1)  ;Pointer auf nulltes Zeichen vom Infotext setzen
		            sta Text_Pointer    ;weil "infotextbitpos" gleich beim ersten Durchlauf
		            lda #>(infotext-1)  ;unterläuft und den Pointer inkrementiert
		            sta Text_Pointer+1

					rts								;Endlosschleife

play_scroll		
					
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
					sta sprite_6+35 		;ganz nach rechts in Sprite-7 kopieren
					iny									;Y fürs nächste BYTE erhöhen
					lda (ZP_HELPADR),Y
					sta sprite_6+38
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+41 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+44 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+47 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+50 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+53 
					iny
					lda (ZP_HELPADR),Y
					sta sprite_6+56 

					lda #%00000100				;E/A-Bereich wieder aktivieren
					ora $01
					sta $01

shiftall
					ldx #3*20							;eine Zeile hat 3 BYTEs; ein Zeichen 8 Zeilen
					
loop2
					clc											;Carry löschen
					
					rol sprite_6+2,X
					rol sprite_6+1,X				; keine ahnung warum
					rol sprite_6,X					; aber anscheinend kann ich die weglassen
					rol sprite_5+2,X
					rol sprite_5+1,X
					rol sprite_5,X
					rol sprite_4+2,X
					rol sprite_4+1,X
					rol sprite_4,X
					rol sprite_3+2,X
					rol sprite_3+1,X
					rol sprite_3,X


					dex										;das X-Register dreimal verringern
					dex										;da wir oben immer drei BYTEs auf einmal 
					dex	
																				;'shiften'
					
					bpl loop2							;solange positiv -> wiederholen


					rts									;Interrupt verlassen

