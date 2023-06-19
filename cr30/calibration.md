# Calibration

After updating to version `2.1.2.1`.

## Z

- Printed 100 mm long block
- Measured 100.0 mm

## Hotend

- `M303 C5 S220`
- `bias: 98 d: 98 min: 216.16 max: 223.02 Ku: 36.35 Tu: 19.36`
  ```c
  #define DEFAULT_Kp 21.81
  #define DEFAULT_Ki 2.25
  #define DEFAULT_Kd 52.78
  ```

## E

- Enable cold extruder moves
- **Retract** 100 mm
- Measure result
- G-code
  ```
  M302 P1       ; Enable code extruder moves
  M92 E138.0    ; Set extruder steps
  G92 E0        ; Set E position to 0
  G0 E-15 F400  ; Retract 15 mm, then mark filament with a marker
  G0 E-115      ; Retract 100 mm, then mark filament with a marker againg
  G0 E-130      ; Retract another 15 mm, then cut filament and measure
  ```
- Looped and arrived at `138.8`
