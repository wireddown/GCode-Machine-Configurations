# Ender 3

- [Product page](https://www.creality.com/pages/download-ender-3)
- Marlin Firmware [G Codes](https://marlinfw.org/meta/gcode/)
- Background on [main board and LCD screen](https://www.youtube.com/watch?v=neS7lB7fCww)

## References

- Marlin
  - [Configuration guide](https://marlinfw.org/docs/configuration/configuration.html)
  - [Boot screens](https://github.com/MarlinFirmware/Configurations/blob/bugfix-2.1.x/config/examples/Creality/Ender-3%20V2/LCD%20Files/Custom%20Bootscreens/Custom%20Boot%20Screen%20Instructions.md)
- E3D
  - [Marlin Ender 3 V2 firmware guide](https://e3d-online.zendesk.com/hc/en-us/articles/360017968457-Hemera-Creality-Ender-3-V2-Firmware-Bl-touch-)
  - [Marlin 2.0 firmware guide](https://e3d-online.zendesk.com/hc/en-us/articles/4406823770769-Marlin-2-0-Hemera-Guide)

## Powershell script

### Core tools

- [git](https://git-scm.com/downloads)
- [VS Code](https://code.visualstudio.com/Download)
  - [PlatformIO](https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide) extension

### Example session

```powershell
PS> Unblock-File .\get-and-patch-source.ps
PS> .\get-and-patch-source.ps

Downloading Marlin firmware source code branch bugfix-2.0.x
Cloning into 'tmp.marlinfw'...
remote: Enumerating objects: 2922, done.
remote: Counting objects: 100% (2922/2922), done.
remote: Compressing objects: 100% (2157/2157), done.
Receiving objects: 100% (2922/2922), 7.76 MiB | 21.48 MiB/s, done.ed 0
Resolving deltas: 100% (877/877), done.

Downloading Marlin firmware configuration branch bugfix-2.0.x
Cloning into 'tmp.marlincfg'...
remote: Enumerating objects: 1440, done.
remote: Counting objects: 100% (1440/1440), done.
remote: Compressing objects: 100% (600/600), done.
remote: Total 1440 (delta 775), reused 1430 (delta 770), pack-reused 0
Receiving objects: 100% (1440/1440), 18.44 MiB | 24.21 MiB/s, done.
Resolving deltas: 100% (775/775), done.

Switched to a new branch 'ender3v2-crtouch-hemera'
Copy baseline Ender 3 V2 configuration from Marlin/Configurations/../CrealityV422/CrealityUI
Copy custom boot screen
M  Marlin/private/image/0.jpg

Patching to match Ender-3 V2 'GD-Ender-3 V2-Marlin2.0.8.2-HW-V4.2.2-SW-V1.0.7_E_N_BLTouch
Applying: Enable long filename listing
Applying: Enable emergency parser
Applying: Enable and configure BLTouch Z probe
Applying: Set DEFAULT_MAX_FEEDRATE to 300 on XY
Applying: Set Jerk values to match Ender-3 V2 firmware
Applying: Set filament preheat presets to match Ender-3 V2 firmware
Applying: Enable power loss recovery to match Ender-3 V2 firmware

Tuning movement and fixing stock settings
Applying: Tune homing speed for XY
Applying: Tune bed leveling configuration
Applying: Enable bed mesh after homing
Applying: Keep alphabetical sort for SD file list

Enabling additional Marlin features
Applying: Enable hotend parking for SD cancel
Applying: Enable hotend parking for SD pause

Setting version and custom identifiers
Applying: Changes for unique identification
Applying: Set wireddown as author
Applying: Set PlatformIO for STM32F103RE_creality environment
```

## Differences

### Firmware capabilities

```diff
@@ -1,4 +1,4 @@
-FIRMWARE_NAME:Marlin V1.0.7 (Oct 25 2022 17:47:50) SOURCE_CODE_URL:github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:Ender-3 V2 EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
+FIRMWARE_NAME:Marlin bugfix-2.0.x+wireddown (Apr 30 2023 20:23:44) SOURCE_CODE_URL:github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:B'Elanna EXTRUDER_COUNT:1 UUID:CC074656-0000-0000-0000-000000000014
 Cap:SERIAL_XON_XOFF:0
 Cap:BINARY_FILE_TRANSFER:0
 Cap:EEPROM:1
@@ -19,10 +19,14 @@
 Cap:HOST_ACTION_COMMANDS:0
 Cap:PROMPT_SUPPORT:0
 Cap:SDCARD:1
+Cap:MULTI_VOLUME:0
 Cap:REPEAT:0
 Cap:SD_WRITE:1
 Cap:AUTOREPORT_SD_STATUS:0
 Cap:LONG_FILENAME:1
+Cap:LFN_WRITE:0
+Cap:CUSTOM_FIRMWARE_UPLOAD:0
+Cap:EXTENDED_M20:1
 Cap:THERMAL_PROTECTION:1
 Cap:MOTION_MODES:0
 Cap:ARCS:1
@@ -30,4 +34,5 @@
 Cap:CHAMBER_TEMPERATURE:0
 Cap:COOLER_TEMPERATURE:0
 Cap:MEATPACK:0
+Cap:CONFIG_EXPORT:0
 ok
 ```

### EEPROM settings

```diff
@@ -1,31 +1,36 @@
-echo:  G21    ; Units in mm (mm)
-
-echo:; Filament settings: Disabled
+echo:; Linear Units:
+echo:  G21 ; (mm)
+echo:; Temperature Units:
+echo:  M149 C ; Units in Celsius
+echo:; Filament settings (Disabled):
 echo:  M200 S0 D1.75
 echo:; Steps per unit:
-echo: M92 X80.00 Y80.00 Z400.00 E92.60
-echo:; Maximum feedrates (units/s):
+echo:  M92 X80.00 Y80.00 Z400.00 E93.00
+echo:; Max feedrates (units/s):
 echo:  M203 X300.00 Y300.00 Z5.00 E25.00
-echo:; Maximum Acceleration (units/s2):
+echo:; Max Acceleration (units/s2):
 echo:  M201 X500.00 Y500.00 Z100.00 E1000.00
-echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
-echo:  M204 P1200.00 R1200.00 T1200.00
-echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
+echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
+echo:  M204 P500.00 R500.00 T1000.00
+echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_jerk> Y<max_jerk> Z<max_jerk> E<max_jerk>):
 echo:  M205 B20000.00 S0.00 T0.00 X8.00 Y8.00 Z0.40 E5.00
 echo:; Home offset:
 echo:  M206 X0.00 Y0.00 Z0.00
 echo:; Auto Bed Leveling:
-echo:  M420 S0 Z10.00
+echo:  M420 S0 Z10.00 ; Leveling OFF
 echo:; Material heatup parameters:
 echo:  M145 S0 H200.00 B60.00 F255
 echo:  M145 S1 H240.00 B100.00 F255
-echo:; PID settings:
-echo:  M301 P17.97 I1.46 D55.15
-echo:  M304 P198.96 I38.80 D680.25
-echo:; Power-Loss Recovery:
-echo:  M413 S1
-echo:; Z-Probe Offset (mm):
-echo:  M851 X-40.00 Y-5.00 Z-3.60
-echo:; Filament load/unload lengths:
-echo:  M603 L0.00 U100.00
+echo:; Hotend PID:
+echo:  M301 P28.72 I2.62 D78.81
+echo:; Bed PID:
+echo:  M304 P462.10 I85.47 D624.59
+echo:; LCD Brightness:
+echo:  M256 B250
+echo:; Power-loss recovery:
+echo:  M413 S1 ; ON
+echo:; Z-Probe Offset:
+echo:  M851 X-47.00 Y-5.00 Z-2.70 ; (mm)
+echo:; Filament load/unload:
+echo:  M603 L0.00 U100.00 ; (mm)
 ok
```

## Patch list

- ✅ `M115` is the same
- ✅ `M503` is the same
  - ❌ `echo:  M204 P1200.00 R1200.00 T1200.00`
    - ➡️ Has no effect because these are greater than the max limits in `M201`
- ✅ Z probe speed is the same
- ✅ Patch `0000` diffs are understood
- ✅ Diffs between Creality and Marlin UI are understood
  - ❌ `HOST_ACTION_COMMANDS`
    - ➡️ Seems buggy with the Creality LCD screen
    - ➡️ Printer **hard freezes and beeps after parking** for Creality UI
    - ➡️ Printer resumes and **hard freezes** immediately for Jyers UI
    - ➡️ OctoPrint responds to printer messages https://reprap.org/wiki/G-code#Action_commands
- ✅ Build warnings
  - ➡️ _(seems ok -- screen is responsive)_ Note: Auto-assigned `LCD_SERIAL_PORT`
  - ➡️ _(seems ok -- machine moves normally)_ Creality 4.2.2 boards come with a variety of stepper drivers. Check the board label and set the correct `*_DRIVER_TYPE`! (C=HR4988, E=A4988, A=TMC2208, B=TMC2209, H=TMC2225).
- ✅ Configuration.h
  - ✅ `STRING_CONFIG_H_AUTHOR`
  - ✅ `CUSTOM_MACHINE_NAME`
  - ✅ `MACHINE_UUID`
  - ❌ `SHOW_CUSTOM_BOOTSCREEN`
    - ➡️ For monocrhome screens
  - ❌ `CUSTOM_STATUS_SCREEN_IMAGE`
    - ➡️ For monochrome screens
  - ✅ `GRID_MAX_POINTS`
  - ✅ `XY_PROBE_FEEDRATE`
  - ✅ `Z_PROBE_FEEDRATE_FAST`
  - ✅ `Z_PROBE_FEEDRATE_SLOW`
  - ❌ `Z_MIN_PROBE_REPEATABILITY_TEST`
    - ➡️ BLTouch doesn't report a measurement for this test -- all samples 0.00
  - ✅ `ENABLE_LEVELING_AFTER_G28`
  - ❌ `SPEAKER`
    - ➡️ LCD panel has buzzer
- ✅ Configuration_adv.h
  - ✅ `PROBING_MARGIN_LEFT`
  - ✅ `HOMING_BUMP_DIVISOR`
    - ➡️ Z value only used for homing Z with an endstop
- Maybe
  - ✅ `EVENT_GCODE_SD_ABORT`
  - ✅ `NOZZLE_PARK_FEATURE`
  - ✅ `PARK_HEAD_ON_PAUSE`
  - ✅ `ADVANCED_PAUSE_FEATURE`
  - ❌ `USE_CONTROLLER_FAN`
    - ➡️ Controller fan turns on with the part cooling fan because they share the same IO pin on the control chip
  - ❌ `MULTIPLE_PROBING`
    - ➡️ BLTouch doesn't report a measurement for `Z_MIN_PROBE_REPEATABILITY_TEST`
  - `JUNCTION_DEVIATION_MM` and `S_CURVE_ACCELERATION`
    - https://marlinfw.org/docs/configuration/configuration.html#junction-deviation-
  - `HOTEND_IDLE_TIMEOUT`
  - `PRINTCOUNTER`
  - `GCODE_REPEAT_MARKERS`
  - `SAVED_POSITIONS`
  - JyersUI has more options
    - Tradeoff is no pausing, only canceling