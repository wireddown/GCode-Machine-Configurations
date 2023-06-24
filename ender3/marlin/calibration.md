# Calibration

## Squaring the bed to the frame

1. Attach bed with knobs
   1. Turn knobs until finger snug
   1. Turn all knobs one full turn CCW
      - ⤴️ CCW lowers the bed
      - ⤵️ CW raises the bed
      - Like a volume knob for a stereo
1. Find home position Z offset
   1. This is the difference between
      - What the probe measures as 0.00 mm
      - Where the nozzle touches the bed
   1. Set Z offset to 0.00
      - Screen :: Prepare :: 🔆 Z-offset
   1. Auto home
      - Screen :: Prepare :: 🎯 Auto home
   1. Move nozzle to Z = 0.00
      - Screen :: Prepare :: 💠 Move :: Move Z
   1. Adjust Z offset until nozzle catches a sheet of paper
      - Screen :: Prepare :: 🔆 Z-offset
   1. `M114` should report `X:157.00 Y:122.00 Z:0.00 E:0.00`
   1. Redo this when the distance between probe and nozzle changes:
      - Changing nozzles
      - Replacing the probe
      - Repositioning the probe
1. Auto home
   - Screen :: Prepare :: 🎯 Auto home
   - Redo this when the physical Z = 0.00 position moves:
     - Turning knobs to reshape the bed when leveling it
1. Physically level the print bed
   1. Move nozzle along X and Y to each of the four knobs
      - `G0 Z3 X30  Y35`
      - `G0 Z3 X200`
      - `G0 Z3      Y208`
      - `G0 Z3 X30`
   1. Move nozzle down until Z = 0.00 or it touches the bed
   1. Track the knob with the highest bed position
   1. Turn the highest knob CCW to lower the bed until nozzle catches a sheet of paper when Z = 0.00
   1. Auto home and repeat until the bed settles to within 0.5 mm
   1. Goal: all five touch points, center and knobs, catch a piece of paper when Z = 0.00
1. Print some test patterns looking for first layer consistency
   - Circles and rectangles show high and low spots fairly well
   - If you make further knob adjustments, periodically auto home to remove the accumulated drift from the machine's new physical shape
   - Continue adjusting the knobs until the shapes print cleanly for their first two layers
   - If the layers are getting close but are not quite good enough, you can start a print in the problem area of the bed and _carefully_ adjust the closest knobs _live_, while the printer is running.
   - ![tiles and skirt test pattern](./example-test-print-for-bed-leveling.png)

## Finding extruder steps per mm

1. Prepare for cold retractions
   - Heat the hotend and remove the filament completely
   - Turn off the hotend so that it cools
   - Clip the end of the filament so that it is square
   - Insert the filament until it reaches the bowden coupler on the hotend
   - Clip the filament at the entrance to the extruder, leaving the filament in the bowden tube
   - During the loop below, if the filament runs out, reload more filament
1. Enable cold extruder moves
1. Measure extruder scaling
   - **Retract** 100 mm
   - Measure result
   - Calculate an estimate
     -  `new_e_steps = old_e_steps * (100 / measured_filament_length)`
   - Repeat until the extruder retracts 100 mm of filament
1. Example G-code loop
   ```
   M302 P1       ; Enable code extruder moves
   M92 E90.0     ; Begin loop: Set extruder steps
   G92 E0        ;   Set E position to 0
   G0 E-15 F400  ;   Retract 15 mm, then mark filament at the extruder entrance with a marker
   G0 E-115      ;   Retract 100 mm, then mark filament with a marker again
   G0 E-130      ;   Retract another 15 mm, then cut filament and measure
   ```

## Finding PID coefficients for heaters

Marlin firmware has a built-in [command for tuning PID coefficients](https://marlinfw.org/docs/gcode/M303.html).

1. Tune the hotend with `M303 E0 C5 S200`
1. Tune the bed with `M303 E-1 C5 S75`
