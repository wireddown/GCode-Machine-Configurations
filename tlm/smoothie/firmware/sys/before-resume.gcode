; before-resume.gcode

G90                ; Set absolute coorindates...
M83                ;     but keep extruder relative
G1   E5  F100      ; Prime the nozzle
G92  E0            ; Reset the extruder
G0   F2400         ; Set speed for next move back to the pause-coordinate
