alien_init
          lda #$00      ; init tick and tock
          sta tick
          lda #$aa
          sta tock
          rts

alien_groove

           lda tick
           cmp #21        ; the smaller this gets, the faster it changes
           beq groove
           inc tick
           rts

groove   
          ; toggle between two possible values
          ; and compare to trigger one of the two animations 
          lda #$00
          sta tick
          lda tock          
          cmp #$aa
          beq anima
          jmp animb

anima
          ldx #$30
          stx $d001
          ldx #$5a
          stx $d003
          ldx #sprite_pointer_2
          stx screen_ram + $3fa 
          jmp end

animb
          ldx #$31
          stx $d001
          ldx #$5b
          stx $d003
          ldx #sprite_pointer_3
          stx screen_ram + $3fa 
          jmp end

end
          
          eor #$ff        ; toggle flag
          sta tock
          rts


