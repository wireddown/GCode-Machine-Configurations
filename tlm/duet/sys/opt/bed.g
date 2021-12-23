; bed.g
; called to perform automatic delta calibration via G32
;
; Before running this, you must configure your Z-probe trigger height
; to match your physical geometry via the G31 command in config.g.

G90                    ; Use absolute coordinates
M561                   ; Clear any bed transform
M290 R0   S0           ; Clear any baby stepping
G28                    ; Home all towers
M401                   ; Deploy probe
G4   S1                ; Wait S seconds

G0   Z200 F9600        ; Dive
G0   Z70  F4200        ; Decelerate
G0   Z15  F1600        ; Move hotend to Z mm above bed
G30  S-1               ; Dummy probe to warm up the BLTouch

; Probe the bed at 12 peripheral and 3 halfway points, 
; and perform 6-factor auto compensation. 

; Grid from http://www.escher3d.com/pages/wizards/wizardbed.php
G30  P0   X0.00     Y141.175   Z-99999  H0
G30  P1   X67.12    Y125.075   Z-99999  H0
G30  P2   X121.08   Y78.725    Z-99999  H0
G30  P3   X148.68   Y0         Z-99999  H0
G30  P4   X129.90   Y-66.175   Z-99999  H0
G30  P5   X75.00    Y-121.075  Z-99999  H0
G30  P6   X0.00     Y-141.175  Z-99999  H0
G30  P7   X-75.00   Y-121.075  Z-99999  H0
G30  P8   X-129.90  Y-66.175   Z-99999  H0
G30  P9   X-148.68  Y0         Z-99999  H0
G30  P10  X-121.08  Y78.725    Z-99999  H0
G30  P11  X-67.12   Y125.075   Z-99999  H0
G30  P12  X0.00     Y68.035    Z-99999  H0
G30  P13  X62.6     Y-26       Z-99999  H0
G30  P14  X-62.6    Y-26       Z-99999  H0
G30  P15  X0        Y0         Z-99999  S6

; Load the grid-leveling height map
G29  S1
