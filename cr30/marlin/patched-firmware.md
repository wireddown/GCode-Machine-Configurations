# Firmware after applying patch set

See the specific patches in [./patches](./patches/).

### M115

```
FIRMWARE_NAME:Marlin 0a30fac + pull/1 (Jun 17 2023 09:53:11) SOURCE_CODE_URL:github.com/wireddown/GCode-Machine-Configurations PROTOCOL_VERSION:1.0 MACHINE_TYPE:Camina EXTRUDER_COUNT:1 UUID:CA319A00-0000-0000-0000-00BE174103D4
Cap:SERIAL_XON_XOFF:0
Cap:BINARY_FILE_TRANSFER:0
Cap:EEPROM:1
Cap:VOLUMETRIC:1
Cap:AUTOREPORT_POS:0
Cap:AUTOREPORT_TEMP:1
Cap:PROGRESS:0
Cap:PRINT_JOB:1
Cap:AUTOLEVEL:0
Cap:RUNOUT:1
Cap:Z_PROBE:0
Cap:LEVELING_DATA:0
Cap:BUILD_PERCENT:0
Cap:SOFTWARE_POWER:0
Cap:TOGGLE_LIGHTS:1
Cap:CASE_LIGHT_BRIGHTNESS:0
Cap:EMERGENCY_PARSER:1
Cap:HOST_ACTION_COMMANDS:1
Cap:PROMPT_SUPPORT:0
Cap:SDCARD:1
Cap:MULTI_VOLUME:0
Cap:REPEAT:1
Cap:SD_WRITE:1
Cap:AUTOREPORT_SD_STATUS:0
Cap:LONG_FILENAME:0
Cap:LFN_WRITE:0
Cap:CUSTOM_FIRMWARE_UPLOAD:0
Cap:EXTENDED_M20:0
Cap:THERMAL_PROTECTION:1
Cap:MOTION_MODES:0
Cap:ARCS:1
Cap:BABYSTEPPING:1
Cap:CHAMBER_TEMPERATURE:0
Cap:COOLER_TEMPERATURE:0
Cap:MEATPACK:0
Cap:CONFIG_EXPORT:0
```

### M503

```
echo:; Linear Units:
echo:  G21 ; (mm)
echo:; Temperature Units:
echo:  M149 C ; Units in Celsius
echo:; Filament settings (Disabled):
echo:  M200 S0 D1.75
echo:; Steps per unit:
echo:  M92 X80.00 Y80.00 Z1148.40 E138.80
echo:; Max feedrates (units/s):
echo:  M203 X300.00 Y300.00 Z10.00 E75.00
echo:; Max Acceleration (units/s2):
echo:  M201 X300.00 Y300.00 Z100.00 E5000.00
echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
echo:  M204 P300.00 R300.00 T600.00
echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_jerk> Y<max_jerk> Z<max_jerk> E<max_jerk>):
echo:  M205 B20000.00 S0.00 T0.00 X6.00 Y6.00 Z0.40 E10.00
echo:; Home offset:
echo:  M206 X0.00 Y0.20 Z0.00
echo:; Material heatup parameters:
echo:  M145 S0 H185.00 B55.00 F0
echo:  M145 S1 H240.00 B70.00 F0
echo:; Hotend PID:
echo:  M301 P21.81 I2.25 D52.78
echo:; Bed PID:
echo:  M304 P49.06 I8.87 D180.88
echo:; Controller Fan:
echo:  M710 S255 I0 A1 D60 ; (100% 0%)
echo:; Power-loss recovery:
echo:  M413 S1 ; ON
echo:; Linear Advance:
echo:  M900 K0.00
echo:; Filament load/unload:
echo:  M603 L0.00 U100.00 ; (mm)
echo:; Filament runout sensor:
echo:  M412 S1 ; Sensor ON
```
