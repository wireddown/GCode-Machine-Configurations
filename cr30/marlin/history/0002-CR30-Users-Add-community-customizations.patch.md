# CR30-Users: Add community customizations

## Cover

```
From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
From: Down to the Wire <8404598+wireddown@users.noreply.github.com>
Date: Mon, 5 Jun 2023 20:43:23 -0700
Subject: CR30-Users: Add community customizations

---
 Marlin/Configuration.h                        |   72 +-
 Marlin/Configuration_adv.h                    |   50 +-
 Marlin/_Bootscreen.h                          | 1652 ++++++++++-------
 Marlin/_Statusscreen.h                        |   65 +-
 Marlin/src/inc/Version.h                      |    2 +-
 Marlin/src/lcd/dogm/dogm_Bootscreen.h         |   85 +-
 Marlin/src/lcd/menu/menu_motion.cpp           |   20 +-
 Marlin/src/module/planner.cpp                 |   36 +-
 Marlin/src/module/stepper.cpp                 |    8 +-
 Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h |   37 +-
 10 files changed, 1197 insertions(+), 830 deletions(-)
```

## Marlin/Configuration.h

```diff
diff --git a/Marlin/Configuration.h b/Marlin/Configuration.h
index 8075f1389d..54d03546e7 100644
--- a/Marlin/Configuration.h
+++ b/Marlin/Configuration.h
@@ -1,30 +1,28 @@
 /**
  * Marlin 3D Printer Firmware
- * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ * Copyright (c) 2020 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
  *
  * Based on Sprinter and grbl.
  * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
  *
  */
 #pragma once
 
-#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
-
 /**
  * Configuration.h
  *
  * Basic settings such as:
  *
@@ -70,11 +68,11 @@
 
 // @section info
 
 // Author info of this build printed to the host during boot and M115
 #define STRING_CONFIG_H_AUTHOR "3DPrintMill" // Who made the changes.
-//#define CUSTOM_VERSION_FILE Version.h // Path from the root directory (no quotes)
+#define CUSTOM_VERSION_FILE Version.h // Path from the root directory (no quotes)
 
 /**
  * *** VENDORS PLEASE READ ***
  *
  * Marlin allows you to add a custom boot image for Graphical LCDs.
@@ -128,11 +126,11 @@
 /**
  * Select a secondary serial port on the board to use for communication with the host.
  * Currently Ethernet (-2) is only supported on Teensy 4.1 boards.
  * :[-2, -1, 0, 1, 2, 3, 4, 5, 6, 7]
  */
-#define SERIAL_PORT_2 3
+//#define SERIAL_PORT_2 -1
 //#define BAUDRATE_2 250000   // Enable to override BAUDRATE
 
 /**
  * Select a third serial port on the board to use for communication with the host.
  * Currently only supported for AVR, DUE, LPC1768/9 and STM32/STM32F1
@@ -555,18 +553,18 @@
 #define CHAMBER_MINTEMP    5
 
 // Above this temperature the heater will be switched off.
 // This can protect components from overheating, but NOT from shorts and failures.
 // (Use MINTEMP for thermistor short/failure protection.)
-#define HEATER_0_MAXTEMP 255
-#define HEATER_1_MAXTEMP 255
-#define HEATER_2_MAXTEMP 255
-#define HEATER_3_MAXTEMP 255
-#define HEATER_4_MAXTEMP 255
-#define HEATER_5_MAXTEMP 255
-#define HEATER_6_MAXTEMP 255
-#define HEATER_7_MAXTEMP 255
+#define HEATER_0_MAXTEMP 275
+#define HEATER_1_MAXTEMP 275
+#define HEATER_2_MAXTEMP 275
+#define HEATER_3_MAXTEMP 275
+#define HEATER_4_MAXTEMP 275
+#define HEATER_5_MAXTEMP 275
+#define HEATER_6_MAXTEMP 275
+#define HEATER_7_MAXTEMP 275
 #define BED_MAXTEMP      125
 #define CHAMBER_MAXTEMP  60
 
 /**
  * Thermal Overshoot
@@ -589,11 +587,11 @@
 #define PID_MAX BANG_MAX // Limits current to nozzle while PID is active (see PID_FUNCTIONAL_RANGE below); 255=full current
 #define PID_K1 0.95      // Smoothing factor within any PID loop
 
 #if ENABLED(PIDTEMP)
   //#define PID_EDIT_MENU         // Add PID editing to the "Advanced Settings" menu. (~700 bytes of PROGMEM)
-  //#define PID_AUTOTUNE_MENU     // Add PID auto-tuning to the "Advanced Settings" menu. (~250 bytes of PROGMEM)
+  #define PID_AUTOTUNE_MENU     // Add PID auto-tuning to the "Advanced Settings" menu. (~250 bytes of PROGMEM)
   //#define PID_PARAMS_PER_HOTEND // Uses separate PID parameters for each extruder (useful for mismatched extruders)
                                   // Set/get with gcode: M301 E[extruder number, 0-2]
 
   #if ENABLED(PID_PARAMS_PER_HOTEND)
     // Specify up to one value per hotend here, according to your setup.
@@ -760,18 +758,23 @@
 //#define MARKFORGED_XY  // MarkForged. See https://reprap.org/forum/read.php?152,504042
 //#define MARKFORGED_YX
 
 // Enable for a belt style printer with endless "Z" motion
 #define BELTPRINTER
+#if ENABLED(BELTPRINTER)
+  //#define BELT_KINEMATICS_DEV
+  #define BED_TO_TRUSS_ANGLE 45
+#endif
 
 // Enable for Polargraph Kinematics
 //#define POLARGRAPH
 #if ENABLED(POLARGRAPH)
   #define POLARGRAPH_MAX_BELT_LEN 1035.0
   #define POLAR_SEGMENTS_PER_SECOND 5
 #endif
 
+
 //===========================================================================
 //============================== Endstop Settings ===========================
 //===========================================================================
 
 // @section homing
@@ -841,11 +844,11 @@
 #define Y_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define Z_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define I_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define J_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define K_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
-#define Z_MIN_PROBE_ENDSTOP_INVERTING true  // Set to true to invert the logic of the probe.
+#define Z_MIN_PROBE_ENDSTOP_INVERTING true // Set to true to invert the logic of the probe.
 
 /**
  * Stepper Drivers
  *
  * These settings allow Marlin to tune stepper driver timing and enable advanced options for
@@ -927,31 +930,31 @@
 /**
  * Default Axis Steps Per Unit (steps/mm)
  * Override with M92
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
-#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 1152.95, 137.65 }
+#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 1148.4, 137.65 }
 
 /**
  * Default Max Feed Rate (mm/s)
  * Override with M203
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
 #define DEFAULT_MAX_FEEDRATE          { 300, 300, 10, 75 }
 
 #define LIMITED_MAX_FR_EDITING        // Limit edit via M203 or LCD to DEFAULT_MAX_FEEDRATE * 2
 #if ENABLED(LIMITED_MAX_FR_EDITING)
-  #define MAX_FEEDRATE_EDIT_VALUES    { 600, 600, 10, 50 } // ...or, set your own edit limits
+  #define MAX_FEEDRATE_EDIT_VALUES    { 600, 600, 10, 75 } // ...or, set your own edit limits
 #endif
 
 /**
  * Default Max Acceleration (change/s) change = mm/s
  * (Maximum start speed for accelerated moves)
  * Override with M201
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
-#define DEFAULT_MAX_ACCELERATION      { 300, 300, 100, 1000 }
+#define DEFAULT_MAX_ACCELERATION      { 300, 300, 100, 5000 }
 
 //#define LIMITED_MAX_ACCEL_EDITING     // Limit edit via M201 or LCD to DEFAULT_MAX_ACCELERATION * 2
 #if ENABLED(LIMITED_MAX_ACCEL_EDITING)
   #define MAX_ACCEL_EDIT_VALUES       { 6000, 6000, 200, 20000 } // ...or, set your own edit limits
 #endif
@@ -976,12 +979,12 @@
  * When changing speed and direction, if the difference is less than the
  * value set here, it may happen instantaneously.
  */
 #define CLASSIC_JERK
 #if ENABLED(CLASSIC_JERK)
-  #define DEFAULT_XJERK  6.0
-  #define DEFAULT_YJERK  6.0
+  #define DEFAULT_XJERK 6.0
+  #define DEFAULT_YJERK 6.0
   #define DEFAULT_ZJERK  0.4
   //#define DEFAULT_IJERK  0.3
   //#define DEFAULT_JJERK  0.3
   //#define DEFAULT_KJERK  0.3
 
@@ -1377,17 +1380,17 @@
 //#define J_HOME_DIR -1
 //#define K_HOME_DIR -1
 
 // @section machine
 
-// The size of the printable area
+// The size of the print bed
 #define X_BED_SIZE 220
-#define Y_BED_SIZE 250
+#define Y_BED_SIZE 240
 
 // Travel limits (mm) after homing, corresponding to endstop positions.
 #define X_MIN_POS 0
-#define Y_MIN_POS -5
+#define Y_MIN_POS 0
 #define Z_MIN_POS 0
 #define X_MAX_POS X_BED_SIZE
 #define Y_MAX_POS Y_BED_SIZE
 #define Z_MAX_POS 20000000
 //#define I_MIN_POS 0
@@ -1408,12 +1411,12 @@
 
 // Min software endstops constrain movement within minimum coordinate bounds
 #define MIN_SOFTWARE_ENDSTOPS
 #if ENABLED(MIN_SOFTWARE_ENDSTOPS)
   #define MIN_SOFTWARE_ENDSTOP_X
-  #define MIN_SOFTWARE_ENDSTOP_Y
-  #define MIN_SOFTWARE_ENDSTOP_Z
+  //#define MIN_SOFTWARE_ENDSTOP_Y
+  //#define MIN_SOFTWARE_ENDSTOP_Z
   #define MIN_SOFTWARE_ENDSTOP_I
   #define MIN_SOFTWARE_ENDSTOP_J
   #define MIN_SOFTWARE_ENDSTOP_K
 #endif
 
@@ -1733,11 +1736,11 @@
 //#define BED_CENTER_AT_0_0
 
 // Manually set the home position. Leave these undefined for automatic settings.
 // For DELTA this is the top-center of the Cartesian print volume.
 //#define MANUAL_X_HOME_POS 0
-#define MANUAL_Y_HOME_POS 0
+//#define MANUAL_Y_HOME_POS 0
 //#define MANUAL_Z_HOME_POS 0
 //#define MANUAL_I_HOME_POS 0
 //#define MANUAL_J_HOME_POS 0
 //#define MANUAL_K_HOME_POS 0
 
@@ -1868,35 +1871,35 @@
 // Preheat Constants - Up to 5 are supported without changes
 //
 #define PREHEAT_1_LABEL       "PLA"
 #define PREHEAT_1_TEMP_HOTEND 185
 #define PREHEAT_1_TEMP_BED     55
-#define PREHEAT_1_TEMP_CHAMBER 30
+#define PREHEAT_1_TEMP_CHAMBER 35
 #define PREHEAT_1_FAN_SPEED     0 // Value from 0 to 255
 
 #define PREHEAT_2_LABEL       "ABS"
 #define PREHEAT_2_TEMP_HOTEND 240
-#define PREHEAT_2_TEMP_BED     70
+#define PREHEAT_2_TEMP_BED    70
 #define PREHEAT_2_TEMP_CHAMBER 35
 #define PREHEAT_2_FAN_SPEED     0 // Value from 0 to 255
 
 /**
  * Nozzle Park
  *
  * Park the nozzle at the given XYZ position on idle or G27.
  *
  * The "P" parameter controls the action applied to the Z axis:
  *
  *    P0  (Default) If Z is below park Z raise the nozzle.
  *    P1  Raise the nozzle always to Z-park height.
  *    P2  Raise the nozzle by Z-park amount, limited to Z_MAX_POS.
  */
 #define NOZZLE_PARK_FEATURE
 
 #if ENABLED(NOZZLE_PARK_FEATURE)
   // Specify a park position as { X, Y, Z_raise }
-  #define NOZZLE_PARK_POINT { X_MIN_POS, MANUAL_Y_HOME_POS + 100, 0 }
+  #define NOZZLE_PARK_POINT { (X_MIN_POS), (Y_MIN_POS + 100), 0 }
   //#define NOZZLE_PARK_X_ONLY          // X move only is required to park
   //#define NOZZLE_PARK_Y_ONLY          // Y move only is required to park
   #define NOZZLE_PARK_Z_RAISE_MIN   0   // (mm) Always raise Z by at least this distance
   #define NOZZLE_PARK_XY_FEEDRATE 100   // (mm/s) X and Y axes feedrate (also used for delta Z axis)
   #define NOZZLE_PARK_Z_FEEDRATE    5   // (mm/s) Z axis feedrate (not used for delta printers)
@@ -2068,10 +2071,11 @@
  *
  * :{ 'en':'English', 'an':'Aragonese', 'bg':'Bulgarian', 'ca':'Catalan', 'cz':'Czech', 'da':'Danish', 'de':'German', 'el':'Greek (Greece)', 'el_CY':'Greek (Cyprus)', 'es':'Spanish', 'eu':'Basque-Euskera', 'fi':'Finnish', 'fr':'French', 'gl':'Galician', 'hr':'Croatian', 'hu':'Hungarian', 'it':'Italian', 'jp_kana':'Japanese', 'ko_KR':'Korean (South Korea)', 'nl':'Dutch', 'pl':'Polish', 'pt':'Portuguese', 'pt_br':'Portuguese (Brazilian)', 'ro':'Romanian', 'ru':'Russian', 'sk':'Slovak', 'sv':'Swedish', 'tr':'Turkish', 'uk':'Ukrainian', 'vi':'Vietnamese', 'zh_CN':'Chinese (Simplified)', 'zh_TW':'Chinese (Traditional)' }
  */
 #define LCD_LANGUAGE en
 
+
 /**
  * LCD Character Set
  *
  * Note: This option is NOT applicable to Graphical Displays.
  *
@@ -2474,15 +2478,10 @@
 // This is RAMPS-compatible using a single 10-pin connector.
 // (For CR-10 owners who want to replace the Melzi Creality board but retain the display)
 //
 #define CR10_STOCKDISPLAY
 
-//
-// Creality V4.2.5 display. Creality board but retain the display.
-//
-#define RET6_12864_LCD
-
 //
 // Ender-2 OEM display, a variant of the MKS_MINI_12864
 //
 //#define ENDER2_STOCKDISPLAY
 
@@ -2797,10 +2796,15 @@
 //#define DWIN_CREALITY_LCD_ENHANCED  // Enhanced UI
 //#define DWIN_CREALITY_LCD_JYERSUI   // Jyers UI by Jacob Myers
 //#define DWIN_MARLINUI_PORTRAIT      // MarlinUI (portrait orientation)
 //#define DWIN_MARLINUI_LANDSCAPE     // MarlinUI (landscape orientation)
 
+//
+// Creality V4.2.5 display. Creality board but retain the display.
+//
+#define RET6_12864_LCD
+
 //
 // Touch Screen Settings
 //
 //#define TOUCH_SCREEN
 #if ENABLED(TOUCH_SCREEN)
```

