;==========================================================
;
; It's dead, line
;
;==========================================================

;==========================================================
; MACROS
;==========================================================

!src "code/macros.a"

;==========================================================
; LABELS
;==========================================================

  Text_Pointer    = $02
	SCRRAM          = $2000
	COLRAM          = $d800
  ZP_HELPADR      = $FB
	tmp_akku        = $a6
	tmp_xreg        = $a7
	tmp_yreg        = $a8
  music           = $1000
  init_sid        = music           ; init routine for music
  play_sid        = music + $03     ; play music routine
  SP_ADDR         = $0900	  	      ; loading address for sprite
  SP_SCROLLER_ADDR= $3400
  BASIC           = $0801
  MAIN            = $4000
  CHARSET_DATA    = $3800

;==========================================================
; BASIC header
;==========================================================

* = BASIC

                !byte $0b, $08
                !byte $E4                           ; BASIC line number:  $E2=2018 $E3=2019      
                !byte $07, $9E
                !byte '0' + main % 100000 / 10000 
                !byte '0' + main % 10000 / 1000        
                !byte '0' + main %  1000 /  100        
                !byte '0' + main %   100 /   10        
                !byte '0' + main %    10             
                !byte $00, $00, $00                 ; end of basic


;==========================================================
; MAIN
;==========================================================

* = MAIN
main:


                lda #$00                            ; the color value
                sta $d020                           ; set background color
                sta $d021                           ; set border color
                jsr clear
                jsr copy_charset
                jsr init_sid
                jsr init_sprites
                jsr set_dino_5
                jsr init_scroll
                
                sei                                 ; set interrupt disable flag
                ldy #$7f                            ; $7f = %01111111
                sty $dc0d                           ; Turn off CIAs Timer interrupts 
                sty $dd0d                           ; Turn off CIAs Timer interrupts 
                lda $dc0d                           
                lda $dd0d                           

                lda #$01                            ; Set Interrupt Request Mask...
                sta $d01a                           ; ...we want IRQ by Rasterbeam (%00000001)
                lda #<irq                           ; point IRQ Vector to our custom irq routine
                ldx #>irq 
                sta $0314                           ; store in $314/$315
                stx $0315   
                lda #$0                            ; trigger interrupt at row zero
                sta $d012
                cli                                 ; clear interrupt disable flag

                jmp *                               ; infinite loop


;==========================================================
; IRQ
;==========================================================

irq:        
                +stack
                

                ; start right below the screen
                ; good to get the non-sprite stuff out of the way
                ; so that e.g. the spiral doesn't glitch

                lda #$02
-               cmp $d012
                bne -
                
                ; count up a global timer
                inc global_timer_low
                lda global_timer_low
                cmp #33
                bne +
                  inc global_timer_high
                  lda #$00
                  sta global_timer_low
                  
                ; load in the high byte of the timer
                lda global_timer_high
                cmp #12
                bne +
                  lda #$01
                  sta display_spiral

+
                lda global_timer_high
                cmp #23
                bne +
                  lda #$01
                  sta display_scroller

+
                jsr play_sid

                dec spiral_counter_byte
                lda spiral_counter_byte
                bpl +
                  lda #6
                  sta spiral_counter_byte
                  jsr set_spiral_chars
                  lda #%11111111      ; not really the right place, but prevents initial sprite garbage
                  sta $d015           ; enable sprites 

                  lda display_spiral              ; display the spiral only if this is not 0
                  beq +
                  jsr set_spiral_color  

+

                ; next up we need to prepare the scroller sprites
                ; by setting their pointers and positions
                ;

                jsr prep_scroll_sprites

                ; and this is the are for the scroller routine
                ;
                ; 

                lda display_scroller            ; display the scroller only if this is not 0
                beq +
                  jsr play_scroll
                ; now we wait until the raster beam is below the 
                ; scroller area
                ;
+                
                lda #$76
-               cmp $d012
                bne -
              

                ; we are now below the scroller area
                ; so we prepare the dino sprites
                ;

                jsr set_dino_sprites

                ; dino routine goes here

                jsr rhythm

                asl $d019

                jsr $ffe4                       ; GETIN
                cmp #$20                        ; check for space key
                bne +                           ; pressed?
                jmp reset                        ; yes, exit intro

+
                +unstack
                
                jmp $ea31                           ; return to Kernal routine

