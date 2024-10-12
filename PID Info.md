PID is a control system for motors and related items. It operates by adding terms to get an output as a sort of guide to get a *measured* value to a *target* value.
It consists of three (or more) terms added together:
## P - Proportional
P is directly proportional to distance. This one is the main force for getting to the target, and may be the only one needed if the motor/gearing can start/stop very quickly.
## I - Integral
I is cumulative, useful for when other terms alone won't get quite enough oomph to go the last bit. Often has an effective distance (if the target is too far away I is reset and not used) and a max range (it can't push too hard).
## D - Derivative
D is directly proportional to speed, and usually used to slow down before reaching the target to avoid overshooting and oscillating.
## S - Static
S is a fixed value applied in the direction of the desired movement to overcome static friction.
## Feedforward
Feedforward adds speed to the motor based directly on what speed it "should" be going, e.g. for PathPlanner it's the speed the robot should be going.