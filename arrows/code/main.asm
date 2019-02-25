
;==========================================================
; INCLUDES
;  
;  
;==========================================================


* = $3800
charset
!bin "sources/arrows-charset.bin" 

* = $2800
map
!source "sources/map.asm"

* = $2000
sprites
!bin "sources/myd-logo.spd",3*64,3


;==========================================================
; LABELS
; Comment or uncomment the lines below 
; Depending on your target machine
;==========================================================


; C64
BGCOLOR       = $d021
BORDERCOLOR   = $d020
BASIC         = $0801
SCREEN        = $0400
COLRAM        = $d800
ARROW_START   = $0400

;==========================================================
; BASIC header
;==========================================================

* = BASIC

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


                jsr clear

                ; initialize the custom font
                lda $d018
                ora #$0e                ; #$0e
                sta $d018
                
                lda #$0b
                sta $d011               ; turn off screen

                sei               ; set interrupt disable flag

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

                lda #$f0    ; trigger interrupt at row zero
                sta $d012

                cli         ; clear interrupt disable flag
                jmp *       ; infinite loop


;==========================================================
; IRQ
;==========================================================

var_play_animation  !byte $fe
var_fade_delay      !byte $00
var_counter_to_end  !byte $60                       ; TIMING: change this for longer play time

irq        
			    dec $d019
                ;dec $d020
                jsr move_logo


                ; --- start simple waiting loop
                lda var_fade_delay

                cmp #6                          ; loop speed
                beq +
                    inc var_fade_delay 
                    jmp end_irq

+
                
                lda #0
                sta var_fade_delay

                ; check if the part was running long enough
                lda var_counter_to_end
                bne +
                    ; time to say goodbye :)
                    lda #20
                    sta var_play_animation

+
                dec var_counter_to_end

                ; --- end simple waiting loop

                lda var_play_animation             ; which animation step to display?
                cmp #16
                bne +
                    lda #0
                    sta var_play_animation
                
                ; from here on var_play_animation gets checked
                ; and depending on the value a different arrow table is set

+
                cmp #$fe
                bne +
                    
                    jsr fade_in
                    jmp end_irq

+
                cmp #$ff
                bne +
                    jsr display_map
                    jsr init_sprites
                    
                    lda #$1b
                    sta $d011               ; turn on screen
                    inc var_play_animation
                    jmp end_irq

+
                cmp #0
                bne +
                    lda #$f0
                    sta var_fade_delay
                    jsr display_screen_1 
                    ldx #<arr_0
                    ldy #>arr_0
                    jmp call_anim
+               
               
                cmp #1
                bne +
                    
                    ldx #<arr_1
                    ldy #>arr_1
                    jmp call_anim

+               
               
                cmp #2
                bne +
                    ldx #<arr_2
                    ldy #>arr_2
                    jmp call_anim

+               
               
                cmp #3
                bne +
                    ldx #<arr_3
                    ldy #>arr_3
                    jmp call_anim

+               
               
                cmp #4
                bne +
                    lda #$f0
                    sta var_fade_delay
                    jsr display_screen_2 
                    ldx #<arr_12
                    ldy #>arr_12
                    jmp call_anim
                    

+               
               
                cmp #5
                bne +
                    ldx #<arr_13
                    ldy #>arr_13
                    jmp call_anim

+               
               
                cmp #6
                bne +
                    ldx #<arr_14
                    ldy #>arr_14
                    jmp call_anim

+               
               
                cmp #7
                bne +
                    ldx #<arr_15
                    ldy #>arr_15
                    jmp call_anim

+               
               
                cmp #8
                bne +
                    lda #$f0
                    sta var_fade_delay
                    jsr display_screen_1 
                    ldx #<arr_8
                    ldy #>arr_8
                    jmp call_anim

+               
               
                cmp #9
                bne +
                    ldx #<arr_9
                    ldy #>arr_9
                    jmp call_anim

+               
               
                cmp #10
                bne +
                    ldx #<arr_10
                    ldy #>arr_10
                    jmp call_anim

