; homedelta.g
; Called to home all towers on a delta printer.
; To support G32 autocal (as written in bed.g), we leave the carriages stopped at
; their endstops so that we can meet the G30 command's preconditions to probe the Z-level.
;    - https://duet3d.dozuki.com/Wiki/Calibrating_a_delta_printer#Section_Homing_the_machine

G91                                  ; Set relative positioning
G0   S1   X300  Y300  Z300  F4800    ; Move all towers to the upper endstops
G0   S1   X405  Y405  Z405  F2400    ; Move all towers to the upper endstops
G0   S2   X-4   Y-4   Z-4   F1200    ; Go down a few mm to do a second pass
G0   S1   X10   Y10   Z10   F60      ; Move all towers up slowly
M400                                 ; Wait for all moves to complete
G90                                  ; Set absolute positioning

M401                                 ; Deploy Z probe
M402                                 ; Retract Z probe
