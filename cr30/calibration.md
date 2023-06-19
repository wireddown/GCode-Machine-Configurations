# Calibration

After updating to version `2.1.2.1`.

## Z

- Printed 100 mm long block
- Measured 100.0 mm

## Extruder calibration

1. Prepare for cold retractions
   - Heat the hotend and remove the filament completely
   - Turn off the hotend so that it cools
   - Clip the end of the filament so that it is square
   - Insert the filament until it reaches the bowden coupler on the hotend
   - Clip the filament between the extruder and runout sensor
   - During the loop below, if the filament runs out, reload more filament
1. Enable cold extruder moves
1. Measure extruder scaling
   - **Retract** 100 mm
   - Measure result
   - Set new extruder steps coefficient
     - Increase the value if the measurement was less than 100 mm
     - Decrease the value if the measurement was greater than 100 mm
     - Increase or decrease the value by 5 until the measurement crosses 100 mm
     - Then increase or decrease by half for each additional crossing
   - Or calculate an estimate
     -  `new_e_steps = old_e_steps * (100 / measured_filament_length)`
   - Repeat until the extruder retracts 100 mm of filament
1. Example G-code loop
   ```
   M302 P1       ; Enable code extruder moves
   M92 E138.0    ; Begin loop: Set extruder steps
   G92 E0        ;   Set E position to 0
   G0 E-15 F400  ;   Retract 15 mm, then mark filament at the extruder entrance with a marker
   G0 E-115      ;   Retract 100 mm, then mark filament with a marker again
   G0 E-130      ;   Retract another 15 mm, then cut filament and measure
   ```
   - For my CR-30, arrived at `138.8`

## Hotend control loop calibration

- `M303 C5 S220`
- `bias: 98 d: 98 min: 216.16 max: 223.02 Ku: 36.35 Tu: 19.36`
  ```c
  #define DEFAULT_Kp 21.81
  #define DEFAULT_Ki 2.25
  #define DEFAULT_Kd 52.78
  ```

## References

- [GridSpace/BeltPrinting Wiki Z-Steps](https://github.com/GridSpace/BeltPrinting/wiki/Z-Steps)
- [NAK3DDesigns Z Axis Calibration Thing](https://www.thingiverse.com/thing:4794626)
- [GridSpace/BeltPrinting Wiki E-Steps](https://github.com/GridSpace/BeltPrinting/wiki/E-Steps)