## Marlin/Configuration_adv.h

```diff
diff --git a/Marlin/Configuration_adv.h b/Marlin/Configuration_adv.h
index 97c89a006b..01b6d09718 100644
--- a/Marlin/Configuration_adv.h
+++ b/Marlin/Configuration_adv.h
@@ -1,30 +1,28 @@
 /**
  * Marlin 3D Printer Firmware
- * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ * Copyright (c) 2020 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
  *
  * Based on Sprinter and grbl.
  * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
  *
  */
 #pragma once
 
-#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
-
 /**
  * Configuration_adv.h
  *
  * Advanced settings.
  * Only change these if you know exactly what you're doing.
@@ -303,25 +301,25 @@
    *
    * If you get false positives for "Heating failed", increase WATCH_TEMP_PERIOD
    * and/or decrease WATCH_TEMP_INCREASE. WATCH_TEMP_INCREASE should not be set
    * below 2.
    */
-  #define WATCH_TEMP_PERIOD  40               // Seconds
+  #define WATCH_TEMP_PERIOD  20               // Seconds
   #define WATCH_TEMP_INCREASE 2               // Degrees Celsius
 #endif
 
 /**
  * Thermal Protection parameters for the bed are just as above for hotends.
  */
 #if ENABLED(THERMAL_PROTECTION_BED)
-  #define THERMAL_PROTECTION_BED_PERIOD       180 // Seconds
+  #define THERMAL_PROTECTION_BED_PERIOD        20 // Seconds
   #define THERMAL_PROTECTION_BED_HYSTERESIS     2 // Degrees Celsius
 
   /**
    * As described above, except for the bed (M140/M190/M303).
    */
-  #define WATCH_BED_TEMP_PERIOD               180 // Seconds
+  #define WATCH_BED_TEMP_PERIOD                60 // Seconds
   #define WATCH_BED_TEMP_INCREASE               2 // Degrees Celsius
 #endif
 
 /**
  * Thermal Protection parameters for the heated chamber.
@@ -506,24 +504,24 @@
  * To cool down the stepper drivers and MOSFETs.
  *
  * The fan turns on automatically whenever any driver is enabled and turns
  * off (or reduces to idle speed) shortly after drivers are turned off.
  */
-//#define USE_CONTROLLER_FAN
+#define USE_CONTROLLER_FAN
 #if ENABLED(USE_CONTROLLER_FAN)
-  //#define CONTROLLER_FAN_PIN -1           // Set a custom pin for the controller fan
+  #define CONTROLLER_FAN_PIN PC1            // Set a custom pin for the controller fan
   //#define CONTROLLER_FAN_USE_Z_ONLY       // With this option only the Z axis is considered
   //#define CONTROLLER_FAN_IGNORE_Z         // Ignore Z stepper. Useful when stepper timeout is disabled.
   #define CONTROLLERFAN_SPEED_MIN         0 // (0-255) Minimum speed. (If set below this value the fan is turned off.)
   #define CONTROLLERFAN_SPEED_ACTIVE    255 // (0-255) Active speed, used when any motor is enabled
   #define CONTROLLERFAN_SPEED_IDLE        0 // (0-255) Idle speed, used when motors are disabled
   #define CONTROLLERFAN_IDLE_TIME        60 // (seconds) Extra time to keep the fan running after disabling motors
 
   // Use TEMP_SENSOR_BOARD as a trigger for enabling the controller fan
   //#define CONTROLLER_FAN_MIN_BOARD_TEMP 40  // (°C) Turn on the fan if the board reaches this temperature
 
-  //#define CONTROLLER_FAN_EDITABLE         // Enable M710 configurable settings
+  #define CONTROLLER_FAN_EDITABLE           // Enable M710 configurable settings
   #if ENABLED(CONTROLLER_FAN_EDITABLE)
     #define CONTROLLER_FAN_MENU             // Enable the Controller Fan submenu
   #endif
 #endif
 
@@ -605,11 +603,11 @@
  * or set to -1 to disable completely.
  *
  * Multiple extruders can be assigned to the same pin in which case
  * the fan will turn on when any selected extruder is above the threshold.
  */
-#define E0_AUTO_FAN_PIN -1
+#define E0_AUTO_FAN_PIN PC0
 #define E1_AUTO_FAN_PIN -1
 #define E2_AUTO_FAN_PIN -1
 #define E3_AUTO_FAN_PIN -1
 #define E4_AUTO_FAN_PIN -1
 #define E5_AUTO_FAN_PIN -1
@@ -672,19 +670,19 @@
 #define FANMUX2_PIN -1
 
 /**
  * M355 Case Light on-off / brightness
  */
-//#define CASE_LIGHT_ENABLE
+#define CASE_LIGHT_ENABLE
 #if ENABLED(CASE_LIGHT_ENABLE)
-  //#define CASE_LIGHT_PIN 4                  // Override the default pin if needed
+  #define CASE_LIGHT_PIN PC14                 // Override the default pin if needed
   #define INVERT_CASE_LIGHT false             // Set true if Case Light is ON when pin is LOW
   #define CASE_LIGHT_DEFAULT_ON true          // Set default power-up state on
-  #define CASE_LIGHT_DEFAULT_BRIGHTNESS 105   // Set default power-up brightness (0-255, requires PWM pin)
+  #define CASE_LIGHT_DEFAULT_BRIGHTNESS 255   // Set default power-up brightness (0-255, requires PWM pin)
   //#define CASE_LIGHT_NO_BRIGHTNESS          // Disable brightness control. Enable for non-PWM lighting.
   //#define CASE_LIGHT_MAX_PWM 128            // Limit PWM duty cycle (0-255)
-  //#define CASE_LIGHT_MENU                   // Add Case Light options to the LCD menu
+  #define CASE_LIGHT_MENU                   // Add Case Light options to the LCD menu
   #if ENABLED(NEOPIXEL_LED)
     //#define CASE_LIGHT_USE_NEOPIXEL         // Use NeoPixel LED as case light
   #endif
   #if EITHER(RGB_LED, RGBW_LED)
     //#define CASE_LIGHT_USE_RGB_LED          // Use RGB / RGBW LED as case light
@@ -1375,11 +1373,11 @@
 
   // Add an 'M73' G-code to set the current percentage
   //#define LCD_SET_PROGRESS_MANUALLY
 
   // Show the E position (filament used) during printing
-  #define LCD_SHOW_E_TOTAL
+  //#define LCD_SHOW_E_TOTAL
 #endif
 
 // LCD Print Progress options
 #if EITHER(SDSUPPORT, LCD_SET_PROGRESS_MANUALLY)
   #if CAN_SHOW_REMAINING_TIME
@@ -1428,26 +1426,26 @@
   #define GCODE_REPEAT_MARKERS              // Enable G-code M808 to set repeat markers and do looping
 
   #define SD_PROCEDURE_DEPTH 1              // Increase if you need more nested M32 calls
 
   #define SD_FINISHED_STEPPERRELEASE true   // Disable steppers when SD Print is finished
-  #define SD_FINISHED_RELEASECOMMAND "G28XY\nG1Y100\nM84"  // Use "M84XYE" to keep Z enabled so your bed stays in place
+  #define SD_FINISHED_RELEASECOMMAND "G28XY\nG1Y5\nM84"  // Use "M84XYE" to keep Z enabled so your bed stays in place
 
   // Reverse SD sort to show "more recent" files first, according to the card's FAT.
   // Since the FAT gets out of order with usage, SDCARD_SORT_ALPHA is recommended.
   #define SDCARD_RATHERRECENTFIRST
 
   #define SD_MENU_CONFIRM_START             // Confirm the selected SD file before printing
 
   //#define NO_SD_AUTOSTART                 // Remove auto#.g file support completely to save some Flash, SRAM
   //#define MENU_ADDAUTOSTART               // Add a menu option to run auto#.g files
 
   //#define BROWSE_MEDIA_ON_INSERT          // Open the file browser when media is inserted
 
-  //#define MEDIA_MENU_AT_TOP               // Force the media menu to be listed on the top of the main menu
+  #define MEDIA_MENU_AT_TOP               // Force the media menu to be listed on the top of the main menu
 
-  #define EVENT_GCODE_SD_ABORT "G28XY\nG1Y100" // G-code to run on SD Abort Print (e.g., "G28XY" or "G27")
+  #define EVENT_GCODE_SD_ABORT "G28XY\nG1Y5" // G-code to run on SD Abort Print (e.g., "G28XY" or "G27")
 
   #if ENABLED(PRINTER_EVENT_LEDS)
     #define PE_LEDS_COMPLETED_TIME  (30*60) // (seconds) Time to keep the LED "done" color before restoring normal illumination
   #endif
 
@@ -1729,11 +1727,11 @@
 #if HAS_MARLINUI_U8GLIB || IS_DWIN_MARLINUI
   // Show SD percentage next to the progress bar
   //#define SHOW_SD_PERCENT
 
   // Enable to save many cycles by drawing a hollow frame on Menu Screens
-  //#define MENU_HOLLOW_FRAME
+  #define MENU_HOLLOW_FRAME
 
   // Swap the CW/CCW indicators in the graphics overlay
   //#define OVERLAY_GFX_REVERSE
 #endif
 
@@ -1950,14 +1948,14 @@
   //#define BABYSTEP_WITHOUT_HOMING
   #define BABYSTEP_ALWAYS_AVAILABLE         // Allow babystepping at all times (not just during movement).
   #define BABYSTEP_XY                       // Also enable X/Y Babystepping. Not supported on DELTA!
   #define BABYSTEP_INVERT_Z false           // Change if Z babysteps should go the other way
   //#define BABYSTEP_MILLIMETER_UNITS       // Specify BABYSTEP_MULTIPLICATOR_(XY|Z) in mm instead of micro-steps
-  #define BABYSTEP_MULTIPLICATOR_Z  11      // (steps or mm) Steps or millimeter distance for each Z babystep
+  #define BABYSTEP_MULTIPLICATOR_Z  11       // (steps or mm) Steps or millimeter distance for each Z babystep
   #define BABYSTEP_MULTIPLICATOR_XY 2       // (steps or mm) Steps or millimeter distance for each XY babystep
 
-  #define DOUBLECLICK_FOR_Z_BABYSTEPPING    // Double-click on the Status Screen for Z Babystepping.
+  //#define DOUBLECLICK_FOR_Z_BABYSTEPPING  // Double-click on the Status Screen for Z Babystepping.
   #if ENABLED(DOUBLECLICK_FOR_Z_BABYSTEPPING)
     #define DOUBLECLICK_MAX_INTERVAL 1250   // Maximum interval between clicks, in milliseconds.
                                             // Note: Extra time may be added to mitigate controller latency.
     //#define MOVE_Z_WHEN_IDLE              // Jump to the move Z menu on doubleclick when printer is idle.
     #if ENABLED(MOVE_Z_WHEN_IDLE)
@@ -1989,14 +1987,14 @@
  * If this algorithm produces a higher speed offset than the extruder can handle (compared to E jerk)
  * print acceleration will be reduced during the affected moves to keep within the limit.
  *
  * See https://marlinfw.org/docs/features/lin_advance.html for full instructions.
  */
-#define LIN_ADVANCE
+//#define LIN_ADVANCE
 #if ENABLED(LIN_ADVANCE)
   //#define EXTRA_LIN_ADVANCE_K // Enable for second linear advance constants
-  #define LIN_ADVANCE_K 0       // Unit: mm compression per 1mm/s extruder speed
+  #define LIN_ADVANCE_K 0.22    // Unit: mm compression per 1mm/s extruder speed
   //#define LA_DEBUG            // If enabled, this will generate debug information output over USB.
   //#define EXPERIMENTAL_SCURVE // Enable this option to permit S-Curve Acceleration
   //#define ALLOW_LOW_EJERK     // Allow a DEFAULT_EJERK value of <10. Recommended for direct drive hotends.
 #endif
 
@@ -3098,11 +3096,11 @@
 
   /**
    * Enable M122 debugging command for TMC stepper drivers.
    * M122 S0/1 will enable continuous reporting.
    */
-  //#define TMC_DEBUG
+  #define TMC_DEBUG
 
   /**
    * You can set your own advanced settings by filling in predefined functions.
    * A list of available functions can be found on the library github page
    * https://github.com/teemuatlut/TMCStepper
@@ -3442,11 +3440,11 @@
 #if EITHER(SPINDLE_FEATURE, LASER_FEATURE)
   #define SPINDLE_LASER_ACTIVE_STATE    LOW    // Set to "HIGH" if SPINDLE_LASER_ENA_PIN is active HIGH
 
   #define SPINDLE_LASER_USE_PWM                // Enable if your controller supports setting the speed/power
   #if ENABLED(SPINDLE_LASER_USE_PWM)
-    #define SPINDLE_LASER_PWM_INVERT    true   // Set to "true" if the speed/power goes up when you want it to go slower
+    #define SPINDLE_LASER_PWM_INVERT    false  // Set to "true" if the speed/power goes up when you want it to go slower
     #define SPINDLE_LASER_FREQUENCY     2500   // (Hz) Spindle/laser frequency (only on supported HALs: AVR and LPC)
   #endif
 
   //#define AIR_EVACUATION                     // Cutter Vacuum / Laser Blower motor control with G-codes M10-M11
   #if ENABLED(AIR_EVACUATION)
@@ -3952,11 +3950,11 @@
  * Some features add reason codes to extend these commands.
  *
  * Host Prompt Support enables Marlin to use the host for user prompts so
  * filament runout and other processes can be managed from the host side.
  */
-//#define HOST_ACTION_COMMANDS
+#define HOST_ACTION_COMMANDS
 #if ENABLED(HOST_ACTION_COMMANDS)
   //#define HOST_PAUSE_M76
   //#define HOST_PROMPT_SUPPORT
   //#define HOST_START_MENU_ITEM      // Add a menu item that tells the host to start
   //#define HOST_SHUTDOWN_MENU_ITEM   // Add a menu item that tells the host to shut down
```

