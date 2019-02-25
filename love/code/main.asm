;===================================
; main.asm triggers all subroutines 
; and runs the Interrupt Routine
;===================================

main      sei               ; set interrupt disable flag

          jsr clear_screen  ; clear the screen
          jsr init_koala  

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

irq        
          dec $d019          ; acknowledge IRQ / clear register for next interrupt

;=============================
; Open Top/Bottom borders
;=============================

          lda #$00       ; clear potential garbage in $3fff
          sta $3fff

          lda #$03          ; cyan
          ldy #$8
          cpy $d012
          bne *-3
          sta $d020
          sta $d021

          lda #$0c          ; cyan
          ldy #$33
          cpy $d012
          bne *-3
          sta $d021

          lda #$0b          ; dark grey
          ldy #$b8
          cpy $d012
          bne *-3
          sta $d020

          lda #$0c          ; mid grey
          ldy #$ba
          cpy $d012
          bne *-3
          sta $d020

          lda #$0f          ; light grey
          ldy #$f6
          cpy $d012
          bne *-3
          sta $d020

          lda #$0b          ; dark grey
          ldy #$f8
          cpy $d012
          bne *-3
          sta $d020
          sta $d021

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

          lda #$00          ; black
          ldy #$5
          cpy $d012
          bne *-3
          sta $d021
          sta $d020


          jmp $ea31      ; return to Kernel routine


