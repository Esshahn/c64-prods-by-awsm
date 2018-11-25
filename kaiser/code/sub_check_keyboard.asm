
;===============================
; check for a single key press
;===============================


check_keyboard              

                        lda #%11111111  ; CIA#1 Port A set to output 
                        sta ddra             
                        lda #%00000000  ; CIA#1 Port B set to inputt
                        sta ddrb             
            
check_space             lda #%01111111  ; select row 8
                        sta pra 
                        lda prb         ; load column information
                        and #%00010000  ; test 'space' key to exit 
                        beq exit_to_basic                        
                        rts             ; return     

exit_to_basic           lda #$00
                        sta $d015        ; turn off all sprites
                        sta $d01a        ; and disable raster interrupt
                              
goload
                        lda #$00
                        lda #fnameend-fname
                        ldx #<fname
                        ldy #>fname
                        jsr $FFBD     ; call SETNAM

                        lda #$01
                        ldx $BA       ; last used device number
                        bne skip
                        ldx #$08      ; default to device 8
skip                    ldy #$01      ; not $01 means: load to address stored in file
                        jsr $FFBA     ; call SETLFS

                        lda #$00      ; $00 means: load to memory (not verify)
                        jsr $FFD5     ; call LOAD
                        bcs error    ; if carry set, a load error has happened
                        
                        stx $2d ; Neu!
                        sty $2e ; Neu!
                        
                        jsr $e453 ; prepare BASIC pointers for RUN 
                        jsr $a660 ;
                        jsr $a68e ; RUN
                        jmp $a7ae ;

error
        ; Accumulator contains BASIC error code

        ; most likely errors:
        ; A = $05 (DEVICE NOT PRESENT)
        ; A = $04 (FILE NOT FOUND)
        ; A = $1D (LOAD ERROR)
        ; A = $00 (BREAK, RUN/STOP has been pressed during loading)

                        dec $d020  
                        sta $0401        ; error code ausgeben  

fname  
!scr "DATA"
fnameend
