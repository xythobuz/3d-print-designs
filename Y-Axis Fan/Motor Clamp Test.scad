/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in March 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

// -----------------------------------------------------------

//translate([-31.784, 42.247, -18.25])
//    import( "/Users/thomas/Downloads/turnigy_3d_fabrikator_y-axis_fan_cheese_fan_bracket.stl");

// -----------------------------------------------------------

top_height = 5;
bottom_height = 2;
distance = 10;
motor_width = 28;
arm_width = 2;
holder_nub = 1;
hole = 22;

$fn = 25;

// -----------------------------------------------------------

// Test rendering of motor
/*
#translate([holder_nub, arm_width, 0])
    cube([motor_width, motor_width, motor_width]);
*/

// -----------------------------------------------------------

module arm(dir = "left", h) {
    cube([motor_width + holder_nub, arm_width, h]);
    
    translate([0, (dir == "right") ? -holder_nub : 0, 0])
        cube([holder_nub, arm_width + holder_nub, h]);
}

module clamp(h) {
    arm("left", h);
    
    translate([0, motor_width + arm_width, 0])
        arm("right", h);
    
    translate([motor_width + holder_nub, 0, 0])
        cube([arm_width, motor_width + (2 * arm_width), h]);
}

module part() {
    clamp(bottom_height);
    
    translate([0, 0, distance + bottom_height])
        clamp(top_height);
    
    translate([motor_width + holder_nub, 0, 0])
        cube([arm_width, motor_width + (2 * arm_width), top_height + distance + bottom_height]);
}

// -----------------------------------------------------------

difference() {
    part();
    
    translate([motor_width + holder_nub - (arm_width / 2), (motor_width / 2) + arm_width, 4])
        rotate([0, 90, 0])
        cylinder(d = hole, h = 2 * arm_width);
}
