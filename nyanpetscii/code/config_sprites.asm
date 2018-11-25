;============================================================
; configuration of the sprite used in the intro
;============================================================


; the sprite pointer for Sprite#0
sprite_pointer_1		= (address_sprites + 0*$40) / $40
sprite_pointer_2		= (address_sprites + 1*$40) / $40
sprite_pointer_3		= (address_sprites + 2*$40) / $40
sprite_pointer_4		= (address_sprites + 3*$40) / $40
sprite_pointer_5		= (address_sprites + 4*$40) / $40
sprite_pointer_6		= (address_sprites + 5*$40) / $40
sprite_pointer_7		= (address_sprites + 6*$40) / $40
sprite_pointer_8		= (address_sprites + 7*$40) / $40

; store the pointer in the sprite pointer register for Sprite#0
; Sprite Pointers are the last 8 bytes of Screen RAM, e.g. $07f8-$07ff
lda #sprite_pointer_6
sta screen_ram + $3f8 	

lda #sprite_pointer_7
sta screen_ram + $3f9 

lda #sprite_pointer_8
sta screen_ram + $3fa 

lda #sprite_pointer_1
sta screen_ram + $3fb 

lda #sprite_pointer_2
sta screen_ram + $3fc 	

lda #sprite_pointer_3
sta screen_ram + $3fd 

lda #sprite_pointer_4
sta screen_ram + $3fe 

lda #sprite_pointer_5
sta screen_ram + $3ff 


;============================================================
; Initialize involved VIC-II registers
;============================================================

lda #%11111111     ; enable sprites
sta $d015 

lda #%00000111     ; set multicolor mode for sprites
sta $d01c

lda #%00000011		; x  stretch 
sta $d01d
lda #%00000111		; y stretch 
sta $d017


; -------------------
; color for all multicolor sprites
; -------------------

lda #$02
sta $d025	; sprite multicolor 1
lda #$05
sta $d026	; sprite multicolor 2

; -------------------
; individual colors
; -------------------


lda #$09 	; sprite color 0
sta $d027

lda #$08	; sprite color 1
sta $d028

lda #$06	; sprite color 2
sta $d029

lda #$08	; sprite color 3
sta $d02a

lda #$0a	; sprite color 4
sta $d02b

lda #$07	; sprite color 5
sta $d02c

lda #$0d	; sprite color 6
sta $d02d

lda #$0e	; sprite color 7
sta $d02e

; sprite 0
lda #$80 	; set Sprite#0 positions with X/Y coords to
sta $d000   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d001   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 1
lda #$b0 	; set Sprite#0 positions with X/Y coords to
sta $d002   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d003   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 2
lda #$e0 	; set Sprite#0 positions with X/Y coords to
sta $d004   ; lower right of the screen
lda #$fa    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d005   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 3
lda #$80 	; set Sprite#0 positions with X/Y coords to
sta $d006   ; lower right of the screen
lda #$1d    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d007   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 4
lda #$98 	; set Sprite#0 positions with X/Y coords to
sta $d008   ; lower right of the screen
lda #$1d    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d009   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 5
lda #$b0 	; set Sprite#0 positions with X/Y coords to
sta $d00a   ; lower right of the screen
lda #$1d    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d00b   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 6
lda #$c8 	; set Sprite#0 positions with X/Y coords to
sta $d00c   ; lower right of the screen
lda #$1d    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d00d   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)

; sprite 7
lda #$e0 	; set Sprite#0 positions with X/Y coords to
sta $d00e   ; lower right of the screen
lda #$1d    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
sta $d00f   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)


