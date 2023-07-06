# Revert some CR30-Users modifications to `v2.0.9.3`

These patches carry the recommended reversions ❌ from [pull/1](https://github.com/wireddown/GCode-Machine-Configurations/pull/1). The remaining modifications to retain are in this [patch set](./002b-Selected-CR30-Users-modifcations-to-v2.0.9.3.patch.md).

## Cover

```
From 757f1d9237761d95dbad0b1f4ba1aa152e2ac6eb Mon Sep 17 00:00:00 2001
From: Down to the Wire <8404598+wireddown@users.noreply.github.com>
Date: Thu, 8 Jun 2023 20:18:53 -0700
Subject: Revert some CR30-Users changes

- Some are for safety or use cases
- Some won't build
- Some are only formatting or ordering
- Some should be bunded with rework instructions
- See https://github.com/wireddown/GCode-Machine-Configurations/pull/1 for discussion and details

---
 Marlin/Configuration.h                        | 54 +++++++++----------
 Marlin/Configuration_adv.h                    | 22 ++++----
 Marlin/src/inc/Version.h                      |  2 +-
 Marlin/src/lcd/menu/menu_motion.cpp           | 15 ------
 Marlin/src/module/planner.cpp                 | 36 +------------
 Marlin/src/module/stepper.cpp                 |  8 +--
 Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h | 33 ++----------
 7 files changed, 43 insertions(+), 127 deletions(-)
```

## Marlin/Configuration.h

```diff
diff --git a/Marlin/Configuration.h b/Marlin/Configuration.h
index 54d03546e7..d6202b02db 100644
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
@@ -126,11 +128,11 @@
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
@@ -553,18 +555,18 @@
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
+#define HEATER_0_MAXTEMP 255
+#define HEATER_1_MAXTEMP 255
+#define HEATER_2_MAXTEMP 255
+#define HEATER_3_MAXTEMP 255
+#define HEATER_4_MAXTEMP 255
+#define HEATER_5_MAXTEMP 255
+#define HEATER_6_MAXTEMP 255
+#define HEATER_7_MAXTEMP 255
 #define BED_MAXTEMP      125
 #define CHAMBER_MAXTEMP  60
 
 /**
  * Thermal Overshoot
@@ -758,23 +760,18 @@
 //#define MARKFORGED_XY  // MarkForged. See https://reprap.org/forum/read.php?152,504042
 //#define MARKFORGED_YX
 
 // Enable for a belt style printer with endless "Z" motion
 #define BELTPRINTER
-#if ENABLED(BELTPRINTER)
-  //#define BELT_KINEMATICS_DEV
-  #define BED_TO_TRUSS_ANGLE 45
-#endif
 
 // Enable for Polargraph Kinematics
 //#define POLARGRAPH
 #if ENABLED(POLARGRAPH)
   #define POLARGRAPH_MAX_BELT_LEN 1035.0
   #define POLAR_SEGMENTS_PER_SECOND 5
 #endif
 
-
 //===========================================================================
 //============================== Endstop Settings ===========================
 //===========================================================================
 
 // @section homing
@@ -844,11 +841,11 @@
 #define Y_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define Z_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define I_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define J_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
 #define K_MAX_ENDSTOP_INVERTING false // Set to true to invert the logic of the endstop.
-#define Z_MIN_PROBE_ENDSTOP_INVERTING true // Set to true to invert the logic of the probe.
+#define Z_MIN_PROBE_ENDSTOP_INVERTING true  // Set to true to invert the logic of the probe.
 
 /**
  * Stepper Drivers
  *
  * These settings allow Marlin to tune stepper driver timing and enable advanced options for
@@ -979,26 +976,26 @@
  * When changing speed and direction, if the difference is less than the
  * value set here, it may happen instantaneously.
  */
 #define CLASSIC_JERK
 #if ENABLED(CLASSIC_JERK)
-  #define DEFAULT_XJERK 6.0
-  #define DEFAULT_YJERK 6.0
+  #define DEFAULT_XJERK  6.0
+  #define DEFAULT_YJERK  6.0
   #define DEFAULT_ZJERK  0.4
   //#define DEFAULT_IJERK  0.3
   //#define DEFAULT_JJERK  0.3
   //#define DEFAULT_KJERK  0.3
 
   //#define TRAVEL_EXTRA_XYJERK 0.0     // Additional jerk allowance for all travel moves
 
   //#define LIMITED_JERK_EDITING        // Limit edit via M205 or LCD to DEFAULT_aJERK * 2
   #if ENABLED(LIMITED_JERK_EDITING)
     #define MAX_JERK_EDIT_VALUES { 20, 20, 0.6, 10 } // ...or, set your own edit limits
   #endif
 #endif
 
-#define DEFAULT_EJERK    5.0  // May be used by Linear Advance
+#define DEFAULT_EJERK   10.0  // May be used by Linear Advance build fix PR @ https://github.com/MarlinFirmware/Configurations/pull/737
 
 /**
  * Junction Deviation Factor
  *
  * See:
@@ -1380,13 +1377,13 @@
 //#define J_HOME_DIR -1
 //#define K_HOME_DIR -1
 
 // @section machine
 
-// The size of the print bed
+// The size of the printable area
 #define X_BED_SIZE 220
 #define Y_BED_SIZE 240
 
 // Travel limits (mm) after homing, corresponding to endstop positions.
 #define X_MIN_POS 0
 #define Y_MIN_POS 0
 #define Z_MIN_POS 0
@@ -1871,16 +1868,16 @@
 // Preheat Constants - Up to 5 are supported without changes
 //
 #define PREHEAT_1_LABEL       "PLA"
 #define PREHEAT_1_TEMP_HOTEND 185
 #define PREHEAT_1_TEMP_BED     55
-#define PREHEAT_1_TEMP_CHAMBER 35
+#define PREHEAT_1_TEMP_CHAMBER 30
 #define PREHEAT_1_FAN_SPEED     0 // Value from 0 to 255
 
 #define PREHEAT_2_LABEL       "ABS"
 #define PREHEAT_2_TEMP_HOTEND 240
-#define PREHEAT_2_TEMP_BED    70
+#define PREHEAT_2_TEMP_BED     70
 #define PREHEAT_2_TEMP_CHAMBER 35
 #define PREHEAT_2_FAN_SPEED     0 // Value from 0 to 255
 
 /**
  * Nozzle Park
@@ -2071,11 +2068,10 @@
  *
  * :{ 'en':'English', 'an':'Aragonese', 'bg':'Bulgarian', 'ca':'Catalan', 'cz':'Czech', 'da':'Danish', 'de':'German', 'el':'Greek (Greece)', 'el_CY':'Greek (Cyprus)', 'es':'Spanish', 'eu':'Basque-Euskera', 'fi':'Finnish', 'fr':'French', 'gl':'Galician', 'hr':'Croatian', 'hu':'Hungarian', 'it':'Italian', 'jp_kana':'Japanese', 'ko_KR':'Korean (South Korea)', 'nl':'Dutch', 'pl':'Polish', 'pt':'Portuguese', 'pt_br':'Portuguese (Brazilian)', 'ro':'Romanian', 'ru':'Russian', 'sk':'Slovak', 'sv':'Swedish', 'tr':'Turkish', 'uk':'Ukrainian', 'vi':'Vietnamese', 'zh_CN':'Chinese (Simplified)', 'zh_TW':'Chinese (Traditional)' }
  */
 #define LCD_LANGUAGE en
 
-
 /**
  * LCD Character Set
  *
  * Note: This option is NOT applicable to Graphical Displays.
  *
@@ -2478,10 +2474,15 @@
 // This is RAMPS-compatible using a single 10-pin connector.
 // (For CR-10 owners who want to replace the Melzi Creality board but retain the display)
 //
 #define CR10_STOCKDISPLAY
 
+//
+// Creality V4.2.5 display. Creality board but retain the display.
+//
+#define RET6_12864_LCD
+
 //
 // Ender-2 OEM display, a variant of the MKS_MINI_12864
 //
 //#define ENDER2_STOCKDISPLAY
 
@@ -2796,15 +2797,10 @@
 //#define DWIN_CREALITY_LCD_ENHANCED  // Enhanced UI
 //#define DWIN_CREALITY_LCD_JYERSUI   // Jyers UI by Jacob Myers
 //#define DWIN_MARLINUI_PORTRAIT      // MarlinUI (portrait orientation)
 //#define DWIN_MARLINUI_LANDSCAPE     // MarlinUI (landscape orientation)
 
-//
-// Creality V4.2.5 display. Creality board but retain the display.
-//
-#define RET6_12864_LCD
-
 //
 // Touch Screen Settings
 //
 //#define TOUCH_SCREEN
 #if ENABLED(TOUCH_SCREEN)
```

## Marlin/Configuration_adv.h

```diff
diff --git a/Marlin/Configuration_adv.h b/Marlin/Configuration_adv.h
index 01b6d09718..7c80a830b0 100644
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
@@ -1948,11 +1950,11 @@
   //#define BABYSTEP_WITHOUT_HOMING
   #define BABYSTEP_ALWAYS_AVAILABLE         // Allow babystepping at all times (not just during movement).
   #define BABYSTEP_XY                       // Also enable X/Y Babystepping. Not supported on DELTA!
   #define BABYSTEP_INVERT_Z false           // Change if Z babysteps should go the other way
   //#define BABYSTEP_MILLIMETER_UNITS       // Specify BABYSTEP_MULTIPLICATOR_(XY|Z) in mm instead of micro-steps
-  #define BABYSTEP_MULTIPLICATOR_Z  11       // (steps or mm) Steps or millimeter distance for each Z babystep
+  #define BABYSTEP_MULTIPLICATOR_Z  11      // (steps or mm) Steps or millimeter distance for each Z babystep
   #define BABYSTEP_MULTIPLICATOR_XY 2       // (steps or mm) Steps or millimeter distance for each XY babystep
 
   //#define DOUBLECLICK_FOR_Z_BABYSTEPPING  // Double-click on the Status Screen for Z Babystepping.
   #if ENABLED(DOUBLECLICK_FOR_Z_BABYSTEPPING)
     #define DOUBLECLICK_MAX_INTERVAL 1250   // Maximum interval between clicks, in milliseconds.
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
 
@@ -3096,11 +3098,11 @@
 
   /**
    * Enable M122 debugging command for TMC stepper drivers.
    * M122 S0/1 will enable continuous reporting.
    */
-  #define TMC_DEBUG
+  //#define TMC_DEBUG
 
   /**
    * You can set your own advanced settings by filling in predefined functions.
    * A list of available functions can be found on the library github page
    * https://github.com/teemuatlut/TMCStepper
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

## Marlin/src/inc/Version.h

```diff
diff --git a/Marlin/src/inc/Version.h b/Marlin/src/inc/Version.h
index 17755de348..767e3e9a8e 100644
--- a/Marlin/src/inc/Version.h
+++ b/Marlin/src/inc/Version.h
@@ -40,11 +40,11 @@
  * The STRING_DISTRIBUTION_DATE represents when the binary file was built,
  * here we define this default string as the date where the latest release
  * version was tagged.
  */
 #ifndef STRING_DISTRIBUTION_DATE
-  #define STRING_DISTRIBUTION_DATE "2021-09-03"
+  #define STRING_DISTRIBUTION_DATE "2021-12-25"
 #endif
 
 /**
  * Minimum Configuration.h and Configuration_adv.h file versions.
  * Set based on the release version number. Used to catch an attempt to use
```

## Marlin/src/lcd/menu/menu_motion.cpp

```diff
diff --git a/Marlin/src/lcd/menu/menu_motion.cpp b/Marlin/src/lcd/menu/menu_motion.cpp
index 1092bfdad3..13b0835650 100644
--- a/Marlin/src/lcd/menu/menu_motion.cpp
+++ b/Marlin/src/lcd/menu/menu_motion.cpp
@@ -105,17 +105,10 @@ void lcd_move_x() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_X), X_AXIS); }
 #endif
 #if LINEAR_AXES >= 6
   void lcd_move_k() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_K), K_AXIS); }
 #endif
 
-#if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-  // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
-  // It might be implemented by doing the math to move Y and Z in combination
-  // to arrive at the correct C position.
-  void lcd_move_c() { _lcd_move_xyz(GET_TEXT(MSG_MOVE_C), Z_HEAD); }
-#endif
-
 #if E_MANUAL
 
   static void lcd_move_e(TERN_(MULTI_E_MANUAL, const int8_t eindex=active_extruder)) {
     if (ui.use_click()) return ui.goto_previous_screen_no_defer();
     if (ui.encoderPosition) {
@@ -172,14 +165,10 @@ void _menu_move_distance(const AxisEnum axis, const screenFunc_t func, const int
   if (LCD_HEIGHT >= 4) {
     switch (axis) {
       case X_AXIS: STATIC_ITEM(MSG_MOVE_X, SS_DEFAULT|SS_INVERT); break;
       case Y_AXIS: STATIC_ITEM(MSG_MOVE_Y, SS_DEFAULT|SS_INVERT); break;
       case Z_AXIS: STATIC_ITEM(MSG_MOVE_Z, SS_DEFAULT|SS_INVERT); break;
-      #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-        // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
-        case Z_HEAD: STATIC_ITEM(MSG_MOVE_C, SS_DEFAULT|SS_INVERT); break;
-      #endif
       default:
         TERN_(MANUAL_E_MOVES_RELATIVE, manual_move_e_origin = current_position.e);
         STATIC_ITEM(MSG_MOVE_E, SS_DEFAULT|SS_INVERT);
         break;
     }
@@ -266,14 +255,10 @@ void menu_move() {
     #endif
 
     #if HAS_Z_AXIS
       SUBMENU(MSG_MOVE_Z, []{ _menu_move_distance(Z_AXIS, lcd_move_z); });
     #endif
-    #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-      // TODO: Implement C-only movement with 'Z_HEAD' as a proxy
-      SUBMENU(MSG_MOVE_C, []{ _menu_move_distance(Z_AXIS, lcd_move_c); });
-    #endif
     #if LINEAR_AXES >= 4
       SUBMENU(MSG_MOVE_I, []{ _menu_move_distance(I_AXIS, lcd_move_i); });
     #endif
     #if LINEAR_AXES >= 5
       SUBMENU(MSG_MOVE_J, []{ _menu_move_distance(J_AXIS, lcd_move_j); });
```

## Marlin/src/module/planner.cpp

```diff
diff --git a/Marlin/src/module/planner.cpp b/Marlin/src/module/planner.cpp
index 378aeac196..45ccdd1702 100644
--- a/Marlin/src/module/planner.cpp
+++ b/Marlin/src/module/planner.cpp
@@ -1764,29 +1764,11 @@ float Planner::get_axis_position_mm(const AxisEnum axis) {
 
     axis_steps = stepper.position(axis);
 
   #endif
 
-  float axis_mm;
-
-  #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-
-    axis_mm = axis_steps * mm_per_step[axis];
-    switch (axis) {
-      case CORE_AXIS_2:         // Y is offset in proportion to (Z - 0)
-        axis_mm += C_TO_B_OFFS(stepper.position(NORMAL_AXIS) * steps_to_mm[NORMAL_AXIS]);
-      case CORE_AXIS_1: break;
-      default: C_TO_Z(axis_mm); // Z is some fraction of C
-    }
-
-  #else
-
-    axis_mm = axis_steps * mm_per_step[axis];
-
-  #endif
-
-  return axis_mm;
+  return axis_steps * mm_per_step[axis];
 }
 
 /**
  * Block until the planner is finished processing
  */
@@ -2999,43 +2981,27 @@ bool Planner::buffer_segment(const abce_pos_t &abce
 
   stepper.wake_up();
   return true;
 } // buffer_segment()
 
-#if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-  // Each 1mm of "Z" motion requires a slightly greater amount of C motion...
-  constexpr float Z_TO_C(const float z) { return z * (1.0f / sin(RADIANS(BED_TO_TRUSS_ANGLE))); }
-  // As the Belt (C) moves, Z is adjusted. This computes that ratio.
-  // Sine tells us the number of hypotenuse mm for each base mm
-  constexpr float C_TO_Z(const float c) { return c * sin(RADIANS(BED_TO_TRUSS_ANGLE)); }
-  // Positive "C" motion results in negative "B" motion
-  constexpr float C_TO_B_OFFS(const float c) { return c * cos(RADIANS(BED_TO_TRUSS_ANGLE)); }
-#endif
-
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
 
-  #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-    // Belt Printer uses Z to modify Y, and moves C farther according to the angle
-    machine.b += C_TO_Z(rz);  // The B position is directly affected by the Z axis
-    machine.c = Z_TO_C(rz);
-  #endif
-
   #if IS_KINEMATIC
 
     #if HAS_JUNCTION_DEVIATION
       const xyze_pos_t cart_dist_mm = LOGICAL_AXIS_ARRAY(
         cart.e - position_cart.e,
```

## Marlin/src/module/stepper.cpp

```diff
diff --git a/Marlin/src/module/stepper.cpp b/Marlin/src/module/stepper.cpp
index 4f03a0b1e9..c100051f98 100644
--- a/Marlin/src/module/stepper.cpp
+++ b/Marlin/src/module/stepper.cpp
@@ -2804,17 +2804,11 @@ void Stepper::init() {
 void Stepper::_set_position(const abce_long_t &spos) {
   #if ANY(IS_CORE, MARKFORGED_XY, MARKFORGED_YX)
     #if CORE_IS_XY
       // corexy positioning
       // these equations follow the form of the dA and dB equations on https://www.corexy.com/theory.html
-      #if BOTH(BELTPRINTER, BELT_KINEMATICS_DEV)
-        // TODO: Incorporate C into B. This may be done ahead of this method
-        // and then this placeholder can be removed.
-        count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
-      #else
-        count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
-      #endif
+      count_position.set(spos.a + spos.b, CORESIGN(spos.a - spos.b), spos.c);
     #elif CORE_IS_XZ
       // corexz planning
       count_position.set(spos.a + spos.c, spos.b, CORESIGN(spos.a - spos.c));
     #elif CORE_IS_YZ
       // coreyz planning
```

## Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h

```diff
diff --git a/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h b/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
index 9974f5e33a..02dd0a6113 100644
--- a/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
+++ b/Marlin/src/pins/stm32f1/pins_CREALITY_V4210.h
@@ -36,10 +36,12 @@
 #endif
 #ifndef DEFAULT_MACHINE_NAME
   #define DEFAULT_MACHINE_NAME "3DPrintMill"
 #endif
 
+#define BOARD_NO_NATIVE_USB
+
 //
 // EEPROM
 //
 #if NO_EEPROM_SELECTED
   // FLASH
@@ -71,20 +73,20 @@
 //
 // Servos
 //
 #if !HAS_TMC_UART
   #define SERVO0_PIN                          PB0   // BLTouch OUT
-  #define Z_MIN_PROBE_PIN                     PB1   // BLTouch IN
 #endif
 
 //
 // Limit Switches
 //
 #define X_STOP_PIN                          PA3
 #define Y_STOP_PIN                          PA7
 #define Z_STOP_PIN                          PA5
 
+#define Z_MIN_PROBE_PIN                     PA5   // BLTouch IN
 
 //
 // Filament Runout Sensor
 //
 #ifndef FIL_RUNOUT_PIN
@@ -144,23 +146,10 @@
 #define HEATER_BED_PIN                      PA1   // HOT BED
 
 #define FAN_PIN                             PA2   // FAN
 #define FAN_SOFT_PWM
 
-//#ifndef FAN1_PIN
-//  #define FAN1_PIN                         PC0
-//#endif
-
-//#ifndef FAN2_PIN
-//  #define FAN2_PIN                         PC1
-//#endif
-
-#ifndef CASE_LIGHT_PIN
-  #define CASE_LIGHT_PIN                     PC14   // LED driving pin
-#endif
-
-
 //
 // SD Card
 //
 #define SD_DETECT_PIN                       PC7
 #define SDCARD_CONNECTION                ONBOARD
@@ -249,21 +238,5 @@
   #define BTN_EN2                           PA4
 
   #define BEEPER_PIN                        PA5
 
 #endif
-
-#if HAS_TMC_UART
-  #define X_SERIAL_TX_PIN                   PB0
-  #define X_SERIAL_RX_PIN                   PB0
-
-  #define Y_SERIAL_TX_PIN                   PB1
-  #define Y_SERIAL_RX_PIN                   PB1
-
-  #define Z_SERIAL_TX_PIN                   PA13
-  #define Z_SERIAL_RX_PIN                   PA13
-
-  #define E0_SERIAL_TX_PIN                  PA14
-  #define E0_SERIAL_RX_PIN                  PA14
-
-  #define TMC_BAUD_RATE                    19200
-#endif
-- 
2.40.1.windows.1

