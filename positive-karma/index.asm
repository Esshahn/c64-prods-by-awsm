;============================================================
;    specify output file
;============================================================

!cpu 6502
!to "build/awsm-karma.prg",cbm    ; output file

;============================================================
; BASIC loader with start address $c000
;============================================================

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

;============================================================
;    symbols
;============================================================

address_music 	= $1000 ; loading address for sid tune
sid_init 		= $1000      ; init routine for music
sid_play 		= $1003      ; play music routine
black 			= $00
white 			= $01
cyan 		   	= $03
purple 			= $04
yellow 			= $07
orange 			= $08
light_red   = $0a

PICTURE 		= $6000
PIC_ADD     = $4000
SPR_ADD     = $4000

colors
         !byte white,cyan,cyan,cyan,cyan,cyan,cyan,cyan,cyan,cyan,black,black
         !byte white,yellow,yellow,yellow,yellow,yellow,yellow,yellow,yellow,yellow,black,black
         !byte white,cyan,cyan,cyan,cyan,cyan,cyan,cyan,cyan,cyan

         !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
         !byte purple,purple,purple,purple,purple,purple,purple,purple,purple,purple
         !byte purple,purple,purple,purple,purple,purple,purple,purple,purple,purple
         !byte purple,purple,purple,purple,purple,purple,purple,purple,purple,purple
         !byte purple,purple

         !byte orange,orange,orange,orange,orange,orange,orange,orange,orange,orange
         !byte orange,orange,orange,orange,orange,orange,orange,orange,orange,orange
         !byte orange,orange,orange,orange,orange,orange,orange,orange,orange,orange
         !byte orange,orange,orange,orange,orange,orange,orange,orange,orange,orange
         !byte orange,orange,orange,orange,orange,orange,orange,orange,orange,orange
         !byte orange,orange,orange,orange,orange,orange

         !byte $00

sinus     
          !byte $b3
          !byte $b1
          !byte $b0
          !byte $af,$af
          !byte $ae,$ae
          !byte $ad,$ad
          !byte $ac,$ac,$ac,$ac
          !byte $ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab,$ab
          !byte $ac,$ac,$ac,$ac
          !byte $ad,$ad
          !byte $ae,$ae
          !byte $af,$af
          !byte $b0
          !byte $b1      
          !byte $00

ZP_HELPADR = $FB
Text_Pointer = $02

infotext        !scr "3.....2.....1.....   cooommmpooo fiiilllleeeerrrr!!!!!"
                !scr "      hi everybody at gubbdata 2015, how's it going?"
                !scr "  i bet it's pretty awsm!!!    here it is, my remote entry"
                !scr " for the compo called 'positive karma', based on the fantastic tune by linus... it's still only about a month since i"
                !scr " got into 6502 asm, so i've got a lot to learn! "
                !scr "               *** greetings to:      mermaid (thank you for all the help!), hein, dr.j, scarzix, theryk, freak and everybody at gubbdata!"
                !scr " alright, time to wrap it up, have fun and get wasted!!!                  "

                !byte $00

infotextpos     !byte $FF
infotextbitpos  !byte $00


;============================================================
;    resources
;============================================================

* = PICTURE
!binary "resources/karma_edited_12.kla",,2 


;load sid music
* = address_music                         ; address to load the music data
!bin "resources/Positive_Karma.sid",, $7c+2  ; remove header from sid and cut off original loading address 

* = $4900
sprite_0  !fill 64, $00
sprite_1  !fill 64, $00
sprite_2  !fill 64, $00
sprite_3  !fill 64, $00
sprite_4  !fill 64, $00   ; last visible sprite
sprite_5  !fill 64, $00




;============================================================
;    some initialization and interrupt redirect setup
;============================================================
 * = $c000 
           
           jsr init_koala  
           lda #$00       
           jsr sid_init     ; init music routine now
           jsr init_scroll

           sei         ; set interrupt disable flag

           ldy #$7f    ; $7f = %01111111
           sty $dc0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
           sty $dd0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
           lda $dc0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
           lda $dd0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
          
           lda #$01    ; Set Interrupt Request Mask...
           sta $d01a   ; ...we want IRQ by Rasterbeam (%00000001)

           lda $d011   ; Bit#0 of $d011 indicates if we have passed line 255 on the screen
           and #$7f    ; it is basically the 9th Bit for $d012
           sta $d011   ; we need to make sure it is set to zero for our intro.

           lda #<irq   ; point IRQ Vector to our custom irq routine
           ldx #>irq 
           sta $314    ; store in $314/$315
           stx $315   

           lda #$48    ; trigger first interrupt at row zero
           sta $d012

           cli                  ; clear interrupt disable flag

           jmp *

           

;============================================================
;    custom interrupt routine
;============================================================
!align 256,0
irq         
          dec $d019
        
          
         
;============================================================
;    the rasters
;============================================================


            lda #$01          ; white
            ldy #$49
            cpy $d012
            bne *-3
            sta $d020


            lda #$03          ; cyan
            ldy #$4a
            cpy $d012
            bne *-3            
            sta $d020

ldx #$66
dex
bne * -1

            lda #$00          ; black
            sta $d020


            lda #$01          ; white
            ldy #$55
            cpy $d012
            bne *-3
            sta $d020


            lda #$07          ; yellow
            ldy #$56
            cpy $d012
            bne *-3
            sta $d020


            lda #$00          ; black
            ldy #$5f
            cpy $d012
            bne *-3
            sta $d020



            lda #$01          ; white
            ldy #$61
            cpy $d012
            bne *-3
            sta $d020

            lda #$03          ; cyan
            ldy #$62
            cpy $d012
            bne *-3
            sta $d020

ldx #$66
dex
bne * -1

            lda #$00          ; black
            sta $d020


            lda #$04          ; purple
            ldy #$8e
            cpy $d012
            bne *-3
            sta $d020

ldx #$ff
dex
bne * -1
ldx #$52
dex
bne * -1

            lda #$08          ; orange
            sta $d020

ldx #$ff
dex
bne * -1
ldx #$ff
dex
bne * -1
ldx #$19
dex
bne * -1


            lda #$00          ; black
            sta $d020

;============================================================
;    end rasters
;============================================================

next     

          jsr play_scroll
          jsr sid_play     ; jump to play music routine           
          jmp $ea81        ; return to kernel interrupt routine


!source "code/spritescroller.asm"
!source "code/koala.asm"

;============================================================
;    end rasters
;============================================================
