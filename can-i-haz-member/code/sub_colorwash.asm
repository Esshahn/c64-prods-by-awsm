;============================================================
; color washer routine
;============================================================

colwash    lda color+$00      ; load the current first color from table
           sta color+$28      ; store in in last position of table to reset the cycle
           ldx #$00           ; init X with zero

cycle1     lda color+1,x      ; Start cycle by fetching next color in the table...
           sta color,x        ; ...and store it in the current active position.
           sta colram+1*line,x
           sta colram+2*line-$2,x
           sta colram+3*line-$4,x
           sta colram+4*line-$6,x
           sta colram+5*line-$8,x
           sta colram+6*line-$9,x ; no idea why this line is fixing the color problem

           inx                ; increment X-Register
           cpx #$28           ; have we done 40 iterations yet?
           bne cycle1         ; if no, continue

colwash2   lda color2+$27     ; load current last color from second table
           sta color2+$00     ; store in in first position of table to reset the cycle
           ldx #$28

cycle2     lda color2-1,x     ; Start cycle by fetching previous color in the table...
           sta color2,x       ; ...and store it in the current active position.
           
           sta colram+17*line-4,x
           sta colram+18*line-6,x
           sta colram+19*line-8,x
           sta colram+20*line-10,x
           sta colram+21*line-12,x
           sta colram+22*line-14,x

           dex                ; decrease iterator
           bne cycle2  


hearts     lda #$0a
           sta colram+9*line+$12
           sta colram+9*line+$13
           sta colram+10*line+$12
           lda #$09
           sta colram+10*line+$0e
           sta colram+10*line+$0f
           sta colram+10*line+$1a
           sta colram+10*line+$1b
           sta colram+12*line+$10
           sta colram+12*line+$11
           sta colram+12*line+$18
           sta colram+12*line+$19
           

           rts                ; return from subroutine