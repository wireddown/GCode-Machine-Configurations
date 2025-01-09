; resume.g
; called before a print from SD card is resumed

G1   R1  X0  Y0  Z9  F2000   ; go to Z mm above position of the last print move
G1   R1  X0  Y0      F900    ; go back to the last print move

M83                          ; relative extruder moves
G1   E2  F180                ; extrude filament
