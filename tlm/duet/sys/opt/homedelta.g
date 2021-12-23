; homedelta.g
; Called to home all towers on a delta printer.
; To support G32 autocal, we leave the carriages stopped at their endstops rather
;    than move them down 5 mm to center the effector for cosmetics.
;    - https://duet3d.dozuki.com/Wiki/Calibrating_a_delta_printer#Section_Homing_the_machine

G91                                  ; Set relative positioning
G1   S1   X705  Y705  Z705  F3200    ; Move all towers to the upper endstops
G1   S2   X-3   Y-3   Z-3   F1000    ; Go down a few mm to do a second pass
G1   S1   X10   Y10   Z10   F100     ; Move all towers up slowly
G90                                  ; Set absolute positioning

M401                                 ; Deploy Z probe
M402                                 ; Retract Z probe
