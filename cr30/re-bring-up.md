# Last look before upgrading

Appears to be factory firmware.

## M115

```
FIRMWARE_NAME:Marlin 2.0.6.3 (Jan 14 2021 18:24:36) SOURCE_CODE_URL:https://github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:3DPrintMill EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
Cap:SERIAL_XON_XOFF:0
Cap:BINARY_FILE_TRANSFER:0
Cap:EEPROM:1
Cap:VOLUMETRIC:1
Cap:AUTOREPORT_TEMP:1
Cap:PROGRESS:0
Cap:PRINT_JOB:1
Cap:AUTOLEVEL:0
Cap:RUNOUT:1
Cap:Z_PROBE:0
Cap:LEVELING_DATA:0
Cap:BUILD_PERCENT:0
Cap:SOFTWARE_POWER:0
Cap:TOGGLE_LIGHTS:0
Cap:CASE_LIGHT_BRIGHTNESS:0
Cap:EMERGENCY_PARSER:0
Cap:PROMPT_SUPPORT:0
Cap:SDCARD:1
Cap:AUTOREPORT_SD_STATUS:0
Cap:LONG_FILENAME:0
Cap:THERMAL_PROTECTION:1
Cap:MOTION_MODES:0
Cap:ARCS:1
Cap:BABYSTEPPING:1
Cap:CHAMBER_TEMPERATURE:0
```

## M503

```
echo:  G21    ; Units in mm (mm)
echo:  M149 C ; Units in Celsius

echo:; Filament settings: Disabled
echo:  M200 S0 D1.75
echo:; Steps per unit:
echo: M92 X80.00 Y80.00 Z1161.06 E137.65
echo:; Maximum feedrates (units/s):
echo:  M203 X300.00 Y300.00 Z10.00 E75.00
echo:; Maximum Acceleration (units/s2):
echo:  M201 X300.00 Y300.00 Z100.00 E1000.00
echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
echo:  M204 P300.00 R300.00 T600.00
echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
echo:  M205 B20000.00 S0.00 T0.00 X6.00 Y6.00 Z0.40 E5.00
echo:; Home offset:
echo:  M206 X0.00 Y0.00 Z0.00
echo:; Material heatup parameters:
echo:  M145 S0 H185 B55 F0
echo:  M145 S1 H240 B70 F0
echo:; PID settings:
echo:  M301 P15.90 I1.25 D44.40
echo:  M304 P96.72 I16.17 D385.83
echo:; Power-Loss Recovery:
echo:  M413 S1
echo:; Filament load/unload lengths:
echo:  M603 L0.00 U100.00
echo:; Filament runout sensor:
echo:  M412 S1
echo:; 0:en 1:cn language change font:
echo:  M414 S0
echo:; repeat markers count:
echo:  M808 L0
```

## Basic checks

[x] Motion
[x] Homing
    - Relies on optical endstop
[x] Heating
[x] Extrusion
