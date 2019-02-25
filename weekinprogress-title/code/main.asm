
;==========================================================
; LABELS
; Comment or uncomment the lines below 
; Depending on your target machine
;==========================================================


; C64
BGCOLOR       = $d020
BORDERCOLOR   = $d021
BASIC         = $0801
SCREEN        = $0400
COLRAM        = $d800

* = $2000
sprites
!bin "sources/wip-01-sprites.spd",7*64,3

* = $2800
map
!bin "sources/wip-01-map.bin" 

* = $3800
!bin "sources/wip-01-charset.bin"

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

                lda #$00                ; the color value
                sta BGCOLOR             ; change background color
                sta BORDERCOLOR         ; change border color 
                jsr clear

                ; initialize the custom font
                lda $d018
                ora #$0e                ; #$0e
                sta $d018

                jsr display_screen
                
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

                lda #$00    ; trigger interrupt at row zero
                sta $d012

                cli         ; clear interrupt disable flag
                jmp *       ; infinite loop

;==========================================================
; IRQ
;==========================================================

var_play_animation !byte $00

irq        
			    dec $d019
                
                lda var_play_animation

                cmp #0
                bne +
                    jsr border_blink
                    jmp end_irq
+               
               
                cmp #1
                bne +
                    jsr init_sprites
                    inc var_play_animation
                    jmp end_irq
+               

                cmp #2
                bne +
                    jsr blink_myd
                    jmp end_irq
+ 

                cmp #3
                bne +
                    jsr move_day
                    jmp end_irq

+               
                
                cmp #4
                bne +
                    jsr blink_myd_aus
                    jmp end_irq

+               
                
                cmp #5
                bne +
                    jsr fade_out
                    jmp end_irq

+               
                
                cmp #6
                bne +
                    
                    jmp *           ; HIER KOMMT DER SPRUNG ZUM NAECHSTEN PART!!

+ 
end_irq
                jmp $ea31      ; return to Kernel routine

;==========================================================
; init all sprites
;==========================================================

init_sprites

                lda #%11111111
                sta $d015 ; enable all sprites

                lda #%000001
                sta $d017       ; double height sprites
                lda #%000001
                sta $d01d       ; double width sprites

                lda #(sprites + 0*$40) / $40    ; sprite 0 week day
                sta SCREEN + $3fe  

                lda #(sprites + 6*$40) / $40    ; sprite 1 black bar
                sta SCREEN + $3f8  

                ; sprite 0 - week day
                lda #$24    	
                sta $d00c   ; x 
                lda #$60    
                sta $d00d   ; y
                lda #$01
                sta $d02d   ; color

                ; sprite 1 - black bar
                lda #$24    	
                sta $d000   ; x 
                lda #$7a    
                sta $d001   ; y
                lda #$00
                sta $d027   ; color
                
                rts

;==========================================================
; move the sprites
;==========================================================

var_wait        !byte $01           ; animation wait counter
var_wait_delay  !byte $02

move_day
                dec var_wait        ; decrease wait time counter
                lda var_wait 
                cmp #0              ; reached 0?
                beq move_x          ; then move sprites
                rts

move_x
                lda $d00c

                ; char colors

                cmp #$24
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 3
                    stx COLRAM + 10*40 + 3
                    stx COLRAM + 11*40 + 3
                    stx COLRAM + 12*40 + 3
                    stx COLRAM + 9*40 + 4
                    stx COLRAM + 10*40 + 4
                    stx COLRAM + 11*40 + 4
                    stx COLRAM + 12*40 + 4
                    stx COLRAM + 9*40 + 5
                    stx COLRAM + 10*40 + 5
                    stx COLRAM + 11*40 + 5
                    stx COLRAM + 12*40 + 5
                    stx COLRAM + 9*40 + 6
                    stx COLRAM + 10*40 + 6
                    stx COLRAM + 11*40 + 6
                    stx COLRAM + 12*40 + 6
+
                cmp #$24 + 4*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 7
                    stx COLRAM + 10*40 + 7
                    stx COLRAM + 11*40 + 7
                    stx COLRAM + 12*40 + 7
                    stx COLRAM + 9*40 + 8
                    stx COLRAM + 10*40 + 8
                    stx COLRAM + 11*40 + 8
                    stx COLRAM + 12*40 + 8
                    stx COLRAM + 9*40 + 9
                    stx COLRAM + 10*40 + 9
                    stx COLRAM + 11*40 + 9
                    stx COLRAM + 12*40 + 9
                    stx COLRAM + 9*40 + 10
                    stx COLRAM + 10*40 + 10
                    stx COLRAM + 11*40 + 10
                    stx COLRAM + 12*40 + 10

+
                cmp #$24 + 8*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 11
                    stx COLRAM + 10*40 + 11
                    stx COLRAM + 11*40 + 11
                    stx COLRAM + 12*40 + 11
                    stx COLRAM + 9*40 + 12
                    stx COLRAM + 10*40 + 12
                    stx COLRAM + 11*40 + 12
                    stx COLRAM + 12*40 + 12
                    stx COLRAM + 9*40 + 13
                    stx COLRAM + 10*40 + 13
                    stx COLRAM + 11*40 + 13
                    stx COLRAM + 12*40 + 13
                    stx COLRAM + 9*40 + 14
                    stx COLRAM + 10*40 + 14
                    stx COLRAM + 11*40 + 14
                    stx COLRAM + 12*40 + 14

