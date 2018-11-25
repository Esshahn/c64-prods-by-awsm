; color data table
; first 9 rows (40 bytes) are used for the color washer
; on start the gradient is done by byte 40 is mirroed in byte 1, byte 39 in byte 2 etc... 

color        !byte $09,$09,$02,$02,$08 
             !byte $08,$0a,$0a,$0f,$0f 
             !byte $07,$07,$01,$01,$01 
             !byte $01,$01,$01,$01,$01 
             !byte $01,$01,$01,$01,$01 
             !byte $01,$01,$01,$07,$07 
             !byte $0f,$0f,$0a,$0a,$08 
             !byte $08,$02,$02,$09,$09 

color2       !byte dark_grey, dark_grey, dark_grey, dark_grey, dark_grey 
             !byte grey, grey, grey, grey, grey
             !byte light_grey, light_grey, light_grey, light_grey, light_grey
             !byte white, white, white, white, white
             !byte white, white, white, white, white
             !byte light_grey, light_grey, light_grey, light_grey, light_grey
             !byte grey, grey, grey, grey, grey
             !byte dark_grey, dark_grey, dark_grey, dark_grey, dark_grey