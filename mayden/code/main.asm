;==========================================================
; THE MAYDEN 
; Screen for Mayday! C64 demo WEEK IN PROGRESS
; Released at BCC#13 
; by awsm/Mayday! Feb2019
;
; This code example is available on Github:
; https://github.com/Esshahn/c64-prods-by-awsm
;
; Written in ACME
; Using the ACME-VSCode template:
; https://github.com/Esshahn/acme-assembly-vscode-template
;
;==========================================================



;==========================================================
; INCLUDES
;==========================================================

* = $4000
!bin "sources/girl_bitmap.bin"

* = $6000
!bin "sources/girl_screen.bin"

* = $6400
!bin "sources/girl_colors.bin"

* = $7000
sprites
!bin "sources/mikie.spd",6*64,3

;==========================================================
; LABELS
;==========================================================

SCREEN = $6000
COLORS = $6400

;==========================================================
; BASIC header
;==========================================================

* = $0801

                !byte $0b, $08
                !byte $E3                     ; BASIC line number:  $E2=2018 $E3=2019 etc       
                !byte $07, $9E
                !byte '0' + entry % 10000 / 1000        
                !byte '0' + entry %  1000 /  100        
                !byte '0' + entry %   100 /   10        
                !byte '0' + entry %    10             
                !byte $00, $00, $00           ; end of basic


;==========================================================
; CODE
;==========================================================

entry


                jsr init_koala
                jsr init_sprites
                
                lda #$0c 
                sta $d020

                sei         ; set interrupt disable flag

                ldy #$7f    ; $7f = %01111111
                sty $dc0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
                sty $dd0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
                lda $dc0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
                lda $dd0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed

                lda #$01    ; Set Interrupt Request Mask...
                sta $d01a   ; ...we want IRQ by Rasterbeam (%00000001)

                lda #<irq   ; point IRQ Vector to our custom irq routine
                ldx #>irq 
                sta $0314    ; store in $314/$315
                stx $0315   

                lda #$00    ; trigger interrupt at row zero
                sta $d012

                cli         ; clear interrupt disable flag
                jmp *       ; infinite loop


;==========================================================
; IRQ
;==========================================================

CONST_ANIMATION_STEPS = 9

var_delay           !byte $00
var_phase_sprite_0  !byte $00
var_phase_sprite_1  !byte $01 
var_phase_sprite_2  !byte $02
var_phase_sprite_3  !byte $03
var_phase_sprite_4  !byte $04
var_phase_sprite_5  !byte $05
var_phase_sprite_6  !byte $06
var_phase_sprite_7  !byte $07

irq        
			    asl $d019
                
                ;
                ; slow the animation down
                ;

                inc var_delay
                lda var_delay
                cmp #5                  ; Animation speed
                beq +
                jmp end_irq

+
                lda #$00
                sta var_delay

                inc var_phase_sprite_0
                inc var_phase_sprite_1
                inc var_phase_sprite_2
                inc var_phase_sprite_3
                inc var_phase_sprite_4
                inc var_phase_sprite_5
                inc var_phase_sprite_6
                inc var_phase_sprite_7

                ;
                ; start animation
                ;

; =========================
; sprite 0
; =========================

                lda var_phase_sprite_0
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_0
                lda #$00
                sta mod_new_x +1
                lda #$01
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3f8
                sta sprite_add +1
                lda #> SCREEN + $3f8
                sta sprite_add +2
                lda var_phase_sprite_0
                jsr display_hearts

; =========================
; sprite 1
; =========================

                lda var_phase_sprite_1
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_1
                lda #$02
                sta mod_new_x +1
                lda #$03
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3f9
                sta sprite_add +1
                lda #> SCREEN + $3f9
                sta sprite_add +2
                lda var_phase_sprite_1
                jsr display_hearts            

; =========================
; sprite 2
; =========================

                lda var_phase_sprite_2
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_2
                lda #$04
                sta mod_new_x +1
                lda #$05
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3fa
                sta sprite_add +1
                lda #> SCREEN + $3fa
                sta sprite_add +2
                lda var_phase_sprite_1
                jsr display_hearts

; =========================
; sprite 3
; =========================

                lda var_phase_sprite_3
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_3
                lda #$06
                sta mod_new_x +1
                lda #$07
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3fb
                sta sprite_add +1
                lda #> SCREEN + $3fb
                sta sprite_add +2
                lda var_phase_sprite_3
                jsr display_hearts

; =========================
; sprite 4
; =========================

                lda var_phase_sprite_4
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_4
                lda #$08
                sta mod_new_x +1
                lda #$09
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3fc
                sta sprite_add +1
                lda #> SCREEN + $3fc
                sta sprite_add +2
                lda var_phase_sprite_4
                jsr display_hearts


; =========================
; sprite 5
; =========================

                lda var_phase_sprite_5
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_5
                lda #$0a
                sta mod_new_x +1
                lda #$0b
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3fd
                sta sprite_add +1
                lda #> SCREEN + $3fd
                sta sprite_add +2
                lda var_phase_sprite_5
                jsr display_hearts

