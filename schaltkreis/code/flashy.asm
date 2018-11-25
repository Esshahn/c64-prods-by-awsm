; fine color thingy program

flashy_init
		
		; set the random changing char to grey

		lda #$0f
		sta $d800 + 14*40 + 26

		rts

flashy

		; one char on screen is constantly changing
		lda $d41b		; some sid register i have no clue about ($d41b)
		
		; first check for $00 and $ff, cause these are the values the register
		; has in the beginning. we don't want the flash to happen then

		cmp #$00
		bne check2
		rts
check2	cmp #$ff
		bne check3
		rts
check3	cmp #$60			; the higher the number, the more likely to flash
		bcc flash_all

		cmp #$80
		bcc logo_char_jump_1
		cmp #$20			; restore the old logo chars
		bcs logo_char_jump_2
		rts		

logo_char_jump_1
		;lda #$c8
		;sta $d016
		;lda #$93 	; set Sprite#0 positions with X/Y coords to
		;sta $d000   ; lower right of the screen
		;sta $d002   ; lower right of the screen
		;lda #$3b 	; set Sprite#0 positions with X/Y coords to
		;sta $d004   ; lower right of the screen
		
		lda #$00	; music by ed logo goes dark grey
		sta $d02e

		rts

logo_char_jump_2
		;lda #$c9
	;	sta $d016
		;lda #$94 	; set Sprite#0 positions with X/Y coords to
		;sta $d000   ; lower right of the screen
	;	sta $d002   ; lower right of the screen
	;	lda #$3c 	; set Sprite#0 positions with X/Y coords to
	;	sta $d004   ; lower right of the screen	

		lda #$0b	; music by ed logo goes dark grey
		sta $d02e

		rts


flash_all
		
		sta $0400 + 14*40 + 26

		jsr flashy_logo_top		
		jsr flashy_logo_bottom

		; goes through all the circle areas in coloram to make the color flash

		dec $d800 + 38
		dec $d828 + 30
		dec $d828 + 35
		dec $d850 + 4
		dec $d878 + 2
		dec $d878 + 35
		dec $d8a0 + 37
		dec $d8c8 + 2
		dec $d918 + 1
		dec $d918 + 35
		dec $d940 + 37
		dec $d968 
		dec $d968 + 33
		dec $d990 + 1
		dec $d990 + 38
		dec $d9b8 
		dec $d9b8 + 36
		dec $d9e0 + 33
		dec $da08 + 37
		dec $da30 + 25
		dec $da30 + 27
		dec $da58 
		dec $da58 + 38
		dec $da80 + 6
		dec $da80 + 16
		dec $da80 + 32
		dec $da80 + 37
		dec $daa8
		dec $daa8 + 35
		dec $daf8 + 2	
		dec $daf8 + 32
		dec $db48 + 2
		rts

flashy_logo_top

		;lda #$05

		; logo row 1

		sta $d800 + 7*40 + 10
		sta $d800 + 7*40 + 11
		sta $d800 + 7*40 + 12
		sta $d800 + 7*40 + 14
		sta $d800 + 7*40 + 18
		sta $d800 + 7*40 + 20
		sta $d800 + 7*40 + 21
		sta $d800 + 7*40 + 22
		sta $d800 + 7*40 + 24
		sta $d800 + 7*40 + 28	

		; logo row 2

		sta $d800 + 8*40 + 10		
		sta $d800 + 8*40 + 12
		sta $d800 + 8*40 + 14
		sta $d800 + 8*40 + 18
		sta $d800 + 8*40 + 20
		sta $d800 + 8*40 + 24
		sta $d800 + 8*40 + 25
		sta $d800 + 8*40 + 27
		sta $d800 + 8*40 + 28	

		; logo row 4

		sta $d800 + 9*40 + 16
		sta $d800 + 9*40 + 26
			
		rts

flashy_logo_bottom

		and $01

		; logo row 3

		sta $d800 + 9*40 + 10
		sta $d800 + 9*40 + 11
		sta $d800 + 9*40 + 12
		sta $d800 + 9*40 + 14
		sta $d800 + 9*40 + 18
		sta $d800 + 9*40 + 21
		sta $d800 + 9*40 + 24
		sta $d800 + 9*40 + 28	

		; logo row 4

		sta $d800 + 10*40 + 10		
		sta $d800 + 10*40 + 12
		sta $d800 + 10*40 + 14
		sta $d800 + 10*40 + 15
		sta $d800 + 10*40 + 17
		sta $d800 + 10*40 + 18
		sta $d800 + 10*40 + 22
		sta $d800 + 10*40 + 24
		sta $d800 + 10*40 + 28	

		; logo row 5

		sta $d800 + 11*40 + 10
		sta $d800 + 11*40 + 12
		sta $d800 + 11*40 + 14
		sta $d800 + 11*40 + 18
		sta $d800 + 11*40 + 20
		sta $d800 + 11*40 + 21
		sta $d800 + 11*40 + 22
		sta $d800 + 11*40 + 24
		sta $d800 + 11*40 + 28	
			
		rts


logo_char

		;lda #$05

		; logo row 1

		sta $0400 + 7*40 + 10
		sta $0400 + 7*40 + 11
		sta $0400 + 7*40 + 12
		sta $0400 + 7*40 + 14
		sta $0400 + 7*40 + 18
		sta $0400 + 7*40 + 20
		sta $0400 + 7*40 + 21
		sta $0400 + 7*40 + 22
		sta $0400 + 7*40 + 24
		sta $0400 + 7*40 + 28	

		; logo row 2

		sta $0400 + 8*40 + 10		
		sta $0400 + 8*40 + 12
		sta $0400 + 8*40 + 14
		sta $0400 + 8*40 + 18
		sta $0400 + 8*40 + 20
		sta $0400 + 8*40 + 24
		sta $0400 + 8*40 + 25
		sta $0400 + 8*40 + 27
		sta $0400 + 8*40 + 28	

		; logo row 4

		sta $0400 + 9*40 + 16
		sta $0400 + 9*40 + 26
			

		; logo row 3

		sta $0400 + 9*40 + 10
		sta $0400 + 9*40 + 11
		sta $0400 + 9*40 + 12
		sta $0400 + 9*40 + 14
		sta $0400 + 9*40 + 18
		sta $0400 + 9*40 + 21
		sta $0400 + 9*40 + 24
		sta $0400 + 9*40 + 28	

		; logo row 4

		sta $0400 + 10*40 + 10		
		sta $0400 + 10*40 + 12
		sta $0400 + 10*40 + 14
		sta $0400 + 10*40 + 15
		sta $0400 + 10*40 + 17
		sta $0400 + 10*40 + 18
		sta $0400 + 10*40 + 22
		sta $0400 + 10*40 + 24
		sta $0400 + 10*40 + 28	

		; logo row 5

		sta $0400 + 11*40 + 10
		sta $0400 + 11*40 + 12
		sta $0400 + 11*40 + 14
		sta $0400 + 11*40 + 18
		sta $0400 + 11*40 + 20
		sta $0400 + 11*40 + 21
		sta $0400 + 11*40 + 22
		sta $0400 + 11*40 + 24
		sta $0400 + 11*40 + 28	
			
		rts