## Marlin/_Bootscreen.h

```diff
diff --git a/Marlin/_Bootscreen.h b/Marlin/_Bootscreen.h
index 884806170f..8e72bfe3d7 100644
--- a/Marlin/_Bootscreen.h
+++ b/Marlin/_Bootscreen.h
@@ -1,752 +1,1044 @@
 /**
  * Marlin 3D Printer Firmware
- * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ * Copyright (c) 2020 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
  *
  * Based on Sprinter and grbl.
  * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 #pragma once
 
-#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
-
 /**
  * Animated boot screen example
  */
 
-#define CUSTOM_BOOTSCREEN_BOTTOM_JUSTIFY
 #define CUSTOM_BOOTSCREEN_ANIMATED
+#define CUSTOM_BOOTSCREEN_FRAME_TIME 300  // (ms)
+
+#define CUSTOM_BOOTSCREEN_BMPWIDTH   128
 
 const unsigned char custom_start_bmp[] PROGMEM = {
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-  B00000000,B00000001,B11111100,B00111111,B10000111,B11111100,B11111111,B10011011,B00000011,B11111111,B11001110,B01110011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000001,B11111110,B00111111,B11000111,B11111110,B11111111,B11011011,B10000011,B11111111,B11011111,B11111011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B11000000,B11011011,B11000011,B00001100,B00011111,B11111011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B11001111,B11011011,B11100011,B00001100,B00011101,B10111011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B11011111,B10011011,B01110011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11011100,B00011011,B00111011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11001110,B00011011,B00011111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000111,B00011011,B00001111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-  B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000011,B10011011,B00000111,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
-  B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000001,B11011011,B00000011,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
+  B00000000,B00000000,B00001111,B11111101,B11111111,B11000000,B11111111,B10000000,B11000000,B01100000,B00001111,B11111111,B11111000,B00001111,B00000000,B00000000,
+  B00000000,B00000000,B00011111,B11111101,B11111111,B11100011,B11111111,B10000000,B11000000,B01100000,B00001111,B11111111,B11111000,B00011110,B00000000,B00000000,
+  B00000000,B00000000,B00111100,B00000001,B10000000,B01100111,B10000000,B00000001,B11000000,B01100000,B00001110,B00001110,B00011110,B00111100,B00000000,B00000000,
+  B00000000,B00000000,B01110000,B00000001,B10000000,B01100111,B00000000,B00000001,B11100000,B01100000,B00001110,B00001110,B00001111,B01111000,B00000000,B00000000,
+  B00000000,B00000000,B01100000,B00000001,B10000000,B01101110,B00000000,B00000011,B11100000,B01100000,B00001110,B00001110,B00000111,B11110000,B00000000,B00000000,
+  B00000000,B00000000,B01100000,B00000001,B10111111,B11101111,B11111111,B10000011,B01110000,B01100000,B00001110,B00001110,B00000011,B11100000,B00000000,B00000000,
+  B00000000,B00000000,B01100000,B00000001,B10011111,B11001111,B11111111,B10000111,B00111000,B01100000,B00001110,B00001110,B00000001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B01100000,B00000001,B10001110,B00001110,B00000000,B00000111,B00011000,B01100000,B00001110,B00001110,B00000001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B01110000,B00000001,B10000111,B00000111,B00000000,B00001110,B00011110,B01100000,B00001110,B00001110,B00000001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B00111100,B00000001,B10000011,B10000111,B10000000,B00001100,B00001110,B01100000,B00001110,B00001110,B00000001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B00011111,B11111101,B10000001,B11000011,B11111111,B10011100,B11111110,B01111111,B11101110,B00001110,B00000001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B00001111,B11111101,B10000000,B11100000,B11111111,B10111101,B11111111,B01111111,B11101110,B00001110,B00000001,B11000000,B00000000,B00000000,
   B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-  B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-  B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-  B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-  B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-  B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-  B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
-  B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
-  B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
-  B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
-  B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-  B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
-  B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
-  B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
-  B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
-  B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
-  B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-  B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-  B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
-  B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
 };
 
-#if DISABLED(CUSTOM_BOOTSCREEN_ANIMATED)
-
-  #define CUSTOM_BOOTSCREEN_FRAME_TIME 500 // (ms)
-
-#else
+#if ENABLED(CUSTOM_BOOTSCREEN_ANIMATED)
 
   const unsigned char custom_start_bmp1[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-    B00011111,B10000011,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11000001,B11111000,
-    B00111001,B11000111,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B11100011,B10011100,
-    B00111000,B11000110,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B01100011,B00011100,
-    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
-    B00111000,B11000110,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B01100011,B00011100,
-    B00111001,B11000111,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B11100011,B10011100,
-    B00011111,B10000011,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11000001,B11111000,
-    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111000,B11111100,B00111111,B10000000,B00000000,B01100000,B00000000,B00000000,B01110000,B11100001,B10000111,B10000111,B10000000,B00000000,
+  B00000000,B00000001,B10001100,B01100110,B00011000,B11000000,B00000000,B00000000,B00000000,B00110000,B00110000,B11000000,B00000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B00001100,B01100011,B00011000,B11000000,B00000000,B00000000,B00000000,B00110000,B00111001,B11000000,B00000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B00001100,B01100011,B00011000,B11001111,B11110001,B11100001,B11111000,B11111110,B00111001,B11000111,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B01111000,B01100011,B00011000,B11000011,B10011000,B01100000,B11101100,B00110000,B00111111,B11000001,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B00001100,B01100011,B00011111,B10000011,B00000000,B01100000,B11001100,B00110000,B00111111,B11000001,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B00001100,B01100011,B00011000,B00000011,B00000000,B01100000,B11001100,B00110000,B00110110,B11000001,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B00001100,B01100011,B00011000,B00000011,B00000000,B01100000,B11001100,B00110000,B00110110,B11000001,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000001,B10001100,B01100110,B00011000,B00000011,B00000000,B01100000,B11001100,B00110011,B00110000,B11000001,B10000001,B10000001,B10000000,B00000000,
+  B00000000,B00000000,B11111000,B11111100,B00111110,B00001111,B11000001,B11111001,B11111110,B00011110,B01111001,B11100111,B11100111,B11100111,B11100000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
 
   const unsigned char custom_start_bmp2[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
-    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
-    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
-    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
-    B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
-    B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
-    B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
-    B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
-  };
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000011,B11100011,B11110000,B11111110,B00000000,B00000001,B10000000,B00000000,B00000001,B11000011,B10000110,B00011110,B00011110,B00000000,
+  B00000000,B00000000,B00000110,B00110001,B10011000,B01100011,B00000000,B00000000,B00000000,B00000000,B11000000,B11000011,B00000000,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000000,B00110001,B10001100,B01100011,B00000000,B00000000,B00000000,B00000000,B11000000,B11100111,B00000000,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000000,B00110001,B10001100,B01100011,B00111111,B11000111,B10000111,B11100011,B11111000,B11100111,B00011110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000001,B11100001,B10001100,B01100011,B00001110,B01100001,B10000011,B10110000,B11000000,B11111111,B00000110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000000,B00110001,B10001100,B01111110,B00001100,B00000001,B10000011,B00110000,B11000000,B11111111,B00000110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000000,B00110001,B10001100,B01100000,B00001100,B00000001,B10000011,B00110000,B11000000,B11011011,B00000110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000000,B00110001,B10001100,B01100000,B00001100,B00000001,B10000011,B00110000,B11000000,B11011011,B00000110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000110,B00110001,B10011000,B01100000,B00001100,B00000001,B10000011,B00110000,B11001100,B11000011,B00000110,B00000110,B00000110,B00000000,
+  B00000000,B00000000,B00000011,B11100011,B11110000,B11111000,B00111111,B00000111,B11100111,B11111000,B01111001,B11100111,B10011111,B10011111,B10011111,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
 
   const unsigned char custom_start_bmp3[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000010,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10010000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011100,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
-    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
-    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
-    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
-    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
-    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
-    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
-    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
-    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
-    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
-    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00001111,B10001111,B11000011,B11111000,B00000000,B00000110,B00000000,B00000000,B00000111,B00001110,B00011000,B01111000,B01111000,
+  B00000000,B00000000,B00000000,B00011000,B11000110,B01100001,B10001100,B00000000,B00000000,B00000000,B00000011,B00000011,B00001100,B00000000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10001100,B00000000,B00000000,B00000000,B00000011,B00000011,B10011100,B00000000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10001100,B11111111,B00011110,B00011111,B10001111,B11100011,B10011100,B01111000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000111,B10000110,B00110001,B10001100,B00111001,B10000110,B00001110,B11000011,B00000011,B11111100,B00011000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B11111000,B00110000,B00000110,B00001100,B11000011,B00000011,B11111100,B00011000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10000000,B00110000,B00000110,B00001100,B11000011,B00000011,B01101100,B00011000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10000000,B00110000,B00000110,B00001100,B11000011,B00000011,B01101100,B00011000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00011000,B11000110,B01100001,B10000000,B00110000,B00000110,B00001100,B11000011,B00110011,B00001100,B00011000,B00011000,B00011000,
+  B00000000,B00000000,B00000000,B00001111,B10001111,B11000011,B11100000,B11111100,B00011111,B10011111,B11100001,B11100111,B10011110,B01111110,B01111110,B01111110,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
 
   const unsigned char custom_start_bmp4[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11000011,B11111000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11100011,B11111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110011,B00011110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111011,B00000111,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11111011,B00000011,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11111011,B00000011,B01000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111011,B00000111,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110011,B00011110,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11100011,B11111100,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11000011,B11111000,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
-    B00011100,B00011100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001110,B00111000,
-    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
-    B00111000,B00011100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00001110,B00011100,
-    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
-    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
-    B00110001,B01111111,B10011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B10111111,B11001100,
-    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
-    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
-    B00111000,B01100000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B00011100,
-    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
-    B00011100,B01100000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00110000,B00111000,
-    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
-    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
-  };
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11110000,B00000000,B00001100,B00000000,B00000000,B00001110,B00011100,B00110000,B11110000,
+  B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000110,B00011000,B00000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000111,B00111000,B00000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011001,B11111110,B00111100,B00111111,B00011111,B11000111,B00111000,B11110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00001111,B00001100,B01100011,B00011000,B01110011,B00001100,B00011101,B10000110,B00000111,B11111000,B00110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B11110000,B01100000,B00001100,B00011001,B10000110,B00000111,B11111000,B00110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,B00110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,B00110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00000000,B01100000,B00001100,B00011001,B10000110,B01100110,B00011000,B00110000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11000001,B11111000,B00111111,B00111111,B11000011,B11001111,B00111100,B11111100,B11111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
 
   const unsigned char custom_start_bmp5[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111100,B00111111,B10000111,B11111000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111110,B00111111,B11000111,B11111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
-    B00001111,B11110111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11111011,B11110000,
-    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
-    B00011100,B00111000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00011100,B00111000,
-    B00011100,B00111000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00011100,B00111000,
-    B00111000,B00110000,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00011000,B00011100,
-    B00111000,B00100000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B00010000,B00011100,
-    B00110111,B00111111,B11111001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B10011111,B11111100,
-    B00111111,B10111011,B11111001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011111,B11011101,B11111100,
-    B00111111,B11111001,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011111,B11111100,B11101100,
-    B00111000,B00001000,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00000100,B00011100,
-    B00111000,B00011000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00001100,B00011100,
-    B00011100,B00111000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
-    B00011100,B00111000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
-    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
-    B00001111,B11011111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11101111,B11110000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11110000,B00000000,B00001100,B00000000,B00000000,B00001110,B00011100,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000110,B00011000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000111,B00111000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011001,B11111110,B00111100,B00111111,B00011111,B11000111,B00111000,B11110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00001100,B01100011,B00011000,B01110011,B00001100,B00011101,B10000110,B00000111,B11111000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B11110000,B01100000,B00001100,B00011001,B10000110,B00000111,B11111000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00000000,B01100000,B00001100,B00011001,B10000110,B01100110,B00011000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11000001,B11111000,B00111111,B00111111,B11000011,B11001111,B00111100,B11111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
 
   const unsigned char custom_start_bmp6[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00111111,B11100111,B11111000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00111111,B11110111,B11111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00110110,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110011,B11110110,B01111110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110111,B11100110,B11111100,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110000,B00000110,B11100000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110000,B00000110,B01110000,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00000110,B00111000,B11010000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00110000,B00000110,B00011100,B11011000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00110000,B00000110,B00001110,B11011000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
-    B00011100,B00001100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000110,B00111000,
-    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
-    B00111000,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00000110,B00011100,
-    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
-    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
-    B00110011,B11111101,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011001,B11111110,B10001100,
-    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
-    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
-    B00111000,B01110000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00111000,B00011100,
-    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
-    B00011100,B01110000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00111000,B00111000,
-    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
-  };
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11110000,B00000000,B00001100,B00000000,B00000000,B00001110,B00011100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000110,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011000,B00000000,B00000000,B00000000,B00000110,B00000111,B00111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00011001,B11111110,B00111100,B00111111,B00011111,B11000111,B00111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00001100,B01100011,B00011000,B01110011,B00001100,B00011101,B10000110,B00000111,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B11110000,B01100000,B00001100,B00011001,B10000110,B00000111,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100011,B00000000,B01100000,B00001100,B00011001,B10000110,B00000110,B11011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,B11000011,B00000000,B01100000,B00001100,B00011001,B10000110,B01100110,B00011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B00011111,B10000111,B11000001,B11111000,B00111111,B00111111,B11000011,B11001111,B00111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
 
   const unsigned char custom_start_bmp7[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00111111,B11100111,B11111100,B11011000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00111111,B11110111,B11111110,B11011100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00110110,B00000110,B11011110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110011,B11110110,B01111110,B11011111,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110111,B11100110,B11111100,B11011011,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110000,B00000110,B11100000,B11011001,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110000,B00000110,B01110000,B11011000,B11100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00000110,B00111000,B11011000,B01110000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00110000,B00000110,B00011100,B11011000,B00111000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00110000,B00000110,B00001110,B11011000,B00011000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
-    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
-    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
-    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
-    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
-    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
-    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
-    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
-    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
-    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
-    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
-    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11110001,B11111000,B01111111,B00000000,B00000000,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B00011000,B11001100,B00110001,B10000000,B00000000,B00000000,B00000000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B00110001,B10000000,B00000000,B00000000,B00000000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B00110001,B10011111,B11100011,B11000011,B11110001,B11111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11110000,B11000110,B00110001,B10000111,B00110000,B11000001,B11011000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B00111111,B00000110,B00000000,B11000001,B10011000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B00110000,B00000110,B00000000,B11000001,B10011000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B00110000,B00000110,B00000000,B11000001,B10011000,B01100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B00011000,B11001100,B00110000,B00000110,B00000000,B11000001,B10011000,B01100110,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11110001,B11111000,B01111100,B00011111,B10000011,B11110011,B11111100,B00111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
-
+  
   const unsigned char custom_start_bmp8[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11111111,B10011111,B11110011,B01100000,B01111000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11111111,B11011111,B11111011,B01110000,B01111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B11011000,B00011011,B01111000,B01100000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11001111,B11011001,B11111011,B01111100,B01100001,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11011111,B10011011,B11110011,B01101110,B01100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11000000,B00011011,B10000011,B01100111,B01100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11000000,B00011001,B11000011,B01100011,B11100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B00011000,B11100011,B01100001,B11100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11000000,B00011000,B01110011,B01100000,B11100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11000000,B00011000,B00111011,B01100000,B01100001,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
-    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
-    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
-    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
-    B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
-    B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
-    B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
-    B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
-  };
-
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,B11111100,B00111111,B10000000,B00000000,B01100000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100110,B00011000,B11000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,B01100011,B00011000,B11000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,B01100011,B00011000,B11001111,B11110001,B11100001,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,B01100011,B00011000,B11000011,B10011000,B01100000,B11101100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,B01100011,B00011111,B10000011,B00000000,B01100000,B11001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,B01100011,B00011000,B00000011,B00000000,B01100000,B11001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,B01100011,B00011000,B00000011,B00000000,B01100000,B11001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,B01100110,B00011000,B00000011,B00000000,B01100000,B11001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,B11111100,B00111110,B00001111,B11000001,B11111001,B11111110,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
+  
   const unsigned char custom_start_bmp9[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011111,B11000011,B11111110,B01111111,B11001101,B10000001,B11111111,B11100000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011111,B11100011,B11111111,B01111111,B11101101,B11000001,B11111111,B11101100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10011000,B11110011,B00000011,B01100000,B01101101,B11100001,B10000110,B00001110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11011000,B00111011,B00111111,B01100111,B11101101,B11110001,B10000110,B00001110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11011000,B00011011,B01111110,B01101111,B11001101,B10111001,B10000110,B00001100,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11011000,B00011011,B00000000,B01101110,B00001101,B10011101,B10000110,B00001100,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11011000,B00111011,B00000000,B01100111,B00001101,B10001111,B10000110,B00001100,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10011000,B11110011,B00000000,B01100011,B10001101,B10000111,B10000110,B00001100,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011111,B11100011,B00000000,B01100001,B11001101,B10000011,B10000110,B00001100,B11001000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011111,B11000011,B00000000,B01100000,B11101101,B10000001,B10000110,B00001100,B11001100,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
-    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
-    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
-    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
-    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
-    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
-    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
-    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
-    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
-    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
-    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
-    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
-    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111100,B01111110,B00011111,B11000000,B00000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110011,B00001100,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B01100111,B11111000,B11110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111100,B00110001,B10001100,B01100001,B11001100,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001111,B11000001,B10000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B00000001,B10000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B00000001,B10000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110011,B00001100,B00000001,B10000000,B00110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111100,B01111110,B00011111,B00000111,B11100000,B11111100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
-
+  
   const unsigned char custom_start_bmp10[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11111111,B10011111,B11110011,B01100000,B01111111,B11111001,B11001000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11111111,B11011111,B11111011,B01110000,B01111111,B11111011,B11111100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B11011000,B00011011,B01111000,B01100001,B10000011,B11111110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11001111,B11011001,B11111011,B01111100,B01100001,B10000011,B10110111,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11011111,B10011011,B11110011,B01101110,B01100001,B10000011,B00110011,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11000000,B00011011,B10000011,B01100111,B01100001,B10000011,B00110011,B01000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11000000,B00011001,B11000011,B01100011,B11100001,B10000011,B00110011,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B00011000,B11100011,B01100001,B11100001,B10000011,B00110011,B01100000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11000000,B00011000,B01110011,B01100000,B11100001,B10000011,B00110011,B01101000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11000000,B00011000,B00111011,B01100000,B01100001,B10000011,B00110011,B01101100,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
-    B00011100,B00011100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001110,B00111000,
-    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
-    B00111000,B00011100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00001110,B00011100,
-    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
-    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
-    B00110001,B01111111,B10011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B10111111,B11001100,
-    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
-    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
-    B00111000,B01100000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B00011100,
-    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
-    B00011100,B01100000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00110000,B00111000,
-    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
-    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
-  };
-
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111100,B01111110,B00011111,B11000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110011,B00001100,B01100000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B01100000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B01100111,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111100,B00110001,B10001100,B01100001,B11001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001111,B11000001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B00000001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10001100,B00000001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110011,B00001100,B00000001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111100,B01111110,B00011111,B00000111,B11100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
+  
   const unsigned char custom_start_bmp11[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111000,B01111111,B00001111,B11111001,B11111111,B00110110,B00000111,B11111111,B10011100,B11100000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111100,B01111111,B10001111,B11111101,B11111111,B10110111,B00000111,B11111111,B10111111,B11110100,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00001110,B01100011,B11001100,B00001101,B10000001,B10110111,B10000110,B00011000,B00111111,B11110110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000111,B01100000,B11101100,B11111101,B10011111,B10110111,B11000110,B00011000,B00111011,B01110110,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111111,B01100000,B01101101,B11111001,B10111111,B00110110,B11100110,B00011000,B00110011,B00110110,B10000000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111111,B01100000,B01101100,B00000001,B10111000,B00110110,B01110110,B00011000,B00110011,B00110110,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000111,B01100000,B11101100,B00000001,B10011100,B00110110,B00111110,B00011000,B00110011,B00110110,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00001110,B01100011,B11001100,B00000001,B10001110,B00110110,B00011110,B00011000,B00110011,B00110110,B11000000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111100,B01111111,B10001100,B00000001,B10000111,B00110110,B00001110,B00011000,B00110011,B00110110,B11111000,B00000000,
-    B00000000,B00000000,B00000000,B00000011,B11111000,B01111111,B00001100,B00000001,B10000011,B10110110,B00000110,B00011000,B00110011,B00110110,B11111100,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
-    B00001111,B11110111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11111011,B11110000,
-    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
-    B00011100,B00111000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00011100,B00111000,
-    B00011100,B00111000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00011100,B00111000,
-    B00111000,B00110000,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00011000,B00011100,
-    B00111000,B00100000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B00010000,B00011100,
-    B00110111,B00111111,B11111001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B10011111,B11111100,
-    B00111111,B10111011,B11111001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011111,B11011101,B11111100,
-    B00111111,B11111001,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011111,B11111100,B11101100,
-    B00111000,B00001000,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00000100,B00011100,
-    B00111000,B00011000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00001100,B00011100,
-    B00011100,B00111000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
-    B00011100,B00111000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
-    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
-    B00001111,B11011111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11101111,B11110000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10001111,B11000011,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B01100001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11000110,B00110001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B11000110,B01100001,B10000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10001111,B11000011,B11100000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
-
+  
   const unsigned char custom_start_bmp12[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000001,B11111100,B00111111,B10000111,B11111100,B11111111,B10011011,B00000011,B11111111,B11001110,B01110011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000001,B11111110,B00111111,B11000111,B11111110,B11111111,B11011011,B10000011,B11111111,B11011111,B11111011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B11000000,B11011011,B11000011,B00001100,B00011111,B11111011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B11001111,B11011011,B11100011,B00001100,B00011101,B10111011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B11011111,B10011011,B01110011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11011100,B00011011,B00111011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11001110,B00011011,B00011111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000111,B00011011,B00001111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
-    B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000011,B10011011,B00000111,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
-    B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000001,B11011011,B00000011,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
-    B00011100,B00001100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000110,B00111000,
-    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
-    B00111000,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00000110,B00011100,
-    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
-    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
-    B00110011,B11111101,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011001,B11111110,B10001100,
-    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
-    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
-    B00111000,B01110000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00111000,B00011100,
-    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
-    B00011100,B01110000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00111000,B00111000,
-    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
-    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100011,B11110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11100001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00110001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,B00110001,B10011000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100011,B11110000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
+  
+  const unsigned char custom_start_bmp13[] PROGMEM = {
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B10001100,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B01111000,B10001000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00011110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110000,B01010000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001010,B00001110,B00000000,
+  B00000000,B01111000,B10001000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00010001,B00001110,B00000000,
+  B00000000,B00111001,B00000100,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00100000,B10011100,B00000000,
+  B00000000,B00111110,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B01111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
-
+  
   const unsigned char custom_start_bmp14[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00011111,B11000001,B11111100,B00011111,B11110001,B11111111,B00011011,B00000001,B11111111,B11110011,B10011110,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00011111,B11100001,B11111110,B00011111,B11111001,B11111111,B10011011,B10000001,B11111111,B11110111,B11111111,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B01110001,B10001111,B00011000,B00011001,B10000001,B10011011,B11000001,B10000110,B00000111,B11111111,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B00111001,B10000011,B10011001,B11111001,B10011111,B10011011,B11100001,B10000110,B00000111,B01101111,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00011111,B11111001,B10000001,B10011011,B11110001,B10111111,B00011011,B01110001,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00011111,B11111001,B10000001,B10011000,B00000001,B10111000,B00011011,B00111001,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B00111001,B10000001,B10011000,B00000001,B10011100,B00011011,B00011101,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B01110001,B10000011,B10011000,B00000001,B10001110,B00011011,B00001111,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00000000,B01110001,B10001111,B00011000,B00000001,B10001110,B00011011,B00000111,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
-    B00000000,B00011111,B11100001,B11111110,B00011000,B00000001,B10000111,B00011011,B00000011,B10000110,B00000110,B01100011,B01101111,B11110111,B11110000,B00000000,
-    B00000000,B00011111,B11000001,B11111100,B00011000,B00000001,B10000011,B10011011,B00000001,B10000110,B00000110,B01100011,B01101111,B11110111,B11110000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
-    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
-    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
-    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
-    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
-    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
-    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
-    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
-    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100
-  };
-
-  const unsigned char custom_start_bmp15[] PROGMEM = {
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000111,B11111000,B00111111,B11100001,B11111111,B11000111,B11111111,B00110011,B00000001,B11111111,B11111100,B11110011,B11001110,B11000000,B00110000,B00000000,
-    B00000111,B11111100,B00111111,B11110001,B11111111,B11110111,B11111111,B10110011,B10000001,B11111111,B11111101,B11111111,B11101110,B11000000,B00110000,B00000000,
-    B00000000,B00001111,B00111000,B11111001,B11000000,B01110110,B00000011,B10110011,B11000001,B11000001,B10000001,B11111111,B11101110,B11000000,B00110000,B00000000,
-    B00000000,B00001111,B00111000,B11111001,B11000000,B01110110,B00000011,B10110011,B11100001,B11000001,B10000001,B11111111,B11101110,B11000000,B00110000,B00000000,
-    B00000000,B00000111,B10111000,B00011101,B11001111,B11110110,B01111111,B10110011,B11110001,B11000001,B10000001,B11101100,B11101110,B11000000,B00110000,B00000000,
-    B00000111,B11111111,B10111000,B00001101,B11011111,B11000110,B11111111,B00110011,B01111001,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
-    B00000111,B11111111,B10111000,B00001101,B11000000,B00000110,B11110000,B00110011,B00011101,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
-    B00000000,B00000111,B10111000,B00011101,B11000000,B00000110,B00111000,B00110011,B00001111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
-    B00000000,B00001111,B00111000,B11111001,B11000000,B00000110,B00011100,B00110011,B00000111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
-    B00000000,B00001111,B00111000,B11111001,B11000000,B00000110,B00011100,B00110011,B00000111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
-    B00000111,B11111100,B00111111,B11110001,B11000000,B00000110,B00001111,B00110011,B00000011,B11000001,B10000001,B11001100,B01101110,B11111111,B10111111,B11000000,
-    B00000111,B11111000,B00111111,B11100001,B11000000,B00000110,B00000111,B10110011,B00000001,B11000001,B10000001,B11001100,B01101110,B11111111,B10111111,B11000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
-  };
-
-  const unsigned char custom_start_bmp16[] PROGMEM = {
-    B01111111,B11100001,B11111111,B10000111,B11111111,B00011111,B11111100,B01110011,B10000001,B11111111,B11111110,B00111110,B00111110,B00111001,B11000000,B11100000,
-    B01111111,B11110001,B11111111,B11000111,B11111111,B10011111,B11111110,B01110011,B10000001,B11111111,B11111110,B01111111,B11111111,B00111001,B11000000,B11100000,
-    B00000000,B11111001,B11000011,B11100111,B11111111,B10011111,B11111110,B01110011,B11000001,B11111111,B11111110,B01111111,B11111111,B00111001,B11000000,B11100000,
-    B00000000,B01111001,B11000001,B11100111,B00000001,B10011100,B00000110,B01110011,B11100001,B11000001,B11000000,B01111111,B11111111,B00111001,B11000000,B11100000,
-    B00000000,B01111001,B11000000,B11100111,B00000001,B10011100,B00000110,B01110011,B11110001,B11000001,B11000000,B01111001,B11001111,B00111001,B11000000,B11100000,
-    B01111111,B11111001,B11000000,B11100111,B00111111,B10011100,B11111110,B01110011,B11111001,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
-    B01111111,B11111001,B11000000,B11100111,B01111111,B10011101,B11111110,B01110011,B10111101,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
-    B01111111,B11111001,B11000000,B11100111,B01111111,B00011101,B11111100,B01110011,B10011111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
-    B00000000,B01111001,B11000000,B11100111,B00000000,B00011100,B11110000,B01110011,B10001111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
-    B00000000,B01111001,B11000001,B11100111,B00000000,B00011100,B01111000,B01110011,B10000111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
-    B00000000,B11111001,B11000011,B11100111,B00000000,B00011100,B00111100,B01110011,B10000011,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
-    B01111111,B11110001,B11111111,B11000111,B00000000,B00011100,B00011110,B01110011,B10000001,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
-    B01111111,B11100001,B11111111,B10000111,B00000000,B00011100,B00001110,B01110011,B10000001,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
-    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
-  };
-
-  #define CUSTOM_BOOTSCREEN_TIME_PER_FRAME
-
-  static const boot_frame_t boot_frame_0  PROGMEM = { custom_start_bmp1,   200 };
-  static const boot_frame_t boot_frame_1  PROGMEM = { custom_start_bmp2,   150 };
-  static const boot_frame_t boot_frame_2  PROGMEM = { custom_start_bmp3,   150 };
-  static const boot_frame_t boot_frame_3  PROGMEM = { custom_start_bmp4,   150 };
-  static const boot_frame_t boot_frame_4  PROGMEM = { custom_start_bmp5,   150 };
-  static const boot_frame_t boot_frame_5  PROGMEM = { custom_start_bmp6,   150 };
-  static const boot_frame_t boot_frame_6  PROGMEM = { custom_start_bmp7,   150 };
-  static const boot_frame_t boot_frame_7  PROGMEM = { custom_start_bmp8,   150 };
-  static const boot_frame_t boot_frame_8  PROGMEM = { custom_start_bmp9,   150 };
-  static const boot_frame_t boot_frame_9  PROGMEM = { custom_start_bmp10,  150 };
-  static const boot_frame_t boot_frame_10 PROGMEM = { custom_start_bmp11,  150 };
-  static const boot_frame_t boot_frame_11 PROGMEM = { custom_start_bmp12,  150 };
-  static const boot_frame_t boot_frame_12 PROGMEM = { custom_start_bmp,   1000 };
-  static const boot_frame_t boot_frame_13 PROGMEM = { custom_start_bmp14,  150 };
-  static const boot_frame_t boot_frame_14 PROGMEM = { custom_start_bmp15,  150 };
-  static const boot_frame_t boot_frame_15 PROGMEM = { custom_start_bmp16, 1000 };
-
-  static const boot_frame_t * const custom_bootscreen_animation[] PROGMEM = {
-    &boot_frame_0, &boot_frame_1, &boot_frame_2, &boot_frame_3, &boot_frame_4,
-    &boot_frame_5, &boot_frame_6, &boot_frame_7, &boot_frame_8, &boot_frame_9,
-    &boot_frame_10, &boot_frame_11, &boot_frame_12, &boot_frame_13, &boot_frame_14, &boot_frame_15
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11100000,B11100000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B01000000,B01000000,B10000000,B00000000,B00000000,B00001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00100000,B10011110,B10011101,B11100111,B01110011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00110101,B10010010,B10010001,B00100100,B10010010,B01001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00010101,B00011110,B10010001,B00100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00011011,B00010000,B10010001,B00100100,B10010010,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00001010,B00011110,B10011101,B11100100,B10010011,B11001000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B00000000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B01111000,B00100000,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00011110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01110111,B11111111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B11111111,B11101110,B00000000,
+  B00000000,B01110000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000100,B00001110,B00000000,
+  B00000000,B01111000,B00100000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B00000100,B00001110,B00000000,
+  B00000000,B00111000,B00100000,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00000100,B00011100,B00000000,
+  B00000000,B00111100,B00100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000100,B00111100,B00000000,
+  B00000000,B00011111,B00000111,B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11100000,B11111000,B00000000,
+  B00000000,B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,B00000000,
+  B00000000,B00000111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11100000,B00000000,
+  B00000000,B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+};
+  
+  const unsigned char * const custom_bootscreen_animation[] PROGMEM = {
+    custom_start_bmp, custom_start_bmp, custom_start_bmp, custom_start_bmp1, custom_start_bmp1, custom_start_bmp2, custom_start_bmp3, custom_start_bmp4, custom_start_bmp5, custom_start_bmp6, custom_start_bmp7, custom_start_bmp8, custom_start_bmp9, custom_start_bmp10, custom_start_bmp11, custom_start_bmp12, custom_start_bmp13, custom_start_bmp14, custom_start_bmp1 
   };
 
 #endif
```

