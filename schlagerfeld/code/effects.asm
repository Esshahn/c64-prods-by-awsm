
effects:
          lda $d416
          cmp #$0f
          bne +
          lda scrolltemp
          cmp #$c0
          beq momo
          lda #$c0
          sta scrolltemp
          jmp +
momo:
          lda #$c4
          sta scrolltemp

+:
          lda scrolltemp
          sta $d016
          

theend:
          rts

scrolltemp: 
!byte $c0
