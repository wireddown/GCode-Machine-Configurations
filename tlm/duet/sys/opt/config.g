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
;  - Only L R and B need to be accurate.
;    The others [H XYZ AB] are calculated by autocal aka G32.
M665  L400  R156.8  H525  B175            ; Set delta diagonal rod length, radius, homed height, printable radius
M666  X0    Y0      Z0    A0   B0         ; Zero all endstop adjustments and tilt corrections

;; Scaling and strength
M92   X200   Y200   Z200   E2637          ; Set steps per mm
M350  X16    Y16    Z16    E16   I1       ; Configure microstepping with interpolation
M906  X1200  Y1200  Z1200  E500  I30      ; Set motor currents (in 100 mA steps) and motor idle factor in percent

;; Drives
;  - No need to tune the stepper constants (yet... choppers not as influential in first layer adhesion)
M569  P0 S1                               ; Stepper 0 goes forwards
M569  P1 S1                               ; Stepper 1 goes forwards
M569  P2 S1                               ; Stepper 2 goes forwards
M569  P3 S0                               ; Stepper 3 goes backwards

;; Fans
;  - Set name, fan port, initial speed [0..1], PWM inversion and frequency; disable thermostatic control
M106  C"Part Fan 1"  P0  S0.5  I0  F250  H-1
M106  C"Part Fan 2"  P1  S0.5  I0  F250  H-1
M106  C"Tool Fan"    P2  S0.5  I0  F250  H-1

;; Heaters
M305  S"Bed heater"    P0  T100000  B4138  C0   ; Heater 0 has thermistor + ADC parameters
M143  H0  S150                                  ; Set temperature limit for heater 0 to 150C
M305  S"Hotend heater" P1  X200  R430  F60      ; Heater 1 has PT100 on ch200, 430 ohm ref, 60 Hz noise
M143  H1  S300                                  ; Set temperature limit for heater 1 to 300C
M307  H1  A477.5   C252.5  D4.5  S1.0  B0       ; Set PID parameters for hotend: gAin timeConstant Deadtime maxPWM, no bang-bang

;; Tools
M563  S"Hotend"   P0  D0  H1  F2          ; Define tool 0's drive, heater, and fan
G10   P0  X0  Y0  Z0                      ; Set nozzle offset from origin
G10   P0  S200  R100                      ; Set initial tool 0 service and reserve temperatures in C

;; Speed and dynamics
M203  X18000  Y18000  Z18000  E900        ; Set maximum speeds (mm/min)
M201  X1000   Y1000   Z1000   E120        ; Set accelerations (mm/s^2)
M566  X1000   Y1000   Z1000   E40         ; Set maximum instantaneous speed changes (mm/min)
M84   S30                                 ; Set idle timeout

;; Z-Probe
M307  H3   A-1   C-1   D-1                ; Disable heater on PWM channel 3 to reuse it for the BLTouch
M558  P9   H5    F100  T6000   A5         ; Set Z probe type to BLTouch, dive height (mm) and speed, travel speed, max 5 samples
G31   P25  X-2.4 Y21.4 Z1.07              ; Set probe trigger threshold, offset from nozzle, and trigger height

;; Custom settings
M106  P0  S0                              ; Part fan 0 off
M106  P1  S0                              ; Part fan 1 off
G90                                       ; Send absolute coordinates...
M83                                       ; ...but relative extruder moves
G28                                       ; Go home
