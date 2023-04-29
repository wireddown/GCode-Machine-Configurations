# Ender 3

- [Product page](https://www.creality.com/pages/download-ender-3)
- Marlin Firmware [G Codes](https://marlinfw.org/meta/gcode/)
- Background on [main board and LCD screen](https://www.youtube.com/watch?v=neS7lB7fCww)

## First look

### M115

- [FIRMWARE_NAME:2.0.8.2](https://github.com/MarlinFirmware/Marlin/blob/2.0.x/Marlin/src/gcode/host/M115.cpp)

```
16:41:24.261 -> FIRMWARE_NAME:2.0.8.2 (Oct 12 2021 10:07:41) SOURCE_CODE_URL:www.creality.com PROTOCOL_VERSION:1.0 MACHINE_TYPE:Ender-3 EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
16:41:24.261 -> Cap:SERIAL_XON_XOFF:0
16:41:24.261 -> Cap:BINARY_FILE_TRANSFER:0
16:41:24.261 -> Cap:EEPROM:1
16:41:24.261 -> Cap:VOLUMETRIC:1
16:41:24.261 -> Cap:AUTOREPORT_POS:0
16:41:24.261 -> Cap:AUTOREPORT_TEMP:1
16:41:24.261 -> Cap:PROGRESS:0
16:41:24.261 -> Cap:PRINT_JOB:1
16:41:24.261 -> Cap:AUTOLEVEL:0
16:41:24.261 -> Cap:RUNOUT:0
16:41:24.261 -> Cap:Z_PROBE:0
16:41:24.261 -> Cap:LEVELING_DATA:0
16:41:24.261 -> Cap:BUILD_PERCENT:1
16:41:24.261 -> Cap:SOFTWARE_POWER:0
16:41:24.261 -> Cap:TOGGLE_LIGHTS:0
16:41:24.261 -> Cap:CASE_LIGHT_BRIGHTNESS:0
16:41:24.261 -> Cap:EMERGENCY_PARSER:0
16:41:24.261 -> Cap:HOST_ACTION_COMMANDS:0
16:41:24.309 -> Cap:PROMPT_SUPPORT:0
16:41:24.309 -> Cap:SDCARD:1
16:41:24.309 -> Cap:REPEAT:0
16:41:24.309 -> Cap:SD_WRITE:1
16:41:24.309 -> Cap:AUTOREPORT_SD_STATUS:0
16:41:24.309 -> Cap:LONG_FILENAME:0
16:41:24.309 -> Cap:THERMAL_PROTECTION:1
16:41:24.309 -> Cap:MOTION_MODES:0
16:41:24.309 -> Cap:ARCS:1
16:41:24.309 -> Cap:BABYSTEPPING:1
16:41:24.309 -> Cap:CHAMBER_TEMPERATURE:0
16:41:24.309 -> Cap:COOLER_TEMPERATURE:0
16:41:24.309 -> Cap:MEATPACK:0
16:41:24.309 -> ok
```

### M503 Settings

```
16:52:24.183 -> echo:  G21    ; Units in mm (mm)
16:52:24.183 -> echo:  M149 C ; Units in Celsius
16:52:24.183 -> 
16:52:24.183 -> echo:; Filament settings: Disabled
16:52:24.183 -> echo:  M200 S0 D1.75
16:52:24.183 -> echo:; Steps per unit:
16:52:24.183 -> echo: M92 X80.00 Y80.00 Z400.00 E93.00
16:52:24.183 -> echo:; Maximum feedrates (units/s):
16:52:24.183 -> echo:  M203 X500.00 Y500.00 Z5.00 E25.00
16:52:24.183 -> echo:; Maximum Acceleration (units/s2):
16:52:24.230 -> echo:  M201 X500.00 Y500.00 Z100.00 E1000.00
16:52:24.230 -> echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
16:52:24.230 -> echo:  M204 P500.00 R1000.00 T1000.00
16:52:24.230 -> echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
16:52:24.230 -> echo:  M205 B20000.00 S0.00 T0.00 X8.00 Y8.00 Z0.20 E5.00
16:52:24.230 -> echo:; Home offset:
16:52:24.230 -> echo:  M206 X0.00 Y0.00 Z0.00
16:52:24.230 -> echo:; Material heatup parameters:
16:52:24.230 -> echo:  M145 S0 H200.00 B60.00 F255
16:52:24.230 -> echo:  M145 S1 H240.00 B70.00 F255
16:52:24.230 -> echo:; PID settings:
16:52:24.230 -> echo:  M301 P25.80 I2.50 D66.64
16:52:24.277 -> echo:  M304 P198.96 I38.80 D680.25
16:52:24.277 -> echo:; Power-Loss Recovery:
16:52:24.277 -> echo:  M413 S1
16:52:24.277 -> ok
```

### M119 Endstop test

```
16:47:47.854 -> Reporting endstop status
16:47:47.854 -> x_min: open
16:47:47.854 -> y_min: open
16:47:47.854 -> z_min: open
16:47:47.854 -> ok
16:47:58.234 -> Reporting endstop status
16:47:58.234 -> x_min: TRIGGERED
16:47:58.234 -> y_min: open
16:47:58.234 -> z_min: open
16:47:58.234 -> ok
16:48:08.588 -> Reporting endstop status
16:48:08.588 -> x_min: open
16:48:08.588 -> y_min: TRIGGERED
16:48:08.588 -> z_min: open
16:48:08.588 -> ok
16:49:38.469 -> Reporting endstop status
16:49:38.469 -> x_min: open
16:49:38.469 -> y_min: open
16:49:38.469 -> z_min: TRIGGERED
16:49:38.469 -> ok
```

## Upgrade firmware for both screen and main board

- Manual for screen
   - https://img.staticdj.com/70e2f03e25b85b3e91addc52239dd624.pdf
   - Jump to page 17
- Manual for Z probe
   - https://www.creality.com/products/cr-touch-auto-leveling-kit
- Downloads
   - https://www.creality.com/pages/download-ender-3-v2

### M115

```
20:29:49.326 -> FIRMWARE_NAME:Marlin V1.0.7 (Oct 25 2022 17:47:50) SOURCE_CODE_URL:github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:Ender-3 V2 EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
20:29:49.372 -> Cap:SERIAL_XON_XOFF:0
20:29:49.372 -> Cap:BINARY_FILE_TRANSFER:0
20:29:49.372 -> Cap:EEPROM:1
20:29:49.372 -> Cap:VOLUMETRIC:1
20:29:49.372 -> Cap:AUTOREPORT_POS:0
20:29:49.372 -> Cap:AUTOREPORT_TEMP:1
20:29:49.372 -> Cap:PROGRESS:0
20:29:49.372 -> Cap:PRINT_JOB:1
20:29:49.372 -> Cap:AUTOLEVEL:1
20:29:49.372 -> Cap:RUNOUT:0
20:29:49.372 -> Cap:Z_PROBE:1
20:29:49.372 -> Cap:LEVELING_DATA:1
20:29:49.372 -> Cap:BUILD_PERCENT:0
20:29:49.372 -> Cap:SOFTWARE_POWER:0
20:29:49.372 -> Cap:TOGGLE_LIGHTS:0
20:29:49.372 -> Cap:CASE_LIGHT_BRIGHTNESS:0
20:29:49.372 -> Cap:EMERGENCY_PARSER:1
20:29:49.372 -> Cap:HOST_ACTION_COMMANDS:0
20:29:49.372 -> Cap:PROMPT_SUPPORT:0
20:29:49.372 -> Cap:SDCARD:1
20:29:49.372 -> Cap:REPEAT:0
20:29:49.372 -> Cap:SD_WRITE:1
20:29:49.419 -> Cap:AUTOREPORT_SD_STATUS:0
20:29:49.419 -> Cap:LONG_FILENAME:1
20:29:49.419 -> Cap:THERMAL_PROTECTION:1
20:29:49.419 -> Cap:MOTION_MODES:0
20:29:49.419 -> Cap:ARCS:1
20:29:49.419 -> Cap:BABYSTEPPING:1
20:29:49.419 -> Cap:CHAMBER_TEMPERATURE:0
20:29:49.419 -> Cap:COOLER_TEMPERATURE:0
20:29:49.419 -> Cap:MEATPACK:0
20:29:49.419 -> ok
```

### M503 Settings

```
20:31:07.791 -> echo:  G21    ; Units in mm (mm)
20:31:07.791 -> 
20:31:07.791 -> echo:; Filament settings: Disabled
20:31:07.791 -> echo:  M200 S0 D1.75
20:31:07.791 -> echo:; Steps per unit:
20:31:07.791 -> echo: M92 X80.00 Y80.00 Z400.00 E92.60
20:31:07.791 -> echo:; Maximum feedrates (units/s):
20:31:07.791 -> echo:  M203 X300.00 Y300.00 Z5.00 E25.00
20:31:07.791 -> echo:; Maximum Acceleration (units/s2):
20:31:07.791 -> echo:  M201 X500.00 Y500.00 Z100.00 E1000.00
20:31:07.791 -> echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
20:31:07.791 -> echo:  M204 P1200.00 R1200.00 T1200.00
20:31:07.838 -> echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
20:31:07.838 -> echo:  M205 B20000.00 S0.00 T0.00 X8.00 Y8.00 Z0.40 E5.00
20:31:07.838 -> echo:; Home offset:
20:31:07.838 -> echo:  M206 X0.00 Y0.00 Z0.00
20:31:07.838 -> echo:; Auto Bed Leveling:
20:31:07.838 -> echo:  M420 S0 Z10.00
20:31:07.838 -> echo:; Material heatup parameters:
20:31:07.838 -> echo:  M145 S0 H200.00 B60.00 F255
20:31:07.838 -> echo:  M145 S1 H240.00 B100.00 F255
20:31:07.838 -> echo:; PID settings:
20:31:07.838 -> echo:  M301 P17.97 I1.46 D55.15
20:31:07.838 -> echo:  M304 P198.96 I38.80 D680.25
20:31:07.838 -> echo:; Power-Loss Recovery:
20:31:07.838 -> echo:  M413 S1
20:31:07.884 -> echo:; Z-Probe Offset (mm):
20:31:07.884 -> echo:  M851 X-40.00 Y-5.00 Z-3.60
20:31:07.884 -> echo:; Filament load/unload lengths:
20:31:07.884 -> echo:  M603 L0.00 U100.00
20:31:07.884 -> ok
```

### Differences

#### Firmware capabilities

```diff
@@ -1,4 +1,4 @@
-FIRMWARE_NAME:2.0.8.2 (Oct 12 2021 10:07:41) SOURCE_CODE_URL:www.creality.com PROTOCOL_VERSION:1.0 MACHINE_TYPE:Ender-3 EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
+FIRMWARE_NAME:Marlin V1.0.7 (Oct 25 2022 17:47:50) SOURCE_CODE_URL:github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:Ender-3 V2 EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
 Cap:SERIAL_XON_XOFF:0
 Cap:BINARY_FILE_TRANSFER:0
 Cap:EEPROM:1
@@ -7,22 +7,22 @@
 Cap:AUTOREPORT_TEMP:1
 Cap:PROGRESS:0
 Cap:PRINT_JOB:1
-Cap:AUTOLEVEL:0
+Cap:AUTOLEVEL:1
 Cap:RUNOUT:0
-Cap:Z_PROBE:0
-Cap:LEVELING_DATA:0
-Cap:BUILD_PERCENT:1
+Cap:Z_PROBE:1
+Cap:LEVELING_DATA:1
+Cap:BUILD_PERCENT:0
 Cap:SOFTWARE_POWER:0
 Cap:TOGGLE_LIGHTS:0
 Cap:CASE_LIGHT_BRIGHTNESS:0
-Cap:EMERGENCY_PARSER:0
+Cap:EMERGENCY_PARSER:1
 Cap:HOST_ACTION_COMMANDS:0
 Cap:PROMPT_SUPPORT:0
 Cap:SDCARD:1
 Cap:REPEAT:0
 Cap:SD_WRITE:1
 Cap:AUTOREPORT_SD_STATUS:0
-Cap:LONG_FILENAME:0
+Cap:LONG_FILENAME:1
 Cap:THERMAL_PROTECTION:1
 Cap:MOTION_MODES:0
 Cap:ARCS:1
```

#### EEPROM settings

```diff
@@ -1,25 +1,30 @@
 echo:  G21    ; Units in mm (mm)
-echo:  M149 C ; Units in Celsius
 echo:; Filament settings: Disabled
 echo:  M200 S0 D1.75
 echo:; Steps per unit:
-echo: M92 X80.00 Y80.00 Z400.00 E93.00
+echo: M92 X80.00 Y80.00 Z400.00 E92.60
 echo:; Maximum feedrates (units/s):
-echo:  M203 X500.00 Y500.00 Z5.00 E25.00
+echo:  M203 X300.00 Y300.00 Z5.00 E25.00
 echo:; Maximum Acceleration (units/s2):
 echo:  M201 X500.00 Y500.00 Z100.00 E1000.00
 echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
-echo:  M204 P500.00 R1000.00 T1000.00
+echo:  M204 P1200.00 R1200.00 T1200.00
 echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
-echo:  M205 B20000.00 S0.00 T0.00 X8.00 Y8.00 Z0.20 E5.00
+echo:  M205 B20000.00 S0.00 T0.00 X8.00 Y8.00 Z0.40 E5.00
 echo:; Home offset:
 echo:  M206 X0.00 Y0.00 Z0.00
+echo:; Auto Bed Leveling:
+echo:  M420 S0 Z10.00
 echo:; Material heatup parameters:
 echo:  M145 S0 H200.00 B60.00 F255
-echo:  M145 S1 H240.00 B70.00 F255
+echo:  M145 S1 H240.00 B100.00 F255
 echo:; PID settings:
-echo:  M301 P25.80 I2.50 D66.64
+echo:  M301 P17.97 I1.46 D55.15
 echo:  M304 P198.96 I38.80 D680.25
 echo:; Power-Loss Recovery:
 echo:  M413 S1
+echo:; Z-Probe Offset (mm):
+echo:  M851 X-40.00 Y-5.00 Z-3.60
+echo:; Filament load/unload lengths:
+echo:  M603 L0.00 U100.00
 ok
 ```

## Observations

- Print exclusion border
  - Safe: 12.0 mm
  - X: nozzle overshoots right side, **keep X < 230.0 mm**
  - Y: nozzle overshoots front side, **keep Y > 8.0 mm**
  - Y: nozzle collides with retaining clips for the glass bed, **keep models clear**
- PTFE tube easily blocks because it interfaces with the nozzle
  - 200 C seems to be about the peak temperature before PLA begins to clog
  - The heat causes the filament to soften, expand, and bind _inside_ the PTFE tube
  - An all metal hotend increases the temperature difference between the nozzle and the PTFE tube

## Recommendations

- E3D Hemera
  - All metal hotend + direct drive extruder
  - https://e3d-online.zendesk.com/hc/en-us/articles/360018062117-Hemera-Ender-3-V2-Ender-3-CR10-CR10-V2-Upgrade-Guide-Edition-2-
  - Ender 3 is a 24V system
