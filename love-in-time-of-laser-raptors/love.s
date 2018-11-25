; Compile with: acme -o export.prg -f cbm export.s

	*=$801
	!byte $b,$08,$ef,$0,$9e,$32,$30,$36,$31,$0,$0,$0

	lda	#11
	sta	$d011
	lda	#0
	sta	$d020
	lda	#0
	sta	$d021

	ldx	#0
	ldy	#250
kopy:
	lda	img,x
	sta	$400,x
	lda	img+250,x
	sta	$400+250,x
	lda	img+500,x
	sta	$400+500,x
	lda	img+750,x
	sta	$400+750,x

	lda	img+1000,x
	sta	$d800,x
	lda	img+1250,x
	sta	$d800+250,x
	lda	img+1500,x
	sta	$d800+500,x
	lda	img+1750,x
	sta	$d800+750,x

	inx
	dey
	bne	kopy

	lda	#27
	sta	$d011

jumi:	jmp jumi

img:
; Character data
	!byte 96,96,46,96,96,96,96,96,96,96,96,46,96,96,96,233,197,197,197,197,197,197,197,197,197,197,223,96,96,46,96,96,96,104,104,104,96,96,43,96
	!byte 100,100,100,100,100,100,100,100,96,100,100,100,96,100,98,220,224,174,232,232,232,232,232,232,232,232,220,104,44,96,96,104,102,224,224,224,102,44,96,96
	!byte 119,119,119,119,119,119,119,119,96,119,119,119,96,119,226,220,174,232,232,232,232,232,232,232,232,232,220,95,102,104,104,102,224,174,224,224,224,102,96,233
	!byte 96,96,96,96,104,104,104,104,104,104,104,96,233,224,224,223,104,104,123,68,119,32,119,68,104,104,233,223,95,224,224,224,224,224,171,224,224,105,233,224
	!byte 96,96,104,102,224,224,224,224,160,105,233,224,224,224,224,224,224,236,32,32,32,32,32,32,124,251,224,224,223,96,95,224,224,224,224,224,105,233,224,224
	!byte 96,104,224,224,224,224,224,105,233,224,224,224,160,239,239,228,224,32,32,32,32,32,32,32,32,103,160,224,224,224,223,95,160,160,105,96,233,224,224,224
	!byte 96,224,160,160,160,160,105,233,224,224,236,119,32,32,32,32,32,32,32,100,32,32,32,32,32,32,220,224,224,224,224,223,95,105,233,224,224,224,224,224
	!byte 96,224,224,224,105,233,224,224,224,236,32,32,32,32,32,32,32,103,223,172,208,97,32,32,32,108,224,224,224,224,224,224,224,223,95,160,160,160,160,224
	!byte 96,224,105,233,224,224,224,224,224,101,32,32,32,32,32,32,32,220,172,160,236,124,96,111,98,220,224,224,224,224,224,224,224,224,224,223,226,226,226,226
	!byte 96,105,233,224,224,224,224,224,224,101,32,32,32,32,32,32,32,220,160,127,108,254,160,239,232,95,224,224,224,224,224,224,224,224,172,224,224,224,224,105
	!byte 96,233,224,224,224,224,224,224,224,101,32,32,32,32,32,85,32,229,232,206,160,213,167,160,174,230,220,224,224,224,224,224,224,105,230,232,232,224,105,233
	!byte 233,224,224,224,224,224,239,239,160,252,123,32,32,32,32,74,75,206,160,160,213,254,202,160,160,102,225,224,224,224,224,224,105,108,98,98,98,98,98,224
	!byte 230,224,224,174,239,224,224,224,223,95,160,227,98,121,123,108,227,224,160,167,58,102,220,172,160,186,92,224,224,224,224,105,233,224,174,224,224,224,224,224
	!byte 230,224,232,95,224,205,224,224,224,96,96,233,206,105,92,230,230,224,224,160,223,220,102,212,160,160,92,224,224,224,224,96,224,224,224,224,224,174,224,224
	!byte 230,174,230,96,223,95,205,224,224,223,95,105,224,95,123,230,230,230,224,174,160,223,220,212,160,160,92,220,224,172,105,233,224,224,174,224,224,224,224,224
	!byte 230,232,95,230,223,104,224,224,224,224,223,95,105,162,160,123,230,253,205,224,232,126,220,161,160,160,92,172,230,230,96,230,230,230,230,230,224,224,224,224
	!byte 230,230,223,96,220,167,224,224,224,224,232,223,95,224,224,234,163,220,160,196,196,247,247,203,160,232,108,230,230,105,233,230,174,224,224,224,224,224,224,224
	!byte 225,230,220,92,96,105,174,224,223,224,174,233,106,224,224,224,208,196,196,192,239,239,239,239,232,105,254,230,230,96,230,224,224,224,224,224,174,224,224,224
	!byte 96,230,230,223,233,96,105,232,232,232,230,230,106,224,224,224,234,220,224,224,230,104,104,102,102,225,230,230,104,230,224,224,224,224,224,224,224,174,224,224
	!byte 96,95,174,220,233,96,96,95,105,105,105,105,233,224,160,236,233,160,224,160,174,230,160,102,102,244,230,186,224,224,224,224,174,224,224,174,224,224,224,224
	!byte 96,223,95,224,223,233,96,96,96,96,233,95,160,160,236,207,160,167,160,160,230,220,160,174,102,225,174,224,224,224,186,224,224,224,224,224,224,224,224,232
	!byte 96,174,223,95,224,223,233,96,96,96,96,233,95,160,220,160,187,160,160,174,230,245,174,102,102,225,224,224,224,224,224,174,224,224,186,224,174,224,232,58
	!byte 96,230,224,223,95,174,223,223,233,233,233,233,116,230,230,232,212,232,174,102,230,232,230,102,232,230,224,232,232,232,232,174,224,224,224,224,224,232,58,96
	!byte 96,34,230,232,223,95,174,197,196,196,196,197,96,230,230,230,230,102,230,232,230,230,230,230,230,230,220,232,96,96,96,230,232,232,232,232,232,44,96,96
	!byte 96,96,96,96,96,96,95,232,230,230,230,105,96,96,96,104,104,230,230,232,232,232,230,230,232,230,230,104,46,96,96,96,96,96,96,96,96,96,96,96