## Marlin/_Statusscreen.h

```diff
diff --git a/Marlin/_Statusscreen.h b/Marlin/_Statusscreen.h
index 97c0e30023..72d47d85e1 100644
--- a/Marlin/_Statusscreen.h
+++ b/Marlin/_Statusscreen.h
@@ -1,55 +1,32 @@
-/**
- * Marlin 3D Printer Firmware
- * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
- *
- * Based on Sprinter and grbl.
- * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
- */
-
 /**
  * Made with Marlin Bitmap Converter
  * https://marlinfw.org/tools/u8glib/converter.html
  *
  * This bitmap from 56x19 C/C++ data
  */
 #pragma once
 
-#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
-
-#define STATUS_SCREEN_X 64
-#define STATUS_LOGO_WIDTH 48
+#define STATUS_SCREEN_X 72
+#define STATUS_LOGO_WIDTH 56
 
 const unsigned char status_logo_bmp[] PROGMEM = {
-  B00000000,B00000000,B00111001,B11000000,B00000000,B00000000,
-  B00000000,B00000000,B01000101,B00100000,B00000000,B00000000,
-  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
-  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
-  B00000000,B00000000,B00011001,B00010000,B00000000,B00000000,
-  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
-  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
-  B00000000,B00000000,B01000101,B00100000,B00000000,B00000000,
-  B00000000,B00000000,B00111001,B11000000,B00000000,B00000000,
-  B00111100,B00000000,B00000000,B00011000,B11001001,B10011000,
-  B00100010,B00000010,B00000000,B10011000,B11000000,B10001000,
-  B00100010,B00000000,B00000000,B10011000,B11000000,B10001000,
-  B00100010,B10110110,B01011001,B11010101,B01011000,B10001000,
-  B00111100,B11000010,B01100100,B10010101,B01001000,B10001000,
-  B00100000,B10000010,B01000100,B10010101,B01001000,B10001000,
-  B00100000,B10000010,B01000100,B10010010,B01001000,B10001000,
-  B00100000,B10000010,B01000100,B10010010,B01001000,B10001000,
-  B00100000,B10000111,B01000100,B01010010,B01011101,B11011100
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B01110011,B10001111,B00000000,B10000000,B00000110,B00110010,B01100110,
+  B10001010,B01001000,B10000000,B00000000,B00100110,B00110000,B00100010,
+  B00001010,B00101000,B10000000,B00000000,B00100110,B00110000,B00100010,
+  B00001010,B00101000,B10101101,B10010110,B01110101,B01010110,B00100010,
+  B00110010,B00101111,B00110000,B10011001,B00100101,B01010010,B00100010,
+  B00001010,B00101000,B00100000,B10010001,B00100101,B01010010,B00100010,
+  B00001010,B00101000,B00100000,B10010001,B00100100,B10010010,B00100010,
+  B10001010,B01001000,B00100000,B10010001,B00100100,B10010010,B00100010,
+  B01110011,B10001000,B00100001,B11010001,B00010100,B10010111,B01110111
 };
```

