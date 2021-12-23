; after-pause.gcode

G91                    ; Set relative coorindates
G0   Z20  E-5  F4800   ; Raise the nozzle and retract
G90                    ; Set absolute coorindates...
M83                    ;     but keep extruder relative
G92  E0                ; Reset the extruder