; Color data
	!byte 12,0,12,4,4,4,4,4,4,4,4,11,4,4,4,15,15,3,15,3,3,14,3,14,14,14,6,0,0,6,0,0,5,3,3,3,0,0,11,12
	!byte 1,1,1,1,1,1,1,1,14,1,1,1,14,1,10,15,14,14,14,14,14,14,14,14,14,14,6,3,3,0,0,3,3,3,3,3,3,3,0,12
	!byte 7,7,7,7,7,1,7,1,14,1,1,1,14,1,4,14,6,6,6,6,6,6,6,6,6,6,6,3,3,3,3,3,3,3,3,3,3,3,5,13
	!byte 12,0,0,6,3,3,3,3,3,3,3,6,15,15,15,11,6,6,6,11,11,1,11,11,6,6,11,11,3,3,3,3,3,3,3,3,3,3,13,13
	!byte 12,0,3,3,3,3,3,3,3,3,12,12,12,12,12,11,11,11,9,8,8,8,8,8,11,11,11,12,12,12,3,3,3,3,3,3,3,13,13,5
	!byte 10,10,10,10,10,10,10,10,11,11,12,12,12,12,12,12,12,11,8,8,8,8,8,8,8,11,12,12,12,12,12,10,10,10,10,3,13,13,5,5
	!byte 12,4,4,4,4,4,4,11,12,15,12,12,11,8,8,8,11,8,8,8,8,8,8,8,8,8,11,12,12,12,12,12,4,4,13,13,13,5,5,5
	!byte 12,5,5,5,5,11,12,15,15,12,11,8,8,8,8,8,8,11,12,8,8,9,8,8,8,11,11,11,12,15,12,12,12,12,13,5,5,5,5,5
	!byte 12,5,5,11,11,15,15,15,12,11,8,8,8,8,8,8,9,9,8,8,9,9,8,9,9,11,11,12,12,15,15,12,12,12,12,12,5,5,5,5
	!byte 12,5,11,12,15,15,15,12,12,11,8,8,8,8,8,8,8,8,8,12,8,8,8,8,8,11,11,12,15,15,15,15,12,12,12,12,12,12,12,12
	!byte 3,11,12,15,15,15,12,12,11,11,8,8,8,8,8,2,8,9,8,8,8,8,8,8,8,9,11,12,15,15,15,12,12,11,11,11,11,11,11,13
	!byte 11,11,12,15,15,15,12,11,11,11,11,11,8,8,8,8,7,9,8,8,8,8,8,8,8,8,11,12,12,15,12,12,11,13,13,13,13,13,13,13
	!byte 11,11,12,12,12,15,15,15,15,11,11,11,11,11,11,9,9,8,8,8,12,8,8,8,8,8,8,11,12,12,12,11,13,13,13,13,13,13,13,13
	!byte 11,11,12,11,11,12,15,15,15,15,12,12,11,11,11,9,8,8,8,8,8,9,8,8,8,8,8,11,12,12,11,3,13,13,13,13,13,13,13,13
	!byte 11,11,11,11,10,12,15,15,15,15,13,12,11,11,5,9,8,8,8,8,8,8,9,8,8,8,8,11,11,11,11,5,5,5,5,5,5,5,5,13
	!byte 11,11,11,11,11,11,12,15,15,15,15,13,11,5,5,5,9,8,8,8,8,8,9,8,8,8,8,11,11,11,11,5,5,5,5,5,5,5,13,13
	!byte 11,11,12,11,11,11,11,12,15,15,15,11,5,5,5,5,8,8,8,8,8,8,8,8,8,8,11,11,11,11,5,5,5,5,5,5,13,13,13,13
	!byte 11,11,12,11,15,2,11,11,11,12,12,11,5,5,5,5,5,9,9,8,8,8,8,8,8,9,11,11,11,11,5,5,5,5,13,13,13,13,13,13
	!byte 5,11,12,12,9,15,2,11,11,11,11,11,5,5,5,5,5,9,8,8,8,9,9,9,9,5,5,11,5,5,5,13,13,13,13,13,13,13,13,13
	!byte 5,11,11,12,2,5,15,2,9,10,10,2,5,5,5,5,8,8,8,8,8,9,9,9,9,5,5,5,5,5,13,13,13,13,13,13,13,13,13,5
	!byte 5,5,11,11,12,2,11,11,11,11,9,5,5,5,5,8,8,8,8,8,8,9,8,9,9,5,5,5,5,13,13,13,13,13,13,13,13,13,5,5
	!byte 5,5,5,11,11,12,10,11,11,11,11,9,5,5,8,8,8,8,8,8,8,8,8,8,9,5,5,5,5,5,13,13,13,13,13,13,13,13,5,5
	!byte 5,5,5,5,11,11,12,2,2,10,2,9,11,5,9,8,8,8,8,8,5,5,5,9,5,5,5,5,5,5,5,5,5,13,13,13,13,5,5,12
	!byte 5,5,5,5,5,11,11,12,15,15,12,11,11,5,5,5,5,9,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,12
	!byte 5,5,5,5,5,5,11,11,11,11,11,11,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,8,8,8,8,8,5,5,12