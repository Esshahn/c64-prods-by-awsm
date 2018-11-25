message         !scr "   kaiser ! cracked by the almigty baxxter in 1986 !!! one another cool game to play on the commodore 64 !!! hpg are the coolest crackers in north germany and the whole world !!! greetings go to eaglesoft , hotline , computerclub leer , dj matrixx and me hehehe !!! contact me: plk 089101 , 2950 leer , west germany ... moin moin so jetz mal auf deutsch leude , das spiel ist ja auch auf deutsch hehehe , also keine ahnung aber ich hab das ding bestimmt schon ne woche im laufwerk , macht laune !!! gefaellt euch die hammer musik ??? written and coded by the almighty baxxter of hpg !!! so das wars jetzt von mir viel spass noch und reingehauen !!!             einen hab ich noch: kommt ein skelett in die kneipe. 'ein bier und nen aufnehmer bitte !' hahahaha !!!            "
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
nowrap           sta screenloc+$27
                 inc read+1
                 lda read+1
                 cmp #$00
                 bne endscroll
                 inc read+2
endscroll        rts

