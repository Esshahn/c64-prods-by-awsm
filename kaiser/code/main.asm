;===================================
; main.asm triggers all subroutines 
; and runs the Interrupt Routine
;===================================

main      sei               ; set interrupt disable flag

          jsr clear_screen  ; clear the screen
          lda #$00          ; GODDAMN 00 FOR THE SID INIT!!!! NEVER FORGET AGAIN!!! DAMN!!11
          jsr init_sid      ; init music routine 
          jsr petscii
          jsr init_scroll
          jsr alien_init

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

          lda #$0c    ; set border to grey color
          sta $d020
          sta $d021

          lda #$0b                    ; outputs "kaiser"
          sta screen_ram+17*$28+14
          lda #$01
          sta screen_ram+17*$28+16
          lda #$09
          sta screen_ram+17*$28+18
          lda #$13
          sta screen_ram+17*$28+20
          lda #$05
          sta screen_ram+17*$28+22
          lda #$12
          sta screen_ram+17*$28+24

          cli         ; clear interrupt disable flag
          jmp *       ; infinite loop


;================================
; Our custom interrupt routines 
;================================

irq        dec $d019          ; acknowledge IRQ / clear register for next interrupt
           jsr play_sid       ; jump to play music routine
           jsr check_keyboard ; check keyboard controls
           jsr scroll
           jsr alien_groove

           ; rasters
           
           ldy #$0c
           lda #$20       
           cmp $d012
           bne *-3
           sty $d020
           sty $d021
       
           ldy #$07
           lda #$af      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           ldy #$02
           lda #$d0      
           cmp $d012
           bne *-3
           sty $d020
           sty $d021

           jmp $ea31      ; return to Kernel routine
