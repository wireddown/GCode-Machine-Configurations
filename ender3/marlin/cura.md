# Cura

## Stock hotend

### Start G-code

```
G28      ; Home all axes
```

### End G-code

```
G91               ; Relative positioning
G1 E-2 F2700      ; Retract a bit
G1 E-2 Z0.5 F2400 ; Retract and raise Z
G1 X5 Y5 F3000    ; Wipe out
G1 Z10            ; Raise Z more
G90               ; Absolute positioning

G1 X0 Y{machine_depth}      ; Present print
M106 S0           ; Turn-off fan
M104 S0           ; Turn-off hotend
M140 S0           ; Turn-off bed

M84 X Y E         ; Disable all steppers but Z
```

## Hemera hotend

See [upgrade e3d hemera](./upgrade-e3d-hemera.md)