+               
               
                cmp #11
                bne +
                    ldx #<arr_11
                    ldy #>arr_11
                    jmp call_anim

+               
               
                cmp #12
                bne +
                    lda #$f0
                    sta var_fade_delay
                    jsr display_screen_2 
                    ldx #<arr_4
                    ldy #>arr_4
                    jmp call_anim

+               
               
                cmp #13
                bne +
                    ldx #<arr_5
                    ldy #>arr_5
                    jmp call_anim

+               
               
                cmp #14
                bne +
                    ldx #<arr_6
                    ldy #>arr_6
                    jmp call_anim

+               
               
                cmp #15
                bne +
                    ldx #<arr_7
                    ldy #>arr_7
                    jmp call_anim

+               
               
                cmp #20
                bne +
                    jsr clear
                    lda #%000000
                    sta $d015 ; enable sprites
                    lda #21
                    sta var_play_animation

+
                     
                cmp #21
                bne +
                    
                    jsr fade_out
                    jmp end_irq

+


                cmp #22
                bne +

                    jmp *                               ; HIER SPRUNG ZUM NAECHSTEN PART

+

call_anim
                stx var_arrow_index
                sty var_arrow_index+1
                jsr display_arrows
                inc var_play_animation
                
                
end_irq
               ; inc $d020
                jmp $ea31      ; return to Kernel routine


;==========================================================
; display arrows
;==========================================================

var_arrow_index !word $0000 ;   Adresse, wo arrow tabelle liegt


display_arrows

                lda var_arrow_index     ; 1. byte der adresse lesen
                sta mod+1 
                sta mod1+1              
                lda var_arrow_index+1   ; 2.
                sta mod+2
                sta mod1+2

                lda #0
                sta po+1

                ldy #0
po
                ldx #0
mod
                lda $1000,x               ; hier steht jetzt $0974
                sta mod2 +1
                inx
mod1
                lda $1000,x
                sta mod2 +2

                ldx #0            
mod2
                lda $1000,x             ; this is the correct address of the char in the charset now
inverter
                eor #$00                ; are the arrows displayed normal ($00) or inverted ($FF) -> via selfmod
                sta charset + 240*8,y
                inx 
                iny
                cpx #8
                bne mod2
                    inc po+1
                    inc po+1
                    cpy #128            ; 16*8 bytes copied?
                    bne po
                    rts


;==========================================================
; display the characters on screen
;==========================================================

display_screen_1



                lda #$ff
                sta inverter +1
                jsr fill_screenram
                rts



;==========================================================

display_screen_2


                lda #$00
                sta inverter +1
                jsr fill_screenram2
                rts



;==========================================================
; fill screenram
;==========================================================

CONST_ARROW_X_POS_OFFSET = 8
CONST_ARROW_Y_POS_OFFSET = 40*4
CONST_ARROWS = 6 * 4

fill_screenram


                ldx #0

-
                lda chars1_1,x
                sta SCREEN + 40*0 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*4 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*8 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*12 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*16 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars1_2,x
                sta SCREEN + 40*1 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*5 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*9 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*13 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*17 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars1_3,x
                sta SCREEN + 40*2 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*6 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*10 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*14 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*18 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars1_4,x
                sta SCREEN + 40*3 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*7 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*11 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*15 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*19 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                inx 
                cpx #CONST_ARROWS
                bne -
                rts

;==========================================================
; fill screenram
;==========================================================

fill_screenram2


                ldx #0

-
                lda chars2_1,x
                sta SCREEN + 40*0 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*4 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*8 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*12 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*16 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars2_2,x
                sta SCREEN + 40*1 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*5 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*9 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*13 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*17 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars2_3,x
                sta SCREEN + 40*2 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*6 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*10 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*14 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*18 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                lda chars2_4,x
                sta SCREEN + 40*3 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*7 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*11 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*15 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x
                sta SCREEN + 40*19 + CONST_ARROW_Y_POS_OFFSET + CONST_ARROW_X_POS_OFFSET,x

                inx
                cpx #CONST_ARROWS
                bne -
                rts

;==========================================================
; clear screen
;==========================================================

clear

                ldx #0

