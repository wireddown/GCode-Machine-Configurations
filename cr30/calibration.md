# Calibration

After updating to version `2.1.2.1`.

## Z

- Printed 100 mm long block
- Measured 100.0 mm

## Hotend

- `M303 C5 S220`
- `bias: 98 d: 98 min: 216.16 max: 223.02 Ku: 36.35 Tu: 19.36`
  ```c
  #define DEFAULT_Kp 21.81
  #define DEFAULT_Ki 2.25
  #define DEFAULT_Kd 52.78
  ```

## E

- Retracted 100 mm
  ```
  M302 P1
  G92 E0
  G0 E-100 F600
  G92 E0
  ```
- Measured 97 mm
