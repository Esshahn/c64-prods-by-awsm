

!cpu 6502
!to "build/bcc10-awsm.prg",cbm    ; output file

address_sprites = $0b00	  	; loading address for ship sprite
screen_ram      = $0400     ; location of screen ram
pra             = $dc00     ; CIA#1 (Port Register A)
prb             = $dc01     ; CIA#1 (Port Register B)
ddra            = $dc02     ; CIA#1 (Data Direction Register A)
ddrb            = $dc03     ; CIA#1 (Data Direction Register B)
ZP_HELPADR 	= $FB

PICTURE     = $2000
PIC_ADD     = $0
SPR_ADD     = $0

* = PICTURE
!binary "resources/bcc-pinup-02.kla",,2 

* = address_sprites                  
!bin "resources/bcc-sprites.spd",192,3  	 ; skip first three bytes which is encoded Color Information


* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152


* = $c000     ; start_address were all the assembled 
			  ; code will be consecutively written to

!source "code/config_sprites.asm"
!source "code/main.asm"
!source "code/sub_clear_screen.asm"
!source "code/sub_check_keyboard.asm"
!source "code/koala.asm"
