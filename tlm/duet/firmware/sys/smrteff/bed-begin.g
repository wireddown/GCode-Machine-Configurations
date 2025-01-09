; Clear all calibration, transforms, offsets
; Move down to prepare calibration begin

G90                       ; Use absolute coordinates

M665 X0   Y0   Z0         ; Clear tower placement corrections
M666 A0   B0              ; Clear bed tilt
M561                      ; Clear any bed transform
M290 R0   S0              ; Clear any baby stepping

G28                       ; Home all towers
G4   S1                   ; Wait S seconds

G0   Z160 F9600           ; Dive
G0   Z40  F4800           ; Decelerate
G0   Z5   F1600           ; Move hotend to Z mm above bed

M99
