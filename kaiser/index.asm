

!cpu 6502
!to "build/scooter.prg",cbm    ; output file

address_sprites = $0b00	  	; loading address for ship sprite
address_sid 	= $1000 	; loading address for sid tune
init_sid        = $1000     ; init routine for music
play_sid        = $1003     ; play music routine
pra             = $dc00     ; CIA#1 (Port Register A)
prb             = $dc01     ; CIA#1 (Port Register B)
ddra            = $dc02     ; CIA#1 (Data Direction Register A)
ddrb            = $dc03     ; CIA#1 (Data Direction Register B)
smooth          = $05        ;Control for smooth scroll
screenloc       = $798
screen_ram      = $0400     ; location of screen ram



* = address_sprites                  
!bin "resources/hpalien.spd",256,3  	 ; skip first three bytes which is encoded Color Information
										 ; then load 16x64 Bytes from file
* = address_sid                         
!bin "resources/hpg.sid",, $7c+2  ; remove header from sid and cut off original loading address 


* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$00,$00,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

tick			!byte $00
tock			!byte $00

* = $c000     ; start_address were all the assembled 
			  ; code will be consecutively written to


!source "code/config_sprites.asm"
!source "code/main.asm"
!source "code/alien_groove.asm"
!source "code/scroller.asm"
!source "code/sub_clear_screen.asm"
!source "code/sub_check_keyboard.asm"
!source "code/petscii.asm"