; =========================
; sprite 6
; =========================

                lda var_phase_sprite_6
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_6
                lda #$0c
                sta mod_new_x +1
                lda #$0d
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3fe
                sta sprite_add +1
                lda #> SCREEN + $3fe
                sta sprite_add +2
                lda var_phase_sprite_6
                jsr display_hearts

; =========================
; sprite 7
; =========================

                lda var_phase_sprite_7
                cmp #CONST_ANIMATION_STEPS
                bne +
                lda #0                          ; reset counter for sprite
                sta var_phase_sprite_7
                lda #$0e
                sta mod_new_x +1
                lda #$0f
                sta mod_new_y +1
                jsr get_new_pos

+
                
                ; display animation sprite for sprite x

                lda #< SCREEN + $3ff
                sta sprite_add +1
                lda #> SCREEN + $3ff
                sta sprite_add +2
                lda var_phase_sprite_7
                jsr display_hearts

end_irq
               
                jmp $ea31      ; return to Kernel routine

;==========================================================
; display hearts
;==========================================================

               
display_hearts

                tay
                lda animationtable,y
                ora #$c0
sprite_add
                sta $1000
                rts



animationtable
                !byte ( 1*$40) / $40
                !byte ( 2*$40) / $40
                !byte ( 3*$40) / $40
                !byte ( 4*$40) / $40
                !byte ( 5*$40) / $40
                !byte ( 5*$40) / $40
                !byte ( 4*$40) / $40
                !byte ( 3*$40) / $40
                !byte ( 1*$40) / $40
                !byte ( 0*$40) / $40
                
                   

;==========================================================
; get new position
;==========================================================

var_table_pos !byte $00

get_new_pos
                inc var_table_pos
                ldx var_table_pos

                cpx #100
                bne +
                ldx #0
                stx var_table_pos

+
                lda random_table_x,x
mod_new_x 
                sta $d000 
                lda random_table_y,x 
mod_new_y
                sta $d001 
                rts


random_table_x
!byte 097,149,188,071,122,073,218,125,209,204,114,240,110,253,072,170,115,092,161,150,236,215,185,171,083,138,219,173,208,102,082,193,200,127,202,223,254,214,137,167,186,077,103,130,244,094,155,169,179,148,242,104,076,212,143,152,230,141,159,211,198,133,184,084,187,070,176,250,172,067,134,232,135,177,154,160,246,225,247,233,081,145,229,235,074,164,144,255,066,189,089,120,080,199,181,183,196,139,165,192

random_table_y
!byte 117,161,104,158,114,127,207,170,162,143,200,191,100,168,083,102,090,126,136,181,087,091,120,151,135,065,172,073,133,115,082,180,208,210,205,220,174,152,107,148,145,195,206,215,189,106,110,199,150,214,141,155,198,069,134,176,094,178,086,112,166,122,171,109,067,216,144,095,218,159,079,081,098,123,188,213,139,160,183,116,156,153,203,062,197,138,089,194,201,192,088,077,185,066,068,217,131,186,105,187

;==========================================================
; init all sprites
;==========================================================

init_sprites

                lda #%11111111
                sta $d015   ; enable sprites
                sta $d01c   ; multicolor

                lda #(192 + 0*$40) / $40    
                sta SCREEN + $3f8  

                lda #(192 + 1*$40) / $40   
                sta SCREEN + $3f9 

                lda #(192 + 2*$40) / $40   
                sta SCREEN + $3fa 

                lda #(192 + 3*$40) / $40   
                sta SCREEN + $3fb 

                lda #(192 + 4*$40) / $40    
                sta SCREEN + $3fc  

                lda #(192 + 0*$40) / $40   
                sta SCREEN + $3fd 

                lda #(192 + 1*$40) / $40   
                sta SCREEN + $3fe 

                lda #(192 + 2*$40) / $40   
                sta SCREEN + $3ff 

                lda #$0a             ; sprite color
                sta $d027
                sta $d028
                sta $d029
                sta $d02a
                
                lda #$02
                sta $d02b
                sta $d02c

                lda #$04
                sta $d02d
                sta $d02e


                lda #$00        
                sta $d025           ; multicolor 1

                lda #$01
                sta $d026           ; multicolor 2


                ; sprite y pos
                lda #$0        
                sta $d001
                sta $d003
                sta $d005
                sta $d007
                sta $d009
                sta $d00b
                sta $d00d
                sta $d00f
 
  	
                sta $d000 
                sta $d002
                sta $d004
                sta $d006
                sta $d008
                sta $d00a
                sta $d00c
                sta $d00e

                rts




;==========================================================
; display koala image
;==========================================================


init_koala	 
			

                
				lda #2				;vic bank $4000-$7fff
				sta $dd00 
				

                ldx #$00 

-

                lda COLORS,x
                sta $d800,x
                lda COLORS+$100,x
                sta $d900,x
                lda COLORS+$200,x
                sta $da00,x
                lda COLORS+$300,x
                sta $db00,x
                dex
                bne -

                lda #$00			;$d021 color
                sta $d021
                
                ; 
                ; Bitmap Mode On 
                ; 
                lda #$3b 
                sta $d011 

                ; 
                ; MultiColor On 
                ; 

                lda #$d8 
                sta $d016 

                lda #$80			;//bitmap = $4000, screen = $6000
				sta $d018

                rts