## Marlin/src/inc/Version.h

```diff
diff --git a/Marlin/src/inc/Version.h b/Marlin/src/inc/Version.h
index 767e3e9a8e..17755de348 100644
--- a/Marlin/src/inc/Version.h
+++ b/Marlin/src/inc/Version.h
@@ -40,11 +40,11 @@
  * The STRING_DISTRIBUTION_DATE represents when the binary file was built,
  * here we define this default string as the date where the latest release
  * version was tagged.
  */
 #ifndef STRING_DISTRIBUTION_DATE
-  #define STRING_DISTRIBUTION_DATE "2021-12-25"
+  #define STRING_DISTRIBUTION_DATE "2021-09-03"
 #endif
 
 /**
  * Minimum Configuration.h and Configuration_adv.h file versions.
  * Set based on the release version number. Used to catch an attempt to use
```

## Marlin/src/lcd/dogm/dogm_Bootscreen.h

```diff
diff --git a/Marlin/src/lcd/dogm/dogm_Bootscreen.h b/Marlin/src/lcd/dogm/dogm_Bootscreen.h
index 4240861471..cf22aa6369 100644
--- a/Marlin/src/lcd/dogm/dogm_Bootscreen.h
+++ b/Marlin/src/lcd/dogm/dogm_Bootscreen.h
@@ -65,10 +65,19 @@
 #if ENABLED(BOOT_MARLIN_LOGO_SMALL)
 
   #define START_BMPWIDTH      56
 
   const unsigned char start_bmp[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00001110,B00000000,B00000000,B00000000,B00000010,B00100000,B00000000,
+    B00001001,B00000000,B00000000,B00000000,B00000010,B00100000,B00000000,
+    B00001001,B00110010,B00100110,B01011001,B10001110,B00111001,B00100000,
+    B00001110,B01001010,B00101111,B01100011,B11010010,B00100101,B00100000,
+    B00001000,B01001010,B10101000,B01000010,B00010010,B00100100,B11100000,
+    B00001000,B00110001,B01000111,B01000001,B11001110,B00111000,B00100000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
     B00011111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,
     B01100000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,
     B01000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,
     B10000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111111,
     B10000011,B11001111,B00000000,B00000000,B00001100,B00110000,B00111111,
@@ -227,48 +236,48 @@
 #else
 
   #define START_BMPWIDTH      112
 
   const unsigned char start_bmp[] PROGMEM = {
-    B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,
-    B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,
-    B00011110,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11111111,B11111111,
-    B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B11111111,B11111111,
-    B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,B11111111,
-    B01100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11111111,
-    B01100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111111,B11111111,
-    B11000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,B00000000,B00000000,B00111111,B11111111,
-    B11000000,B00001111,B11000000,B11111100,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,B00011000,B00000000,B00011111,B11111111,
-    B11000000,B00111111,B11100001,B11111111,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,B00111100,B00000000,B00001111,B11111111,
-    B11000000,B01111111,B11110011,B11111111,B10000000,B00000000,B00000000,B00000000,B00000000,B01111000,B00111100,B00000000,B00000111,B11111111,
-    B11000000,B11111111,B11111111,B11111111,B11000000,B00000000,B00000000,B00000000,B00000000,B01111000,B00111100,B00000000,B00000011,B11111111,
-    B11000001,B11111000,B01111111,B10000111,B11100000,B00000000,B00000000,B00000000,B00000000,B01111000,B00000000,B00000000,B00000001,B11111111,
-    B11000001,B11110000,B00111111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B01111000,B00000000,B00000000,B00000000,B11111111,
-    B11000001,B11100000,B00011110,B00000001,B11100000,B00011111,B00000000,B00000011,B11100000,B01111000,B00111100,B00000011,B11110000,B01111111,
-    B11000001,B11100000,B00011110,B00000001,B11100000,B01111111,B11000000,B00001111,B11111000,B01111000,B00111100,B00000111,B11111100,B00111111,
-    B11000001,B11100000,B00011110,B00000001,B11100001,B11111111,B11100000,B00011111,B11111100,B01111000,B00111100,B00001111,B11111110,B00011111,
-    B11000001,B11100000,B00011110,B00000001,B11100011,B11111111,B11110000,B00111111,B11111110,B01111000,B00111100,B00011111,B11111110,B00001111,
-    B11000001,B11100000,B00011110,B00000001,B11100011,B11110011,B11111000,B00111111,B00111110,B01111000,B00111100,B00111111,B00111111,B00000111,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B11100000,B11111100,B01111100,B00011111,B01111000,B00111100,B00111110,B00011111,B00000111,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B11000000,B01111100,B01111100,B00001111,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B10000000,B01111100,B01111000,B00001111,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B10000000,B00111100,B01111000,B00000000,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B10000000,B00111100,B01111000,B00000000,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B10000000,B00111100,B01111000,B00000000,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100111,B11000000,B00111100,B01111000,B00000000,B01111000,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100011,B11100000,B00111100,B01111000,B00000000,B01111100,B00111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100011,B11111111,B00111111,B11111000,B00000000,B01111111,B10111100,B00111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100001,B11111111,B00111111,B11111000,B00000000,B00111111,B10111111,B11111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100000,B11111111,B00111111,B11111000,B00000000,B00011111,B10111111,B11111100,B00001111,B00000011,
-    B11000001,B11100000,B00011110,B00000001,B11100000,B01111111,B00111111,B11111000,B00000000,B00001111,B10111111,B11111100,B00001111,B00000011,
-    B01100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,
-    B01100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000110,
-    B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,
-    B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,
-    B00011110,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01111000,
-    B00001111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11110000,
-    B00000001,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B11111111,B10000000
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00111111,B00011111,B10000011,B11111100,B00000000,B00000110,B00000000,B00000000,B00000000,B00011000,B00011000,B01100000,B11110000,B01111000,
+    B01110011,B10001100,B11000001,B10001110,B00000000,B00000110,B00000000,B00000000,B00000000,B00011000,B00011000,B01100000,B00110000,B00011000,
+    B01100001,B10001100,B01100001,B10000110,B00000000,B00000000,B00000000,B00000000,B11000000,B00011000,B00011000,B00000000,B00110000,B00011000,
+    B01100001,B10001100,B00110001,B10000110,B00000000,B00000000,B00000000,B00000000,B11000000,B00011100,B00111000,B00000000,B00110000,B00011000,
+    B00000011,B10001100,B00110001,B10000110,B00000000,B00000000,B00000000,B00000000,B11000000,B00011100,B00111000,B00000000,B00110000,B00011000,
+    B00000111,B00001100,B00110001,B10001110,B01110011,B10011110,B00011011,B11100111,B11111000,B00011100,B00111001,B11100000,B00110000,B00011000,
+    B00011110,B00001100,B00110001,B11111100,B00011111,B10000110,B00011110,B01100000,B11000000,B00011010,B01011000,B01100000,B00110000,B00011000,
+    B00000111,B00001100,B00110001,B10000000,B00011100,B00000110,B00001100,B01100000,B11000000,B00011010,B01011000,B01100000,B00110000,B00011000,
+    B00000011,B10001100,B00110001,B10000000,B00011000,B00000110,B00001100,B01100000,B11000000,B00011010,B01011000,B01100000,B00110000,B00011000,
+    B01000001,B10001100,B00110001,B10000000,B00011000,B00000110,B00001100,B01100000,B11000000,B00011001,B10011000,B01100000,B00110000,B00011000,
+    B01100001,B10001100,B01100001,B10000000,B00011000,B00000110,B00001100,B01100000,B11000100,B00011001,B10011000,B01100000,B00110000,B00011000,
+    B01100011,B00001100,B11000001,B10000000,B00011000,B00000110,B00001100,B01100000,B11001100,B00011001,B10011000,B01100000,B00110000,B00011000,
+    B00111111,B00011111,B10000011,B11000000,B01111110,B00011111,B10011100,B01110000,B01111000,B00011001,B10011001,B11111000,B11111100,B01111110,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
   };
 
   #if ENABLED(BOOT_MARLIN_LOGO_ANIMATED)
 
     const unsigned char start_bmp1[] PROGMEM = {
```

