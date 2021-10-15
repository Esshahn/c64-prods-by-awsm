
  ; the sprite pointer for Sprite#0
  p0		= (SP_ADDR + 0*$40) / $40
  p1		= (SP_ADDR + 1*$40) / $40
  p2		= (SP_ADDR + 2*$40) / $40
  p3		= (SP_ADDR + 3*$40) / $40
  p4		= (SP_ADDR + 4*$40) / $40
  p5		= (SP_ADDR + 5*$40) / $40
  p6		= (SP_ADDR + 6*$40) / $40
  p7		= (SP_ADDR + 7*$40) / $40
  p8		= (SP_ADDR + 8*$40) / $40
  p9		= (SP_ADDR + 9*$40) / $40
  p10		= (SP_ADDR + 10*$40) / $40
  p11		= (SP_ADDR + 11*$40) / $40
  p12		= (SP_ADDR + 12*$40) / $40
  p13		= (SP_ADDR + 13*$40) / $40
  p14		= (SP_ADDR + 14*$40) / $40
  p15		= (SP_ADDR + 15*$40) / $40
  p16		= (SP_ADDR + 16*$40) / $40
  p17		= (SP_ADDR + 17*$40) / $40
  p18		= (SP_ADDR + 18*$40) / $40
  p19		= (SP_ADDR + 19*$40) / $40
  p20		= (SP_ADDR + 20*$40) / $40
  p21		= (SP_ADDR + 21*$40) / $40
  p22		= (SP_ADDR + 22*$40) / $40
  p23		= (SP_ADDR + 23*$40) / $40
  p24		= (SP_ADDR + 24*$40) / $40

  s0		= (SP_SCROLLER_ADDR + 0*$40) / $40
  s1		= (SP_SCROLLER_ADDR + 1*$40) / $40
  s2		= (SP_SCROLLER_ADDR + 2*$40) / $40
  s3		= (SP_SCROLLER_ADDR + 3*$40) / $40
  s4		= (SP_SCROLLER_ADDR + 4*$40) / $40
  s5		= (SP_SCROLLER_ADDR + 5*$40) / $40
  s6		= (SP_SCROLLER_ADDR + 6*$40) / $40
  s7		= (SP_SCROLLER_ADDR + 7*$40) / $40

scroll:
!byte s0,s1, s2, s3, s4, s5, s6

dino_1:
!byte p0,p1
!byte p8,p9,p10
!byte p17,p18,p19

dino_2:
!byte p0,p2
!byte p8,p9,p10
!byte p17,p18,p19

dino_3:
!byte p0,p3
!byte p8,p9,p10
!byte p17,p18,p19

dino_4:
!byte p4,p5
!byte p11,p12,p13
!byte p17,p20,p21

dino_5:
!byte p6,p7
!byte p14,p15,p16
!byte p22,p23,p24

; 1 = eye normal, mouth closed
; 2 = eye right, mouth closed
; 3 = eye closed, body up
; 4 = eye closed, body down
; 5 = eye normal, mouth open
dino_animation  
!byte 3,3,3,3,3,3,3,3  
!byte 3,3,3,3,3,3,3,3    
!byte 1,1,1,2,2,1,1,1
!byte 3,3,3,3,3,3,3,3     
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 3,4,3,4,3,4,3,4
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte 1,5,1,5,1,5,1,5
!byte $ff

dino_animation_table_pos
!byte 0

;==========================================================
; dino animation
;==========================================================

animate_dino:
              ldy dino_animation_table_pos
              lda dino_animation,y
+
              cmp #1
              bne +
                jsr set_dino_1
                jmp exit
+             cmp #2
              bne +
                jsr set_dino_2
                jmp exit
+             cmp #3
              bne +
                jsr set_dino_3
                jmp exit
+             cmp #4
              bne +
                jsr set_dino_4
                jmp exit
+             cmp #5
              bne +
                jsr set_dino_5
                jmp exit

+             cmp #$ff
              bne exit
                lda #0
                sta dino_animation_table_pos
                jmp animate_dino

exit:              
              
              rts

;==========================================================
; copies each of the eight sprites to each of the screens we cycle through
;==========================================================