-

                lda #238       
                sta SCREEN,x       
                sta SCREEN + $100,x 
                sta SCREEN + $200,x 
                sta SCREEN + $2e8,x
                lda #$01
                sta COLRAM,x  
                sta COLRAM + $100,x
                sta COLRAM + $200,x
                sta COLRAM + $2e8,x
                inx                
                bne -                     
                rts 

;==========================================================
; display the characters on screen
;==========================================================

display_map

 
                ldx #0

-

                lda map+2,x        
                sta SCREEN,x  
                lda map+2     + $100,x     
                sta SCREEN  + $100,x 
                lda map+2     + $200,x
                sta SCREEN  + $200,x 
                lda map+2     + $2e8,x
                sta SCREEN  + $2e8,x
                
                
                lda #$0c
                sta COLRAM,x  
                sta COLRAM  + $100,x
                sta COLRAM  + $200,x
                sta COLRAM  + $2e8,x
                inx                
                bne -    

                ; draw the colram for the checkerboard arrows

                lda #$01 ; color of the checkerboard arrows
                ldx #CONST_ARROWS
-
                dex
                sta 0*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 1*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 2*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 3*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 4*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 5*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 6*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 7*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 8*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 9*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 10*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 11*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 12*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 13*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 14*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 15*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 16*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 17*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 18*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                sta 19*40 + COLRAM + CONST_ARROW_X_POS_OFFSET + CONST_ARROW_Y_POS_OFFSET,x
                
                bne -

                rts



;==========================================================
; init all sprites
;==========================================================

init_sprites

                lda #%11111111
                sta $d015 ; enable sprites

                sta $d01d   ; sprite x strech

                lda #(sprites + 0*$40) / $40    
                sta SCREEN + $3f8  

                lda #(sprites + 1*$40) / $40   
                sta SCREEN + $3f9 

                lda #(sprites + 2*$40) / $40   
                sta SCREEN + $3fa 

                lda #(sprites + 0*$40) / $40   
                sta SCREEN + $3fb 

                lda #(sprites + 1*$40) / $40    
                sta SCREEN + $3fc  

                lda #(sprites + 2*$40) / $40   
                sta SCREEN + $3fd 


                lda #$01        ; sprite color
                sta $d027
                sta $d028
                sta $d029


                lda #$4         ; sprite shadow color
                sta $d02a
                sta $d02b
                sta $d02c


                lda #$36        ; sprite y pos
                sta $d001
                sta $d003
                sta $d005


                lda #$36
                sta $d007
                sta $d009
                sta $d00b
 

                CONST_SPRITE_X_OFFSET = 136

                ; sprite 0 
                lda #CONST_SPRITE_X_OFFSET    	
                sta $d000   ; x 
                sta $d006

                ; sprite 1 
                lda #CONST_SPRITE_X_OFFSET + 2*24  	
                sta $d002   ; x 
                sta $d008

                ; sprite 2 
                lda #CONST_SPRITE_X_OFFSET + 3*24   	
                sta $d004   ; x
                sta $d00a

                
                rts



;==========================================================
; move the logo
;==========================================================

var_logo_pos    !byte $00

move_logo
                ldx var_logo_pos
                lda sine_table,x
                cmp #255
                bne +
                    ldx #0
                    stx var_logo_pos
                    lda sine_table,x
                
+
                
                adc #66
                sta $d000   ; sprite 0 x 

                adc #24*2
                sta $d002   ; sprite 1 x 

                adc #24*2
                sta $d004   ; sprite 2 x

                lda sine_table2,x

                adc #66
                sta $d006   ; sprite 3 x

                adc #24*2
                sta $d008   ; sprite 4 x

                adc #24*2
                sta $d00a   ; sprite 5 x


                inc var_logo_pos
                rts


;==========================================================
; fade in
;==========================================================

var_fade_table_pos !byte $00

fade_in
-
                lda $d012
                cmp #40
                bne -

                ldx var_fade_table_pos
                lda fade_table,x
                cmp #255
                bne +
                    inc var_play_animation
                    rts

+
                sta $d020
                sta $d021
                inc var_fade_table_pos
                rts

