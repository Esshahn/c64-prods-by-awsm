


address_sprites = $0b00	  	; loading address for ship sprite
address_sid 	= $1000 	; loading address for sid tune
init_sid        = $1000     ; init routine for music
play_sid        = $1003     ; play music routine
pra             = $dc00     ; CIA#1 (Port Register A)
prb             = $dc01     ; CIA#1 (Port Register B)
ddra            = $dc02     ; CIA#1 (Data Direction Register A)
ddrb            = $dc03     ; CIA#1 (Data Direction Register B)
smooth          = $12        ;Control for smooth scroll
screenloc       = $0400+24*40
screen_ram      = $0400     ; location of screen ram

* = address_sprites                  
!bin "../resources/claudio.spd",256,3  	 ; skip first three bytes which is encoded Color Information
										 ; then load 16x64 Bytes from file

* = address_sid                         
!bin "../resources/dingsmitzeug.sid",, $7c+2  ; remove header from sid and cut off original loading address 


tick			!byte $00
tock			!byte $00

* = $c000     ; start_address were all the assembled 
			  ; code will be consecutively written to

!source "config_sprites.asm"
!source "main.asm"
!source "alien_groove.asm"
!source "scroller.asm"
!source "sub_clear_screen.asm"
!source "sub_check_keyboard.asm"
!source "effects.asm"
!source "petscii.asm"
