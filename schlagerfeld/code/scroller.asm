message         !scr "                    wer in jogginghosen released, hat die kontrolle ueber sein leben verloren.            computer sind etwas fuer's personal.          sehe ich aus wie jemand, der coden kann? ich kann netflix starten und damit hat sich das.          ich bin umgeben von jungen und schoenen scenern. der anblick von haesslichkeit ist mir ein graus.          ich kenne triad nicht. auch claudia kennt die nicht. die waren nie in paris, die kennen wir nicht.          in der demoszene muss man staendig zerstoeren, um sich zu erneuern. das lieben, was man gehasst hat, und das hassen, was man geliebt hat.          "
                 !byte 0
                 
init_scroll
                 lda #<message
                 ldy #>message
                 sta read+1
                 sty read+2
                 rts

scroll           lda smooth
                 sec
                 sbc #$01 ;Speed of scroll can be edited to how you want it, but don't go too mad :)
                 and #$07 ;We need this to make the variable smooth into something smooth :)
                 sta smooth
                 bcs endscroll 
                 ldx #$00
wrapmessage      lda screenloc+1,x
                 sta screenloc,x
                 inx
                 cpx #$28
                 bne wrapmessage
read             lda screenloc+$27
                 cmp #$00 ;Is byte 0 (@) read?
                 bne nowrap ;If not, goto label nowrap
                 lda #<message
                 ldy #>message
                 sta read+1
                 sty read+2
                 jmp read
nowrap           
                 ;adc #$7f
                sta screenloc+$27
                 inc read+1
                 lda read+1
                 cmp #$00
                 bne endscroll
                 inc read+2
endscroll        rts

