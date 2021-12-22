; homedelta.g
; Called to home all towers on a delta printer
; To support G32 autocal, we leave the carriages stopped at their endstops
;  * https://duet3d.dozuki.com/Wiki/Calibrating_a_delta_printer#Section_Homing_the_machine

G91                                  ; Set relative positioning
G1   S1   X705  Y705  Z705  F3200    ; Move all towers to the upper endstops
G1   S2   X-5   Y-5   Z-5   F1000    ; Go down a few mm to do a second pass
G1   S1   X10   Y10   Z10   F120     ; Move all towers up slowly
G90                                  ; Set absolute positioning

M98  Pdeployprobe.g                  ; deploy mechanical Z probe
M98  Pretractprobe.g                 ; retract mechanical Z probe
