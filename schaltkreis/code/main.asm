;===================================
; main.asm triggers all subroutines 
; and runs the Interrupt Routine
;===================================

main      sei               ; set interrupt disable flag

          jsr clear_screen  ; clear the screen
          lda #$00          ; GODDAMN 00 FOR THE SID INIT!!!! NEVER FORGET AGAIN!!! DAMN!!11
          tax
          tay
          jsr init_sid      ; init music routine 
          jsr petscii
          jsr init_scroll
          jsr flashy_init
          ldy #$7f    ; $7f = %01111111
          sty $dc0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
          sty $dd0d   ; Turn off CIAs Timer interrupts ($7f = %01111111)
          lda $dc0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
          lda $dd0d   ; by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
           
          lda #$01    ; Set Interrupt Request Mask...
          sta $d01a   ; ...we want IRQ by Rasterbeam (%00000001)

          lda #<irq   ; point IRQ Vector to our custom irq routine
          ldx #>irq 
          sta $0314    ; store in $314/$315
          stx $0315   

          lda #$00    ; trigger interrupt at row zero
          sta $d012

          lda #$00    ; set border to blue color
          sta $d020

          cli         ; clear interrupt disable flag
          jmp *       ; infinite loop


;================================
; Our custom interrupt routines 
;================================

irq        dec $d019          ; acknowledge IRQ / clear register for next interrupt
           jsr play_sid       ; jump to play music routine
           
           jsr check_keyboard ; check keyboard controls
           jsr play_scroll
           jsr flashy


;=============================
; Open Top/Bottom borders
;=============================

           lda #$00       ; clear potential garbage in $3fff
           sta $3fff

           ldy #$0b
           lda #$5e       
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$00
           lda #$60      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$0b
           lda #$66      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$00
           lda #$68      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ; second rasters

           ldy #$0b
           lda #$c5      
           cmp $d012
           bne *-3
           nop
           nop
           nop
           nop
           nop
            nop
           nop
           nop
           nop
          nop
           nop
           nop
           nop          
           nop
           nop
           nop
           nop
           nop
           nop
           nop
          nop
           nop
           nop
           nop          
           nop
           nop
           nop
           sty $d020
           sty $d021

           ldy #$00
           lda #$c8      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$0b
           lda #$d6       
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$00
           lda #$d8      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ; third

           ldy #$0b
           lda #$e6       
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$00
           lda #$e8      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021


           lda #$f9       ; wait until Raster Line 249
           cmp $d012
           bne *-3

           lda $d011      ; Trick the VIC and open the border
           and #$f7
           sta $d011

           lda #$ff       ; Wait until Raster Line 255
           cmp $d012
           bne *-3

           lda $d011      ; Reset bit 3 for the next frame
           ora #$08
           sta $d011

           jmp $ea31      ; return to Kernel routine
