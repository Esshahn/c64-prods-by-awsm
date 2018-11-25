
init_koala	 
			

            lda $d016
            ora #$10
            sta $d016
            lda #$19
            sta $D018
            lda #$3b
            sta $d011

			ldx #$00 

			KOALARE
			lda $3f40,x 
			sta $0400,x
			lda $4040,x
			sta $0500,x
			lda $4140,x
			sta $0600,x
			lda $4228,x
			sta $06e8,x

			lda $4328,x 
			sta $d800,x
			lda $4428,x
			sta $d900,x
			lda $4528,x
			sta $da00,x
			lda $4610,x
			sta $dae8,x
			dex
			bne KOALARE

			lda $4710
			sta $d021
			lda #$00
			sta $d020
			
			lda $d018
			and #240
			ora #8	;0-2-4-6-8-10-12-14 : 0000-07ff, 0800-0fff, 1000-17ff, 1800-1fff
			;	2000-27ff, 2800-2fff, 3000-37ff, 3800-3fff
			sta $d018

          	rts