;==========================================================
; fade out
;==========================================================

var_fade_out_table_pos !byte $00

fade_out

-
                lda $d012
                cmp #40
                bne -

                ldx var_fade_out_table_pos
                lda fade_out_table,x
                cmp #255
                bne +
                    inc var_play_animation
                    rts

+
                sta $d020
                sta $d021
                inc var_fade_out_table_pos
                rts

;==========================================================
; arrow character indexes
;==========================================================

!align 255,0

arr_0
!word 0*8 + charset,1*8 + charset,0*8 + charset,0*8 + charset
!word 1*8 + charset,25*8 + charset,25*8 + charset,25*8 + charset
!word 44*8 + charset,25*8 + charset,25*8 + charset,25*8 + charset
!word 0*8 + charset,44*8 + charset,0*8 + charset,0*8 + charset

; a1
arr_1
!word 2*8 + charset,3*8 + charset,4*8 + charset,0*8 + charset
!word 26*8 + charset,25*8 + charset,27*8 + charset,28*8 + charset
!word 45*8 + charset,25*8 + charset,25*8 + charset,46*8 + charset
!word 65*8 + charset,66*8 + charset,67*8 + charset,68*8 + charset

; a2
arr_2
!word 5*8 + charset,6*8 + charset,7*8 + charset,8*8 + charset
!word 29*8 + charset,25*8 + charset,30*8 + charset,31*8 + charset
!word 47*8 + charset,48*8 + charset,25*8 + charset,49*8 + charset
!word 69*8 + charset,70*8 + charset,71*8 + charset,72*8 + charset

; a3
arr_3
!word 9*8 + charset,10*8 + charset,11*8 + charset,12*8 + charset
!word 32*8 + charset,25*8 + charset,25*8 + charset,33*8 + charset
!word 50*8 + charset,51*8 + charset,25*8 + charset,52*8 + charset
!word 0*8 + charset,73*8 + charset,74*8 + charset,75*8 + charset

; a4
arr_4
!word 0*8 + charset,1*8 + charset,13*8 + charset,0*8 + charset
!word 1*8 + charset,25*8 + charset,25*8 + charset,13*8 + charset
!word 0*8 + charset,25*8 + charset,25*8 + charset,0*8 + charset
!word 0*8 + charset,25*8 + charset,25*8 + charset,0*8 + charset

; a5
arr_5
!word 2*8 + charset,14*8 + charset,15*8 + charset,16*8 + charset
!word 34*8 + charset,25*8 + charset,25*8 + charset,35*8 + charset
!word 53*8 + charset,25*8 + charset,54*8 + charset,55*8 + charset
!word 76*8 + charset,77*8 + charset,78*8 + charset,0*8 + charset

; a6
arr_6
!word 17*8 + charset,18*8 + charset,6*8 + charset,19*8 + charset
!word 36*8 + charset,37*8 + charset,25*8 + charset,38*8 + charset
!word 56*8 + charset,25*8 + charset,57*8 + charset,58*8 + charset
!word 79*8 + charset,80*8 + charset,81*8 + charset,82*8 + charset

; a7
arr_7
!word 0*8 + charset,20*8 + charset,21*8 + charset,12*8 + charset
!word 39*8 + charset,40*8 + charset,25*8 + charset,41*8 + charset
!word 59*8 + charset,25*8 + charset,25*8 + charset,60*8 + charset
!word 83*8 + charset,84*8 + charset,85*8 + charset,86*8 + charset

; a8
arr_8
!word 0*8 + charset,0*8 + charset,13*8 + charset,0*8 + charset
!word 25*8 + charset,25*8 + charset,25*8 + charset,13*8 + charset
!word 25*8 + charset,25*8 + charset,25*8 + charset,61*8 + charset
!word 0*8 + charset,0*8 + charset,61*8 + charset,0*8 + charset

; a9
arr_9
!word 22*8 + charset,23*8 + charset,24*8 + charset,16*8 + charset
!word 42*8 + charset,25*8 + charset,25*8 + charset,43*8 + charset
!word 62*8 + charset,63*8 + charset,25*8 + charset,64*8 + charset
!word 0*8 + charset,87*8 + charset,88*8 + charset,89*8 + charset

