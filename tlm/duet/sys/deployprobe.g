; deployprobe.g
; called to deploy a physical Z probe

M280  P3 S160 I1   ; Clear errors
M280  P3 S10  I1   ; Deploy the probe!
