; pause.g
; called when a print from SD card is paused

G91                ; relative positioning
M83                ; relative extruder moves
G1   E-2  F180     ; retract filament
G1   Z15  F900     ; lift Z

G90                ; absolute positioning
M83                ; relative extruder moves
G1 X0 Y0 F2000     ; go to X=0 Y=0
