;; Configuration file for Duet WiFi
;  - Executed by the firmware on start-up

;; Automatic power saving
;  - Set voltage thresholds and actions to run on power loss
M911  S10 R11 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000"

;; General preferences
M111  S0                                  ; Debug __OFF__
G21                                       ; Units are mm

;; Network
;  - Authentication is configured manually via
;    M587 S"your-network-ssid" P"your-network-password"
M550  Pceleste                            ; Set machine name
M552  S1                                  ; Enable network
M586  P0 S1                               ; Enable HTTP
M586  P1 S1                               ; Enable FTP
M586  P2 S0                               ; Disable Telnet

;; Delta axis limits
M208  Z0 S1                               ; Set minimum Z to 0 mm
M574  X2 Y2 Z2 S1                         ; Set active-high endstops

;; Physical geometry in mm
;  M665  L400.34  R162.75  H530     B174.0   X0  Y0  Z0  ; Best guess from raw measurements, no corrections
;  M666  X0       Y0       Z0       A0       B0
;  M665  L400.34  R162.75  H521.8   B174.0   X0  Y0  Z0  ; Confirmed raw measurements, no corrections
;  M666  X0       Y0       Z0       A0       B0
;  M665  L400.34  R162.758  H521.911  B174.0   X0.017  Y0.280  Z0.000  ; First pass auto calibration
;  M666  X-0.17   Y0.23     Z-0.06    A0       B0
;  M665  L400.34  R162.793  H521.880  B174.0   X0.079  Y0.308  Z0.000  ; After three-pass auto calibration
;  M666  X-0.13   Y0.29     Z-0.16    A0       B0
M665  L400.34  R162.767  H521.572  B174.0   X0.067  Y0.309  Z0.000  ; After tightening belts
M666  X-0.09   Y0.36     Z-0.27    A0       B0

;; Smart Effector Z probe
;  - Set Z probe type to unfiltered contact switch with recovery holdoff,
;    dive height (mm) and speed (mm/min), travel speed, max 5 samples
M558  P8    R0.4  H9  F200  T6000  A5
G31   P100  X0    Y0  Z-0.1               ; Set probe trigger threshold, offset from nozzle

;; Scaling and strength
M92   X200   Y200   Z200   E4140          ; Set steps per mm
M350  X16    Y16    Z16    E16   I1       ; Configure microstepping with interpolation for motors
M906  X1500  Y1500  Z1500  E600  I50      ; Set motor currents (in 100 mA steps) and motor idle factor in percent

;; Drives
M569  P0 S1                               ; Stepper 0 (X)  goes forwards
M569  P1 S1                               ; Stepper 1 (Y)  goes forwards
M569  P2 S1                               ; Stepper 2 (Z)  goes forwards
M569  P3 S1                               ; Stepper 3 (E0) goes forwards

;; Part fan
;  - Set name, fan port, initial speed [0..1], PWM inversion and frequency,
;    disable thermostatic control, blip at full-speed for 1 sec, lowest speed is off, then 20%
M106  C"Part cooling"  P0  S0.0  I0  F250  H-1  B1.0  L0.2

;; Heaters
M305  S"Bed"    P0  T100000  B4138  C0                 ; Heater 0 has thermistor + ADC parameters
M143  H0  S150                                         ; Set temperature limit for heater 0 to 150C
M305  S"Nozzle" P1  X200     R430   F60                ; Heater 1 has PT100 on ch200, 430 ohm ref, 60 Hz noise
M143  H1  S300                                         ; Set temperature limit for heater 1 to 300C
M307  H1  A487.2    C184.1   D2.6   S1.0  V23.7  B0    ; Set PID parameters for 50W hotend: gAin timeConstant Deadtime maxPWM, heaterVoltage, no bang-bang

;; Tools
M563  S"Mosquito" P0  D0  H1  F2          ; Define tool 0's drive, heater, and fan
G10   P0  X0  Y0  Z0                      ; Set nozzle offset from origin
G10   P0  S0  R0                          ; Set initial tool 0 service and reserve temperatures in C

;; Machine fans
;  - Set name, fan port, PWM inversion and frequency; configure thermostatic control for 50 C on Heater 1
M106  C"Nozzle cooling" P2  S0.5  I0  F250  T50  H1  B1.0  L0.2

;; Speed and dynamics
M203  X18000  Y18000  Z18000  E600        ; Set maximum speeds (mm/min)
M201  X1000   Y1000   Z1000   E40         ; Set accelerations (mm/s^2)
M566  X1000   Y1000   Z1000   E2          ; Set maximum instantaneous speed changes (mm/min)
M84   S30                                 ; Set idle timeout

;; Custom settings
G90                                       ; Send absolute coordinates...
M83                                       ; ...but relative extruder moves

G28                                       ; Go home via homedelta.g
;;M290  R0   S-0.34                         ; Use baby stepping on Z to move S mm in absolute coordinates
M557  R130 S20                            ; Grid-level radius R mm with a mesh spacing of S mm
M376  H12                                 ; Taper the grid-level compensation to 0 at H mm
G29   S1                                  ; Load the grid-leveling height map

M106  P0   S0                             ; Part fan 0 off