;==========================================================
; CODE INCLUDES
;==========================================================

reset:     
                sei
                lda #$ea                        ; $ea31 = original IRQ vector
                sta $0315                       ; IRQ vector routine high byte
                lda #$31
                sta $0314                       ; IRQ vector routine low byte
                jsr $ff81                       ; SCINIT
                lda #$97
                sta $dd00                       ; CIA #2 - port A, serial bus access
                cli

                lda #$00
                sta $d020
                sta $d021

                ldy #$0a  
                     

character_loop:

                lda hello,y             ; load character number y of the string
                sta $0400+12*40+14,y         ; save it at position y of the screen ram
                lda #$01
                sta $d800+12*40+14,y
                dey                     ; decrement y by 1
                bpl character_loop      ; is y positive? then repeat
                jmp $fce2                       ; clean up IRQ and reset

prep_scroll_sprites:

SCROLLER_LEFT = 24
                lda #$01
                sta $d027
                sta $d029
                sta $d02a
                sta $d02c
                sta $d02d
                sta $d02e
                sta $d028
                sta $d02b

                lda #%00000000
                sta $d01c           ; set multicolor mode for sprites	 
                lda #%01100000
                sta $d010                     ; x coordinate

                lda #SCROLLER_LEFT + 0 * 48
                sta $d000
                lda #SCROLLER_LEFT + 1 * 48
                sta $d002
                lda #SCROLLER_LEFT + 2 * 48
                sta $d004
                lda #SCROLLER_LEFT + 3 * 48
                sta $d006
                lda #SCROLLER_LEFT + 4 * 48
                sta $d008
                lda #8
                sta $d00a
                lda #8 + 48
                sta $d00c

                rts


BEAT_TEMPO = $17 / 2
beat_countdown:
!byte BEAT_TEMPO

rhythm:
                
                dec beat_countdown
                lda beat_countdown
                bpl +
                lda #BEAT_TEMPO
                sta beat_countdown
                inc dino_animation_table_pos
+         
                jsr animate_dino
                rts


copy_charset:
                lda $d018
                ora #$0e       ; set chars location to $3800 for displaying the custom font
                sta $d018      ; Bits 1-3 ($400+512bytes * low nibble value) of $d018 sets char location
                                ; $400 + $200*$0E = $3800
                rts

set_spiral_color:
                ; set color
                ldx spiral_color
                lda spiral_colors,x
                cmp #$ff
                bne +
                ldx #$0
                stx spiral_color
                lda spiral_colors,x
+
                sta $d021
                inc spiral_color
                rts

set_spiral_chars:

                ; set chars
                ldx spiral
                lda spirals,x 
                cmp #$ff
                bne +
                ldx #$0
                stx spiral
                lda spirals,x
+
                sta $d018
                inc spiral
                rts



;
; clear the screen
;

clear:
	              ldx #0
-
                lda #$20     
                sta $0400,x  
                sta $0500,x 
                sta $0600,x 
                sta $06e8,x
                lda #0
                sta $d800,x  
                sta $d900,x
                sta $da00,x
                sta $dae8,x
                inx          
                bne -                 
                rts          


global_timer_low:
!byte $00

global_timer_high:
!byte $00

display_spiral:
!byte $00

display_scroller:
!byte $00

wait_timer:
!byte $ff

spiral_counter_byte:
!byte 20

; the current spiral pointer
spiral:
!byte 0

spirals:
!byte %10001111
!byte %10011111
!byte %10101111
!byte %10111111
!byte %11001111
!byte $ff ; terminator



; the current spiral color pointer
spiral_color:
!byte 0

spiral_colors:
!byte 2,6
!byte $ff ; terminator
!byte 6,14,3,7,1,3,14,6
!byte 11,12,15,1,1,1,15,12,11,12,15,1,1,1,15,12


hello           
!scr "awsm/dalezy"     ; our string to display

!source "code/config-sprites.asm"
!source "code/spritescroller.asm"

; music
* = music
!bin "sid/rumluemmeln.sid",, $7c+2

; spiral char data
!source "code/spiral.asm"

* = SP_ADDR           
!bin "gfx/dino-only.spd",25*64,3  	 ; skip first three bytes which is encoded Color Information

* = CHARSET_DATA 
!bin "gfx/movie-writer-charset.bin",,2