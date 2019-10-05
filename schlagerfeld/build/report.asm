
; ******** Source: index.asm
     1                          
     2                          
     3                          
     4                          address_sprites = $0b00	  	; loading address for ship sprite
     5                          address_sid 	= $1000 	; loading address for sid tune
     6                          init_sid        = $1000     ; init routine for music
     7                          play_sid        = $1003     ; play music routine
     8                          pra             = $dc00     ; CIA#1 (Port Register A)
     9                          prb             = $dc01     ; CIA#1 (Port Register B)
    10                          ddra            = $dc02     ; CIA#1 (Data Direction Register A)
    11                          ddrb            = $dc03     ; CIA#1 (Data Direction Register B)
    12                          smooth          = $12        ;Control for smooth scroll
    13                          screenloc       = $0400+24*40
    14                          screen_ram      = $0400     ; location of screen ram
    15                          
    16                          * = address_sprites                  
    17  0b00 0000000000000000...!bin "../resources/claudio.spd",256,3  	 ; skip first three bytes which is encoded Color Information
    18                          										 ; then load 16x64 Bytes from file
    19                          
    20                          * = address_sid                         
    21  1000 4cad104cb110b957...!bin "../resources/dingsmitzeug.sid",, $7c+2  ; remove header from sid and cut off original loading address 
    22                          
    23                          
    24  1acc 00                 tick			!byte $00
    25  1acd 00                 tock			!byte $00
    26                          
    27                          * = $c000     ; start_address were all the assembled 
    28                          			  ; code will be consecutively written to
    29                          

; ******** Source: config_sprites.asm
     1                          ;============================================================
     2                          ; configuration of the sprite used in the intro
     3                          ;============================================================
     4                          
     5                          
     6                          ; the sprite pointer for Sprite#0
     7                          sprite_pointer_0		= (address_sprites + 0*$40) / $40
     8                          sprite_pointer_1		= (address_sprites + 1*$40) / $40
     9                          sprite_pointer_2		= (address_sprites + 2*$40) / $40
    10                          sprite_pointer_3		= (address_sprites + 3*$40) / $40
    11                          
    12                          ; store the pointer in the sprite pointer register for Sprite#0
    13                          ; Sprite Pointers are the last 8 bytes of Screen RAM, e.g. $07f8-$07ff
    14  c000 a92c               lda #sprite_pointer_0
    15  c002 8df807             sta screen_ram + $3f8 	
    16                          
    17  c005 a92d               lda #sprite_pointer_1
    18  c007 8df907             sta screen_ram + $3f9 
    19                          
    20  c00a a92e               lda #sprite_pointer_2
    21  c00c 8dfa07             sta screen_ram + $3fa 
    22                          
    23  c00f a92f               lda #sprite_pointer_3
    24  c011 8dfb07             sta screen_ram + $3fb 
    25                          
    26                          
    27                          ;============================================================
    28                          ; Initialize involved VIC-II registers
    29                          ;============================================================
    30                          
    31  c014 a9ff               lda #%11111111     ; enable sprites
    32  c016 8d15d0             sta $d015 
    33                          
    34  c019 a90f               lda #%00001111     ; set multicolor mode for sprites
    35  c01b 8d1cd0             sta $d01c
    36                          
    37  c01e a90f               lda #%00001111		; x  stretch 
    38  c020 8d1dd0             sta $d01d
    39  c023 a90f               lda #%00001111		; y stretch 
    40  c025 8d17d0             sta $d017
    41                          
    42                          
    43                          ; -------------------
    44                          ; color for all multicolor sprites
    45                          ; -------------------
    46                          
    47  c028 a90a               lda #$0a
    48  c02a 8d25d0             sta $d025	; sprite multicolor 1
    49  c02d a907               lda #$07
    50  c02f 8d26d0             sta $d026	; sprite multicolor 2
    51                          
    52                          ; -------------------
    53                          ; individual colors
    54                          ; -------------------
    55                          
    56                          
    57  c032 a900               lda #$00 	; sprite color 0
    58  c034 8d27d0             sta $d027
    59                          
    60  c037 a902               lda #$02	; sprite color 1
    61  c039 8d28d0             sta $d028
    62                          
    63  c03c a904               lda #$04	; sprite color 2
    64  c03e 8d29d0             sta $d029
    65                          
    66  c041 a904               lda #$04	; sprite color 3
    67  c043 8d2ad0             sta $d02a
    68                          
    69                          
    70  c046 a90f               lda #%00001111	; set X pos > FF to true for all sprites
    71                          ;sta $d010		; so that the sprites appear far right
    72                          
    73                          ; sprite 0
    74  c048 a920               lda #$20 	; set Sprite#0 positions with X/Y coords to
    75  c04a 8d00d0             sta $d000   ; lower right of the screen
    76  c04d a96c               lda #$30+60    ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
    77  c04f 8d01d0             sta $d001   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)
    78                          
    79                          ; sprite 1
    80  c052 a920               lda #$20 	; set Sprite#0 positions with X/Y coords to
    81  c054 8d02d0             sta $d002   ; lower right of the screen
    82  c057 a996               lda #$5a +60   ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
    83  c059 8d03d0             sta $d003   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)
    84                          
    85                          ; sprite 2
    86  c05c a920               lda #$20 	; set Sprite#0 positions with X/Y coords to
    87  c05e 8d04d0             sta $d004   ; lower right of the screen
    88  c061 a9c0               lda #$84 +60   ; $d000 corresponds to X-Coord (0-504 incl 9th Bit on PAL systems)
    89  c063 8d05d0             sta $d005   ; $d001 corresponds to Y-Coord (0-255 on PAL systems)
    90                          