copy_sprites_to_every_screenram:

              lda SCRRAM + $3f8 
              sta SCRRAM + $3f8 + 1 * $400 
              sta SCRRAM + $3f8 + 2 * $400
              sta SCRRAM + $3f8 + 3 * $400 
              sta SCRRAM + $3f8 + 4 * $400 
              sta SCRRAM + $3f8 + 5 * $400

              lda SCRRAM + $3f9 
              sta SCRRAM + $3f9 + 1 * $400
              sta SCRRAM + $3f9 + 2 * $400
              sta SCRRAM + $3f9 + 3 * $400
              sta SCRRAM + $3f9 + 4 * $400
              sta SCRRAM + $3f9 + 5 * $400

              lda SCRRAM + $3fa 
              sta SCRRAM + $3fa + 1 * $400
              sta SCRRAM + $3fa + 2 * $400
              sta SCRRAM + $3fa + 3 * $400
              sta SCRRAM + $3fa + 4 * $400
              sta SCRRAM + $3fa + 5 * $400

              lda SCRRAM + $3fb 
              sta SCRRAM + $3fb + 1 * $400
              sta SCRRAM + $3fb + 2 * $400
              sta SCRRAM + $3fb + 3 * $400
              sta SCRRAM + $3fb + 4 * $400
              sta SCRRAM + $3fb + 5 * $400

              lda SCRRAM + $3fc 
              sta SCRRAM + $3fc + 1 * $400
              sta SCRRAM + $3fc + 2 * $400
              sta SCRRAM + $3fc + 3 * $400
              sta SCRRAM + $3fc + 4 * $400
              sta SCRRAM + $3fc + 5 * $400

              lda SCRRAM + $3fd 
              sta SCRRAM + $3fd + 1 * $400
              sta SCRRAM + $3fd + 2 * $400
              sta SCRRAM + $3fd + 3 * $400
              sta SCRRAM + $3fd + 4 * $400
              sta SCRRAM + $3fd + 5 * $400

              lda SCRRAM + $3fe 
              sta SCRRAM + $3fe + 1 * $400
              sta SCRRAM + $3fe + 2 * $400
              sta SCRRAM + $3fe + 3 * $400
              sta SCRRAM + $3fe + 4 * $400
              sta SCRRAM + $3fe + 5 * $400

              lda SCRRAM + $3ff 
              sta SCRRAM + $3ff + 1 * $400
              sta SCRRAM + $3ff + 2 * $400
              sta SCRRAM + $3ff + 3 * $400
              sta SCRRAM + $3ff + 4 * $400
              sta SCRRAM + $3ff + 5 * $400

              rts


;==========================================================
; sets the sprite by referencing the sprite table address with x and y
;==========================================================

set_sprites:
              stx set_register + 2
              sty set_register + 1
              ldy #7

set_register: lda $1000,y                 ; selmod
              sta SCRRAM + $3f8,y
              dey
              bpl set_register
              jsr copy_sprites_to_every_screenram
              rts


;==========================================================
; set dino 1
;==========================================================


set_dino_1:
              ldx #>dino_1
              ldy #<dino_1
              lda #$1             ; eye color ( 1 or b )
              sta $d028
              jsr set_sprites
              rts

set_dino_2:
              ldx #>dino_2
              ldy #<dino_2
              lda #$1             ; eye color ( 1 or b )
              sta $d028
              jsr set_sprites
              rts

set_dino_3:
              ldx #>dino_3
              ldy #<dino_3
              lda #$b             ; eye color ( 1 or b )
              sta $d028
              jsr set_sprites
              rts

set_dino_4:
              ldx #>dino_4
              ldy #<dino_4
              lda #$b             ; eye color ( 1 or b )
              sta $d028
              jsr set_sprites
              rts

set_dino_5:
              ldx #>dino_5
              ldy #<dino_5
              lda #$1             ; eye color ( 1 or b )
              sta $d028
              jsr set_sprites
              rts

;==========================================================
; initial sprite setup for the dino
;==========================================================

init_sprites:

              ;============================================================
              ; Initialize involved VIC-II registers
              ;============================================================

              lda #%11111111      ; applies to all eight sprites
              ;sta $d015           ; enable sprites 
              sta $d01c           ; set multicolor mode for sprites	 
              sta $d01d           ; x  stretch		
              sta $d017           ; y stretch 

              rts



set_dino_sprites:

              XBASE = 140
              YBASE = 124

              lda #%11111111
              sta $d01c           ; set multicolor mode for sprites	 
                           

              lda #%00000000	; set X pos > FF to true for all sprites
              sta $d010		; so that the sprites appear far right

              ; -------------------
              ; color for all multicolor sprites
              ; -------------------

              lda #$00
              sta $d025	; sprite multicolor 1
              lda #$05
              sta $d026	; sprite multicolor 2

              ; -------------------
              ; individual colors
              ; -------------------

              lda #$0b 	; sprite color 0
              sta $d027
              sta $d029
              sta $d02a
              
              sta $d02c
              sta $d02d
              sta $d02e

              lda #$01
              sta $d028
              sta $d02b

              ;============================================================
              ; row 1
              ;============================================================

              ; sprite 0
              lda #XBASE  + 0 * 48	+ 28
              sta $d000   ; X
              lda #YBASE  + 0 * 42
              sta $d001   ; Y

              ; sprite 1
              lda #XBASE 	+ 1 * 48 + 28
              sta $d002   ; X
              lda #YBASE  + 0 * 42
              sta $d003   ; Y              

              ;============================================================
              ; row 2
              ;============================================================

              ; sprite 2
              lda #XBASE 	+ 0 * 48
              sta $d004   ; X
              lda #YBASE  + 1 * 42
              sta $d005   ; Y

              ; sprite 3
              lda #XBASE 	+ 1 * 48
              sta $d006   ; X
              lda #YBASE  + 1 * 42
              sta $d007   ; Y

              ; sprite 4
              lda #XBASE 	+ 2 * 48
              sta $d008   ; X
              lda #YBASE  + 1 * 42
              sta $d009   ; Y

              ;============================================================
              ; row 3
              ;============================================================

              ; sprite 5
              lda #XBASE 	+ 0 * 48
              sta $d00a   ; X
              lda #YBASE  + 2 * 42
              sta $d00b   ; Y

              ; sprite 6
              lda #XBASE 	+ 1 * 48
              sta $d00c   ; X
              lda #YBASE  + 2 * 42
              sta $d00d   ; Y

              ; sprite 7
              lda #XBASE 	+ 2 * 48
              sta $d00e   ; X
              lda #YBASE  + 2 * 42
              sta $d00f   ; Y

              rts