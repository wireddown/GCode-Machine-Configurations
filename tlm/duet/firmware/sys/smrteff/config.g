;; Configuration file for Duet WiFi
;  - Executed by the firmware on start-up

;; Network
;  - Authentication is configured manually via
;    M587 S"your-network-ssid" P"your-network-password"
M550  Pceleste                            ; Set machine name
M552  S1                                  ; Enable network
M586  P0 S1                               ; Enable HTTP
M586  P1 S1                               ; Enable FTP
M586  P2 S0                               ; Disable Telnet

;; Automatic power saving
; - Set voltage stop/recover thresholds
; - Add actions to run on power loss
;   - Lower motor current to NN percent
;   - From current position, lift nozzle and retract
M911  S19.8  R22.0  P"M913 X20 Y20 Z20 E40 G91 M83 G1 Z3 E-2 F1000"

;; General preferences
M111  S0                                  ; Debug __OFF__
G21                                       ; Units are mm

;; Smart Effector Z probe
;  - Set Z probe type to unfiltered contact switch with recovery holdoff,
;    dive height (mm) and speed (mm/min), travel speed, max 5 samples, tolerance of S mm
M558  P8    R0.5  H5  F1000  T4000  A5  S0.016
G31   P100  X0    Y0  Z-0.06              ; Set probe trigger threshold, offset from nozzle

;; Physical geometry in mm
M665  L400.34  R162.900  H521.072  B174.0   X0.012   Y0.166   Z0.000
M666  X-0.17    Y-0.08    Z0.24    A0.00    B0.00

;; Scaling and strength
M92   X200   Y200   Z200   E2637          ; Set steps per mm, E is for Zesty Nimble v1
M350  X16    Y16    Z16    E16   I1       ; Configure microstepping with interpolation for motors
M906  X1300  Y1300  Z1300  E800  I50      ; Set motor currents (in 100 mA steps) and motor idle factor in percent

;; Speed and dynamics
M203  X18000  Y18000  Z18000  E900        ; Set maximum speeds (mm/min), E is for Zesty Nimble v1
M201  X1000   Y1000   Z1000   E120        ; Set accelerations (mm/s^2), E is FOR Zesty Nimble v1
M566  X1000   Y1000   Z1000   E40         ; Set maximum instantaneous speed changes (mm/min), E is for Zesty Nimble v1
M84   S30                                 ; Set idle timeout

;; Delta axis limits
M208  Z0 S1                               ; Set minimum Z to 0 mm
M574  X2 Y2 Z2 S1                         ; Set active-high endstops

;; Drives
M569  P0 S1                               ; Stepper 0 (X)  goes forwards
M569  P1 S1                               ; Stepper 1 (Y)  goes forwards
M569  P2 S1                               ; Stepper 2 (Z)  goes forwards
M569  P3 S0                               ; Stepper 3 (E0) goes backwards for Zesty Nimble v1

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

;; Machine fan
;  - Set name, fan port, max speed, inversion and frequency; configure thermostatic control for 50 C on Heater 1
;  - Disable fan on port 1, which seems like a bug in the firmware when left unconfigured:
;       Fan 1 pin: F1, frequency: 250Hz, speed: 100%, min: 10%, max: 100%, blip: 0.10,
;       inverted: no, temperature: 45.0:45.0C, heaters: 1 2 3 4 5 6 7, current speed: 100%
M106  C"Nozzle cooling" P2  X0.92  I0  F250  T50  H1
M106  C"no cxn"         P1  S0.0   I0  F250  H-1

;; Custom settings
G28                                       ; Go home via homedelta.g
M18   E0                                  ; De-energize extruder
M290  R0   S0.10                          ; Use baby stepping on Z to move S mm in absolute coordinates
M557  R155 S15                            ; Grid-level radius R mm with a mesh spacing of S mm
M376  H2                                  ; Taper the grid-level compensation to 0 at H mm
G29   S1                                  ; Load the grid-leveling height map

M106  P0   S0                             ; Part fan 0 off