+
                cmp #$24 + 12*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 15
                    stx COLRAM + 10*40 + 15
                    stx COLRAM + 11*40 + 15
                    stx COLRAM + 12*40 + 15
                    stx COLRAM + 9*40 + 16
                    stx COLRAM + 10*40 + 16
                    stx COLRAM + 11*40 + 16
                    stx COLRAM + 12*40 + 16
                    stx COLRAM + 9*40 + 17
                    stx COLRAM + 10*40 + 17
                    stx COLRAM + 11*40 + 17
                    stx COLRAM + 12*40 + 17
                    stx COLRAM + 9*40 + 18
                    stx COLRAM + 10*40 + 18
                    stx COLRAM + 11*40 + 18
                    stx COLRAM + 12*40 + 18

+
                cmp #$24 + 16*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 19
                    stx COLRAM + 10*40 + 19
                    stx COLRAM + 11*40 + 19
                    stx COLRAM + 12*40 + 19
                    stx COLRAM + 9*40 + 20
                    stx COLRAM + 10*40 + 20
                    stx COLRAM + 11*40 + 20
                    stx COLRAM + 12*40 + 20
                    stx COLRAM + 9*40 + 21
                    stx COLRAM + 10*40 + 21
                    stx COLRAM + 11*40 + 21
                    stx COLRAM + 12*40 + 21
                    stx COLRAM + 9*40 + 22
                    stx COLRAM + 10*40 + 22
                    stx COLRAM + 11*40 + 22
                    stx COLRAM + 12*40 + 22

+
                cmp #$24 + 20*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 23
                    stx COLRAM + 10*40 + 23
                    stx COLRAM + 11*40 + 23
                    stx COLRAM + 12*40 + 23
                    stx COLRAM + 9*40 + 24
                    stx COLRAM + 10*40 + 24
                    stx COLRAM + 11*40 + 24
                    stx COLRAM + 12*40 + 24
                    stx COLRAM + 9*40 + 25
                    stx COLRAM + 10*40 + 25
                    stx COLRAM + 11*40 + 25
                    stx COLRAM + 12*40 + 25
                    stx COLRAM + 9*40 + 26
                    stx COLRAM + 10*40 + 26
                    stx COLRAM + 11*40 + 26
                    stx COLRAM + 12*40 + 26
                    

+
                cmp #$24 + 24*8
                bne +
                    ldx #$01
                    stx COLRAM + 9*40 + 27
                    stx COLRAM + 10*40 + 27
                    stx COLRAM + 11*40 + 27
                    stx COLRAM + 12*40 + 27
                    stx COLRAM + 9*40 + 28
                    stx COLRAM + 10*40 + 28
                    stx COLRAM + 11*40 + 28
                    stx COLRAM + 12*40 + 28
                    stx COLRAM + 9*40 + 29
                    stx COLRAM + 10*40 + 29
                    stx COLRAM + 11*40 + 29
                    stx COLRAM + 12*40 + 29
                    stx COLRAM + 9*40 + 30
                    stx COLRAM + 10*40 + 30
                    stx COLRAM + 11*40 + 30
                    stx COLRAM + 12*40 + 30
                    

+

                ; sprites
                cmp #$24 + $2b * 1
                bne +
                    ldx #(sprites + 1*$40) / $40
                    stx SCREEN + $3fe
              
+
                cmp #$24 + $2b * 2
                bne +
                    ldx #(sprites + 2*$40) / $40
                    stx SCREEN + $3fe 
                     
+
                cmp #$24 + $2b * 3
                bne +
                    ldx #(sprites + 3*$40) / $40
                    stx SCREEN + $3fe
               
+
                cmp #$24 + $2b * 4
                bne +
                    ldx #(sprites + 4*$40) / $40
                    stx SCREEN + $3fe
                    
+
                cmp #$24 + $2b * 5
                bne +
                    ldx #(sprites + 5*$40) / $40
                    stx SCREEN + $3fe 
                    
                          
+               
                cmp #$ff
                bne set_x 
                    inc var_play_animation
                    jmp end
set_x                  
                inc $d00c ; sprite 0 - week day, x pos
                inc $d000 ; sprite black bar
end
                
                lda var_wait_delay
                sta var_wait
                rts

;==========================================================
; display the characters on screen
;==========================================================

display_screen

 
                ldx #0

-

                lda map,x        
                sta SCREEN,x  
                lda map     + $100,x     
                sta SCREEN  + $100,x 
                lda map     + $200,x
                sta SCREEN  + $200,x 
                lda map     + $2e8,x
                sta SCREEN  + $2e8,x
                lda #0
                sta COLRAM,x  
                sta COLRAM  + $100,x
                sta COLRAM  + $200,x
                sta COLRAM  + $2e8,x
                inx                
                bne -    
            
                rts
;==========================================================
; clear screen
;==========================================================

