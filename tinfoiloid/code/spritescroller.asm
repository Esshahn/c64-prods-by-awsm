init_scroll			
								lda #$00
								sta $FF 			; store 0 in fd which is our counter for the y pos of the scroller
								lda #0              ;Variablen initialisieren
								sta infotextbitpos
								lda #<(infotext-1)  ;Pointer auf nulltes Zeichen vom Infotext setzen
								sta Text_Pointer    ;weil "infotextbitpos" gleich beim ersten Durchlauf
								lda #>(infotext-1)  ;unterläuft und den Pointer inkrementiert
								sta Text_Pointer+1
								rts								

play_scroll		

								ldx #>scroll
              	ldy #<scroll
              	jsr set_sprites

								ldx $FF				;Y-Position für alle Sprites setzen
								lda sinus,x
								cmp #$00
								bne set_y_pos					
								sta $FF
								jmp play_scroll

set_y_pos
			
								sta $D001				; links				
								sta $D003								
								sta $D005							
								sta $D007
								sta $D009
								sta $D00b
								sta $D00d
								inc $FF
					
								dec infotextbitpos  	;wurden bereits 8-Bits 'verschoben'
								bpl shiftall				  ;falls nein, alle Spritedaten 'shiften'
								lda #$07				  		;sonst Zähler zurücksetzen
								sta infotextbitpos  	;und dann nächstes Zeichen holen
								inc Text_Pointer  	  ;Zeiger aufs nächste Zeichen erhöhen
								bne go_on2
								inc Text_Pointer+1

go_on2:     		
								ldy #0
								lda (Text_Pointer),Y	;Zeichen in den Akku
								bne getChar				  	;falls kein Textende ($00) weiter bei getChar
								lda #<(infotext)      ;sonst Zeiger aufs erste Zeichen
								sta Text_Pointer		  ;zurückstellen
								lda #>(infotext)
								sta Text_Pointer+1
								jmp go_on2

getChar                             ;ein Zeichen aus dem Char-ROM holen
								tax                                ;Zeichen ins X-Register
								lda #$00                           ;Startadresse des Char-ROMs auf die Zero-Page
								sta ZP_HELPADR
								lda #$38
								sta ZP_HELPADR+1
								
nextChar                            ;Jetzt für jedes Zeichen, bis zum gesuchten,
								clc                                ;8-Bytes auf die Char-ROM-Adresse in der
								lda #$08                           ;Zero-Page addieren
								adc ZP_HELPADR
								sta ZP_HELPADR
								lda #$00
								adc ZP_HELPADR+1
								sta ZP_HELPADR+1
								dex
								bne nextChar



							lda #%11111011			;E/A-Bereich abschalten, um aufs Char-ROM
							and $01							;zugreifen zu können
							sta $01

							ldy #$00				;Y-Reg. für die Y-nach-indizierte-Adressierung
							lda (ZP_HELPADR),Y	;jeweils ein BYTE aus dem Char-ROM
							sta SP_SCROLLER_ADDR+7*$40 +2+8 		;ganz nach rechts in Sprite-7 kopieren
							iny									;Y fürs nächste BYTE erhöhen
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +5+8
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +8+8
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +11+8
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +14+8
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +17+8 
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +20+8
							iny
							lda (ZP_HELPADR),Y
							sta SP_SCROLLER_ADDR+7*$40 +23+8 

							lda #%00000100				;E/A-Bereich wieder aktivieren
							ora $01
							sta $01

shiftall
							ldx #3*10							;eine Zeile hat 3 BYTEs; ein Zeichen 8 Zeilen
					
-
							clc											;Carry löschen
							rol SP_SCROLLER_ADDR+7*$40 +2,X
							rol SP_SCROLLER_ADDR+7*$40 +1,X				
							rol SP_SCROLLER_ADDR+7*$40 ,X	
							rol SP_SCROLLER_ADDR+6*$40 +2,X
							rol SP_SCROLLER_ADDR+6*$40 +1,X				
							rol SP_SCROLLER_ADDR+6*$40 ,X									
							rol SP_SCROLLER_ADDR+5*$40 +2,X
							rol SP_SCROLLER_ADDR+5*$40 +1,X				
							rol SP_SCROLLER_ADDR+5*$40 ,X					
							rol SP_SCROLLER_ADDR+4*$40 +2,X
							rol SP_SCROLLER_ADDR+4*$40 +1,X
							rol SP_SCROLLER_ADDR+4*$40 ,X
							rol SP_SCROLLER_ADDR+3*$40 +2,X
							rol SP_SCROLLER_ADDR+3*$40 +1,X
							rol SP_SCROLLER_ADDR+3*$40 ,X
							rol SP_SCROLLER_ADDR+2*$40 +2,X
							rol SP_SCROLLER_ADDR+2*$40 +1,X
							rol SP_SCROLLER_ADDR+2*$40 ,X
							rol SP_SCROLLER_ADDR+1*$40 +2,X
							rol SP_SCROLLER_ADDR+1*$40 +1,X
							rol SP_SCROLLER_ADDR+1*$40 ,X
							rol SP_SCROLLER_ADDR+0*$40+2,X
							rol SP_SCROLLER_ADDR+0*$40+1,X
							rol SP_SCROLLER_ADDR+0*$40,X

							dex										;das X-Register dreimal verringern
							dex										;da wir oben immer drei BYTEs auf einmal 
							dex	
																						;'shiften'
			
							bpl -							;solange positiv -> wiederholen
							rts									;Interrupt verlassen


sinus:     
!byte 66, 68, 69, 70, 71, 72, 73, 74, 74, 76, 76, 78, 78, 78, 79, 79, 80, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 80, 79, 79, 78, 78, 77, 76, 75, 74, 73, 73, 71, 70, 70, 68, 67, 66, 65, 64, 63, 62, 61, 60, 58, 58, 57, 57, 55, 55, 54, 54, 54, 53, 52, 52, 52, 52, 52, 52, 52, 52, 53, 54, 54, 54, 55, 55, 56, 57, 58, 58, 59, 60, 62, 62, 63, 65, 66, 66
!byte $00


infotext        

!scr "greetings from your favorite reptoid!"
!scr "    long live the lizard folk!!"
!scr "    good news everyone!"
!scr "    we've made great progress chipping the humanz, thanks to our allied marsian friend, gill bates...."
!scr "    resistance to 'facts' is at an alltime high, and cardano is stronger than ever!"
!scr "    very soonish we will finally unite the two kingdoms! hollow earth and flat earth will become..."
!scr "    flallow earth... err... well, naming hasn't passed marketing yet, we'll keep you posted on that..."
!scr "    but for now, let's paaarty and keep the adrenochrome flowing, because it's dead, line!!!"
!scr "                                             "
!byte $00

infotextbitpos  
!byte $00