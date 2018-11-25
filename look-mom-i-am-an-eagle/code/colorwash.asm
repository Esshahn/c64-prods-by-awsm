;============================================================
; color washer routine
;============================================================



;============================================================
; color scroll inside logo
;============================================================

colwash    lda colorlogo+$00      ; load the current first color from table
           sta colorlogo+$78      ; store in in last position of table to reset the cycle
           ldx #$00           ; init X with zero
           ldy #$00

cycle1     lda colorlogo+1,x      ; Start cycle by fetching next color in the table...
           sta colorlogo,x        ; ...and store it in the current active position.
           sta colramlogo,y

           iny
           cpy #$27
           bne continue
           ldy #$00

continue   inx                ; increment X-Register
           cpx #$78           ; are we through with all iterations yet?
           bne cycle1         ; if no, continue

           rts                ; return from subroutine


;============================================================
; color scroll for scroller
;============================================================


colwash2   lda colorscroll+$00      ; load the current first color from table
           sta colorscroll+$50      ; store in in last position of table to reset the cycle
           ldx #$00           ; init X with zero
           ldy #$00

cycle2     lda colorscroll+1,x      ; Start cycle by fetching next color in the table...
           sta colorscroll,x        ; ...and store it in the current active position.
           sta colramscroll,y

           iny
           cpy #$27
           bne continue1
           ldy #$00

continue1  inx                ; increment X-Register
           cpx #$50           ; have we done 40 iterations yet?
           bne cycle2         ; if no, continue

           rts                ; return from subroutine