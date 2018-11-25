;============================================================
; write the two line of text to screen center
;============================================================


init_text  ldx #$00          
loop_text  lda line1,x      
           sta scrram+1*line,x 
           lda line2,x     
           sta scrram+2*line,x     
           lda line3,x      
           sta scrram+3*line,x      
           lda line4,x
           sta scrram+4*line,x
           lda line5,x
           sta scrram+5*line,x
           lda line6,x
           sta scrram+8*line,x
           lda line7,x
           sta scrram+10*line,x
           lda line8,x
           sta scrram+12*line,x
           lda line9,x
           sta scrram+16*line,x
           lda line10,x
           sta scrram+17*line,x
           lda line11,x
           sta scrram+18*line,x
           lda line12,x
           sta scrram+19*line,x
           lda line13,x
           sta scrram+20*line,x
           lda line14,x
           sta scrram+21*line,x
           lda line15,x
           sta scrram+24*line,x

           inx 
           cpx #$28         
           bne loop_text 
           lda #$00   
           rts