## Marlin/src/lcd/menu/menu_motion.cpp

```diff
diff --git a/Marlin/src/lcd/menu/menu_motion.cpp b/Marlin/src/lcd/menu/menu_motion.cpp
index 29a908ac33..1092bfdad3 100644
--- a/Marlin/src/lcd/menu/menu_motion.cpp
+++ b/Marlin/src/lcd/menu/menu_motion.cpp
@@ -105,10 +105,17 @@ void lcd_move_x() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_X), X_AXIS); }
 #endif
 #if LINEAR_AXES >= 6
   void lcd_move_k() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_K), K_AXIS); }
 #endif
 
+#if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+  // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
+  // It might be implemented by doing the math to move Y and Z in combination
+  // to arrive at the correct C position.
+  void lcd_move_c() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_C), Z_HEAD); }
+#endif
+
 #if E_MANUAL
 
   static void lcd_move_e(TERN_(MULTI_E_MANUAL, const int8_t eindex=active_extruder)) {
     if (ui.use_click()) return ui.goto_previous_screen_no_defer();
     if (ui.encoderPosition) {
@@ -165,30 +172,37 @@ void _menu_move_distance(const AxisEnum axis, const screenFunc_t func, const int
   if (LCD_HEIGHT >= 4) {
     switch (axis) {
       case X_AXIS: STATIC_ITEM(MSG_MOVE_X, SS_DEFAULT|SS_INVERT); break;
       case Y_AXIS: STATIC_ITEM(MSG_MOVE_Y, SS_DEFAULT|SS_INVERT); break;
       case Z_AXIS: STATIC_ITEM(MSG_MOVE_Z, SS_DEFAULT|SS_INVERT); break;
+      #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+        // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
+        case Z_HEAD: STATIC_ITEM(MSG_MOVE_C, SS_DEFAULT|SS_INVERT); break;
+      #endif
       default:
         TERN_(MANUAL_E_MOVES_RELATIVE, manual_move_e_origin = current_position.e);
         STATIC_ITEM(MSG_MOVE_E, SS_DEFAULT|SS_INVERT);
         break;
     }
   }
 
   BACK_ITEM(MSG_MOVE_AXIS);
   if (parser.using_inch_units()) {
     if (LARGE_AREA_TEST) SUBMENU(MSG_MOVE_1IN, []{ _goto_manual_move(IN_TO_MM(1.000f)); });
     SUBMENU(MSG_MOVE_01IN,   []{ _goto_manual_move(IN_TO_MM(0.100f)); });
     SUBMENU(MSG_MOVE_001IN,  []{ _goto_manual_move(IN_TO_MM(0.010f)); });
     SUBMENU(MSG_MOVE_0001IN, []{ _goto_manual_move(IN_TO_MM(0.001f)); });
   }
   else {
     if (LARGE_AREA_TEST) SUBMENU(MSG_MOVE_100MM, []{ _goto_manual_move(100); });
     SUBMENU(MSG_MOVE_10MM, []{ _goto_manual_move(10);    });
     SUBMENU(MSG_MOVE_1MM,  []{ _goto_manual_move( 1);    });
     SUBMENU(MSG_MOVE_01MM, []{ _goto_manual_move( 0.1f); });
-    if (axis == Z_AXIS && (FINE_MANUAL_MOVE) > 0.0f && (FINE_MANUAL_MOVE) < 0.1f) {
+
+    #define FINE_ADJ_AXIS TERN(BELTPRINTER, Y_AXIS, Z_AXIS)
+
+    if (axis == FINE_ADJ_AXIS && (FINE_MANUAL_MOVE) > 0.0f && (FINE_MANUAL_MOVE) < 0.1f) {
       // Determine digits needed right of decimal
       constexpr uint8_t digs = !UNEAR_ZERO((FINE_MANUAL_MOVE) * 1000 - int((FINE_MANUAL_MOVE) * 1000)) ? 4 :
                                !UNEAR_ZERO((FINE_MANUAL_MOVE) *  100 - int((FINE_MANUAL_MOVE) *  100)) ? 3 : 2;
       PGM_P const label = GET_TEXT(MSG_MOVE_N_MM);
       char tmp[strlen_P(label) + 10 + 1], numstr[10];
@@ -252,10 +266,14 @@ void menu_move() {
     #endif
 
     #if HAS_Z_AXIS
       SUBMENU(MSG_MOVE_Z, []{ _menu_move_distance(Z_AXIS, lcd_move_z); });
     #endif
+    #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+      // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
+      SUBMENU(MSG_MOVE_C, []{ _menu_move_distance(Z_AXIS, lcd_move_c); });
+    #endif
     #if LINEAR_AXES >= 4
       SUBMENU(MSG_MOVE_I, []{ _menu_move_distance(I_AXIS, lcd_move_i); });
     #endif
     #if LINEAR_AXES >= 5
       SUBMENU(MSG_MOVE_J, []{ _menu_move_distance(J_AXIS, lcd_move_j); });
```

