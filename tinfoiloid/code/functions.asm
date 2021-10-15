
;
;   general functions
;
;
;


_fill_colram:
; takes A as color to fill
                ldx #250                        
-                     
                sta COLORRAM-1,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+249,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+499,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+749,x                   ; und A ins COLRAM and Pos Y
                dex                                 ; Ende ?
                bne -                               ; nein
                rts

_fill_scrram:
; takes A as char to fill

                ldx #250                
-                       
                sta SCREENRAM-1,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+249,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+499,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+749,x                   ; und A ins COLRAM and Pos Y
                dex                                 ; Ende ?
                bne -                               ; nein
                rts

_clear:
                lda #$0
                ldx #250                        
-                     
                sta COLORRAM-1,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+249,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+499,x                   ; und A ins COLRAM and Pos Y
                sta COLORRAM+749,x                   ; und A ins COLRAM and Pos Y

                sta SCREENRAM-1,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+249,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+499,x                   ; und A ins COLRAM and Pos Y
                sta SCREENRAM+749,x                   ; und A ins COLRAM and Pos Y

                dex                                 ; Ende ?
                bne -                               ; nein
                rts