; a10
arr_10
!word 90*8 + charset,49*8 + charset,31*8 + charset,91*8 + charset
!word 71*8 + charset,25*8 + charset,103*8 + charset,104*8 + charset
!word 70*8 + charset,115*8 + charset,25*8 + charset,38*8 + charset
!word 124*8 + charset,125*8 + charset,126*8 + charset,127*8 + charset

; a11
arr_11
!word 92*8 + charset,93*8 + charset,94*8 + charset,0*8 + charset
!word 105*8 + charset,25*8 + charset,106*8 + charset,107*8 + charset
!word 116*8 + charset,25*8 + charset,25*8 + charset,117*8 + charset
!word 128*8 + charset,129*8 + charset,130*8 + charset,86*8 + charset

; a12
arr_12
!word 0*8 + charset,25*8 + charset,25*8 + charset,0*8 + charset
!word 0*8 + charset,25*8 + charset,25*8 + charset,0*8 + charset
!word 44*8 + charset,25*8 + charset,25*8 + charset,61*8 + charset
!word 0*8 + charset,44*8 + charset,61*8 + charset,0*8 + charset

; a13
arr_13
!word 0*8 + charset,95*8 + charset,96*8 + charset,97*8 + charset
!word 108*8 + charset,109*8 + charset,25*8 + charset,110*8 + charset
!word 118*8 + charset,25*8 + charset,25*8 + charset,119*8 + charset
!word 65*8 + charset,131*8 + charset,132*8 + charset,89*8 + charset

; a14
arr_14
!word 98*8 + charset,36*8 + charset,56*8 + charset,99*8 + charset
!word 111*8 + charset,112*8 + charset,25*8 + charset,80*8 + charset
!word 29*8 + charset,25*8 + charset,120*8 + charset,81*8 + charset
!word 133*8 + charset,126*8 + charset,134*8 + charset,135*8 + charset

; a15
arr_15
!word 9*8 + charset,100*8 + charset,101*8 + charset,102*8 + charset
!word 113*8 + charset,25*8 + charset,25*8 + charset,114*8 + charset
!word 121*8 + charset,25*8 + charset,122*8 + charset,123*8 + charset
!word 128*8 + charset,136*8 + charset,137*8 + charset,0*8 + charset

!align 255,0

chars1_1
!byte 240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243;,240,241,242,243,240,241,242,243
chars1_2
!byte 244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247;,244,245,246,247,244,245,246,247
chars1_3
!byte 248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251;,248,249,250,251,248,249,250,251
chars1_4
!byte 252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255;,252,253,254,255,252,253,254,255


chars2_1
!byte 250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249,250,251,248,249;,250,251,248,249,250,251,248,249
chars2_2
!byte 254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253,254,255,252,253;,254,255,252,253,254,255,252,253
chars2_3
!byte 242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241,242,243,240,241;,242,243,240,241,242,243,240,241
chars2_4
!byte 246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245,246,247,244,245;,246,247,244,245,246,247,244,245


sine_table
!byte 55,59,62,65,68,71,73,75,77,78,79,80,80,80,79,78,77,75,73,71,68,65,62,59,55,52,48,44,40,36,32,28,25,21,18,15,12,9,7,5,3,2,1,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28,32,36,40,44,48,52,255

sine_table2
!byte 40,44,48,52,55,59,62,65,68,71,73,75,77,78,79,80,80,80,79,78,77,75,73,71,68,65,62,59,55,52,48,44,40,36,32,28,25,21,18,15,12,9,7,5,3,2,1,0,0,0,1,2,3,5,7,9,12,15,18,21,25,28,32,36,255


fade_table
!byte $00
!byte $00
!byte $00
!byte $0b
!byte $0c
!byte $0f
!byte $01
!byte $0f
!byte $0b
!byte $ff


fade_out_table
!byte $0c
!byte $0f
!byte $01
!byte $0f
!byte $0c
!byte $0b
!byte $00, $ff







