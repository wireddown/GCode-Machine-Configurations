# CR-30 3DPrintMill

- [Product page](https://www.creality.com/products/creality-cr-30-3d-printer)
- Marlin Firmware [G Codes](https://marlinfw.org/meta/gcode/)

## References

- Marlin
  - [Configuration guide](https://marlinfw.org/docs/configuration/configuration.html)
  - [CR-30](https://github.com/MarlinFirmware/Configurations/tree/bugfix-2.1.x/config/examples/Creality/CR-30%20PrintMill) on GitHub
- CR30-Users
  - [Marlin fork](https://github.com/CR30-Users/Marlin-CR30)

## Powershell script

### Core tools

- [git](https://git-scm.com/downloads)
- [VS Code](https://code.visualstudio.com/Download)
  - [PlatformIO](https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide) extension

### Usage

1. Delete any patch files you do not want to use
1. Modify any patch files you want to change
   - **NB:** do not insert or delete any _lines_, only change _values_ on lines prefixed with `+`
1. Change or confirm the settings at the top of [`get-and-patch-source.ps1`](./get-and-patch-source.ps1)

### Example session

```powershell
PS> Unblock-File .\get-and-patch-source.ps1
PS> .\get-and-patch-source.ps1

Downloading Marlin firmware source code branch 2.1.x
Cloning into 'C:/dev/scratch/cr30/tmp.marlinfw'...
remote: Enumerating objects: 3027, done.
remote: Counting objects: 100% (3027/3027), done.
remote: Compressing objects: 100% (2219/2219), done.
remote: Total 3027 (delta 1015), reused 2267 (delta 768), pack-reused 0
Receiving objects: 100% (3027/3027), 7.83 MiB | 15.36 MiB/s, done.
Resolving deltas: 100% (1015/1015), done.

Downloading Marlin firmware configuration branch release-2.1.2.1
Cloning into 'C:/dev/scratch/cr30/tmp.marlincfg'...
remote: Enumerating objects: 1441, done.
remote: Counting objects: 100% (1441/1441), done.
remote: Compressing objects: 100% (664/664), done.
remote: Total 1441 (delta 728), reused 1398 (delta 708), pack-reused 0
Receiving objects: 100% (1441/1441), 19.52 MiB | 28.07 MiB/s, done.
Resolving deltas: 100% (728/728), done.

Switched to a new branch 'cr30-stock-with-tuning'
Official: Copy baseline configuration from Marlin/Configurations/config/examples/Creality/CR-30 PrintMill

Upstream baseline is 09d0b4d15
Applying CR30-Users improvements
Applying: CR30-Users: Define custom Version.h
Applying: CR30-Users: Allow fine movements on the Y axis in the LCD menu
Applying: CR30-Users: Add static 3DPrintMill bootscreens
Applying: CR30-Users: Add PID autotune to the LCD menu
Applying: CR30-Users: Set Y axis maximum to 240 mm
Applying: CR30-Users: Machine and user-specific movement coefficients
Applying: CR30-Users: User-specific preheat settings
Applying: CR30-Users: Allow negative Y axis movement
Applying: CR30-Users: Allow Z to move backward below 0
Applying: CR30-Users: Enable controller fan on PC1
Applying: CR30-Users: Enable the hotend autofan on PC0
Applying: CR30-Users: Enable the case light on PC14
Applying: CR30-Users: Reduce Y lift after SD finished
Applying: CR30-Users: Reduce Y lift after SD canceled
Applying: CR30-Users: Force the media menu to the top of the LCD menu
Applying: CR30-Users: Enable hollow frame menus
Applying: CR30-Users: Disable E position on LCD screen
Applying: CR30-Users: Disable double-click for baby stepping
Applying: CR30-Users: Enable host action commands
Applying: Marlin v2.1.2.1: Fix CR-30 animated bootscreen
Applying: Marlin v2.1.2.1: Fix CR-30 power loss recovery
Applying: CR30-Users: Add animated boot screen and status screen
Applying: CR30-Users: Set build environment for PlatformIO

Enabling additional Marlin features
Applying: @wireddown: Allow Z to move forward infinitely
Applying: @wireddown: Enable hotend timeout for safety
Applying: @wireddown: Enable emergency parser
Applying: @wireddown: Switch to Junction Deviation and S Curve Acceleration
Applying: @wireddown: Enable input shaping for X and Y
Applying: @wireddown: Enable sub-mm XY coordinates on LCD
Applying: @wireddown: Move Z and Y more after SD cancel, disable heaters after SD complete
Applying: @wireddown: SD sort by alpha
Applying: @wireddown: Scroll long SD file names
Applying: @wireddown: Scroll long status messages
Applying: @wireddown: Let Back select Back again in LCD menu
Applying: @wireddown: Add a mute option to the LCD menu
Applying: @wireddown: Add a print counter with M78
Applying: @wireddown: Add games to the LCD menu

Setting machine specific constants and custom identifiers
Applying: @wireddown: Adjust X axis for Camina
Applying: @wireddown: Hotend PID calibration for Camina
Applying: @wireddown: E calibration coefficient for Camina
Applying: @wireddown: Add thumbprint and signpost
Applying: @wireddown: Set build date

Launching VS Code
```

## Differences between Creality and Upstream Firmware

These diffs compare the settings for

- the firmware from Creality's download center (red)
- the firmware after applying the patch set from pull/2 (green)

### Firmware capabilities

```diff
-FIRMWARE_NAME:Marlin 2.0.6.3 (Jan 14 2021 18:24:36) SOURCE_CODE_URL:https://github.com/MarlinFirmware/Marlin PROTOCOL_VERSION:1.0 MACHINE_TYPE:3DPrintMill EXTRUDER_COUNT:1 UUID:cede2a2f-41a2-4748-9b12-c55c62f367ff
+FIRMWARE_NAME:Marlin 09d0b4d15 + pull/2 (Jul  5 2023 18:42:22) SOURCE_CODE_URL:github.com/wireddown/GCode-Machine-Configurations PROTOCOL_VERSION:1.0 MACHINE_TYPE:Camina EXTRUDER_COUNT:1 UUID:CA319A00-0000-0000-0000-00BE174103D4
 Cap:SERIAL_XON_XOFF:0
 Cap:BINARY_FILE_TRANSFER:0
 Cap:EEPROM:1
 Cap:VOLUMETRIC:1
+Cap:AUTOREPORT_POS:0
 Cap:AUTOREPORT_TEMP:1
 Cap:PROGRESS:0
 Cap:PRINT_JOB:1
 Cap:AUTOLEVEL:0
 Cap:RUNOUT:1
 Cap:Z_PROBE:0
 Cap:LEVELING_DATA:0
 Cap:BUILD_PERCENT:0
 Cap:SOFTWARE_POWER:0
-Cap:TOGGLE_LIGHTS:0
+Cap:TOGGLE_LIGHTS:1
 Cap:CASE_LIGHT_BRIGHTNESS:0
-Cap:EMERGENCY_PARSER:0
+Cap:EMERGENCY_PARSER:1
+Cap:HOST_ACTION_COMMANDS:1
 Cap:PROMPT_SUPPORT:0
 Cap:SDCARD:1
+Cap:MULTI_VOLUME:0
+Cap:REPEAT:1
+Cap:SD_WRITE:1
 Cap:AUTOREPORT_SD_STATUS:0
 Cap:LONG_FILENAME:0
+Cap:LFN_WRITE:0
+Cap:CUSTOM_FIRMWARE_UPLOAD:0
+Cap:EXTENDED_M20:0
 Cap:THERMAL_PROTECTION:1
 Cap:MOTION_MODES:0
 Cap:ARCS:1
 Cap:BABYSTEPPING:1
 Cap:CHAMBER_TEMPERATURE:0
+Cap:COOLER_TEMPERATURE:0
+Cap:MEATPACK:0
+Cap:CONFIG_EXPORT:0
```

### EEPROM settings

```diff
-echo:  G21    ; Units in mm (mm)
+echo:; Linear Units:
+echo:  G21 ; (mm)
+echo:; Temperature Units:
 echo:  M149 C ; Units in Celsius
-
-echo:; Filament settings: Disabled
+echo:; Filament settings (Disabled):
 echo:  M200 S0 D1.75
 echo:; Steps per unit:
-echo: M92 X80.00 Y80.00 Z1161.06 E137.65
+echo:  M92 X80.00 Y80.00 Z1148.40 E138.80
-echo:; Maximum feedrates (units/s):
+echo:; Max feedrates (units/s):
 echo:  M203 X300.00 Y300.00 Z10.00 E75.00
-echo:; Maximum Acceleration (units/s2):
+echo:; Max Acceleration (units/s2):
-echo:  M201 X300.00 Y300.00 Z100.00 E1000.00
+echo:  M201 X300.00 Y300.00 Z100.00 E5000.00
-echo:; Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
+echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
 echo:  M204 P300.00 R300.00 T600.00
-echo:; Advanced: B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_x_jerk> Y<max_y_jerk> Z<max_z_jerk> E<max_e_jerk>
+echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> J<junc_dev>):
-echo:  M205 B20000.00 S0.00 T0.00 X6.00 Y6.00 Z0.40 E5.00
+echo:  M205 B20000.00 S0.00 T0.00 J0.02
 echo:; Home offset:
-echo:  M206 X0.00 Y0.00 Z0.00
+echo:  M206 X0.00 Y0.97 Z0.00
 echo:; Material heatup parameters:
-echo:  M145 S0 H185 B55 F0
+echo:  M145 S0 H185.00 B55.00 F0
-echo:  M145 S1 H240 B70 F0
+echo:  M145 S1 H240.00 B70.00 F0
-echo:; PID settings:
+echo:; Hotend PID:
-echo:  M301 P15.90 I1.25 D44.40
+echo:  M301 P21.81 I2.25 D52.78
+echo:; Bed PID:
-echo:  M304 P96.72 I16.17 D385.83
+echo:  M304 P49.06 I8.87 D180.88
+echo:; Controller Fan:
+echo:  M710 S255 I0 A1 D60 ; (100% 0%)
-echo:; Power-Loss Recovery:
+echo:; Power-loss recovery:
-echo:  M413 S1
+echo:  M413 S1 ; ON
+echo:; Input Shaping:
+echo:  M593 X F16.60 D0.15
+echo:  M593 Y F16.60 D0.15
-echo:; Filament load/unload lengths:
+echo:; Filament load/unload:
-echo:  M603 L0.00 U100.00
+echo:  M603 L0.00 U100.00 ; (mm)
 echo:; Filament runout sensor:
-echo:  M412 S1
+echo:  M412 S1 ; Sensor ON
-echo:; 0:en 1:cn language change font:
-echo:  M414 S0
-echo:; repeat markers count:
-echo:  M808 L0
```

## Uncovered issues

- ✅ Scrambled bootscreen
  - A symbol changed names on 7 Feb 2021 ([commit](https://github.com/MarlinFirmware/Marlin/commits/5f824c5708191f8d170a735e1a2ab2257fdc9e54))
    - Old name: `CUSTOM_BOOTSCREEN_TIME_PER_FRAME`
    - New name: `CUSTOM_BOOTSCREEN_ANIMATED_FRAME_TIME`
  - Declaring the sequence with `const boot_frame_t custom_bootscreen_animation[]` fixes the animation visuals
  - Fixed in [patch 22](./patches/02-cr30users/0022-Marlin-v2.1.2.1-Fix-CR-30-animated-bootscreen.patch)
- ✅ Build warnings
  - ```
    Marlin\src\feature\powerloss.cpp: In static member function 'static void PrintJobRecovery::resume()':
    Marlin\src\feature\powerloss.cpp:408:15: warning: unused variable 'z_raised' [-Wunused-variable]
               z_raised = z_print + info.zraise;
    ```
    - This was introduced by the `BELTPRINTER` preprocessor defintion
  - Fixed in [patch 23](./patches/02-cr30users/0023-Marlin-v2.1.2.1-Fix-CR-30-power-loss-recovery.patch)
- ✅ Power loss recovery fails
  - Does not home XY
  - Advances Z too far
  - Positions hotend high above belt
  - Resumes printing filament in midair
  - Fixed in [patch 23](./patches/02-cr30users/0023-Marlin-v2.1.2.1-Fix-CR-30-power-loss-recovery.patch)

## Snippets

```
git format-patch --unified=5 --inter-hunk-context=12 --output-directory patches --no-numbered --keep-subject <sinceSHA>
```