## Marlin/src/module/planner.cpp

```diff
diff --git a/Marlin/src/module/planner.cpp b/Marlin/src/module/planner.cpp
index 45ccdd1702..378aeac196 100644
--- a/Marlin/src/module/planner.cpp
+++ b/Marlin/src/module/planner.cpp
@@ -1764,11 +1764,29 @@ float Planner::get_axis_position_mm(const AxisEnum axis) {
 
     axis_steps = stepper.position(axis);
 
   #endif
 
-  return axis_steps * mm_per_step[axis];
+  float axis_mm;
+
+  #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+
+    axis_mm = axis_steps * mm_per_step[axis];
+    switch (axis) {
+      case CORE_AXIS_2:         // Y is offset in proportion to (Z - 0)
+        axis_mm += C_TO_B_OFFS(stepper.position(NORMAL_AXIS) * steps_to_mm[NORMAL_AXIS]);
+      case CORE_AXIS_1: break;
+      default: C_TO_Z(axis_mm); // Z is some fraction of C
+    }
+
+  #else
+
+    axis_mm = axis_steps * mm_per_step[axis];
+
+  #endif
+
+  return axis_mm;
 }
 
 /**
  * Block until the planner is finished processing
  */
@@ -2981,27 +2999,43 @@ bool Planner::buffer_segment(const abce_pos_t &abce
 
   stepper.wake_up();
   return true;
 } // buffer_segment()
 
+#if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+  // Each 1mm of "Z" motion requires a slightly greater amount of C motion...
+  constexpr float Z_TO_C(const float z) { return z * (1.0f / sin(RADIANS(BED_TO_TRUSS_ANGLE))); }
+  // As the Belt (C) moves, Z is adjusted. This computes that ratio.
+  // Sine tells us the number of hypotenuse mm for each base mm
+  constexpr float C_TO_Z(const float c) { return c * sin(RADIANS(BED_TO_TRUSS_ANGLE)); }
+  // Positive "C" motion results in negative "B" motion
+  constexpr float C_TO_B_OFFS(const float c) { return c * cos(RADIANS(BED_TO_TRUSS_ANGLE)); }
+#endif
+
 /**
  * Add a new linear movement to the buffer.
  * The target is cartesian. It's translated to
  * delta/scara if needed.
  *
  *  cart            - target position in mm or degrees
  *  fr_mm_s         - (target) speed of the move (mm/s)
  *  extruder        - target extruder
  *  millimeters     - the length of the movement, if known
  *  inv_duration    - the reciprocal if the duration of the movement, if known (kinematic only if feeedrate scaling is enabled)
  */
 bool Planner::buffer_line(const xyze_pos_t &cart, const_feedRate_t fr_mm_s, const uint8_t extruder/*=active_extruder*/, const float millimeters/*=0.0*/
   OPTARG(SCARA_FEEDRATE_SCALING, const_float_t inv_duration/*=0.0*/)
 ) {
   xyze_pos_t machine = cart;
   TERN_(HAS_POSITION_MODIFIERS, apply_modifiers(machine));
 
+  #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+    // Belt Printer uses Z to modify Y, and moves C farther according to the angle
+    machine.b += C_TO_Z(rz);  // The B position is directly affected by the Z axis
+    machine.c = Z_TO_C(rz);
+  #endif
+
   #if IS_KINEMATIC
 
     #if HAS_JUNCTION_DEVIATION
       const xyze_pos_t cart_dist_mm = LOGICAL_AXIS_ARRAY(
         cart.e - position_cart.e,
```