; ******** Source: index.asm

; ******** Source: main.asm
     1                          ;===================================
     2                          ; main.asm triggers all subroutines 
     3                          ; and runs the Interrupt Routine
     4                          ;===================================
     5                          
     6                          main:
     7  c066 78                           sei               ; set interrupt disable flag
     8                          
     9  c067 20f9c3                       jsr clear_screen  ; clear the screen
    10  c06a a900                         lda #$00          ; GODDAMN 00 FOR THE SID INIT!!!! NEVER FORGET AGAIN!!! DAMN!!11
    11  c06c 200010                       jsr init_sid      ; init music routine 
    12  c06f 205ec4                       jsr petscii
    13  c072 20b1c3                       jsr init_scroll
    14  c075 20fcc0                       jsr alien_init
    15                                  
    16                          
    17  c078 a07f                         ldy #$7f    ; $7f = %01111111
    18  c07a 8c0ddc                       sty $dc0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
    19  c07d 8c0ddd                       sty $dd0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
    20  c080 ad0ddc                       lda $dc0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
    21  c083 ad0ddd                       lda $dd0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
    22                                     
    23  c086 a901                         lda #$01    ; Set Interrupt Request Mask...
    24  c088 8d1ad0                       sta $d01a   ; ...we want IRQ by Rasterbeam (%00000001)
    25                          
    26  c08b a9a6                         lda #<irq   ; point IRQ Vector to our custom irq routine
    27  c08d a2c0                         ldx #>irq 
    28  c08f 8d1403                       sta $0314    ; store in $314/$315
    29  c092 8e1503                       stx $0315   
    30                          
    31  c095 a900                         lda #$0    ; trigger interrupt at row zero
    32  c097 8d12d0                       sta $d012
    33                          
    34  c09a a90c                         lda #$0c    ; set border to grey color
    35  c09c 8d20d0                       sta $d020
    36  c09f 8d21d0                       sta $d021
    37                          
    38  c0a2 58                           cli          ; clear interrupt disable flag
    39  c0a3 4ca3c0                       jmp *       ; infinite loop
    40                          
    41                          
    42                          ;================================
    43                          ; Our custom interrupt routines 
    44                          ;================================
    45                          
    46                          irq        
    47  c0a6 ce19d0                       dec $d019          ; acknowledge IRQ / clear register for next interrupt
    48  c0a9 2021c4                       jsr check_keyboard ; check keyboard controls
    49  c0ac 20bcc3                       jsr scroll
    50  c0af 200310                       jsr play_sid       ; jump to play music routine
    51  c0b2 203bc4                       jsr effects
    52  c0b5 2007c1                       jsr alien_groove
    53                          
    54                                    ; rasters
    55                          
    56  c0b8 a003                         ldy #$03
    57  c0ba a930                         lda #$30     
    58  c0bc cd12d0                       cmp $d012
    59  c0bf d0fb                         bne *-3
    60  c0c1 8c20d0                       sty $d020
    61  c0c4 a90c                         lda #$0c
    62  c0c6 8d21d0                       sta $d021
    63                          
    64                          
    65                          
    66  c0c9 a000                         ldy #$00
    67  c0cb a9ea                         lda #$ea 
    68                          
    69  c0cd cd12d0                       cmp $d012
    70  c0d0 d0fb                         bne *-3
    71                          
    72  c0d2 a9c0                         lda #$c0
    73  c0d4 8d16d0                       sta $d016
    74                          
    75  c0d7 ea                           nop 
    76  c0d8 ea                           nop
    77  c0d9 ea                           nop
    78  c0da ea                           nop
    79  c0db ea                           nop
    80  c0dc ea                           nop
    81  c0dd ea                           nop
    82  c0de ea                           nop
    83  c0df ea                           nop 
    84  c0e0 ea                           nop
    85  c0e1 ea                           nop
    86  c0e2 ea                           nop
    87  c0e3 ea                           nop
    88  c0e4 ea                           nop
    89                                    
    90  c0e5 ea                           nop
    91  c0e6 ea                           nop
    92  c0e7 ea                           nop
    93  c0e8 ea                           nop
    94  c0e9 ea                           nop
    95  c0ea ea                           nop
    96  c0eb ea                           nop
    97  c0ec ea                           nop
    98  c0ed ea                           nop
    99  c0ee ea                           nop
   100  c0ef ea                           nop
   101  c0f0 ea                           nop
   102  c0f1 ea                           nop
   103  c0f2 ea                           nop
   104                          
   105  c0f3 8c20d0                       sty $d020
   106  c0f6 8c21d0                       sty $d021
   107                          
   108  c0f9 4c31ea                       jmp $ea31      ; return to Kernel routine

