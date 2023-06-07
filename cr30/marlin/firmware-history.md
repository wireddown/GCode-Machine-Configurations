# Beltdrive firmware history

## Public

From most active to least active:

1. [Marlin](https://github.com/MarlinFirmware/Marlin)
   - Official support begins at [version **2.0.9.2**](https://github.com/MarlinFirmware/Marlin/releases/tag/2.0.9.2) on 3 Oct 2021
     - Mainboard added [on 3 Jan 2021](https://github.com/MarlinFirmware/Marlin/pull/20647)
     - Printer supported [on 31 Aug 2021](https://github.com/MarlinFirmware/Marlin/pull/22669)
     - Also added to Config repo [on 29 Aug 2021](https://github.com/MarlinFirmware/Configurations/commit/3afe7cd083007dd73789b006e5b2d21e62b5fd0d)
   - Has `M808` _(repeat markers)_ [since 26 Nov 2020](https://github.com/MarlinFirmware/Marlin/pull/20084)
1. [CR-30 Users](https://github.com/CR30-Users/Marlin-CR30)
   - CR30-Users [first introduced NAK 3D code](https://github.com/CR30-Users/Marlin-CR30/commit/c93a97279eadbb5fb3757a7c7e7696690b90b328) at `c93a972` on 12 Apr 2021
     - Message says taken from [NAK 3D `67b5507`](https://github.com/NAK3DDesigns/CR-30-Firmware/commit/67b5507495e8654373dcab4a65e7a53a726939eb)
     - Only difference after introducing the code is enabling a custom version.h
   - Most recent [pull from upstream](https://github.com/CR30-Users/Marlin-CR30/commit/4c8cd975d69b956d9a0ad9d7142d04a1ff1d07e6) is Jan 2022 version **2.0.9.3**
   - [21 files changed](https://github.com/MarlinFirmware/Marlin/compare/2.0.x...CR30-Users:Marlin-CR30:2.0.x_cr30) from upstream
   - Firmware files with changes
     - `Version.h`
     - `inc/Version.h`
     - `_Bootscreen.h`
     - `_Statusscreen.h`
     - `Configuration.h` and `Configuration_adv.h`
       - 1: https://github.com/CR30-Users/Marlin-CR30/commit/3a547b52aac833fecebf07c7c22b241fc6ab5cbf
       - 2: https://github.com/CR30-Users/Marlin-CR30/commit/87145b1126dff0acef8f3ececce3c25909510c04
       - 3: https://github.com/CR30-Users/Marlin-CR30/commit/3ded6c5b104bd5e93b19e031d435034708621fcf
       - 4: https://github.com/CR30-Users/Marlin-CR30/commit/ab69ec8337d9f7b3d401255f61bb068a6be9c5c9
     - `lcd/buttons.h`
       - https://github.com/MarlinFirmware/Marlin/pull/23388
     - `lcd/dogm/dogm_Bootscreen.h`
       - From NAK 3D Designs
       - Adds a large and small stillframe boot screen
         - The small stillframe is compiled into the firmware with `BOOT_MARLIN_LOGO_SMALL`
         - The large stillframe is compiled into the firmware otherwise
     - `lcd/e3v2/enhanced/dwin.cpp`
       - https://github.com/MarlinFirmware/Marlin/pull/23387
     - `lcd/menu/menu_motion.cpp`
       - From NAK 3D Designs
       - These changes don't compile with `BELT_KINEMATICS_DEV`
         ```
         Marlin\src\lcd\menu\menu_motion.cpp:115:46: error: 'MSG_MOVE_C' is not a member of 'Language_en'
         ```
     - `module/planner.cpp`
       - From NAK 3D Designs
       - These changes don't compile with `BELT_KINEMATICS_DEV`
         ```
         Marlin\src\module\planner.cpp:1665:20: error: 'C_TO_B_OFFS' was not declared in this scope
         Marlin\src\module\planner.cpp:1667:16: error: 'C_TO_Z' was not declared in this scope
         ```
     - `module/stepper.cpp`
       - From NAK 3D Designs
       - Changes are a stub and result in no behavior changes with `BELT_KINEMATICS_DEV`
     - `pins/stm32f1/pins_CREALITY_V4210.h`
       - https://github.com/CR30-Users/Marlin-CR30/commit/87145b1126dff0acef8f3ececce3c25909510c04
   - [1250 upstream files changed](https://github.com/CR30-Users/Marlin-CR30/compare/2.0.x_cr30...MarlinFirmware:Marlin:2.0.x) and haven't been brought into the CR30-Users fork
1. [NAK 3D Designs](https://github.com/NAK3DDesigns/CR-30-Firmware)
   - Walkthrough video on [YouTube](https://www.youtube.com/watch?v=3c2PW5GNZrE)
   - Allows a negative Y-axis offset
   - Includes `M808` loop command
   - Commit history is squashed, cannot correlate to upstream
     - Files [added to git](https://github.com/NAK3DDesigns/CR-30-Firmware/commit/67b5507495e8654373dcab4a65e7a53a726939eb) on 8 Mar 2021
     - `STRING_DISTRIBUTION_DATE "2021-01-01"`
     - `MARLIN_HEX_VERSION 020008`
     - Seems to match upstream commit [`4402a05`](https://github.com/MarlinFirmware/Marlin/blob/4402a0578a9fa5c9743eb5774224ce206c618ce9/Marlin/src/inc/Version.h)
       - Nearest-neighbor in configurations is [`98ddd0ec`](https://github.com/MarlinFirmware/Configurations/tree/98ddd0ec8305f686efc1cd902a34465883d3422c)
   - Compared with upstream
     - Adds `BED_TO_TRUSS_ANGLE`
     - Adds `BELT_KINEMATICS_DEV`
     - Adds linear advance
   - Does not compile with `BELT_KINEMATICS_DEV`
     ```
     Marlin\src\lcd\menu\menu_motion.cpp:115:46: error: 'MSG_MOVE_C' is not a member of 'Language_en'
     Marlin\src\module\planner.cpp:1665:20: error: 'C_TO_B_OFFS' was not declared in this scope
     Marlin\src\module\planner.cpp:1667:16: error: 'C_TO_Z' was not declared in this scope
     ```
1. [CrealityOfficial](https://github.com/CrealityOfficial/cr-30)
   - One commit of Marlin with CR-30 support [on 15 Mar 2022](https://github.com/CrealityOfficial/cr-30/commit/a916aa2815684ec39e166340b85808e70dfe7fec)
   - Git history squashed
     - `inc/Version.h` has `SHORT_BUILD_VERSION "2.0.6.3"`
     - Marlin official has no release or tag for this version, the closest is `2.0.6.1`
     - When diffing this tree against Creality's fork, there are **257** changed files
     - For tag `2.0.6` on 26 Jul 2020, there are **36** changed files
     - It seems like Creality was guessing a version that would include support for the CR-30
     - Or maybe they chose a version number that wouldn't be used so that they could have a 'signature version'
   - Added repeat markers
   - Added pause print on SD timeout

## Identify changes to keep

Some changes don't compile, and some might have been for prototype models. Remove the changes that cannot be built and tested, and re-evaluate the remaining changes for safety and recency.

### Initial introduction of CR-30 firmware

- **Compare:** CR30-Users `cr-30-base`
- **Base:** Nearest-neighbor official Marlin firmware with co-temporal Offical Marlin CR-30 config files
  - Which upstream commit is the parent?
    ```
    $ git log --oneline -n3
    c93a97279e (HEAD, tag: cr-30-base) Initial CR-30 firmware
    b9d9e74f2c [cron] Bump distribution date (2021-01-02)
    4402a0578a Fix CHAMBER_FAN_MODE 0 build (#20621)
    ```
  - Parent [upstream firmware commit](https://github.com/MarlinFirmware/Marlin/commit/b9d9e74f2cfce8e53b315e72366dc49c5550c4c6) is `b9d9e74`
  - Corresponding [upstream config commit](https://github.com/MarlinFirmware/Configurations/commit/0a8dfe5594ca981428c9adf76068e3cbe425c3ba) is `0a8dfe5`
- **Diff**
  - [Available on GitHub](https://github.com/CR30-Users/Marlin-CR30/commit/c93a97279eadbb5fb3757a7c7e7696690b90b328)
    - Some of these changes were brought into upstream (pull requests linked above)
    - Some were not, like the side-band multilanguage implementation

### Subsequent community changes

More closely evaluate [the diffs between the community and upstream](https://github.com/MarlinFirmware/Marlin/compare/2.0.x...CR30-Users:Marlin-CR30:2.0.x_cr30). Choosing mainline seems ok if the community diffs don't add improvements.

- **Compare:** CR30-Users `2.0.x_cr30`
- **Base:** Nearest-neighbor official Marlin firmware with co-temporal Offical Marlin CR-30 config files
  - Which upstream commit is the parent?
    ```
    $ git log --oneline -n3
    4c8cd975d6 (HEAD, tag: latest, tag: 2.0.9.3_cr30, origin/HEAD, origin/2.0.x_cr30, 2.0.x_cr30) Merge remote-tracking branch 'upstream/2.0.x' into 2.0.x_cr30
    16f92d673a 🔨 Add .vscode/extensions.json
    f17f458e91 🐛 Fix RRW Keypad & Zonestar buttons (#23388)
    ```
  - Parent [upstream firmware commit](https://github.com/MarlinFirmware/Marlin/commits/73b8320e9caac23873169c8e10344f2f8060b389) is `73b8320` _(just after 2.0.9.3)_
  - Corresponding [upstream config commit](https://github.com/MarlinFirmware/Configurations/commit/820725c157fe82720ab4b1f236d885c7f2dd84ea) is `820725c`
- **Diff**
  - The branch comparison above reflects most of this
    - However that comparison also shows both _release_ and _bugfix_ branches being merged from upstream, so some history is remixed with each rebase
    - Further the comparison is against the **default** configuration files from Marlin, not against the CR-30 configuration files from Marlin
  - We can recreate a pull request diff by taking the file trees from the upstream commits linked above and diffing the unified tree against the latest tree from CR30-Users
    1. Base: [Copy the upstream CR-30 configuration](./history/0001-Marlin-apply-CR-30-configuration-to-default-files.patch.md) into the upstream firmware tree
    1. Compare: [Apply the CR30-Users changes](./history/0002-CR30-Users-Add-community-customizations.patch.md) to the unified upstream tree
  - These differences are listed below

#### List of Changes made in `CR30-Users`

| Keep? | Difference | Reason | Note |
|:-----:|------------|--------|------|
| ❌ | Disable serial port 2 | bundle with rework-required changes | 🔷 |
| ❌ | Increase hotend max temp to 275 | seems a little dangerous |  |
| ✅ | Add PID autotune to the LCD menu |  |  |
| ❌ | Add `BELT_KINEMATICS_DEV` configuration option | doesn't build, code history lost |  |
| ✅ | Misc movement coefficients and limits | identify machine-spefic constants | 🔷 |
| ❌ | Decrease Y size from 250 to 240 | seems like an oversight or early prototype trait |  |
| ❌ | Remove the negative Y offset and home position | seems like an oversight, still in YT videos |  |
| ✅ | Allow Z to move backward below 0 |  |  |
| ❌ | Reduce the thermal watch periods back to defaults | seems dangerous or early prototype trait |  |
| ✅ | Enable controller fan on `PC1` |  |  |
| ✅ | Enable the hotend autofan on `PC0` |  |  |
| ✅ | Enable the case light on `PC14` |  |  |
| ❌ | Remove the total-E on the print status screen | a useful stat for some users and use cases |  |
| ✅ | Reduce Y lift after SD finished or SD canceled |  |  |
| ✅ | Force the media menu to the top of the LCD menu |  |  |
| ✅ | Enable hollow frame menus |  |  |
| ✅ | Disable double-click for baby stepping |  |  |
| ❌ | Disable linear advance | it's enabled but with a 0 multiplier in the stock configuration | 🔷 |
| ❌ | Enable TMC Debug | bundle with rework-required changes | 🔷 |
| ✅ | Enable host action commands |  |  |
| ✅ | Add `3DPrintMill` boot screens |  |  |
| ❌ | Add a "Move C" command to the LCD menu | doesn't build, code history lost |  |
| ✅ | Allow fine movements on the Y axis in the LCD menu |  |  |
| ❌ | Remove `BOARD_NO_NATIVE_USB` | might be a rebase merge mistake |  |
| ❌ | Move `Z_MIN_PROBE_PIN` from `PA5` to `PB1` | bundle with rework-required changes | 🔷 |
| ❌ | Add `CASE_LIGHT_PIN` for `PC14` | already overridden in `configuration_adv.h` |  |
| ❌ | Set pins for TMC UART IO for XYZE axes on `PB0`, `PB1`, `PA13`, `PA14` | bundle with rework-required changes | 🔷 |

### Questions and actions
- See the [CR-30 Users wiki](https://github.com/CR30-Users/Marlin-CR30/wiki)
- How many of these require re-working the board?
  - **No** firmware changes listed above require a rework
  - Removing `STANDALONE` from the `TMC2208` stepper driver configuration requires a rework of the main board
    - Depopulate a resistor for each stepper driver
    - Solder a wire in its place
    - Connect it to an IO header
  - Should be separated into its own patch
- How many just need a plug moved to a different socket?
  - Harmless because fans remain always-on even if their connections are never changed
  - Still should be separated into its own patch
  - Controller fan `K-FAN3`
  - Auto-on hotend fan `K-FAN2`
- Wiki has an extra mod for NeoPixels
  - Also requires a board rework
    - Splice pins on connectors between signals and sensors
  - Should be separated into its own patch

## References

- _"deque mutated during iteration"_
  - bug in `marlin.py` -- https://community.platformio.org/t/trying-to-compile-marlin-2-1-2-for-ender-3-skr-mini-v2-0-board/33769/9
  - forks that haven't updated [since 26 Mar 2023](https://github.com/MarlinFirmware/Marlin/commit/c2decc3e2e30c7cb0f517b7e40d8138a8c1d4a81) are impacted because PlatformIO updated its internal packages
