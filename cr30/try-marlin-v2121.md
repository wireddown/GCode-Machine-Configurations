# Upgrade to Marlin `v2.1.2.1` and bring CR30-Users changes

- Basic machine movement ok

## Mainline issues

Mainline official animated bootscreen showed major artifacts / "static snow".

- Perhaps a new frame dimension or bit-alignment
- Disabling `CUSTOM_BOOTSCREEN_BOTTOM_JUSTIFY` moves the animation but doesn't restore the frames
- A symbol changed names on 7 Feb 2021 ([commit](https://github.com/MarlinFirmware/Marlin/commits/5f824c5708191f8d170a735e1a2ab2257fdc9e54))
  - Old name: `CUSTOM_BOOTSCREEN_TIME_PER_FRAME`
  - New name: `CUSTOM_BOOTSCREEN_ANIMATED_FRAME_TIME`
- Build errors with `CUSTOM_BOOTSCREEN_ANIMATED_FRAME_TIME`
  ```
  In file included from Marlin\src\lcd\dogm\../../inc/../HAL/../HAL/STM32/../shared/Marduino.h:89,
                   from Marlin\src\lcd\dogm\../../inc/../HAL/../HAL/STM32/HAL.h:28,
                   from Marlin\src\lcd\dogm\../../inc/../HAL/HAL.h:30,
                   from Marlin\src\lcd\dogm\../../inc/MarlinConfig.h:31,
                   from Marlin\src\lcd\dogm\HAL_LCD_class_defines.h:24,
                   from Marlin\src\lcd\dogm\marlinui_DOGM.h:31,
                   from Marlin\src\lcd\dogm\marlinui_DOGM.cpp:42:
  Marlin\src\lcd\dogm\marlinui_DOGM.cpp: In static member function 'static void MarlinUI::draw_custom_bootscreen(uint8_t)':
  Marlin\src\lcd\dogm\marlinui_DOGM.cpp:127:114: error: request for member 'bitmap' in 'custom_bootscreen_animation[((int)frame)]', which is of pointer type 'const boot_frame_t* const' (maybe you meant to use '->' ?)
    127 |           const u8g_pgm_uint8_t * const bmp = (u8g_pgm_uint8_t*)pgm_read_ptr(&custom_bootscreen_animation[frame].bitmap);
        |                                                                                                                  ^~~~~~
  Marlin\src\lcd\dogm\../../inc/../HAL/../HAL/STM32/../shared/progmem.h:188:40: note: in definition of macro 'pgm_read_ptr'
    188 | #define pgm_read_ptr(addr) (*((void**)(addr)))
        |                                        ^~~~
    ```
- Build errors with `CUSTOM_BOOTSCREEN_ANIMATED_FRAME_TIME`
  ```
  In file included from C:\Users\mux\.platformio\packages\framework-arduinoststm32\cores\arduino/WString.h:29,
                   from C:\Users\mux\.platformio\packages\framework-arduinoststm32\cores\arduino/Print.h:27,
                   from .pio\libdeps\STM32F103RE_creality\U8glib-HAL\src/U8glib-HAL.h:43,
                   from Marlin\src\lcd\dogm\marlinui_DOGM.h:30,
  Compiling .pio\build\STM32F103RE_creality\src\src\lcd\menu\menu_configuration.cpp.o
                   from Marlin\src\lcd\dogm\marlinui_DOGM.cpp:42:
  Marlin\src\lcd\dogm\marlinui_DOGM.cpp: In static member function 'static void MarlinUI::show_custom_bootscreen()':
  Marlin\src\lcd\dogm\marlinui_DOGM.cpp:164:88: error: request for member 'duration' in 'custom_bootscreen_animation[((int)fr)]', which is of pointer type 'const boot_frame_t* const' (maybe you meant to use '->' ?)
    164 |             const millis_t frame_time = pgm_read_word(&custom_bootscreen_animation[fr].duration);
        |                                                                                        ^~~~~~~~
  C:\Users\mux\.platformio\packages\framework-arduinoststm32\cores\arduino/avr/pgmspace.h:102:10: note: in definition of macro 'pgm_read_word'
    102 |   typeof(addr) _addr = (addr); \
        |          ^~~~
  Marlin\src\lcd\dogm\marlinui_DOGM.cpp:164:88: error: request for member 'duration' in 'custom_bootscreen_animation[((int)fr)]', which is of pointer type 'const boot_frame_t* const' (maybe you meant to use '->' ?)
  Compiling .pio\build\STM32F103RE_creality\src\src\lcd\menu\menu_filament.cpp.o
    164 |             const millis_t frame_time = pgm_read_word(&custom_bootscreen_animation[fr].duration);
        |                                                                                        ^~~~~~~~
  C:\Users\mux\.platformio\packages\framework-arduinoststm32\cores\arduino/avr/pgmspace.h:102:25: note: in definition of macro 'pgm_read_word'
    102 |   typeof(addr) _addr = (addr); \
        |                         ^~~~
  ```
- This seems like a memory access change when compared against the [only other 3D printer with an amimated bootscreen](https://github.com/MarlinFirmware/Configurations/blob/import-2.1.x/config/examples/delta/Velleman/K8800/_Bootscreen.h#L284)
  ```
    // Each frame has its own custom duration
    const boot_frame_t custom_bootscreen_animation[] PROGMEM = {
      { custom_start_bmp1,  1000 },  // 1.0s
      { custom_start_bmp2,  1000 },  // 1.0s
      { custom_start_bmp3,  1000 },  // 1.0s
      { custom_start_bmp4,   500 }   // 0.5s
    };
  ```
- Declaring the sequence with `const boot_frame_t custom_bootscreen_animation[]` fixes the animation visuals

## CR30-Users tests

- Copy in `_Bootscreen.h` and `_Statusscreen.h_`
- The animation sequence is declared as `const unsigned char * const custom_bootscreen_animation[]`
- Builds without error
- Animates without error

## First look

### M115

```
FIRMWARE_NAME:Marlin 2.1.2.1 + pull/1 (Jun 10 2023 16:54:06) SOURCE_CODE_URL:github.com/wireddown/GCode-Machine-Configurations PROTOCOL_VERSION:1.0 MACHINE_TYPE:camina EXTRUDER_COUNT:1 UUID:CA319A00-0000-0000-0000-00BE174103D4
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
echo:  M92 X80.00 Y80.00 Z1148.40 E137.65
echo:; Max feedrates (units/s):
echo:  M203 X300.00 Y300.00 Z10.00 E75.00
echo:; Max Acceleration (units/s2):
echo:  M201 X300.00 Y300.00 Z100.00 E5000.00
echo:; Acceleration (units/s2) (P<print-accel> R<retract-accel> T<travel-accel>):
echo:  M204 P300.00 R300.00 T600.00
echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> X<max_jerk> Y<max_jerk> Z<max_jerk> E<max_jerk>):
echo:  M205 B20000.00 S0.00 T0.00 X6.00 Y6.00 Z0.40 E10.00
echo:; Home offset:
echo:  M206 X0.00 Y0.00 Z0.00
echo:; Material heatup parameters:
echo:  M145 S0 H185.00 B55.00 F0
echo:  M145 S1 H240.00 B70.00 F0
echo:; Hotend PID:
echo:  M301 P24.19 I2.14 D68.33
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

## After tuning

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

## After input shaping

### M115

```
FIRMWARE_NAME:Marlin 09d0b4d15 + pull/2 (Jul  5 2023 18:42:22) SOURCE_CODE_URL:github.com/wireddown/GCode-Machine-Configurations PROTOCOL_VERSION:1.0 MACHINE_TYPE:Camina EXTRUDER_COUNT:1 UUID:CA319A00-0000-0000-0000-00BE174103D4
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
echo:; Advanced (B<min_segment_time_us> S<min_feedrate> T<min_travel_feedrate> J<junc_dev>):
echo:  M205 B20000.00 S0.00 T0.00 J0.02
echo:; Home offset:
echo:  M206 X0.00 Y0.97 Z0.00
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
echo:; Input Shaping:
echo:  M593 X F16.60 D0.15
echo:  M593 Y F16.60 D0.15
echo:; Filament load/unload:
echo:  M603 L0.00 U100.00 ; (mm)
echo:; Filament runout sensor:
echo:  M412 S1 ; Sensor ON
```