; ******** Source: index.asm

; ******** Source: alien_groove.asm
     1                          alien_init
     2  c0fc a900                         lda #$00      ; init tick and tock
     3  c0fe 8dcc1a                       sta tick
     4  c101 a9a0                         lda #$a0
     5  c103 8dcd1a                       sta tock
     6  c106 60                           rts
     7                          
     8                          alien_groove
     9                          
    10  c107 adcc1a                        lda tick
    11  c10a c917                          cmp #23        ; the smaller this gets, the faster it changes
    12  c10c f004                          beq groove
    13  c10e eecc1a                        inc tick
    14  c111 60                            rts
    15                          
    16                          groove   
    17                                    ; toggle between two possible values
    18                                    ; and compare to trigger one of the two animations 
    19  c112 a900                         lda #$00
    20  c114 8dcc1a                       sta tick
    21  c117 adcd1a                       lda tock          
    22  c11a c9a0                         cmp #$a0
    23  c11c f003                         beq anima
    24  c11e 4c33c1                       jmp animb
    25                          
    26                          anima
    27  c121 a26c                         ldx #$30+60
    28  c123 8e01d0                       stx $d001
    29  c126 a296                         ldx #$5a+60
    30  c128 8e03d0                       stx $d003
    31  c12b a22e                         ldx #sprite_pointer_2
    32  c12d 8efa07                       stx screen_ram + $3fa 
    33  c130 4c45c1                       jmp end
    34                          
    35                          animb
    36  c133 a26e                         ldx #$32+60
    37  c135 8e01d0                       stx $d001
    38  c138 a298                         ldx #$5c+60
    39  c13a 8e03d0                       stx $d003
    40  c13d a22f                         ldx #sprite_pointer_3
    41  c13f 8efa07                       stx screen_ram + $3fa 
    42  c142 4c45c1                       jmp end
    43                          
    44                          end
    45                                    
    46  c145 49ff                         eor #$ff        ; toggle flag
    47  c147 8dcd1a                       sta tock
    48  c14a 60                           rts
    49                          
    50                          

