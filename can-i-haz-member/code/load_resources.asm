; load sid music

* = address_music                         ; address to load the music data
!bin "resources/Big_Funk.sid",, $7c+2  ; remove header from sid and cut off original loading address 
