; 19 points, 8 factors, probing radius: 160, probe offset (0, 0)

; !! I 'hacked' the JavaScript on the page to go above 16 probe points
;      "The number of probe points you choose must be at least as high as
;       the number of factors you want to calibrate, and preferably higher.
;       You can use up to 32."
;    https://duet3d.dozuki.com/Wiki/Calibrating_a_delta_printer#Section_Setting_up_the_bed_g_file

G30 P0   X0.00     Y160.00   Z-99999  H0
G30 P1   X80.00    Y138.56   Z-99999  H0
G30 P2   X138.56   Y80.00    Z-99999  H0
G30 P3   X160.00   Y0.00     Z-99999  H0
G30 P4   X138.56   Y-80.00   Z-99999  H0
G30 P5   X80.00    Y-138.56  Z-99999  H0
G30 P6   X0.00     Y-160.00  Z-99999  H0
G30 P7   X-80.00   Y-138.56  Z-99999  H0
G30 P8   X-138.56  Y-80.00   Z-99999  H0
G30 P9   X-160.00  Y-0.00    Z-99999  H0
G30 P10  X-138.56  Y80.00    Z-99999  H0
G30 P11  X-80.00   Y138.56   Z-99999  H0
G30 P12  X0.00     Y80.00    Z-99999  H0
G30 P13  X69.28    Y40.00    Z-99999  H0
G30 P14  X69.28    Y-40.00   Z-99999  H0
G30 P15  X0.00     Y-80.00   Z-99999  H0
G30 P16  X-69.28   Y-40.00   Z-99999  H0
G30 P17  X-69.28   Y40.00    Z-99999  H0

M99