clear

                ldx #0

-

                lda #$ff        
                sta SCREEN,x       
                sta SCREEN + $100,x 
                sta SCREEN + $200,x 
                sta SCREEN + $2e8,x
                lda #0
                sta COLRAM,x  
                sta COLRAM + $100,x
                sta COLRAM + $200,x
                sta COLRAM + $2e8,x
                inx                
                bne -     
                                  
                rts 

;==========================================================
; display border
;==========================================================

var_blink_pos  !byte $00 ; the index position in the table

border_blink

                ldx var_blink_pos
                lda blink_delay,x 

                cmp #$ff                        ; end of animation table? then advance to next part
                bne + 
                    inc var_play_animation
                    rts 
+                   
                cmp #0
                bne +
                    inc var_blink_pos
                    rts

+
                tay
                dey 
                tya 
                sta blink_delay,x

                lda blink_color,x

                ldx #35
-            
                sta COLRAM + 8*40 + 1,x 
                sta COLRAM + 13*40 + 1,x
                dex
                bne - 
                sta COLRAM + 9*40  +2
                sta COLRAM + 10*40 +2
                sta COLRAM + 11*40 +2 
                sta COLRAM + 12*40 +2
                sta COLRAM + 9*40  +36
                sta COLRAM + 10*40 +36
                sta COLRAM + 11*40 +36
                sta COLRAM + 12*40 +36
               
                rts



blink_delay
!byte 080, 002, 026, 002, 022, 002, 018, 002, 014, 002, 010, 002, 006, 002, 002, 002, 001, 002, 001, 020, $ff

blink_color
!byte $00, $0b, $00, $0b, $00, $0c, $00, $0c, $00, $0f, $00, $0f, $00, $01, $00, $07, $00, $01, $00, $01

;==========================================================
; blink myd
;==========================================================

var_blink_myd_pos  !byte $00 ; the index position in the table

blink_myd

                ldx var_blink_myd_pos
                lda blink_myd_delay,x 

                cmp #$ff                        ; end of animation table? then advance to next part
                bne + 
                    inc var_play_animation
                    rts 
+                   
                cmp #0
                bne +
                    inc var_blink_myd_pos
                    rts

+
                tay
                dey 
                tya 
                sta blink_myd_delay,x

                lda blink_myd_color,x

                sta $d02d ; sprite color
               
                rts



blink_myd_delay
!byte 010, 002, 006, 002, 002, 002, 001, 002, 001, 020, $ff

blink_myd_color
!byte $00, $0f, $00, $01, $00, $07, $00, $01, $00, $01

;==========================================================
; blink myd aus
;==========================================================

var_blink_myd_aus_pos  !byte $00 ; the index position in the table

blink_myd_aus

                ldx var_blink_myd_aus_pos
                lda blink_myd_aus_delay,x 

                cmp #$ff                        ; end of animation table? then advance to next part
                bne + 
                    inc var_play_animation
                    rts 
+                   
                cmp #0
                bne +
                    inc var_blink_myd_aus_pos
                    rts

+
                tay
                dey 
                tya 
                sta blink_myd_aus_delay,x

                lda blink_myd_aus_color,x

                sta $d02d ; sprite color
               
                rts



blink_myd_aus_delay
!byte 020, 001, 002, 001, 002, 002, 002, 006, 002, 010, $ff

blink_myd_aus_color
!byte $01, $00, $01, $00, $07, $00, $01, $00, $0f, $00


;==========================================================
; fade out
;==========================================================

var_fade_delay  !byte 80
var_fade_pos    !byte 0

fade_out

                lda var_fade_delay
                cmp #0
                beq +
                    dec var_fade_delay
                    rts
+
                
                lda #1
                sta var_fade_delay

                ldx var_fade_pos
                cpx #40
                bne +
                    inc var_play_animation
                    rts
+        
                lda #3
                sta COLRAM + 8*40 + 2,x
                sta COLRAM + 9*40 + 2,x
                sta COLRAM + 10*40 + 2,x
                sta COLRAM + 11*40 + 2,x
                sta COLRAM + 12*40 + 2,x 
                sta COLRAM + 13*40 + 2,x

                lda #4
                sta COLRAM + 8*40 + 1,x
                sta COLRAM + 9*40 + 1,x
                sta COLRAM + 10*40 + 1,x
                sta COLRAM + 11*40 + 1,x
                sta COLRAM + 12*40 + 1,x 
                sta COLRAM + 13*40 + 1,x

                lda #6
                sta COLRAM + 8*40 + 0,x
                sta COLRAM + 9*40 + 0,x
                sta COLRAM + 10*40 + 0,x
                sta COLRAM + 11*40 + 0,x
                sta COLRAM + 12*40 + 0,x 
                sta COLRAM + 13*40 + 0,x

                lda #0
                sta COLRAM + 8*40 -1 ,x
                sta COLRAM + 9*40 -1,x
                sta COLRAM + 10*40 -1,x
                sta COLRAM + 11*40 -1,x
                sta COLRAM + 12*40 -1,x 
                sta COLRAM + 13*40 -1,x

                inc var_fade_pos 

               
                rts
                
