# Marlin `v2.0.9.3`: Apply CR-30 configuration to default files

- [Base](https://github.com/MarlinFirmware/Marlin/commits/73b8320e9caac23873169c8e10344f2f8060b389) _(Marlin `v2.0.9.3..73b8320` firmware)_
- [Copy-from](https://github.com/MarlinFirmware/Configurations/commit/820725c157fe82720ab4b1f236d885c7f2dd84ea) _(Marlin `v2.0.9.3` configuration for CR-30)_

## Cover

```
From 0000000000000000000000000000000000000000 Mon Sep 17 00:00:00 2001
From: Down to the Wire <8404598+wireddown@users.noreply.github.com>
Date: Mon, 5 Jun 2023 20:38:35 -0700
Subject: Marlin: Apply CR-30 configuration to default files

---
 Marlin/Configuration.h     | 165 ++++----
 Marlin/Configuration_adv.h |  64 ++--
 Marlin/_Bootscreen.h       | 752 +++++++++++++++++++++++++++++++++++++
 Marlin/_Statusscreen.h     |  55 +++
 README.md                  |   5 +
 5 files changed, 931 insertions(+), 110 deletions(-)
 create mode 100644 Marlin/_Bootscreen.h
 create mode 100644 Marlin/_Statusscreen.h
```

## Marlin/Configuration.h

```diff
diff --git a/Marlin/Configuration.h b/Marlin/Configuration.h
index f0fc4dd7d6..8075f1389d 100644
--- a/Marlin/Configuration.h
+++ b/Marlin/Configuration.h
@@ -1,28 +1,30 @@
 /**
  * Marlin 3D Printer Firmware
- * Copyright (c) 2020 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
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
 
+#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
+
 /**
  * Configuration.h
  *
  * Basic settings such as:
  *
@@ -67,85 +69,85 @@
 //===========================================================================
 
 // @section info
 
 // Author info of this build printed to the host during boot and M115
-#define STRING_CONFIG_H_AUTHOR "(none, default config)" // Who made the changes.
+#define STRING_CONFIG_H_AUTHOR "3DPrintMill" // Who made the changes.
 //#define CUSTOM_VERSION_FILE Version.h // Path from the root directory (no quotes)
 
 /**
  * *** VENDORS PLEASE READ ***
  *
  * Marlin allows you to add a custom boot image for Graphical LCDs.
  * With this option Marlin will first show your custom screen followed
  * by the standard Marlin logo with version number and web URL.
  *
  * We encourage you to take advantage of this new feature and we also
  * respectfully request that you retain the unmodified Marlin boot screen.
  */
 
 // Show the Marlin bootscreen on startup. ** ENABLE FOR PRODUCTION **
 #define SHOW_BOOTSCREEN
 
 // Show the bitmap in Marlin/_Bootscreen.h on startup.
-//#define SHOW_CUSTOM_BOOTSCREEN
+#define SHOW_CUSTOM_BOOTSCREEN
 
 // Show the bitmap in Marlin/_Statusscreen.h on the status screen.
-//#define CUSTOM_STATUS_SCREEN_IMAGE
+#define CUSTOM_STATUS_SCREEN_IMAGE
 
 // @section machine
 
 // Choose the name from boards.h that matches your setup
 #ifndef MOTHERBOARD
-  #define MOTHERBOARD BOARD_RAMPS_14_EFB
+  #define MOTHERBOARD BOARD_CREALITY_V4210
 #endif
 
 /**
  * Select the serial port on the board to use for communication with the host.
  * This allows the connection of wireless adapters (for instance) to non-default port pins.
  * Serial port -1 is the USB emulated serial port, if available.
  * Note: The first serial port (-1 or 0) will always be used by the Arduino bootloader.
  *
  * :[-1, 0, 1, 2, 3, 4, 5, 6, 7]
  */
-#define SERIAL_PORT 0
+#define SERIAL_PORT 1
 
 /**
  * Serial Port Baud Rate
  * This is the default communication speed for all serial ports.
  * Set the baud rate defaults for additional serial ports below.
  *
  * 250000 works in most cases, but you might try a lower speed if
  * you commonly experience drop-outs during host printing.
  * You may try up to 1000000 to speed up SD file transfer.
  *
  * :[2400, 9600, 19200, 38400, 57600, 115200, 250000, 500000, 1000000]
  */
-#define BAUDRATE 250000
+#define BAUDRATE 115200
 //#define BAUD_RATE_GCODE     // Enable G-code M575 to set the baud rate
 
 /**
  * Select a secondary serial port on the board to use for communication with the host.
  * Currently Ethernet (-2) is only supported on Teensy 4.1 boards.
  * :[-2, -1, 0, 1, 2, 3, 4, 5, 6, 7]
  */
-//#define SERIAL_PORT_2 -1
+#define SERIAL_PORT_2 3
 //#define BAUDRATE_2 250000   // Enable to override BAUDRATE
 
 /**
  * Select a third serial port on the board to use for communication with the host.
  * Currently only supported for AVR, DUE, LPC1768/9 and STM32/STM32F1
  * :[-1, 0, 1, 2, 3, 4, 5, 6, 7]
  */
 //#define SERIAL_PORT_3 1
 //#define BAUDRATE_3 250000   // Enable to override BAUDRATE
 
 // Enable the Bluetooth serial interface on AT90USB devices
 //#define BLUETOOTH
 
 // Name displayed in the LCD "Ready" message and Info menu
-//#define CUSTOM_MACHINE_NAME "3D Printer"
+#define CUSTOM_MACHINE_NAME "3DPrintMill"
 
 // Printer's unique ID, used by some programs to differentiate between machines.
 // Choose your own or use a service like https://www.uuidgenerator.net/version4
 //#define MACHINE_UUID "00000000-0000-0000-0000-000000000000"
 
@@ -492,11 +494,11 @@
 #define TEMP_SENSOR_3 0
 #define TEMP_SENSOR_4 0
 #define TEMP_SENSOR_5 0
 #define TEMP_SENSOR_6 0
 #define TEMP_SENSOR_7 0
-#define TEMP_SENSOR_BED 0
+#define TEMP_SENSOR_BED 1
 #define TEMP_SENSOR_PROBE 0
 #define TEMP_SENSOR_CHAMBER 0
 #define TEMP_SENSOR_COOLER 0
 #define TEMP_SENSOR_BOARD 0
 #define TEMP_SENSOR_REDUNDANT 0
@@ -553,19 +555,19 @@
 #define CHAMBER_MINTEMP    5
 
 // Above this temperature the heater will be switched off.
 // This can protect components from overheating, but NOT from shorts and failures.
 // (Use MINTEMP for thermistor short/failure protection.)
-#define HEATER_0_MAXTEMP 275
-#define HEATER_1_MAXTEMP 275
-#define HEATER_2_MAXTEMP 275
-#define HEATER_3_MAXTEMP 275
-#define HEATER_4_MAXTEMP 275
-#define HEATER_5_MAXTEMP 275
-#define HEATER_6_MAXTEMP 275
-#define HEATER_7_MAXTEMP 275
-#define BED_MAXTEMP      150
+#define HEATER_0_MAXTEMP 255
+#define HEATER_1_MAXTEMP 255
+#define HEATER_2_MAXTEMP 255
+#define HEATER_3_MAXTEMP 255
+#define HEATER_4_MAXTEMP 255
+#define HEATER_5_MAXTEMP 255
+#define HEATER_6_MAXTEMP 255
+#define HEATER_7_MAXTEMP 255
+#define BED_MAXTEMP      125
 #define CHAMBER_MAXTEMP  60
 
 /**
  * Thermal Overshoot
  * During heatup (and printing) the temperature can often "overshoot" the target by many degrees
@@ -594,58 +596,58 @@
                                   // Set/get with gcode: M301 E[extruder number, 0-2]
 
   #if ENABLED(PID_PARAMS_PER_HOTEND)
     // Specify up to one value per hotend here, according to your setup.
     // If there are fewer values, the last one applies to the remaining hotends.
-    #define DEFAULT_Kp_LIST {  22.20,  22.20 }
-    #define DEFAULT_Ki_LIST {   1.08,   1.08 }
-    #define DEFAULT_Kd_LIST { 114.00, 114.00 }
+    #define DEFAULT_Kp_LIST {  24.19,  24.19 }
+    #define DEFAULT_Ki_LIST {   2.14,   2.14 }
+    #define DEFAULT_Kd_LIST {  68.33,  68.33 }
   #else
-    #define DEFAULT_Kp  22.20
-    #define DEFAULT_Ki   1.08
-    #define DEFAULT_Kd 114.00
+    // Creality 3DPrintMill U-shaped cooling duct and 100% fan tuned at 220c
+    #define DEFAULT_Kp  24.19
+    #define DEFAULT_Ki   2.14
+    #define DEFAULT_Kd  68.33
   #endif
 #endif // PIDTEMP
 
 //===========================================================================
 //====================== PID > Bed Temperature Control ======================
 //===========================================================================
 
 /**
  * PID Bed Heating
  *
  * If this option is enabled set PID constants below.
  * If this option is disabled, bang-bang will be used and BED_LIMIT_SWITCHING will enable hysteresis.
  *
  * The PID frequency will be the same as the extruder PWM.
  * If PID_dT is the default, and correct for the hardware/configuration, that means 7.689Hz,
  * which is fine for driving a square wave into a resistive load and does not significantly
  * impact FET heating. This also works fine on a Fotek SSR-10DA Solid State Relay into a 250W
  * heater. If your configuration is significantly different than this and you don't understand
  * the issues involved, don't use bed PID until someone else verifies that your hardware works.
  */
-//#define PIDTEMPBED
+#define PIDTEMPBED
 
 //#define BED_LIMIT_SWITCHING
 
 /**
  * Max Bed Power
  * Applies to all forms of bed control (PID, bang-bang, and bang-bang with hysteresis).
  * When set to any value below 255, enables a form of PWM to the bed that acts like a divider
  * so don't use it unless you are OK with PWM on your bed. (See the comment on enabling PIDTEMPBED)
  */
 #define MAX_BED_POWER 255 // limits duty cycle to bed; 255=full current
 
 #if ENABLED(PIDTEMPBED)
   //#define MIN_BED_POWER 0
   //#define PID_BED_DEBUG // Sends debug data to the serial port.
 
-  // 120V 250W silicone heater into 4mm borosilicate (MendelMax 1.5+)
-  // from FOPDT model - kp=.39 Tp=405 Tdead=66, Tc set to 79.2, aggressive factor of .15 (vs .1, 1, 10)
-  #define DEFAULT_bedKp 10.00
-  #define DEFAULT_bedKi .023
-  #define DEFAULT_bedKd 305.4
+  // 24V 3mm Aluminium 5mm glass plate (3DPrintMill) tuned at 55c
+  #define DEFAULT_bedKp  49.06
+  #define DEFAULT_bedKi   8.87
+  #define DEFAULT_bedKd 180.88
 
   // FIND YOUR OWN: "M303 E-1 C8 S90" to run autotune on the bed at 90 degreesC for 8 cycles.
 #endif // PIDTEMPBED
 
 //===========================================================================
@@ -747,21 +749,21 @@
 
 // @section machine
 
 // Enable one of the options below for CoreXY, CoreXZ, or CoreYZ kinematics,
 // either in the usual order or reversed
-//#define COREXY
+#define COREXY
 //#define COREXZ
 //#define COREYZ
 //#define COREYX
 //#define COREZX
 //#define COREZY
 //#define MARKFORGED_XY  // MarkForged. See https://reprap.org/forum/read.php?152,504042
 //#define MARKFORGED_YX
 
 // Enable for a belt style printer with endless "Z" motion
-//#define BELTPRINTER
+#define BELTPRINTER
 
 // Enable for Polargraph Kinematics
 //#define POLARGRAPH
 #if ENABLED(POLARGRAPH)
   #define POLARGRAPH_MAX_BELT_LEN 1035.0
@@ -827,54 +829,54 @@
   //#define ENDSTOPPULLDOWN_KMAX
   //#define ENDSTOPPULLDOWN_ZMIN_PROBE
 #endif
 
 // Mechanical endstop with COM to ground and NC to Signal uses "false" here (most common setup).
-#define X_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
-#define Y_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
+#define X_MIN_ENDSTOP_INVERTING true  // Set to true to invert the logic of the endstop.
+#define Y_MIN_ENDSTOP_INVERTING true  // Set to true to invert the logic of the endstop.
 #define Z_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define I_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define J_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define K_MIN_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define X_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define Y_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define Z_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define I_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define J_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define K_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
-#define Z_MIN_PROBE_ENDSTOP_INVERTING false // Set to true to invert the logic of the probe.
+#define Z_MIN_PROBE_ENDSTOP_INVERTING true  // Set to true to invert the logic of the probe.
 
 /**
  * Stepper Drivers
  *
  * These settings allow Marlin to tune stepper driver timing and enable advanced options for
  * stepper drivers that support them. You may also override timing options in Configuration_adv.h.
  *
  * A4988 is assumed for unspecified drivers.
  *
  * Use TMC2208/TMC2208_STANDALONE for TMC2225 drivers and TMC2209/TMC2209_STANDALONE for TMC2226 drivers.
  *
  * Options: A4988, A5984, DRV8825, LV8729, L6470, L6474, POWERSTEP01,
  *          TB6560, TB6600, TMC2100,
  *          TMC2130, TMC2130_STANDALONE, TMC2160, TMC2160_STANDALONE,
  *          TMC2208, TMC2208_STANDALONE, TMC2209, TMC2209_STANDALONE,
  *          TMC26X,  TMC26X_STANDALONE,  TMC2660, TMC2660_STANDALONE,
  *          TMC5130, TMC5130_STANDALONE, TMC5160, TMC5160_STANDALONE
  * :['A4988', 'A5984', 'DRV8825', 'LV8729', 'L6470', 'L6474', 'POWERSTEP01', 'TB6560', 'TB6600', 'TMC2100', 'TMC2130', 'TMC2130_STANDALONE', 'TMC2160', 'TMC2160_STANDALONE', 'TMC2208', 'TMC2208_STANDALONE', 'TMC2209', 'TMC2209_STANDALONE', 'TMC26X', 'TMC26X_STANDALONE', 'TMC2660', 'TMC2660_STANDALONE', 'TMC5130', 'TMC5130_STANDALONE', 'TMC5160', 'TMC5160_STANDALONE']
  */
-#define X_DRIVER_TYPE  A4988
-#define Y_DRIVER_TYPE  A4988
-#define Z_DRIVER_TYPE  A4988
+#define X_DRIVER_TYPE TMC2208_STANDALONE
+#define Y_DRIVER_TYPE TMC2208_STANDALONE
+#define Z_DRIVER_TYPE TMC2208_STANDALONE
 //#define X2_DRIVER_TYPE A4988
 //#define Y2_DRIVER_TYPE A4988
 //#define Z2_DRIVER_TYPE A4988
 //#define Z3_DRIVER_TYPE A4988
 //#define Z4_DRIVER_TYPE A4988
 //#define I_DRIVER_TYPE  A4988
 //#define J_DRIVER_TYPE  A4988
 //#define K_DRIVER_TYPE  A4988
-#define E0_DRIVER_TYPE A4988
+#define E0_DRIVER_TYPE TMC2208_STANDALONE
 //#define E1_DRIVER_TYPE A4988
 //#define E2_DRIVER_TYPE A4988
 //#define E3_DRIVER_TYPE A4988
 //#define E4_DRIVER_TYPE A4988
 //#define E5_DRIVER_TYPE A4988
@@ -925,62 +927,62 @@
 /**
  * Default Axis Steps Per Unit (steps/mm)
  * Override with M92
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
-#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 400, 500 }
+#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 1152.95, 137.65 }
 
 /**
  * Default Max Feed Rate (mm/s)
  * Override with M203
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
-#define DEFAULT_MAX_FEEDRATE          { 300, 300, 5, 25 }
+#define DEFAULT_MAX_FEEDRATE          { 300, 300, 10, 75 }
 
-//#define LIMITED_MAX_FR_EDITING        // Limit edit via M203 or LCD to DEFAULT_MAX_FEEDRATE * 2
+#define LIMITED_MAX_FR_EDITING        // Limit edit via M203 or LCD to DEFAULT_MAX_FEEDRATE * 2
 #if ENABLED(LIMITED_MAX_FR_EDITING)
   #define MAX_FEEDRATE_EDIT_VALUES    { 600, 600, 10, 50 } // ...or, set your own edit limits
 #endif
 
 /**
  * Default Max Acceleration (change/s) change = mm/s
  * (Maximum start speed for accelerated moves)
  * Override with M201
  *                                      X, Y, Z [, I [, J [, K]]], E0 [, E1[, E2...]]
  */
-#define DEFAULT_MAX_ACCELERATION      { 3000, 3000, 100, 10000 }
+#define DEFAULT_MAX_ACCELERATION      { 300, 300, 100, 1000 }
 
 //#define LIMITED_MAX_ACCEL_EDITING     // Limit edit via M201 or LCD to DEFAULT_MAX_ACCELERATION * 2
 #if ENABLED(LIMITED_MAX_ACCEL_EDITING)
   #define MAX_ACCEL_EDIT_VALUES       { 6000, 6000, 200, 20000 } // ...or, set your own edit limits
 #endif
 
 /**
  * Default Acceleration (change/s) change = mm/s
  * Override with M204
  *
  *   M204 P    Acceleration
  *   M204 R    Retract Acceleration
  *   M204 T    Travel Acceleration
  */
-#define DEFAULT_ACCELERATION          3000    // X, Y, Z and E acceleration for printing moves
-#define DEFAULT_RETRACT_ACCELERATION  3000    // E acceleration for retracts
-#define DEFAULT_TRAVEL_ACCELERATION   3000    // X, Y, Z acceleration for travel (non printing) moves
+#define DEFAULT_ACCELERATION          300    // X, Y, Z and E acceleration for printing moves
+#define DEFAULT_RETRACT_ACCELERATION  300    // E acceleration for retracts
+#define DEFAULT_TRAVEL_ACCELERATION   600    // X, Y, Z acceleration for travel (non printing) moves
 
 /**
  * Default Jerk limits (mm/s)
  * Override with M205 X Y Z E
  *
  * "Jerk" specifies the minimum speed change that requires acceleration.
  * When changing speed and direction, if the difference is less than the
  * value set here, it may happen instantaneously.
  */
-//#define CLASSIC_JERK
+#define CLASSIC_JERK
 #if ENABLED(CLASSIC_JERK)
-  #define DEFAULT_XJERK 10.0
-  #define DEFAULT_YJERK 10.0
-  #define DEFAULT_ZJERK  0.3
+  #define DEFAULT_XJERK  6.0
+  #define DEFAULT_YJERK  6.0
+  #define DEFAULT_ZJERK  0.4
   //#define DEFAULT_IJERK  0.3
   //#define DEFAULT_JJERK  0.3
   //#define DEFAULT_KJERK  0.3
 
   //#define TRAVEL_EXTRA_XYJERK 0.0     // Additional jerk allowance for all travel moves
@@ -1184,11 +1186,11 @@
 // Most probes should stay away from the edges of the bed, but
 // with NOZZLE_AS_PROBE this can be negative for a wider probing area.
 #define PROBING_MARGIN 10
 
 // X and Y axis travel speed (mm/min) between probes
-#define XY_PROBE_FEEDRATE (133*60)
+#define XY_PROBE_FEEDRATE (120*60)
 
 // Feedrate (mm/min) for the first approach when double-probing (MULTIPLE_PROBING == 2)
 #define Z_PROBE_FEEDRATE_FAST (4*60)
 
 // Feedrate (mm/min) for the "accurate" probe of each point
@@ -1255,12 +1257,12 @@
  *
  * Example: `M851 Z-5` with a CLEARANCE of 4  =>  9mm from bed to nozzle.
  *     But: `M851 Z+1` with a CLEARANCE of 2  =>  2mm from bed to nozzle.
  */
 #define Z_CLEARANCE_DEPLOY_PROBE   10 // Z Clearance for Deploy/Stow
-#define Z_CLEARANCE_BETWEEN_PROBES  5 // Z Clearance between probe points
-#define Z_CLEARANCE_MULTI_PROBE     5 // Z Clearance between multiple probes
+#define Z_CLEARANCE_BETWEEN_PROBES  0 // Z Clearance between probe points
+#define Z_CLEARANCE_MULTI_PROBE     0 // Z Clearance between multiple probes
 //#define Z_AFTER_PROBING           5 // Z position after probing is done
 
 #define Z_PROBE_LOW_POINT          -2 // Farthest distance below the trigger-point to go before stopping
 
 // For M851 give a range for adjusting the Z probe offset
@@ -1328,21 +1330,21 @@
 #define DISABLE_INACTIVE_EXTRUDER   // Keep only the active extruder enabled
 
 // @section machine
 
 // Invert the stepper direction. Change (or reverse the motor connector) if an axis goes the wrong way.
-#define INVERT_X_DIR false
+#define INVERT_X_DIR true
 #define INVERT_Y_DIR true
-#define INVERT_Z_DIR false
+#define INVERT_Z_DIR true
 //#define INVERT_I_DIR false
 //#define INVERT_J_DIR false
 //#define INVERT_K_DIR false
 
 // @section extruder
 
 // For direct drive extruder v9 set to true, for geared extruder set to false.
-#define INVERT_E0_DIR false
+#define INVERT_E0_DIR true
 #define INVERT_E1_DIR false
 #define INVERT_E2_DIR false
 #define INVERT_E3_DIR false
 #define INVERT_E4_DIR false
 #define INVERT_E5_DIR false
@@ -1376,20 +1378,20 @@
 //#define K_HOME_DIR -1
 
 // @section machine
 
 // The size of the printable area
-#define X_BED_SIZE 200
-#define Y_BED_SIZE 200
+#define X_BED_SIZE 220
+#define Y_BED_SIZE 250
 
 // Travel limits (mm) after homing, corresponding to endstop positions.
 #define X_MIN_POS 0
-#define Y_MIN_POS 0
+#define Y_MIN_POS -5
 #define Z_MIN_POS 0
 #define X_MAX_POS X_BED_SIZE
 #define Y_MAX_POS Y_BED_SIZE
-#define Z_MAX_POS 200
+#define Z_MAX_POS 20000000
 //#define I_MIN_POS 0
 //#define I_MAX_POS 50
 //#define J_MIN_POS 0
 //#define J_MAX_POS 50
 //#define K_MIN_POS 0
@@ -1441,16 +1443,16 @@
  *  3. The heaters were turned on and PRINTJOB_TIMER_AUTOSTART is enabled.
  *
  * RAMPS-based boards use SERVO3_PIN for the first runout sensor.
  * For other boards you may need to define FIL_RUNOUT_PIN, FIL_RUNOUT2_PIN, etc.
  */
-//#define FILAMENT_RUNOUT_SENSOR
+#define FILAMENT_RUNOUT_SENSOR
 #if ENABLED(FILAMENT_RUNOUT_SENSOR)
   #define FIL_RUNOUT_ENABLED_DEFAULT true // Enable the sensor on startup. Override with M412 followed by M500.
   #define NUM_RUNOUT_SENSORS   1          // Number of sensors, up to one per extruder. Define a FIL_RUNOUT#_PIN for each.
 
-  #define FIL_RUNOUT_STATE     LOW        // Pin state indicating that filament is NOT present.
+  #define FIL_RUNOUT_STATE     HIGH       // Pin state indicating that filament is NOT present.
   #define FIL_RUNOUT_PULLUP               // Use internal pullup for filament runout pins.
   //#define FIL_RUNOUT_PULLDOWN           // Use internal pulldown for filament runout pins.
   //#define WATCH_ALL_RUNOUT_SENSORS      // Execute runout script on any triggering sensor, not only for the active extruder.
                                           // This is automatically enabled for MIXING_EXTRUDERs.
 
@@ -1731,11 +1733,11 @@
 //#define BED_CENTER_AT_0_0
 
 // Manually set the home position. Leave these undefined for automatic settings.
 // For DELTA this is the top-center of the Cartesian print volume.
 //#define MANUAL_X_HOME_POS 0
-//#define MANUAL_Y_HOME_POS 0
+#define MANUAL_Y_HOME_POS 0
 //#define MANUAL_Z_HOME_POS 0
 //#define MANUAL_I_HOME_POS 0
 //#define MANUAL_J_HOME_POS 0
 //#define MANUAL_K_HOME_POS 0
 
@@ -1829,16 +1831,16 @@
  *
  *   M500 - Store settings to EEPROM.
  *   M501 - Read settings from EEPROM. (i.e., Throw away unsaved changes)
  *   M502 - Revert settings to "factory" defaults. (Follow with M500 to init the EEPROM.)
  */
-//#define EEPROM_SETTINGS     // Persistent storage with M500 and M501
+#define EEPROM_SETTINGS       // Persistent storage with M500 and M501
 //#define DISABLE_M503        // Saves ~2700 bytes of PROGMEM. Disable for release!
 #define EEPROM_CHITCHAT       // Give feedback on EEPROM commands. Disable to save PROGMEM.
 #define EEPROM_BOOT_SILENT    // Keep M503 quiet and only give errors during first load
 #if ENABLED(EEPROM_SETTINGS)
-  //#define EEPROM_AUTO_INIT  // Init EEPROM automatically on any errors.
+  #define EEPROM_AUTO_INIT    // Init EEPROM automatically on any errors.
   //#define EEPROM_INIT_NOW   // Init EEPROM on first boot after a new build.
 #endif
 
 //
 // Host Keepalive
@@ -1864,40 +1866,40 @@
 
 //
 // Preheat Constants - Up to 5 are supported without changes
 //
 #define PREHEAT_1_LABEL       "PLA"
-#define PREHEAT_1_TEMP_HOTEND 180
-#define PREHEAT_1_TEMP_BED     70
-#define PREHEAT_1_TEMP_CHAMBER 35
+#define PREHEAT_1_TEMP_HOTEND 185
+#define PREHEAT_1_TEMP_BED     55
+#define PREHEAT_1_TEMP_CHAMBER 30
 #define PREHEAT_1_FAN_SPEED     0 // Value from 0 to 255
 
 #define PREHEAT_2_LABEL       "ABS"
 #define PREHEAT_2_TEMP_HOTEND 240
-#define PREHEAT_2_TEMP_BED    110
+#define PREHEAT_2_TEMP_BED     70
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
-//#define NOZZLE_PARK_FEATURE
+#define NOZZLE_PARK_FEATURE
 
 #if ENABLED(NOZZLE_PARK_FEATURE)
   // Specify a park position as { X, Y, Z_raise }
-  #define NOZZLE_PARK_POINT { (X_MIN_POS + 10), (Y_MAX_POS - 10), 20 }
+  #define NOZZLE_PARK_POINT { X_MIN_POS, MANUAL_Y_HOME_POS + 100, 0 }
   //#define NOZZLE_PARK_X_ONLY          // X move only is required to park
   //#define NOZZLE_PARK_Y_ONLY          // Y move only is required to park
-  #define NOZZLE_PARK_Z_RAISE_MIN   2   // (mm) Always raise Z by at least this distance
+  #define NOZZLE_PARK_Z_RAISE_MIN   0   // (mm) Always raise Z by at least this distance
   #define NOZZLE_PARK_XY_FEEDRATE 100   // (mm/s) X and Y axes feedrate (also used for delta Z axis)
   #define NOZZLE_PARK_Z_FEEDRATE    5   // (mm/s) Z axis feedrate (not used for delta printers)
 #endif
 
 /**
@@ -2103,11 +2105,11 @@
  * SD CARD
  *
  * SD Card support is disabled by default. If your controller has an SD slot,
  * you must uncomment the following option or it won't work.
  */
-//#define SDSUPPORT
+#define SDSUPPORT
 
 /**
  * SD CARD: ENABLE CRC
  *
  * Use CRC checks and retries on the SD communication.
@@ -2173,30 +2175,30 @@
 //
 // Individual Axis Homing
 //
 // Add individual axis homing items (Home X, Home Y, and Home Z) to the LCD menu.
 //
-//#define INDIVIDUAL_AXIS_HOMING_MENU
+#define INDIVIDUAL_AXIS_HOMING_MENU
 //#define INDIVIDUAL_AXIS_HOMING_SUBMENU
 
 //
 // SPEAKER/BUZZER
 //
 // If you have a speaker that can produce tones, enable it here.
 // By default Marlin assumes you have a buzzer with a fixed frequency.
 //
-//#define SPEAKER
+#define SPEAKER
 
 //
 // The duration and frequency for the UI feedback sound.
 // Set these to 0 to disable audio feedback in the LCD menus.
 //
 // Note: Test audio output with the G-Code:
 //  M300 S<frequency Hz> P<duration ms>
 //
-//#define LCD_FEEDBACK_FREQUENCY_DURATION_MS 2
-//#define LCD_FEEDBACK_FREQUENCY_HZ 5000
+#define LCD_FEEDBACK_FREQUENCY_DURATION_MS 2
+#define LCD_FEEDBACK_FREQUENCY_HZ 5000
 
 //=============================================================================
 //======================== LCD / Controller Selection =========================
 //========================   (Character-based LCDs)   =========================
 //=============================================================================
@@ -2470,11 +2472,16 @@
 // https://www.aliexpress.com/item/32833148327.html
 //
 // This is RAMPS-compatible using a single 10-pin connector.
 // (For CR-10 owners who want to replace the Melzi Creality board but retain the display)
 //
-//#define CR10_STOCKDISPLAY
+#define CR10_STOCKDISPLAY
+
+//
+// Creality V4.2.5 display. Creality board but retain the display.
+//
+#define RET6_12864_LCD
 
 //
 // Ender-2 OEM display, a variant of the MKS_MINI_12864
 //
 //#define ENDER2_STOCKDISPLAY
```

## Marlin/Configuration_adv.h

```diff
diff --git a/Marlin/Configuration_adv.h b/Marlin/Configuration_adv.h
index 2410d8b903..97c89a006b 100644
--- a/Marlin/Configuration_adv.h
+++ b/Marlin/Configuration_adv.h
@@ -1,28 +1,30 @@
 /**
  * Marlin 3D Printer Firmware
- * Copyright (c) 2020 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
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
 
+#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
+
 /**
  * Configuration_adv.h
  *
  * Advanced settings.
  * Only change these if you know exactly what you're doing.
@@ -301,25 +303,25 @@
    *
    * If you get false positives for "Heating failed", increase WATCH_TEMP_PERIOD
    * and/or decrease WATCH_TEMP_INCREASE. WATCH_TEMP_INCREASE should not be set
    * below 2.
    */
-  #define WATCH_TEMP_PERIOD  20               // Seconds
+  #define WATCH_TEMP_PERIOD  40               // Seconds
   #define WATCH_TEMP_INCREASE 2               // Degrees Celsius
 #endif
 
 /**
  * Thermal Protection parameters for the bed are just as above for hotends.
  */
 #if ENABLED(THERMAL_PROTECTION_BED)
-  #define THERMAL_PROTECTION_BED_PERIOD        20 // Seconds
+  #define THERMAL_PROTECTION_BED_PERIOD       180 // Seconds
   #define THERMAL_PROTECTION_BED_HYSTERESIS     2 // Degrees Celsius
 
   /**
    * As described above, except for the bed (M140/M190/M303).
    */
-  #define WATCH_BED_TEMP_PERIOD                60 // Seconds
+  #define WATCH_BED_TEMP_PERIOD               180 // Seconds
   #define WATCH_BED_TEMP_INCREASE               2 // Degrees Celsius
 #endif
 
 /**
  * Thermal Protection parameters for the heated chamber.
@@ -839,17 +841,17 @@
  * the position of the toolhead relative to the workspace.
  */
 
 //#define SENSORLESS_BACKOFF_MM  { 2, 2, 0 }  // (mm) Backoff from endstops before sensorless homing
 
-#define HOMING_BUMP_MM      { 5, 5, 2 }       // (mm) Backoff from endstops after first bump
+#define HOMING_BUMP_MM      { 5, 12, 0 }       // (mm) Backoff from endstops after first bump
 #define HOMING_BUMP_DIVISOR { 2, 2, 4 }       // Re-Bump Speed Divisor (Divides the Homing Feedrate)
 
-//#define HOMING_BACKOFF_POST_MM { 2, 2, 2 }  // (mm) Backoff from endstops after homing
+#define HOMING_BACKOFF_POST_MM { 0, 0, 0 }  // (mm) Backoff from endstops after homing
 
 //#define QUICK_HOME                          // If G28 contains XY do a diagonal move first
-//#define HOME_Y_BEFORE_X                     // If G28 contains XY home Y before X
+#define HOME_Y_BEFORE_X                       // If G28 contains XY home Y before X
 //#define HOME_Z_FIRST                        // Home Z first. Requires a Z-MIN endstop (not a probe).
 //#define CODEPENDENT_XY_HOMING               // If X/Y can't home without homing Y/X first
 
 // @section bltouch
 
@@ -1033,11 +1035,11 @@
 /**
  * Idle Stepper Shutdown
  * Set DISABLE_INACTIVE_? 'true' to shut down axis steppers after an idle period.
  * The Deactive Time can be overridden with M18 and M84. Set to 0 for No Timeout.
  */
-#define DEFAULT_STEPPER_DEACTIVE_TIME 120
+#define DEFAULT_STEPPER_DEACTIVE_TIME 300
 #define DISABLE_INACTIVE_X true
 #define DISABLE_INACTIVE_Y true
 #define DISABLE_INACTIVE_Z true  // Set 'false' if the nozzle could fall onto your printed part!
 #define DISABLE_INACTIVE_I true
 #define DISABLE_INACTIVE_J true
@@ -1241,12 +1243,12 @@
    * AZTEEG_X3_PRO         0x2C (0x58)       0x2E (0x5C)       MCP4451
    * AZTEEG_X5_MINI        0x2C (0x58)       0x2E (0x5C)       MCP4451
    * AZTEEG_X5_MINI_WIFI         0x58              0x5C        MCP4451
    * MIGHTYBOARD_REVE      0x2F (0x5E)                         MCP4018
    */
-  //#define DIGIPOT_I2C_ADDRESS_A 0x2C  // Unshifted slave address for first DIGIPOT
-  //#define DIGIPOT_I2C_ADDRESS_B 0x2D  // Unshifted slave address for second DIGIPOT
+  #define DIGIPOT_I2C_ADDRESS_A 0x2C  // Unshifted slave address for first DIGIPOT
+  #define DIGIPOT_I2C_ADDRESS_B 0x2D  // Unshifted slave address for second DIGIPOT
 #endif
 
 //===========================================================================
 //=============================Additional Features===========================
 //===========================================================================
@@ -1309,11 +1311,11 @@
       #endif
     #endif
   #endif
 
   // Include a page of printer information in the LCD Main Menu
-  //#define LCD_INFO_MENU
+  #define LCD_INFO_MENU
   #if ENABLED(LCD_INFO_MENU)
     //#define LCD_PRINTER_INFO_IS_BOOTSCREEN // Show bootscreen(s) instead of Printer Info pages
   #endif
 
   // BACK menu items keep the highlight at the top
@@ -1357,27 +1359,27 @@
 #if EITHER(HAS_DISPLAY, DWIN_CREALITY_LCD_ENHANCED)
   // The timeout (in ms) to return to the status screen from sub-menus
   //#define LCD_TIMEOUT_TO_STATUS 15000
 
   #if ENABLED(SHOW_BOOTSCREEN)
-    #define BOOTSCREEN_TIMEOUT 4000      // (ms) Total Duration to display the boot screen(s)
+    #define BOOTSCREEN_TIMEOUT 2000      // (ms) Total Duration to display the boot screen(s)
     #if EITHER(HAS_MARLINUI_U8GLIB, TFT_COLOR_UI)
       #define BOOT_MARLIN_LOGO_SMALL     // Show a smaller Marlin logo on the Boot Screen (saving lots of flash)
     #endif
   #endif
 
   // Scroll a longer status message into view
   //#define STATUS_MESSAGE_SCROLLING
 
   // On the Info Screen, display XY with one decimal place when possible
   //#define LCD_DECIMAL_SMALL_XY
 
   // Add an 'M73' G-code to set the current percentage
   //#define LCD_SET_PROGRESS_MANUALLY
 
   // Show the E position (filament used) during printing
-  //#define LCD_SHOW_E_TOTAL
+  #define LCD_SHOW_E_TOTAL
 #endif
 
 // LCD Print Progress options
 #if EITHER(SDSUPPORT, LCD_SET_PROGRESS_MANUALLY)
   #if CAN_SHOW_REMAINING_TIME
@@ -1421,47 +1423,47 @@
   //#define SD_DETECT_STATE HIGH
 
   //#define SD_IGNORE_AT_STARTUP            // Don't mount the SD card when starting up
   //#define SDCARD_READONLY                 // Read-only SD card (to save over 2K of flash)
 
-  //#define GCODE_REPEAT_MARKERS            // Enable G-code M808 to set repeat markers and do looping
+  #define GCODE_REPEAT_MARKERS              // Enable G-code M808 to set repeat markers and do looping
 
   #define SD_PROCEDURE_DEPTH 1              // Increase if you need more nested M32 calls
 
   #define SD_FINISHED_STEPPERRELEASE true   // Disable steppers when SD Print is finished
-  #define SD_FINISHED_RELEASECOMMAND "M84"  // Use "M84XYE" to keep Z enabled so your bed stays in place
+  #define SD_FINISHED_RELEASECOMMAND "G28XY\nG1Y100\nM84"  // Use "M84XYE" to keep Z enabled so your bed stays in place
 
   // Reverse SD sort to show "more recent" files first, according to the card's FAT.
   // Since the FAT gets out of order with usage, SDCARD_SORT_ALPHA is recommended.
   #define SDCARD_RATHERRECENTFIRST
 
   #define SD_MENU_CONFIRM_START             // Confirm the selected SD file before printing
 
   //#define NO_SD_AUTOSTART                 // Remove auto#.g file support completely to save some Flash, SRAM
   //#define MENU_ADDAUTOSTART               // Add a menu option to run auto#.g files
 
   //#define BROWSE_MEDIA_ON_INSERT          // Open the file browser when media is inserted
 
   //#define MEDIA_MENU_AT_TOP               // Force the media menu to be listed on the top of the main menu
 
-  #define EVENT_GCODE_SD_ABORT "G28XY"      // G-code to run on SD Abort Print (e.g., "G28XY" or "G27")
+  #define EVENT_GCODE_SD_ABORT "G28XY\nG1Y100" // G-code to run on SD Abort Print (e.g., "G28XY" or "G27")
 
   #if ENABLED(PRINTER_EVENT_LEDS)
     #define PE_LEDS_COMPLETED_TIME  (30*60) // (seconds) Time to keep the LED "done" color before restoring normal illumination
   #endif
 
   /**
    * Continue after Power-Loss (Creality3D)
    *
    * Store the current state to the SD Card at the start of each layer
    * during SD printing. If the recovery file is found at boot time, present
    * an option on the LCD screen to continue the print from the last-known
    * point in the file.
    */
-  //#define POWER_LOSS_RECOVERY
+  #define POWER_LOSS_RECOVERY
   #if ENABLED(POWER_LOSS_RECOVERY)
-    #define PLR_ENABLED_DEFAULT   false // Power Loss Recovery enabled by default. (Set with 'M413 Sn' & M500)
+    #define PLR_ENABLED_DEFAULT    true // Power Loss Recovery enabled by default. (Set with 'M413 Sn' & M500)
     //#define BACKUP_POWER_SUPPLY       // Backup power / UPS to move the steppers on power loss
     //#define POWER_LOSS_ZRAISE       2 // (mm) Z axis raise on resume (on power loss with UPS)
     //#define POWER_LOSS_PIN         44 // Pin to detect power loss. Set to -1 to disable default pin on boards without module.
     //#define POWER_LOSS_STATE     HIGH // State of pin indicating power loss
     //#define POWER_LOSS_PULLUP         // Set pullup / pulldown as appropriate for your sensor
@@ -1727,11 +1729,11 @@
 #if HAS_MARLINUI_U8GLIB || IS_DWIN_MARLINUI
   // Show SD percentage next to the progress bar
   //#define SHOW_SD_PERCENT
 
   // Enable to save many cycles by drawing a hollow frame on Menu Screens
-  #define MENU_HOLLOW_FRAME
+  //#define MENU_HOLLOW_FRAME
 
   // Swap the CW/CCW indicators in the graphics overlay
   //#define OVERLAY_GFX_REVERSE
 #endif
 
@@ -1940,32 +1942,32 @@
  * the current position values. This feature is used primarily to adjust the Z
  * axis in the first layer of a print in real-time.
  *
  * Warning: Does not respect endstops!
  */
-//#define BABYSTEPPING
+#define BABYSTEPPING
 #if ENABLED(BABYSTEPPING)
   //#define INTEGRATED_BABYSTEPPING         // EXPERIMENTAL integration of babystepping into the Stepper ISR
   //#define BABYSTEP_WITHOUT_HOMING
-  //#define BABYSTEP_ALWAYS_AVAILABLE       // Allow babystepping at all times (not just during movement).
-  //#define BABYSTEP_XY                     // Also enable X/Y Babystepping. Not supported on DELTA!
+  #define BABYSTEP_ALWAYS_AVAILABLE         // Allow babystepping at all times (not just during movement).
+  #define BABYSTEP_XY                       // Also enable X/Y Babystepping. Not supported on DELTA!
   #define BABYSTEP_INVERT_Z false           // Change if Z babysteps should go the other way
   //#define BABYSTEP_MILLIMETER_UNITS       // Specify BABYSTEP_MULTIPLICATOR_(XY|Z) in mm instead of micro-steps
-  #define BABYSTEP_MULTIPLICATOR_Z  1       // (steps or mm) Steps or millimeter distance for each Z babystep
-  #define BABYSTEP_MULTIPLICATOR_XY 1       // (steps or mm) Steps or millimeter distance for each XY babystep
+  #define BABYSTEP_MULTIPLICATOR_Z  11      // (steps or mm) Steps or millimeter distance for each Z babystep
+  #define BABYSTEP_MULTIPLICATOR_XY 2       // (steps or mm) Steps or millimeter distance for each XY babystep
 
-  //#define DOUBLECLICK_FOR_Z_BABYSTEPPING  // Double-click on the Status Screen for Z Babystepping.
+  #define DOUBLECLICK_FOR_Z_BABYSTEPPING    // Double-click on the Status Screen for Z Babystepping.
   #if ENABLED(DOUBLECLICK_FOR_Z_BABYSTEPPING)
     #define DOUBLECLICK_MAX_INTERVAL 1250   // Maximum interval between clicks, in milliseconds.
                                             // Note: Extra time may be added to mitigate controller latency.
     //#define MOVE_Z_WHEN_IDLE              // Jump to the move Z menu on doubleclick when printer is idle.
     #if ENABLED(MOVE_Z_WHEN_IDLE)
       #define MOVE_Z_IDLE_MULTIPLICATOR 1   // Multiply 1mm by this factor for the move step size.
     #endif
   #endif
 
-  //#define BABYSTEP_DISPLAY_TOTAL          // Display total babysteps since last G28
+  #define BABYSTEP_DISPLAY_TOTAL          // Display total babysteps since last G28
 
   //#define BABYSTEP_ZPROBE_OFFSET          // Combine M851 Z and Babystepping
   #if ENABLED(BABYSTEP_ZPROBE_OFFSET)
     //#define BABYSTEP_HOTEND_Z_OFFSET      // For multiple hotends, babystep relative Z offsets
     //#define BABYSTEP_ZPROBE_GFX_OVERLAY   // Enable graphical overlay on Z-offset editor
@@ -1987,14 +1989,14 @@
  * If this algorithm produces a higher speed offset than the extruder can handle (compared to E jerk)
  * print acceleration will be reduced during the affected moves to keep within the limit.
  *
  * See https://marlinfw.org/docs/features/lin_advance.html for full instructions.
  */
-//#define LIN_ADVANCE
+#define LIN_ADVANCE
 #if ENABLED(LIN_ADVANCE)
   //#define EXTRA_LIN_ADVANCE_K // Enable for second linear advance constants
-  #define LIN_ADVANCE_K 0.22    // Unit: mm compression per 1mm/s extruder speed
+  #define LIN_ADVANCE_K 0       // Unit: mm compression per 1mm/s extruder speed
   //#define LA_DEBUG            // If enabled, this will generate debug information output over USB.
   //#define EXPERIMENTAL_SCURVE // Enable this option to permit S-Curve Acceleration
   //#define ALLOW_LOW_EJERK     // Allow a DEFAULT_EJERK value of <10. Recommended for direct drive hotends.
 #endif
 
@@ -2480,11 +2482,11 @@
  *  - For Filament Change parking enable and configure NOZZLE_PARK_FEATURE.
  *  - For user interaction enable an LCD display, HOST_PROMPT_SUPPORT, or EMERGENCY_PARSER.
  *
  * Enable PARK_HEAD_ON_PAUSE to add the G-code M125 Pause and Park.
  */
-//#define ADVANCED_PAUSE_FEATURE
+#define ADVANCED_PAUSE_FEATURE
 #if ENABLED(ADVANCED_PAUSE_FEATURE)
   #define PAUSE_PARK_RETRACT_FEEDRATE         60  // (mm/s) Initial retract feedrate.
   #define PAUSE_PARK_RETRACT_LENGTH            2  // (mm) Initial retract.
                                                   // This short retract is done immediately, before parking the nozzle.
   #define FILAMENT_CHANGE_UNLOAD_FEEDRATE     10  // (mm/s) Unload filament feedrate. This can be pretty fast.
@@ -2520,11 +2522,11 @@
   #define FILAMENT_CHANGE_ALERT_BEEPS         10  // Number of alert beeps to play when a response is needed.
   #define PAUSE_PARK_NO_STEPPER_TIMEOUT           // Enable for XYZ steppers to stay powered on during filament change.
   //#define FILAMENT_CHANGE_RESUME_ON_INSERT      // Automatically continue / load filament when runout sensor is triggered again.
   //#define PAUSE_REHEAT_FAST_RESUME              // Reduce number of waits by not prompting again post-timeout before continuing.
 
-  //#define PARK_HEAD_ON_PAUSE                    // Park the nozzle during pause and filament change.
+  #define PARK_HEAD_ON_PAUSE                    // Park the nozzle during pause and filament change.
   //#define HOME_BEFORE_FILAMENT_CHANGE           // If needed, home before parking for filament change
 
   //#define FILAMENT_LOAD_UNLOAD_GCODES           // Add M701/M702 Load/Unload G-codes, plus Load/Unload in the LCD Prepare menu.
   //#define FILAMENT_UNLOAD_ALL_EXTRUDERS         // Allow M702 to unload all extruders above a minimum target temp (as set by M302)
 #endif
@@ -3440,11 +3442,11 @@
 #if EITHER(SPINDLE_FEATURE, LASER_FEATURE)
   #define SPINDLE_LASER_ACTIVE_STATE    LOW    // Set to "HIGH" if SPINDLE_LASER_ENA_PIN is active HIGH
 
   #define SPINDLE_LASER_USE_PWM                // Enable if your controller supports setting the speed/power
   #if ENABLED(SPINDLE_LASER_USE_PWM)
-    #define SPINDLE_LASER_PWM_INVERT    false  // Set to "true" if the speed/power goes up when you want it to go slower
+    #define SPINDLE_LASER_PWM_INVERT    true   // Set to "true" if the speed/power goes up when you want it to go slower
     #define SPINDLE_LASER_FREQUENCY     2500   // (Hz) Spindle/laser frequency (only on supported HALs: AVR and LPC)
   #endif
 
   //#define AIR_EVACUATION                     // Cutter Vacuum / Laser Blower motor control with G-codes M10-M11
   #if ENABLED(AIR_EVACUATION)
```

## Marlin/_Bootscreen.h

```diff
diff --git a/Marlin/_Bootscreen.h b/Marlin/_Bootscreen.h
new file mode 100644
index 0000000000..884806170f
--- /dev/null
+++ b/Marlin/_Bootscreen.h
@@ -0,0 +1,752 @@
+/**
+ * Marlin 3D Printer Firmware
+ * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ *
+ * Based on Sprinter and grbl.
+ * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#pragma once
+
+#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
+
+/**
+ * Animated boot screen example
+ */
+
+#define CUSTOM_BOOTSCREEN_BOTTOM_JUSTIFY
+#define CUSTOM_BOOTSCREEN_ANIMATED
+
+const unsigned char custom_start_bmp[] PROGMEM = {
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
+  B00000000,B00000001,B11111100,B00111111,B10000111,B11111100,B11111111,B10011011,B00000011,B11111111,B11001110,B01110011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000001,B11111110,B00111111,B11000111,B11111110,B11111111,B11011011,B10000011,B11111111,B11011111,B11111011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B11000000,B11011011,B11000011,B00001100,B00011111,B11111011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B11001111,B11011011,B11100011,B00001100,B00011101,B10111011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B11011111,B10011011,B01110011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11011100,B00011011,B00111011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11001110,B00011011,B00011111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000111,B00011011,B00001111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+  B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000011,B10011011,B00000111,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
+  B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000001,B11011011,B00000011,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
+  B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+  B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+  B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+  B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+  B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+  B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+  B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
+  B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
+  B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
+  B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
+  B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+  B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
+  B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
+  B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
+  B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
+  B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
+  B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+  B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+  B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
+  B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+};
+
+#if DISABLED(CUSTOM_BOOTSCREEN_ANIMATED)
+
+  #define CUSTOM_BOOTSCREEN_FRAME_TIME 500 // (ms)
+
+#else
+
+  const unsigned char custom_start_bmp1[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+    B00011111,B10000011,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11000001,B11111000,
+    B00111001,B11000111,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B11100011,B10011100,
+    B00111000,B11000110,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B01100011,B00011100,
+    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011000,B00011100,B00001100,
+    B00111000,B11000110,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B01100011,B00011100,
+    B00111001,B11000111,B00111000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011100,B11100011,B10011100,
+    B00011111,B10000011,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11000001,B11111000,
+    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp2[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
+    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
+    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
+    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
+    B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
+    B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
+    B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
+    B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp3[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000010,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10010000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011100,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
+    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
+    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
+    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
+    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
+    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
+    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
+    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
+    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
+    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
+    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp4[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11000011,B11111000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11100011,B11111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110011,B00011110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111011,B00000111,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11111011,B00000011,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11111011,B00000011,B01000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111011,B00000111,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110011,B00011110,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11100011,B11111100,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011111,B11000011,B11111000,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
+    B00011100,B00011100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001110,B00111000,
+    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
+    B00111000,B00011100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00001110,B00011100,
+    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
+    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
+    B00110001,B01111111,B10011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B10111111,B11001100,
+    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
+    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
+    B00111000,B01100000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B00011100,
+    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
+    B00011100,B01100000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00110000,B00111000,
+    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
+    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp5[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111100,B00111111,B10000111,B11111000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111110,B00111111,B11000111,B11111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
+    B00001111,B11110111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11111011,B11110000,
+    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
+    B00011100,B00111000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00011100,B00111000,
+    B00011100,B00111000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00011100,B00111000,
+    B00111000,B00110000,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00011000,B00011100,
+    B00111000,B00100000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B00010000,B00011100,
+    B00110111,B00111111,B11111001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B10011111,B11111100,
+    B00111111,B10111011,B11111001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011111,B11011101,B11111100,
+    B00111111,B11111001,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011111,B11111100,B11101100,
+    B00111000,B00001000,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00000100,B00011100,
+    B00111000,B00011000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00001100,B00011100,
+    B00011100,B00111000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
+    B00011100,B00111000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
+    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
+    B00001111,B11011111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11101111,B11110000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp6[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00111111,B11100111,B11111000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00111111,B11110111,B11111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00110110,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110011,B11110110,B01111110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110111,B11100110,B11111100,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110000,B00000110,B11100000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110000,B00000110,B01110000,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00000110,B00111000,B11010000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00110000,B00000110,B00011100,B11011000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00110000,B00000110,B00001110,B11011000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
+    B00011100,B00001100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000110,B00111000,
+    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
+    B00111000,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00000110,B00011100,
+    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
+    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
+    B00110011,B11111101,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011001,B11111110,B10001100,
+    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
+    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
+    B00111000,B01110000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00111000,B00011100,
+    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
+    B00011100,B01110000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00111000,B00111000,
+    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp7[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00111111,B11100111,B11111100,B11011000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00111111,B11110111,B11111110,B11011100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00110110,B00000110,B11011110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110011,B11110110,B01111110,B11011111,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110111,B11100110,B11111100,B11011011,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11111101,B10000001,B10110000,B00000110,B11100000,B11011001,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00011101,B10000011,B10110000,B00000110,B01110000,B11011000,B11100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111001,B10001111,B00110000,B00000110,B00111000,B11011000,B01110000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11110001,B11111110,B00110000,B00000110,B00011100,B11011000,B00111000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B11100001,B11111100,B00110000,B00000110,B00001110,B11011000,B00011000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
+    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
+    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
+    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
+    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
+    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
+    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
+    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
+    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
+    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
+    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
+    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp8[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11111111,B10011111,B11110011,B01100000,B01111000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11111111,B11011111,B11111011,B01110000,B01111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B11011000,B00011011,B01111000,B01100000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11001111,B11011001,B11111011,B01111100,B01100001,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11011111,B10011011,B11110011,B01101110,B01100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11000000,B00011011,B10000011,B01100111,B01100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11000000,B00011001,B11000011,B01100011,B11100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B00011000,B11100011,B01100001,B11100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11000000,B00011000,B01110011,B01100000,B11100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11000000,B00011000,B00111011,B01100000,B01100001,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
+    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
+    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
+    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011100,B00001100,
+    B00111000,B11000110,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B01100011,B00011100,
+    B00111001,B11000111,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B11100011,B10011100,
+    B00011111,B10000011,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001111,B11000001,B11111000,
+    B00011111,B00000001,B11110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001111,B10000000,B11111000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp9[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011111,B11000011,B11111110,B01111111,B11001101,B10000001,B11111111,B11100000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011111,B11100011,B11111111,B01111111,B11101101,B11000001,B11111111,B11101100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10011000,B11110011,B00000011,B01100000,B01101101,B11100001,B10000110,B00001110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11011000,B00111011,B00111111,B01100111,B11101101,B11110001,B10000110,B00001110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11011000,B00011011,B01111110,B01101111,B11001101,B10111001,B10000110,B00001100,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B11011000,B00011011,B00000000,B01101110,B00001101,B10011101,B10000110,B00001100,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000001,B11011000,B00111011,B00000000,B01100111,B00001101,B10001111,B10000110,B00001100,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000011,B10011000,B11110011,B00000000,B01100011,B10001101,B10000111,B10000110,B00001100,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111111,B00011111,B11100011,B00000000,B01100001,B11001101,B10000011,B10000110,B00001100,B11001000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11111110,B00011111,B11000011,B00000000,B01100000,B11101101,B10000001,B10000110,B00001100,B11001100,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000011,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000001,B11110000,
+    B00011100,B00000111,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000011,B10111000,
+    B00011110,B00000110,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B00000011,B00111000,
+    B00111111,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011111,B10000110,B00011100,
+    B00111011,B10001000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011101,B11000100,B00011100,
+    B00110000,B11111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B01111100,B00001100,
+    B00110000,B00111000,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B00011100,B00001100,
+    B00110000,B00111110,B00011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011111,B00001100,
+    B00111000,B00100011,B10111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00010001,B11011100,
+    B00111000,B01100001,B11111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B11111100,
+    B00011100,B11000000,B11110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B01100000,B01111000,
+    B00011101,B11000000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B11100000,B00111000,
+    B00001111,B10000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11000000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp10[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11111111,B10011111,B11110011,B01100000,B01111111,B11111001,B11001000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11111111,B11011111,B11111011,B01110000,B01111111,B11111011,B11111100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B11011000,B00011011,B01111000,B01100001,B10000011,B11111110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11001111,B11011001,B11111011,B01111100,B01100001,B10000011,B10110111,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11011111,B10011011,B11110011,B01101110,B01100001,B10000011,B00110011,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B11110110,B00000110,B11000000,B00011011,B10000011,B01100111,B01100001,B10000011,B00110011,B01000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B01110110,B00001110,B11000000,B00011001,B11000011,B01100011,B11100001,B10000011,B00110011,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B11100110,B00111100,B11000000,B00011000,B11100011,B01100001,B11100001,B10000011,B00110011,B01100000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B11000111,B11111000,B11000000,B00011000,B01110011,B01100000,B11100001,B10000011,B00110011,B01101000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00111111,B10000111,B11110000,B11000000,B00011000,B00111011,B01100000,B01100001,B10000011,B00110011,B01101100,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11010111,B11111111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
+    B00011100,B00011100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00001110,B00111000,
+    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
+    B00111000,B00011100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00001110,B00011100,
+    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
+    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
+    B00110001,B01111111,B10011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011000,B10111111,B11001100,
+    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
+    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
+    B00111000,B01100000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00110000,B00011100,
+    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
+    B00011100,B01100000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00110000,B00111000,
+    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11000000,
+    B00000000,B11111111,B11110101,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp11[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111000,B01111111,B00001111,B11111001,B11111111,B00110110,B00000111,B11111111,B10011100,B11100000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111100,B01111111,B10001111,B11111101,B11111111,B10110111,B00000111,B11111111,B10111111,B11110100,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00001110,B01100011,B11001100,B00001101,B10000001,B10110111,B10000110,B00011000,B00111111,B11110110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000111,B01100000,B11101100,B11111101,B10011111,B10110111,B11000110,B00011000,B00111011,B01110110,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111111,B01100000,B01101101,B11111001,B10111111,B00110110,B11100110,B00011000,B00110011,B00110110,B10000000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111111,B01100000,B01101100,B00000001,B10111000,B00110110,B01110110,B00011000,B00110011,B00110110,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000111,B01100000,B11101100,B00000001,B10011100,B00110110,B00111110,B00011000,B00110011,B00110110,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00001110,B01100011,B11001100,B00000001,B10001110,B00110110,B00011110,B00011000,B00110011,B00110110,B11000000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111100,B01111111,B10001100,B00000001,B10000111,B00110110,B00001110,B00011000,B00110011,B00110110,B11111000,B00000000,
+    B00000000,B00000000,B00000000,B00000011,B11111000,B01111111,B00001100,B00000001,B10000011,B10110110,B00000110,B00011000,B00110011,B00110110,B11111100,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111101,B01111111,B11111111,B11111111,B11000000,
+    B00001111,B11110111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11111011,B11110000,
+    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
+    B00011100,B00111000,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00011100,B00111000,
+    B00011100,B00111000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00011100,B00111000,
+    B00111000,B00110000,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00011000,B00011100,
+    B00111000,B00100000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B00010000,B00011100,
+    B00110111,B00111111,B11111001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B10011111,B11111100,
+    B00111111,B10111011,B11111001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011111,B11011101,B11111100,
+    B00111111,B11111001,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011111,B11111100,B11101100,
+    B00111000,B00001000,B00111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00000100,B00011100,
+    B00111000,B00011000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00001100,B00011100,
+    B00011100,B00111000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
+    B00011100,B00111000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00011100,B00111000,
+    B00001111,B00111001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10011100,B11110000,
+    B00001111,B11011111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11101111,B11110000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp12[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000001,B11111100,B00111111,B10000111,B11111100,B11111111,B10011011,B00000011,B11111111,B11001110,B01110011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000001,B11111110,B00111111,B11000111,B11111110,B11111111,B11011011,B10000011,B11111111,B11011111,B11111011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000000,B00000111,B00110001,B11100110,B00000110,B11000000,B11011011,B11000011,B00001100,B00011111,B11111011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000000,B00000011,B10110000,B01110110,B01111110,B11001111,B11011011,B11100011,B00001100,B00011101,B10111011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000001,B11111111,B10110000,B00110110,B11111100,B11011111,B10011011,B01110011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000001,B11111111,B10110000,B00110110,B00000000,B11011100,B00011011,B00111011,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000000,B00000011,B10110000,B01110110,B00000000,B11001110,B00011011,B00011111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000000,B00000111,B00110001,B11100110,B00000000,B11000111,B00011011,B00001111,B00001100,B00011001,B10011011,B01100000,B01100000,B00000000,B00000000,
+    B00000000,B00000001,B11111110,B00111111,B11000110,B00000000,B11000011,B10011011,B00000111,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
+    B00000000,B00000001,B11111100,B00111111,B10000110,B00000000,B11000001,B11011011,B00000011,B00001100,B00011001,B10011011,B01111111,B01111111,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00001101,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000110,B11110000,
+    B00011100,B00001100,B01110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001110,B00000110,B00111000,
+    B00011100,B00011000,B01110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001110,B00001100,B00111000,
+    B00111000,B00001100,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B00000110,B00011100,
+    B00111110,B10010000,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011111,B01001000,B00011100,
+    B00110111,B10111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011011,B11011100,B00001100,
+    B00110011,B11111101,B00011001,B10000000,B00011011,B11111101,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B01111000,B00011001,B11111110,B10001100,
+    B00110000,B00111011,B11011001,B10000000,B00011001,B11111001,B11111111,B11000011,B00011000,B01100000,B00110000,B01100000,B00110000,B00011000,B00011101,B11101100,
+    B00111000,B00010010,B11111001,B11000000,B00011000,B11100001,B11000000,B00000110,B00001100,B01100000,B00110000,B01100000,B00110000,B00011100,B00001001,B01111100,
+    B00111000,B01110000,B00111000,B11110000,B00011000,B01110000,B11100000,B00001100,B00000110,B01100000,B00110000,B01100000,B00110000,B00011100,B00111000,B00011100,
+    B00011100,B00110000,B01110000,B01111111,B11011000,B00111000,B01111111,B11001100,B11111110,B01111111,B10110000,B01100000,B00110000,B00001110,B00011000,B00111000,
+    B00011100,B01110000,B01110000,B00111111,B11011000,B00011100,B00111111,B11011001,B11111111,B01111111,B10110000,B01100000,B00110000,B00001110,B00111000,B00111000,
+    B00001111,B01100001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10110000,B11110000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00000011,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B11000000,
+    B00000000,B11111111,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11111111,B00000000
+  };
+
+  const unsigned char custom_start_bmp14[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00011111,B11000001,B11111100,B00011111,B11110001,B11111111,B00011011,B00000001,B11111111,B11110011,B10011110,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00011111,B11100001,B11111110,B00011111,B11111001,B11111111,B10011011,B10000001,B11111111,B11110111,B11111111,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B01110001,B10001111,B00011000,B00011001,B10000001,B10011011,B11000001,B10000110,B00000111,B11111111,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B00111001,B10000011,B10011001,B11111001,B10011111,B10011011,B11100001,B10000110,B00000111,B01101111,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00011111,B11111001,B10000001,B10011011,B11110001,B10111111,B00011011,B01110001,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00011111,B11111001,B10000001,B10011000,B00000001,B10111000,B00011011,B00111001,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B00111001,B10000001,B10011000,B00000001,B10011100,B00011011,B00011101,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B01110001,B10000011,B10011000,B00000001,B10001110,B00011011,B00001111,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00000000,B01110001,B10001111,B00011000,B00000001,B10001110,B00011011,B00000111,B10000110,B00000110,B01100011,B01101100,B00000110,B00000000,B00000000,
+    B00000000,B00011111,B11100001,B11111110,B00011000,B00000001,B10000111,B00011011,B00000011,B10000110,B00000110,B01100011,B01101111,B11110111,B11110000,B00000000,
+    B00000000,B00011111,B11000001,B11111100,B00011000,B00000001,B10000011,B10011011,B00000001,B10000110,B00000110,B01100011,B01101111,B11110111,B11110000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B00000000,
+    B00000011,B11111111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B01011111,B11111111,B11000000,
+    B00001111,B11000111,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B11100011,B11110000,
+    B00001111,B00000001,B11100000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000111,B10000000,B11110000,
+    B00011111,B00000001,B11110000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00001111,B10000000,B11111000,
+    B00011111,B10000011,B11110000,B00111111,B11011111,B11111000,B00111111,B11000000,B01000000,B01100000,B00110111,B11111111,B00000011,B10001111,B11000001,B11111000,
+    B00111001,B11000111,B00111000,B01111111,B11011111,B11111100,B01111111,B11000000,B11100000,B01100000,B00110111,B11111111,B10000111,B00011100,B11100011,B10011100,
+    B00111000,B11000110,B00111000,B11110000,B00011000,B00001100,B11100000,B00000000,B11100000,B01100000,B00110000,B01100001,B11001110,B00011100,B01100011,B00011100,
+    B00110000,B00111000,B00011001,B11000000,B00011000,B00001101,B11000000,B00000001,B10110000,B01100000,B00110000,B01100000,B11111100,B00011000,B00011100,B00001100
+  };
+
+  const unsigned char custom_start_bmp15[] PROGMEM = {
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000111,B11111000,B00111111,B11100001,B11111111,B11000111,B11111111,B00110011,B00000001,B11111111,B11111100,B11110011,B11001110,B11000000,B00110000,B00000000,
+    B00000111,B11111100,B00111111,B11110001,B11111111,B11110111,B11111111,B10110011,B10000001,B11111111,B11111101,B11111111,B11101110,B11000000,B00110000,B00000000,
+    B00000000,B00001111,B00111000,B11111001,B11000000,B01110110,B00000011,B10110011,B11000001,B11000001,B10000001,B11111111,B11101110,B11000000,B00110000,B00000000,
+    B00000000,B00001111,B00111000,B11111001,B11000000,B01110110,B00000011,B10110011,B11100001,B11000001,B10000001,B11111111,B11101110,B11000000,B00110000,B00000000,
+    B00000000,B00000111,B10111000,B00011101,B11001111,B11110110,B01111111,B10110011,B11110001,B11000001,B10000001,B11101100,B11101110,B11000000,B00110000,B00000000,
+    B00000111,B11111111,B10111000,B00001101,B11011111,B11000110,B11111111,B00110011,B01111001,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
+    B00000111,B11111111,B10111000,B00001101,B11000000,B00000110,B11110000,B00110011,B00011101,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
+    B00000000,B00000111,B10111000,B00011101,B11000000,B00000110,B00111000,B00110011,B00001111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
+    B00000000,B00001111,B00111000,B11111001,B11000000,B00000110,B00011100,B00110011,B00000111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
+    B00000000,B00001111,B00111000,B11111001,B11000000,B00000110,B00011100,B00110011,B00000111,B11000001,B10000001,B11001100,B01101110,B11000000,B00110000,B00000000,
+    B00000111,B11111100,B00111111,B11110001,B11000000,B00000110,B00001111,B00110011,B00000011,B11000001,B10000001,B11001100,B01101110,B11111111,B10111111,B11000000,
+    B00000111,B11111000,B00111111,B11100001,B11000000,B00000110,B00000111,B10110011,B00000001,B11000001,B10000001,B11001100,B01101110,B11111111,B10111111,B11000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+  };
+
+  const unsigned char custom_start_bmp16[] PROGMEM = {
+    B01111111,B11100001,B11111111,B10000111,B11111111,B00011111,B11111100,B01110011,B10000001,B11111111,B11111110,B00111110,B00111110,B00111001,B11000000,B11100000,
+    B01111111,B11110001,B11111111,B11000111,B11111111,B10011111,B11111110,B01110011,B10000001,B11111111,B11111110,B01111111,B11111111,B00111001,B11000000,B11100000,
+    B00000000,B11111001,B11000011,B11100111,B11111111,B10011111,B11111110,B01110011,B11000001,B11111111,B11111110,B01111111,B11111111,B00111001,B11000000,B11100000,
+    B00000000,B01111001,B11000001,B11100111,B00000001,B10011100,B00000110,B01110011,B11100001,B11000001,B11000000,B01111111,B11111111,B00111001,B11000000,B11100000,
+    B00000000,B01111001,B11000000,B11100111,B00000001,B10011100,B00000110,B01110011,B11110001,B11000001,B11000000,B01111001,B11001111,B00111001,B11000000,B11100000,
+    B01111111,B11111001,B11000000,B11100111,B00111111,B10011100,B11111110,B01110011,B11111001,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
+    B01111111,B11111001,B11000000,B11100111,B01111111,B10011101,B11111110,B01110011,B10111101,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
+    B01111111,B11111001,B11000000,B11100111,B01111111,B00011101,B11111100,B01110011,B10011111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
+    B00000000,B01111001,B11000000,B11100111,B00000000,B00011100,B11110000,B01110011,B10001111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
+    B00000000,B01111001,B11000001,B11100111,B00000000,B00011100,B01111000,B01110011,B10000111,B11000001,B11000000,B01110001,B11000111,B00111001,B11000000,B11100000,
+    B00000000,B11111001,B11000011,B11100111,B00000000,B00011100,B00111100,B01110011,B10000011,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
+    B01111111,B11110001,B11111111,B11000111,B00000000,B00011100,B00011110,B01110011,B10000001,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
+    B01111111,B11100001,B11111111,B10000111,B00000000,B00011100,B00001110,B01110011,B10000001,B11000001,B11000000,B01110001,B11000111,B00111001,B11111100,B11111110,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,
+    B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000,B00000000
+  };
+
+  #define CUSTOM_BOOTSCREEN_TIME_PER_FRAME
+
+  static const boot_frame_t boot_frame_0  PROGMEM = { custom_start_bmp1,   200 };
+  static const boot_frame_t boot_frame_1  PROGMEM = { custom_start_bmp2,   150 };
+  static const boot_frame_t boot_frame_2  PROGMEM = { custom_start_bmp3,   150 };
+  static const boot_frame_t boot_frame_3  PROGMEM = { custom_start_bmp4,   150 };
+  static const boot_frame_t boot_frame_4  PROGMEM = { custom_start_bmp5,   150 };
+  static const boot_frame_t boot_frame_5  PROGMEM = { custom_start_bmp6,   150 };
+  static const boot_frame_t boot_frame_6  PROGMEM = { custom_start_bmp7,   150 };
+  static const boot_frame_t boot_frame_7  PROGMEM = { custom_start_bmp8,   150 };
+  static const boot_frame_t boot_frame_8  PROGMEM = { custom_start_bmp9,   150 };
+  static const boot_frame_t boot_frame_9  PROGMEM = { custom_start_bmp10,  150 };
+  static const boot_frame_t boot_frame_10 PROGMEM = { custom_start_bmp11,  150 };
+  static const boot_frame_t boot_frame_11 PROGMEM = { custom_start_bmp12,  150 };
+  static const boot_frame_t boot_frame_12 PROGMEM = { custom_start_bmp,   1000 };
+  static const boot_frame_t boot_frame_13 PROGMEM = { custom_start_bmp14,  150 };
+  static const boot_frame_t boot_frame_14 PROGMEM = { custom_start_bmp15,  150 };
+  static const boot_frame_t boot_frame_15 PROGMEM = { custom_start_bmp16, 1000 };
+
+  static const boot_frame_t * const custom_bootscreen_animation[] PROGMEM = {
+    &boot_frame_0, &boot_frame_1, &boot_frame_2, &boot_frame_3, &boot_frame_4,
+    &boot_frame_5, &boot_frame_6, &boot_frame_7, &boot_frame_8, &boot_frame_9,
+    &boot_frame_10, &boot_frame_11, &boot_frame_12, &boot_frame_13, &boot_frame_14, &boot_frame_15
+  };
+
+#endif
```

## Marlin/_Statusscreen.h

```diff
diff --git a/Marlin/_Statusscreen.h b/Marlin/_Statusscreen.h
new file mode 100644
index 0000000000..97c0e30023
--- /dev/null
+++ b/Marlin/_Statusscreen.h
@@ -0,0 +1,55 @@
+/**
+ * Marlin 3D Printer Firmware
+ * Copyright (c) 2021 MarlinFirmware [https://github.com/MarlinFirmware/Marlin]
+ *
+ * Based on Sprinter and grbl.
+ * Copyright (c) 2011 Camiel Gubbels / Erik van der Zalm
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+/**
+ * Made with Marlin Bitmap Converter
+ * https://marlinfw.org/tools/u8glib/converter.html
+ *
+ * This bitmap from 56x19 C/C++ data
+ */
+#pragma once
+
+#define CONFIG_EXAMPLES_DIR "Creality/CR-30 PrintMill"
+
+#define STATUS_SCREEN_X 64
+#define STATUS_LOGO_WIDTH 48
+
+const unsigned char status_logo_bmp[] PROGMEM = {
+  B00000000,B00000000,B00111001,B11000000,B00000000,B00000000,
+  B00000000,B00000000,B01000101,B00100000,B00000000,B00000000,
+  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
+  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
+  B00000000,B00000000,B00011001,B00010000,B00000000,B00000000,
+  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
+  B00000000,B00000000,B00000101,B00010000,B00000000,B00000000,
+  B00000000,B00000000,B01000101,B00100000,B00000000,B00000000,
+  B00000000,B00000000,B00111001,B11000000,B00000000,B00000000,
+  B00111100,B00000000,B00000000,B00011000,B11001001,B10011000,
+  B00100010,B00000010,B00000000,B10011000,B11000000,B10001000,
+  B00100010,B00000000,B00000000,B10011000,B11000000,B10001000,
+  B00100010,B10110110,B01011001,B11010101,B01011000,B10001000,
+  B00111100,B11000010,B01100100,B10010101,B01001000,B10001000,
+  B00100000,B10000010,B01000100,B10010101,B01001000,B10001000,
+  B00100000,B10000010,B01000100,B10010010,B01001000,B10001000,
+  B00100000,B10000010,B01000100,B10010010,B01001000,B10001000,
+  B00100000,B10000111,B01000100,B01010010,B01011101,B11011100
+};
```

## README.md

```diff
diff --git a/README.md b/README.md
index 72b354d4fe..91d7ab8ce0 100644
--- a/README.md
+++ b/README.md
@@ -1,5 +1,10 @@
+# Mimic CR-30 Users at time of pull
+
+upstream fw commit -- `73b8320e9caac23873169c8e10344f2f8060b389`
+upstream cfg commit - `0a8dfe5594ca981428c9adf76068e3cbe425c3ba`
+
 # Marlin 3D Printer Firmware
 
 ![GitHub](https://img.shields.io/github/license/marlinfirmware/marlin.svg)
 ![GitHub contributors](https://img.shields.io/github/contributors/marlinfirmware/marlin.svg)
 ![GitHub Release Date](https://img.shields.io/github/release-date/marlinfirmware/marlin.svg)
-- 
2.40.1.windows.1
```