; ******** Source: index.asm

; ******** Source: scroller.asm
     1  c14b 2020202020202020...message         !scr "                    wer in jogginghosen released, hat die kontrolle ueber sein leben verloren.            computer sind etwas fuer's personal.          sehe ich aus wie jemand, der coden kann? ich kann netflix starten und damit hat sich das.          ich bin umgeben von jungen und schoenen scenern. der anblick von haesslichkeit ist mir ein graus.          ich kenne triad nicht. auch claudia kennt die nicht. die waren nie in paris, die kennen wir nicht.          in der demoszene muss man staendig zerstoeren, um sich zu erneuern. das lieben, was man gehasst hat, und das hassen, was man geliebt hat.          "
     2  c3b0 00                                  !byte 0
     3                                           
     4                          init_scroll
     5  c3b1 a94b                                lda #<message
     6  c3b3 a0c1                                ldy #>message
     7  c3b5 8dd5c3                              sta read+1
     8  c3b8 8cd6c3                              sty read+2
     9  c3bb 60                                  rts
    10                          
    11  c3bc a512               scroll           lda smooth
    12  c3be 38                                  sec
    13  c3bf e901                                sbc #$01 ;Speed of scroll can be edited to how you want it, but don't go too mad :)
    14  c3c1 2907                                and #$07 ;We need this to make the variable smooth into something smooth :)
    15  c3c3 8512                                sta smooth
    16  c3c5 b031                                bcs endscroll 
    17  c3c7 a200                                ldx #$00
    18  c3c9 bdc107             wrapmessage      lda screenloc+1,x
    19  c3cc 9dc007                              sta screenloc,x
    20  c3cf e8                                  inx
    21  c3d0 e028                                cpx #$28
    22  c3d2 d0f5                                bne wrapmessage
    23  c3d4 ade707             read             lda screenloc+$27
    24  c3d7 c900                                cmp #$00 ;Is byte 0 (@) read?
    25  c3d9 d00d                                bne nowrap ;If not, goto label nowrap
    26  c3db a94b                                lda #<message
    27  c3dd a0c1                                ldy #>message
    28  c3df 8dd5c3                              sta read+1
    29  c3e2 8cd6c3                              sty read+2
    30  c3e5 4cd4c3                              jmp read
    31                          nowrap           
    32                                           ;adc #$7f
    33  c3e8 8de707                             sta screenloc+$27
    34  c3eb eed5c3                              inc read+1
    35  c3ee add5c3                              lda read+1
    36  c3f1 c900                                cmp #$00
    37  c3f3 d003                                bne endscroll
    38  c3f5 eed6c3                              inc read+2
    39  c3f8 60                 endscroll        rts
    40                          

; ******** Source: index.asm

