
init_koala	 
			
			;put this inside irq if used, else just do it
            ;KOALA PIC 2000
            lda $dd00 
            and #%11111100
            ora #%00000010 ;vic bank 3 (they go 3-2-1-0, so $6000 is #2)
            sta $dd00
            lda $d016
            ora #$10
            sta $d016
            LDA #$19
            STA $D018
            lda #$3b
            sta $d011

			ldx #$00 


KOALARE
			lda $3f40+PIC_ADD,x ;add +$4000 on these to setup for $6000
			sta $0400+PIC_ADD,x
			lda $4040+PIC_ADD,x
			sta $0500+PIC_ADD,x
			lda $4140+PIC_ADD,x
			sta $0600+PIC_ADD,x
			lda $4228+PIC_ADD,x
			sta $06e8+PIC_ADD,x

			lda $4328+PIC_ADD,x ;add +$4000 for these to setup at $6000
			sta $d800,x
			lda $4428+PIC_ADD,x
			sta $d900,x
			lda $4528+PIC_ADD,x
			sta $da00,x
			lda $4610+PIC_ADD,x
			sta $dae8,x
			dex
			bne KOALARE

			lda $4710+PIC_ADD
			sta $d021
			
			; 
			; Bitmap Mode On 
			; 
			lda #$3b 
			sta $d011 

			; 
			; MultiColor On 
			; 
			lda #$d8 
			sta $d016 


			lda $d018
			and #240
			ora #8	;0-2-4-6-8-10-12-14 : 0000-07ff, 0800-0fff, 1000-17ff, 1800-1fff
			;	2000-27ff, 2800-2fff, 3000-37ff, 3800-3fff
			sta $d018

          	rts


