# Machine squaring log

- Requires updated firmware with CR30-User's negative Y axis offset
- Screw bed down until it's flush
- Lower nozzle until it touches the bed
- Loosen left side optical endstop retaining screws so it can slide in its grooves
- Loosen optical endstop adjustment screw until it begins to come out
- Tighten the optical endstop adjustment screw until the endstop recedes 1-2 mm
- Use gap gauge to set its position
- Repeat for right side physical endstop


- Turn on
- Auto home
- The nozzle is probably a few mm above the bed
- Move Y axis down 0.1mm until the nozzle catches the gap gauge
- Move X to center of bed
- Check gap gauge for clearance
- Move X to far side of bed
- Adjust bed knob until gap gauge catches
- Move X back to center of bed
- Check gap gauge
- Move X back to home
- Check gap gauge
- Move Y axis down same thickness or +0.1 mm as the gap gauge
- Set home offsets
- Save to EEPROM

- Would befefit from `LCD_DECIMAL_SMALL_XY`

- Ready to print
