# Ender 3

- [Product page](https://www.creality.com/pages/download-ender-3)
- Marlin Firmware [G Codes](https://marlinfw.org/meta/gcode/)
- Background on [main board and LCD screen](https://www.youtube.com/watch?v=neS7lB7fCww)
- Ender 3 is a 24V system

## E3D Hemera

- Direct drive extruder
  - Easier to change filament
  - Allows flexible filaments
  - More precise, shorter extrusions and retractions
  - Can use less powerful motor
  - No PTFE tube resistance or pressure between gears and nozzle
- All metal hotend
  - No PTFE tube maintenance
  - Allows higher temperatures
  - Smaller, more controlled heating zone improves short retractions and reduces oozing

## References

- Official E3D
  - [Hemera assembly instructions](https://e3d-online.zendesk.com/hc/en-us/articles/360017204078-Hemera-Direct-Assembly-Guide-New-)
  - [Hemera installation instructions](https://e3d-online.zendesk.com/hc/en-us/articles/360018062117-Hemera-Ender-3-V2-Ender-3-CR10-CR10-V2-Upgrade-Guide-Edition-2-)
  - [Marlin Ender 3 V2 firmware guide](https://e3d-online.zendesk.com/hc/en-us/articles/360017968457-Hemera-Creality-Ender-3-V2-Firmware-Bl-touch-)
  - [Marlin 2.0 firmware guide](https://e3d-online.zendesk.com/hc/en-us/articles/4406823770769-Marlin-2-0-Hemera-Guide)
  - [Extruder calibration](https://e3d-online.zendesk.com/hc/en-us/articles/4404490769169-Hemera-E-Steps-per-mm-Calibration-)
  - [Hotend calibration](https://e3d-online.zendesk.com/hc/en-us/articles/360014865438-Hemera-Marlin-PID-Guide)
  - [Hemera slicer settings](https://e3d-online.zendesk.com/hc/en-us/articles/360018055797-Hemera-Troubleshooting-Guide-#h_01F00YWJ3G8PTJH0321QZ0RBY2)
- All 3DP
  - [Extruder explanation](https://all3dp.com/2/direct-vs-bowden-extruder-technology-shootout/)
- 3D Insider
  - [Hotend explanation](https://3dinsider.com/all-metal-hot-end/)

## Installation

### First-pass firmware changes

1. Set the sensor type for `TEMP_SENSOR_0`
1. Set the new `HEATER_0_MAXTEMP`
1. Set the new `HEATER_0_MINTEMP`
1. Set the new steps-per-mm for E `DEFAULT_AXIS_STEPS_PER_UNIT`
1. Set the new `E0_CURRENT`
1. Measure the extruder steps per mm
   - E100 was 102mm
1. Correct the extruder steps per mm
   - `(L / L0) = (400 / X)` where L0 = 100, L = 102
   - `X = 400 * L0 / L`
   - X = 392

### Assemble the Hemera

1. Screw nozzle into heater block
1. Screw heat break into heater block
1. Install thermistor and heater
1. Screw hotend into main assembly
1. Install the cooling fan
1. Connect wiring
1. Hot tighten the nozzle

### Install the Hemera

1. Print the mounting brackets
1. Remove stock hotend and BLTouch sensor
1. 🅰️ Install the back mounting bracket onto the X carriage
1. 🅱️ Install the side mounting bracket onto the Hemera
1. Install the BLTouch onto the side mounting bracket
1. Fasten the two brackets to each other
1. Install the part cooling fan duct
1. Install the part cooling fan
1. Finalize the routing for the wiring

### Second-pass firmware changes

1. Measure the new home position
1. Set the new home position for `MANUAL_X_HOME_POS` and `MANUAL_Y_HOME_POS`
1. Measure the new offset between the nozzle and the probe
1. Set the new `NOZZLE_TO_PROBE` offset
1. Run PID autotuning for the hotend
1. Set the new PID values

### Square the bed to the frame

- See [calibration.md](./calibration.md)

### Configure the slicer

#### Machine settings

##### Physical

|  Printer settings   |                |  Printhead Settings             |      |
|---------------------|----------------|---------------------------------|------|
| X (Width)           | 215.0          | X min                           | -26  |
| Y (Depth)           | 215.0          | Y min                           | -32  |
| Z (Height)          | 250.0          | X man                           |  32  |
| Build plate shape   | Rectangular    | Y max                           |  34  |
| Origin at center    | ◼️             | Gantry Height                   | 25.0 |
| Heated bed          | ☑️             | Number of Extruders             | 1    |
| Heated build volume | ◼️             | Apply Extruder offsets to GCode | ☑️  |
| G-code flavor       | Marlin         | | |

##### Start

```
G28                 ; Home all axes
```

##### Stop

```
G91                 ; Relative positioning
G1 E-0.5 F2700      ; Retract a bit
G1 E-0.5 Z0.2 F2400 ; Retract and raise Z
G1 X5 Y5 F3000      ; Wipe out
G1 Z10              ; Raise Z more
G90                 ; Absolute positioning

G1 X0 Y{machine_depth}        ; Present print
M106 S0             ; Turn-off fan
M104 S0             ; Turn-off hotend
M140 S0             ; Turn-off bed

M84 X Y E           ; Disable all steppers but Z
```

#### Slicer settings

| Setting             | Value |
|---------------------|-------|
| Travel speed        | 120   |
| Retraction distance | 0.6   |
| Retraction speed    | 10.0  |