; ******** Source: sub_clear_screen.asm
     1                          ;============================================================
     2                          ; clear screen and turn black
     3                          ;============================================================
     4                          
     5  c3f9 a200               clear_screen     ldx #$00     ; start of loop
     6  c3fb 8e20d0                              stx $d020    ; write to border color register
     7  c3fe 8e21d0                              stx $d021    ; write to screen color register
     8  c401 a920               clear_loop       lda #$20     ; #$20 is the spacebar screencode
     9  c403 9d0004                              sta $0400,x  ; fill four areas with 256 spacebar characters
    10  c406 9d0005                              sta $0500,x 
    11  c409 9d0006                              sta $0600,x 
    12  c40c 9de806                              sta $06e8,x 
    13  c40f a90c                                lda #$0c     ; puts into the associated color ram dark grey ($0c)...
    14  c411 9d00d8                              sta $d800,x  ; and this will become color of the scroll text
    15  c414 9d00d9                              sta $d900,x
    16  c417 9d00da                              sta $da00,x
    17  c41a 9de8da                              sta $dae8,x
    18  c41d e8                                  inx         
    19  c41e d0e1                                bne clear_loop   

; ******** Source: index.asm

; ******** Source: sub_check_keyboard.asm
     1  c420 60                 
     2                          ;===============================
     3                          ; check for a single key press
     4                          ;===============================
     5                          
     6                          
     7                          check_keyboard              
     8                          
     9  c421 a9ff                                       lda #%11111111  ; CIA#1 Port A set to output 
    10  c423 8d02dc                                     sta ddra             
    11  c426 a900                                       lda #%00000000  ; CIA#1 Port B set to inputt
    12  c428 8d03dc                                     sta ddrb             
    13                                      
    14  c42b a97f               check_space             lda #%01111111  ; select row 8
    15  c42d 8d00dc                                     sta pra 
    16  c430 ad01dc                                     lda prb         ; load column information
    17  c433 2910                                       and #%00010000  ; test 'space' key to exit 
    18  c435 f001                                       beq exit_to_basic                        
    19  c437 60                                         rts             ; return     
    20                          
    21                          exit_to_basic           
    22  c438 4ce2fc                                     jmp $fce2
    23                          

; ******** Source: index.asm

; ******** Source: effects.asm
     1                          
     2                          effects:
     3  c43b ad16d4                       lda $d416
     4  c43e c90f                         cmp #$0f
     5  c440 d014                         bne +
     6  c442 ad5dc4                       lda scrolltemp
     7  c445 c9c0                         cmp #$c0
     8  c447 f008                         beq momo
     9  c449 a9c0                         lda #$c0
    10  c44b 8d5dc4                       sta scrolltemp
    11  c44e 4c56c4                       jmp +
    12                          momo:
    13  c451 a9c4                         lda #$c4
    14  c453 8d5dc4                       sta scrolltemp
    15                          
    16                          +:
    17  c456 ad5dc4                       lda scrolltemp
    18  c459 8d16d0                       sta $d016
    19                                    
    20                          
    21                          theend:
    22  c45c 60                           rts
    23                          
    24                          scrolltemp: 
    25  c45d c0                 !byte $c0

; ******** Source: index.asm

