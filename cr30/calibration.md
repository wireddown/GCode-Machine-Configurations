# Calibration

After updating to version `2.1.2.1`.

## Squaring the belt to the X axis

Also more commonly called bed leveling 🙃

1. Install the conveyor belt bed assembly
1. Turn all knobs all the way clockwise so the bed carriage is fully flush with the conveyor frame
   - ⤵️ CW lowers the bed
   - ⤴️ CCW raises the bed
   - 🫙 Like opening a screw top container
1. Set the position of Y axis optical endstop
   - Loosen the four retaining screws by a half turn
   - Loosen the positioning screw until its free
   - Tighten the positioning screw until the retaining screws move at least 1 mm
   - Tighten the retaining screws
   - A higher endstop position causes the nozzle to home higher, which is safer for the belt
1. Set the position of Y axis physical endstops
   - Move the hotend carriage down the Y axis until the nozzle touches the bed
   - Loosen the retaining screws for the left side physical endstop
   - Lift the endstop until it pinches the gap gauge against the Y axis roller carriage
   - Tighten the retaining screws for the physical endstop
   - Similarly, use the gap gauge to set the position of the right side physical endstop
1. Auto home
   - Screen :: Motion :: Auto home
   - Confirm the nozzle homes above the belt
1. Physically level the print bed
   1. Move nozzle along X to both ends of the axis
      - `G0 X0`
      - `G0 X220`
   1. Move nozzle down along Y until it touches the bed
   1. Track the end with the highest bed position
   1. Turn the knob on the lowest end CCW to raise the bed until the nozzle catches the gap gauge
   1. Turn the knob on the other end CCW to raise the bed until the nozzle catches the gap gauge
   1. Confirm the nozzle also catches the gap gauge when it's at the center of the belt
   1. Goal: All three positions catch the gap gauge equally
   1. Once the nozzle-side knobs are set, adjust the exit-side knobs until the bed carriage is level with the conveyor frame
1. Print some test patterns to determine the correct home offset for good belt adhesion
   - Wide boxes show high and low spots fairly well
   - Change the Y axis home offsets between trial prints to find the best adhesion
     - Auto home
     - Move Y axis down to -0.100 mm
     - Set home offsets
     - Save configuration
     - Power cycle the printer
     - Auto home
     - Confirm new Y home offset
     - Repeat until good belt adhesion
     - To reset the home offsets, auto home and then set them without moving the nozzle

## Z axis calibration

1. Slice a block that measures 100 mm long, 20 mm wide, and 5 mm tall
1. Measure Z axis scaling
   1. Print the block
   1. Measure its length
   1. Estimate new Z steps coefficient
      - `new_z_steps = old_z_steps * (100 / measured_z_length)`
   1. Set new Z steps coefficient
   1. Repeat until the block's length is 100 mm
1. Example G-code loop
   ```
   M92 Z1148.4      ; Begin loop: Set Z axis steps
   ; (human action) ;   Print the block and measure its length
   ```
   - For my CR-30, value was unchanged `1148.4`

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

- NAK 3D Designs ▶️ [3DPrintMill aligning Y-axis stop switch, bed leveling and setting Y-offset](https://youtu.be/3c2PW5GNZrE)
- GridSpace ▶️ [CR-30 Belt Leveling with Looping GCode](https://youtu.be/PYmVhtjwH9Q)
- GridSpace ▶️ [CR-30 Belt Leveling Front to Back](https://youtu.be/CvUnHj6OMWo)
- GrideSpace/BeltPrinting 📖 [Belt Adhesion](https://github.com/GridSpace/BeltPrinting/wiki/Belt-Adhesion)
- GridSpace/BeltPrinting 📖 [Z-Steps](https://github.com/GridSpace/BeltPrinting/wiki/Z-Steps)
- NAK 3D Designs 📖 [Z Axis Calibration Thing](https://www.thingiverse.com/thing:4794626)
- GridSpace/BeltPrinting 📖 [E-Steps](https://github.com/GridSpace/BeltPrinting/wiki/E-Steps)
