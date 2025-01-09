; bed.g
; called to perform automatic delta calibration via G32
; Grids from https://configtool.reprapfirmware.org/
;   Choose a bed radius and calibration factor
;     4 factor: XYZ endstops + radius
;     6 factor: + XY towers
;     8 factor: + XY tilts

M98 P"bed-begin.g"

M98 P"bed-12x6x140.g"

G30 P18  X0        Y0        Z-99999 S6

; Load the grid-leveling height map
G29  S1
