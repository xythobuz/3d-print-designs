/*
 * Based on "Y-Axis Bracket" by "daveth26":
 * http://www.thingiverse.com/thing:1104535
 *
 * Recreated and modified by:
 * Thomas Buck <xythobuz@xythobuz.de> in March 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 *
 * This part has been modified to use a 25mm fan instead of 
 * a 30mm fan. This can be set in the parameters, but beware
 * of any problems, I have not tested any other sizes.
 *
 * The Fabrikator Mini V1.5 include a new bracket that prevents
 * the old design from sliding fully onto the stepper motor.
 * A parameter has been added (fab_mini_v15) that allows
 * reverting to the old behvior.
 *
 * For V1.5, a height of 25mm is suggested, as this provides
 * enough stability with the big cut-out. To revert to something
 * like the original model, set the height to 15mm (and
 * fab_mini_v15 to "false").
 */

// -----------------------------------------------------------

height = 25; // [14:26]

// default for 25mm fan: 23
fan_hole_diameter = 23; // [26]

// default for 25mm fan: 20
fan_screw_distance = 20; // [22]

// default for 25mm fan: 3
fan_screw_diameter = 3; // [1:5]

fan_hole_angled = "true"; // [true, false]

// -----------------------------------------------------------

/* [Hidden] */

bottom_arm_height = 2;
bottom_arm_gap = 8;

back_support_depth = 2;
mid_left_cutout = 9;

wall_size = 3;
fan_angle = 10;

nub_size = 1;
nub_depth = 1;

motor_width = 28.5;
motor_depth = 27;

$fn = 25;

fan_screw_pos = fan_screw_distance / 2;
fan_screw_neg = -fan_screw_pos;

fabrikator_mini_v15_height = 20;
mid_left_cutout_height = 5;

base_height = 5;

// -----------------------------------------------------------

module ellipse(w, l, d) {
    cube([d, l - w, w]);
    
    translate([0, 0, w / 2])
        rotate([0, 90, 0])
        cylinder(d = w, h = d);
    
    translate([0, l - w, w / 2])
        rotate([0, 90, 0])
        cylinder(d = w, h = d);
}

// -----------------------------------------------------------

// stepper motor
%translate([nub_depth, wall_size, 0])
    cube([motor_depth, motor_width, height + 1]);

// bottom left arm
translate([0, 0, bottom_arm_gap])
    cube([motor_depth + nub_depth, wall_size, bottom_arm_height]);

// bottom left nub
translate([0, 0, bottom_arm_gap])
    cube([nub_depth, wall_size + nub_size, bottom_arm_height]);

if (height > fabrikator_mini_v15_height) {
    // top left arm
    translate([0, 0, fabrikator_mini_v15_height])
        cube([motor_depth + nub_depth, wall_size, height - fabrikator_mini_v15_height]);
    
    // top left nub
    translate([0, 0, fabrikator_mini_v15_height])
        cube([nub_depth, wall_size + nub_size, height - fabrikator_mini_v15_height]);
}

// left back support
translate([motor_depth + nub_depth - back_support_depth, 0, 0])
    cube([back_support_depth, wall_size, height]);

// mid left support
translate([nub_depth + mid_left_cutout, 0, 10])
    cube([motor_depth - back_support_depth - mid_left_cutout, wall_size, height - fabrikator_mini_v15_height + mid_left_cutout_height]);

// right arm
difference() {
    translate([0, motor_width + wall_size, 0])
        cube([motor_depth + nub_depth, wall_size, height]);
    
    translate([24 - wall_size, 28, 4])
        rotate([0, 0, 90])
        ellipse(7, 20, 8);
    
    if (height > 23) {
        translate([24 - wall_size, 28, 15])
            rotate([0, 0, 90])
            ellipse(7, 20, 8);
    }
}
    
// right nub
translate([0, motor_width + wall_size - nub_size, 0])
    cube([nub_depth, wall_size + nub_size, height]);

// back wall
difference() {
    translate([motor_depth + nub_depth, 0, 0])
        cube([wall_size, motor_width + (2 * wall_size), height]);
    
    translate([25, 8 + wall_size, 4])
        ellipse(7, 20, 8);
    
    if (height > 23) {
        translate([25, 8 + wall_size, 15])
            ellipse(7, 20, 8);
    }
}

// bottom part
difference() {
    // base
    translate([0, 0, -base_height])
        cube([motor_depth + nub_depth + wall_size, motor_width + (2 * wall_size), base_height]);
    
    // cut off angled bottom part
    rotate([0, -fan_angle, 0])
        translate([-base_height, -(base_height / 2), -(3 * base_height)])
        cube([motor_depth * 1.5, motor_width + (2 * wall_size) + base_height, (2 * base_height)]);
    
    // main fan hole
    if (fan_hole_angled == "true") {
        rotate([0, -fan_angle, 0])
            translate([nub_depth + (motor_depth / 2), wall_size + (motor_width / 2), -(base_height * 1.5)])
            cylinder(d = fan_hole_diameter, h = (2 * base_height));
    } else {
        translate([nub_depth + (motor_depth / 2), wall_size + (motor_width / 2), -(base_height * 1.5)])
        cylinder(d = fan_hole_diameter, h = (2 * base_height));
    }
    
    // fan screw holes
    for (i = [1 : 2]) {
        for (j = [1 : 2]) {
            rotate([0, -fan_angle, 0])
                translate([nub_depth + (motor_depth / 2), wall_size + (motor_width / 2), -(base_height * 1.5)])
                translate([(((i % 2) == 0) ? fan_screw_pos : fan_screw_neg),
                    (((j % 2) == 0) ? fan_screw_pos : fan_screw_neg), 0])
                cylinder(d = fan_screw_diameter, h = (2 * base_height));
        }
    }
    
    // big air hole
    translate([8, 36, -1.8])
        rotate([90, 0, 0])
        cylinder(d = 2, h = 40);
    
    // small air hole
    translate([12, 36, -1.5])
        rotate([90, 0, 0])
        cylinder(d = 1.5, h = 40);
    
    // elliptical air hole
    translate([-1, 9 + wall_size, -3.5])
        ellipse(2, 12, 8);
}
