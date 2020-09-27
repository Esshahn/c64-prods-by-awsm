; c128 The Goblins Duo Basic Demo
; Rasterbar Interrupt Routine
;
; sys 4864


* = $1300

        sei         ; disable all interrupts so we can change them
        lda #<irq   ; low byte of the raster code address we want to use
        sta $0314   ; store low byte in interrupt vector
        lda #>irq   ; high byte of the raster code address we want to use
        sta $0315   ; store high byte in the interrupt vector
        cli         ; enable interrupts again
        rts         ; return to BASIC again

irq 
        inc $d020   ; decrease border color 
 
        !for loop, 0, 90 {
		nop         ; generate NOPs
        }

        bne irq     ; not 0 yet? jump to start of irq           
        jmp $fa65   ; we're done