; ******** Source: petscii.asm
     1                          
     2                          petscii
     3                          
     4  c45e a200               	ldx	#0
     5  c460 a0fa               	ldy	#250
     6                          
     7                          kopy
     8  c462 bd0048             	lda	img,x
     9  c465 9d0004             	sta	$400,x
    10  c468 bdfa48             	lda	img+250,x
    11  c46b 9dfa04             	sta	$400+250,x
    12  c46e bdf449             	lda	img+500,x
    13  c471 9df405             	sta	$400+500,x
    14  c474 bdee4a             	lda	img+750,x
    15  c477 9dee06             	sta	$400+750,x
    16                          
    17  c47a bde84b             	lda	img+1000,x
    18  c47d 9d00d8             	sta	$d800,x
    19  c480 bde24c             	lda	img+1250,x
    20  c483 9dfad8             	sta	$d800+250,x
    21  c486 bddc4d             	lda	img+1500,x
    22  c489 9df4d9             	sta	$d800+500,x
    23  c48c bdd64e             	lda	img+1750,x
    24  c48f 9deeda             	sta	$d800+750,x
    25                          
    26  c492 e8                 	inx
    27  c493 88                 	dey
    28  c494 d0cc               	bne	kopy
    29                          
    30  c496 60                 	rts
    31                          
    32                          * = $4800
    33                          img:
    34                          ; Character data
    35  4800 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,247,227,247,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    36  4828 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    37  4850 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    38  4878 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,229,160,160,160,160,160,160,160,160,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    39  48a0 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,231,160,160,160,160,160,160,160,160,160,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    40  48c8 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,236,160,160,160,160,160,160,160,160,160,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    41  48f0 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,207,227,247,121,248,248,98,98,98,98,251,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    42  4918 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,225,160,160,80,160,160,160,249,226,248,160,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    43  4940 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,251,105,160,251,160,236,160,160,160,95,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    44  4968 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,246,160,198,160,248,227,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    45  4990 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,231,160,160,160,160,160,160,160,160,204,105,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    46  49b8 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,192,160,160,160,160,160,160,119,254,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    47  49e0 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,76,196,160,160,160,160,213,254,160,236,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    48  4a08 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,217,160,160,160,160,160,254,160,160,225,95,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    49  4a30 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,98,160,160,207,160,160,160,160,97,160,251,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    50  4a58 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,239,98,115,160,155,160,160,160,160,245,160,160,223,228,160,160,160,160,160,160,160,160,160,160,160,160
    51  4a80 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,236,248,247,160,160,160,231,236,121,251,160,160,111,160,160,160,160,160,247,98,249,228,160,160,160,160,160,160,160,160
    52  4aa8 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,254,160,160,160,160,160,160,245,160,252,239,254,137,160,160,160,160,160,160,160,160,160,252,251,160,160,160,160,160,160
    53  4ad0 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,97,160,160,160,160,160,160,160,160,160,160,160,160,225,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    54  4af8 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,229,160,160,160,160,160,160,160,160,160,160,160,217,160,160,160,160,160,160,160,160,160,97,160,160,229,160,160,160,160,160
    55  4b20 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,118,160,160,160,160,160,160,160,160,160,155,160,160,229,160,160,160,160,160
    56  4b48 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,225,160,160,160,160,160,160,160,160,160,160,160,217,254,160,160,160,160,160,160,160,160,231,229,160,160,225,160,160,160,160,160
    57  4b70 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,138,160,160,160,160,160,160,160,160,160,200,160,160,160,97,160,160,160,160,160
    58  4b98 a0a0a0a0a0a0a0a0...!byte 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
    59  4bc0 2020202020202020...!byte 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
    60  4be8 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,15,1,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    61  4c10 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,15,15,15,15,1,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    62  4c38 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,15,10,7,7,13,15,1,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    63  4c60 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,10,10,7,7,7,7,13,15,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    64  4c88 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,10,10,7,7,7,7,13,15,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    65  4cb0 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,10,10,7,7,7,7,7,7,1,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    66  4cd8 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    67  4d00 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,10,1,1,10,10,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    68  4d28 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,10,0,0,0,10,10,10,10,10,10,10,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    69  4d50 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,10,15,1,7,7,10,10,10,10,10,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    70  4d78 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,13,1,7,7,7,10,10,10,10,12,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    71  4da0 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,10,10,7,7,10,10,2,0,12,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    72  4dc8 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,10,10,7,7,10,10,1,1,12,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3
    73  4df0 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,10,7,7,10,10,1,1,1,0,1,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3
    74  4e18 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,11,11,1,1,1,1,1,1,0,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3
    75  4e40 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,15,1,1,1,1,1,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3
    76  4e68 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,15,0,1,1,1,0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3
    77  4e90 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3,3
    78  4eb8 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3
    79  4ee0 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3
    80  4f08 0303030303030303...!byte 3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3
    81  4f30 0303030303030303...!byte 3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3
    82  4f58 0303030303030303...!byte 3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3
    83  4f80 0000000000000000...!byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    84  4fa8 00000b0b0c0c0f0f...!byte 0,0,11,11,12,12,15,15,15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,15,15,15,12,12,11,11,0,0

; ******** Source: index.asm
