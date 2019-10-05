alien_init
          lda #$00      ; init tick and tock
          sta tick
          lda #$a0
          sta tock
          rts

alien_groove

           lda tick
           cmp #23        ; the smaller this gets, the faster it changes
           beq groove
           inc tick
           rts

groove   
          ; toggle between two possible values
          ; and compare to trigger one of the two animations 
          lda #$00
          sta tick
          lda tock          
          cmp #$a0
          beq anima
          jmp animb

anima
          ldx #$30+60
          stx $d001
          ldx #$5a+60
          stx $d003
          ldx #sprite_pointer_2
          stx screen_ram + $3fa 
          jmp end

animb
          ldx #$32+60
          stx $d001
          ldx #$5c+60
          stx $d003
          ldx #sprite_pointer_3
          stx screen_ram + $3fa 
          jmp end

end
          
          eor #$ff        ; toggle flag
          sta tock
          rts


