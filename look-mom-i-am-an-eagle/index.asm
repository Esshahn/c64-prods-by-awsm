;============================================================
;    specify output file
;============================================================

!cpu 6502
!to "build/eaglesoft.prg",cbm    ; output file

;============================================================
; BASIC loader with start address $c000
;============================================================

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

;============================================================
;    symbols
;============================================================

address_music 	= $1000 	 ; loading address for sid tune
sid_init 	    	= $1cc0      ; init routine for music
sid_play 	    	= $1001      ; play music routine
PICTURE 	     	= $2000
colramlogo      = $db71     ; the color ram position of the color scroll in the awsm logo
colramscroll    = $dbc0     ; the color ram position of the color scroll text
smooth          = $05        ;Control for smooth scroll
screenloc       = $7c0         ;This is the line for where the scroll is placed

colorlogo    !byte $00,$00,$00,$00,$00    ; the color for the color scroll in the awsm logo
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 

             !byte $00,$00,$00,$00,$00   
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 

             !byte $06,$0e,$03,$07,$01
             !byte $01,$07,$03,$0e,$06
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00 
             !byte $00,$00,$00,$00,$00
             !byte $00,$00,$00,$00,$00  
             !byte $ff


colorscroll  !byte $09,$09,$02,$02,$08    ; the color for the color scroll in the scroller
             !byte $08,$0a,$0a,$0f,$0f 
             !byte $07,$07,$01,$01,$01 
             !byte $01,$01,$01,$01,$01 
             !byte $01,$01,$01,$01,$01 
             !byte $01,$01,$01,$07,$07 
             !byte $0f,$0f,$0a,$0a,$08 
             !byte $08,$02,$02,$09,$09 

             !byte $06,$06,$0e,$06,$0e
             !byte $0e,$03,$0e,$03,$03
             !byte $07,$03,$07,$07,$01
             !byte $07,$01,$01,$01,$01
             !byte $01,$01,$01,$01,$07
             !byte $01,$07,$07,$03,$07
             !byte $03,$03,$0e,$03,$0e
             !byte $0e,$06,$0e,$06,$06
             !byte $ff


;============================================================
;    resources
;============================================================

* = PICTURE
!binary "resources/eaglesoft1.kla",,2 

* = address_music                         ; address to load the music data
!bin "resources/Future_Knight_1000.sid",, $7c+2  ; remove header from sid and cut off original loading address 

;============================================================
;    some initialization and interrupt redirect setup
;============================================================
 * = $c000 
          sei         ; set interrupt disable flag
                      
          jsr init_koala 

          ldx #$27                 ; clear the last line with spaces
          lda #$20                 ; so that the scroller doesn't start
clrline   sta screenloc,x          ; with trash
          dex                      ;
          bne clrline              ;

          lda #$0
          sta $d012
          sta $d020
           
          jsr sid_init     ; init music routine now
          jsr init_scroll   

          cli                  ; clear interrupt disable flag

          jmp *

           
!source "code/koala.asm"
!source "code/scroller.asm"
!source "code/colorwash.asm"