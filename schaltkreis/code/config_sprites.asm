;============================================================
; configuration of the sprite used in the intro
;============================================================


; the sprite pointer for Sprite#0
sprite_pointer_1		= (address_sprites + 0*$40) / $40
sprite_pointer_2		= (address_sprites + 1*$40) / $40
sprite_pointer_3		= (address_sprites + 2*$40) / $40
sprite_pointer_8		= (address_sprites + 7*$40) / $40

; store the pointer in the sprite pointer register for Sprite#0
; Sprite Pointers are the last 8 bytes of Screen RAM, e.g. $07f8-$07ff
lda #sprite_pointer_1
sta screen_ram + $3f8 	

lda #sprite_pointer_2
sta screen_ram + $3f9 

lda #sprite_pointer_3
sta screen_ram + $3fa 

lda #sprite_pointer_8
sta screen_ram + $3ff

;============================================================
; Initialize involved VIC-II registers
;============================================================

lda #%11111111     ; enable sprites
sta $d015 

lda #%00000111     ; set multicolor mode for sprites
sta $d01c

lda #%00000000		; x  stretch 
sta $d01d
lda #%00000111		; y stretch 
sta $d017


; -------------------
; color for all multicolor sprites
; -------------------

lda #$00
sta $d025	; sprite multicolor 1
lda #$00
sta $d026	; sprite multicolor 2

; -------------------
; individual colors
; -------------------


lda #$0c 	; sprite color 0
sta $d027

lda #$0c	; sprite color 1
sta $d028

lda #$0c	; sprite color 2
sta $d029

lda #$00	; music by ed logo goes dark grey
sta $d02e

; sprite 0
lda #$93 	; set Sprite#0 positions with X/Y coords to
sta $d000   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d001   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 1
lda #$93 	; set Sprite#0 positions with X/Y coords to
sta $d002   ; lower right of the screen
lda #$11    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d003   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 2
lda #$3b 	; set Sprite#0 positions with X/Y coords to
sta $d004   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d005   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 8
lda #$ff 	; set Sprite#0 positions with X/Y coords to
sta $d00e   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d00f   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)
