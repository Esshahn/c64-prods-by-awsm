
                
init_scroll              
                 lda #<message
                 ldy #>message
                 sta read+1
                 sty read+2
                 lda #<interrupt1
                 ldx #>interrupt1
                 
                 sta $314
                 stx $315
                
                 lda #$7f       ; cancel and turn off CIA timer
                 sta $dc0d      ;
                
                 lda #$01       ; enable raster interrupt
                 sta $d01a      ;

                lda #$18        ; fire raster interrupt 
                sta $d012       ; when line reached

                 rts


interrupt1       inc $d019      ; clear interrupt
                
                            ; shameful part where I need to waste
                            ; clock cycles to make the jittter go way

                nop 
                nop
                bit $ea    ;waste 3 cycles
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;waste 3 cycles
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;waste 3 cycles
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3
                bit $ea    ;3

                 ldy #$1b        ; set display to bitmap mode
                 sty $d011       ;
                 lda #$00 
                 sta $d012
                 lda smooth ;Scroll section
                 sta $d016
                lda #$14
                sta $d018
                 lda #<interrupt2
                 ldx #>interrupt2
                 sta $314
                 stx $315

                lda #$00        ; background color = black
                sta $d021       ;
                jsr colwash
                jsr colwash2
               
                 jmp $ea7e

interrupt2       inc $d019
               
                 ldy #$3b       ; set display to 40 chars text mode
                 sty $d011      ;

                 lda #$f0
                 sta $d012
                 lda #$d8 ;No scroll section here
                 sta $d016
                 lda #<interrupt1
                 ldx #>interrupt1
                 sta $314
                 stx $315
                 jsr scroll         
               
                lda #$18
                sta $d018

                lda #$06        ; background color = blue
                sta $d021       ;

                 jsr sid_play
                 jmp $ea7e
                 
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


message          !scr "this is a test scroller, hope it is working now.. "
                 !scr "original scroller by tnd. just some basic text to "
                 !scr "fill some space. "
                 !byte 0