## Marlin/src/module/stepper.cpp

```diff
diff --git a/Marlin/src/module/stepper.cpp b/Marlin/src/module/stepper.cpp
index c100051f98..4f03a0b1e9 100644
--- a/Marlin/src/module/stepper.cpp
+++ b/Marlin/src/module/stepper.cpp
@@ -2804,11 +2804,17 @@ void Stepper::init() {
 void Stepper::_set_position(const abce_long_t &spos) {
   #if ANY(IS_CORE, MARKFORGED_XY, MARKFORGED_YX)
     #if CORE_IS_XY
       // corexy positioning
       // these equations follow the form of the dA and dB equations on https://www.corexy.com/theory.html
-      count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
+      #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
+        // TODO: Incorporate C into B. This may be done ahead of this method
+        // and then this placeholder can be removed.
+        count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
+      #else
+        count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
+      #endif
     #elif CORE_IS_XZ
       // corexz planning
       count_position.set(spos.a + spos.c, spos.b, CORESIGN(spos.a - spos.c));
     #elif CORE_IS_YZ
       // coreyz planning
```

## Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h

```diff
diff --git a/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h b/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
index ae54805a94..9974f5e33a 100644
--- a/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
+++ b/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
@@ -36,12 +36,10 @@
 #endif
 #ifndef DEFAULT_MACHINE_NAME
   #define DEFAULT_MACHINE_NAME "3DPrintMill"
 #endif
 
-#define BOARD_NO_NATIVE_USB
-
 //
 // EEPROM
 //
 #if NO_EEPROM_SELECTED
   // FLASH
@@ -71,20 +69,22 @@
 #endif
 
 //
 // Servos
 //
-#define SERVO0_PIN                          PB0   // BLTouch OUT
+#if !HAS_TMC_UART
+  #define SERVO0_PIN                          PB0   // BLTouch OUT
+  #define Z_MIN_PROBE_PIN                     PB1   // BLTouch IN
+#endif
 
 //
 // Limit Switches
 //
 #define X_STOP_PIN                          PA3
 #define Y_STOP_PIN                          PA7
 #define Z_STOP_PIN                          PA5
 
-#define Z_MIN_PROBE_PIN                     PA5   // BLTouch IN
 
 //
 // Filament Runout Sensor
 //
 #ifndef FIL_RUNOUT_PIN
@@ -144,10 +144,23 @@
 #define HEATER_BED_PIN                      PA1   // HOT BED
 
 #define FAN_PIN                             PA2   // FAN
 #define FAN_SOFT_PWM
 
+//#ifndef FAN1_PIN
+//  #define FAN1_PIN                         PC0
+//#endif
+
+//#ifndef FAN2_PIN
+//  #define FAN2_PIN                         PC1
+//#endif
+
+#ifndef CASE_LIGHT_PIN
+  #define CASE_LIGHT_PIN                     PC14   // LED driving pin
+#endif
+
+
 //
 // SD Card
 //
 #define SD_DETECT_PIN                       PC7
 #define SDCARD_CONNECTION                ONBOARD
@@ -236,5 +249,21 @@
   #define BTN_EN2                           PA4
 
   #define BEEPER_PIN                        PA5
 
 #endif
+
+#if HAS_TMC_UART
+  #define X_SERIAL_TX_PIN                   PB0
+  #define X_SERIAL_RX_PIN                   PB0
+
+  #define Y_SERIAL_TX_PIN                   PB1
+  #define Y_SERIAL_RX_PIN                   PB1
+
+  #define Z_SERIAL_TX_PIN                   PA13
+  #define Z_SERIAL_RX_PIN                   PA13
+
+  #define E0_SERIAL_TX_PIN                  PA14
+  #define E0_SERIAL_RX_PIN                  PA14
+
+  #define TMC_BAUD_RATE                    19200
+#endif
-- 
2.40.1.windows.1

