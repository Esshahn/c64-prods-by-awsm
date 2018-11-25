;============================================================
; configuration of the sprite used in the intro
;============================================================


sprite_pointer_1		= (address_sprites + 0*$40) / $40
sprite_pointer_2		= (address_sprites + 1*$40) / $40
sprite_pointer_3		= (address_sprites + 2*$40) / $40

lda #sprite_pointer_1
sta screen_ram + $3f8 	

lda #sprite_pointer_2
sta screen_ram + $3f9 

lda #sprite_pointer_3
sta screen_ram + $3fa 


;============================================================
; Initialize involved VIC-II registers
;============================================================

lda #%00000111     ; enable sprites
sta $d015 

lda #%00000101     ; set multicolor mode for sprites
sta $d01c

lda #%00000010		; x  stretch 
sta $d01d
lda #%00000000		; y stretch 
sta $d017


; -------------------
; color for all multicolor sprites
; -------------------

lda #$07
sta $d025	; sprite multicolor 1
lda #$02
sta $d026	; sprite multicolor 2

; -------------------
; individual colors
; -------------------


lda #$0a 	; sprite color 0
sta $d027

lda #$0c	; sprite color 1
sta $d028

lda #$00	; sprite color 2
sta $d029

; sprite 0
lda #$8e 	; set Sprite#0 positions with X/Y coords to
sta $d000   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d001   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 1
lda #$64 	; set Sprite#0 positions with X/Y coords to
sta $d002   ; lower right of the screen
lda #$1e    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d003   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 2
lda #$a2 	; set Sprite#0 positions with X/Y coords to
sta $d004   ; lower right of the screen
lda #$f9    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d005   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

