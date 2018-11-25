

!cpu 6502
!to "build/circuit.prg",cbm    ; output file

address_sprites = $0b00	  	; loading address for ship sprite
address_sid 	= $1000 	; loading address for sid tune
screen_ram      = $0400     ; location of screen ram
init_sid        = $1000     ; init routine for music
play_sid        = $1003     ; play music routine
pra             = $dc00     ; CIA#1 (Port Register A)
prb             = $dc01     ; CIA#1 (Port Register B)
ddra            = $dc02     ; CIA#1 (Data Direction Register A)
ddrb            = $dc03     ; CIA#1 (Data Direction Register B)
ZP_HELPADR 	= $FB
Text_Pointer 	= $02
SPR_ADD     	= $0


* = address_sprites                  
!bin "resources/circuit.spd",192,3  	 ; skip first three bytes which is encoded Color Information

; the sprite 3,4,5 and 6 (not displayed but needed) are part of the scrolltext
; they get prefilled with a horizontal line to match a petscii line at start

sprite_3  
		  !fill 42 ,$00
		  !fill 6,  $ff
		  !fill 16 ,$00

sprite_4  
		  !fill 42 ,$00
		  !fill 6,  $ff
		  !fill 16 ,$00

sprite_5  
		  !fill 42 ,$00
		  !fill 6,  $ff
		  !fill 16 ,$00

sprite_6  
		  !fill 42 ,$00
		  !fill 6,  $ff
		  !fill 16 ,$00
sprite_7
                !byte $7F,$FF,$FC,$80,$00,$02,$94,$A6,$9A,$AA,$A8,$A2,$AA,$A4
                !byte $A2,$A2,$A2,$A2,$A2,$EC,$9A,$80,$00,$02,$BA,$27,$72,$A5
                !byte $44,$4A,$B8,$87,$4A,$A4,$84,$4A,$B8,$87,$72,$80,$00,$02
                !byte $7F,$FF,$FC,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                !byte $00,$00,$00,$00,$00,$00,$00,$0C		 


* = address_sid                         
!bin "resources/I_Miss_You.sid",, $7c+2  ; remove header from sid and cut off original loading address 

infotext        
				
				!scr 67,67,67,67,67,67,67,67,67,67,67,67,67
				!scr 67,67,67,67,67,67,67,67,67,67,67,67,67	
				!scr 68,67,67,67,67,67,67,68,67,67,67,67,67	
				!scr 68,69,68,67,67,67,67,68,69,68,67,67,67			
				!scr 68,69,119,69,68,64,70,82
				!scr 111,82,70,64,68,69,119,69,68,64,70,82
				!scr 111,82,70,64,68,69,119,69,68,64,70,82
				!scr 111,82,70,64,68,69,119,69,68,64,70,82
				!scr "101101101010011110000"
                !scr "                    "
                !scr "the law requires each one to seed"
                !scr " a small device inside our head"
                !scr "            "
                !scr "to solve a case without much aid," 
                !scr " to count the things: who's there, who's dead?" 
                !scr "            "
                !scr "it links with me without my yes"
                !scr "            "
                !scr "and reads my brain without permit" 
                !scr "            "
                !scr "and finds me in my secret place"
                !scr "            "
                !scr "and scans my flesh for cold or heat" 
                !scr "            "
                !scr "and spots my stares and line of sight" 
                !scr "            "
                !scr "and determines my hormone saps"
                !scr "            "
                !scr "and spans my heart and pressure's height" 
                !scr "            "
                !scr "and notices my walks, my naps,"
                !scr " then processes the data got"
                !scr "            "
                !scr "again without my own decree" 
                !scr "            "
                !scr "and on their screen a message popped," 
                !scr "            "
                !scr "this man we found       wants to be free."
                !scr "                      eof                      "
                !scr 67,67,67,67,67,67,67,67,67,67,67,67,67
				!scr 67,67,67,67,67,67,67,67,67,67,67,67,67
                !byte $00

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152




infotextpos     !byte $FF
infotextbitpos  !byte $00

* = $c000     ; start_address were all the assembled 
			  ; code will be consecutively written to


!source "code/config_sprites.asm"
!source "code/main.asm"
!source "code/sub_clear_screen.asm"
!source "code/sub_check_keyboard.asm"
!source "code/petscii.asm"
!source "code/spritescroller.asm"
!source "code/flashy.asm"