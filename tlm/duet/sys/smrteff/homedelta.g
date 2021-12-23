; homedelta.g
; Called to home all towers on a delta printer.
; To support G32 autocal (as written in bed.g), we leave the carriages stopped at
; their endstops so that we can meet the G30 command's preconditions to probe the Z-level.
;    - https://duet3d.dozuki.com/Wiki/Calibrating_a_delta_printer#Section_Homing_the_machine

G91                                  ; Set relative positioning

G0   S1   X50   Y50   Z50   F1200    ; Short and slow in case close to ceiling
G0   S1   X300  Y300  Z300  F4800    ; Speed up since we're further
G0   S1   X405  Y405  Z405  F2400    ; Slow down as we approach
G0   S2   X-10  Y-10  Z-10  F1200    ; Go down a few mm to do a second pass

G0   S1   X6    Y6    Z6    F160     ; Move all towers up slowly - stops at first tower home
M400                                 ; Wait for all moves to complete
G0   S1   X6    Y6    Z6    F160     ; Move all towers up slowly - stops at second tower home
M400                                 ; Wait for all moves to complete
G0   S1   X6    Y6    Z6    F160     ; Move all towers up slowly - stops at third tower home
M400                                 ; Wait for all moves to complete

G90                                  ; Set absolute positioning
