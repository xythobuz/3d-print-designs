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
 */

// -----------------------------------------------------------

height = 28.5; // [14:26]

// default for 25mm fan: 23
fan_hole_diameter = 23; // [26]

// default for 25mm fan: 20
fan_screw_distance = 20; // [22]

// default for 25mm fan: 3
fan_screw_diameter = 3; // [1:5]

fan_hole_angled = "true"; // [true, false]

arm_inward_angle_left = 4; // [0:5]

// -----------------------------------------------------------

/* [Hidden] */

right_wall_size_modifier = 1.75; // [0:2]

bottom_arm_height = 2;
bottom_arm_gap = 8;

back_support_depth = 2;
mid_left_cutout = 9;

wall_size = 4;
fan_angle = 10;

nub_size = 1;
nub_depth = 2;

motor_width = 28.3;
motor_depth = 27;

cut_out_depth = 10;
cut_out_height = 5.5;

$fn = 25;

fan_screw_pos = fan_screw_distance / 2;
fan_screw_neg = -fan_screw_pos;

fabrikator_mini_v15_height = 20;
mid_left_cutout_height = 6;

base_height = 5;

arm_inward_angle_right = 0;

top_fan_extra_layer = 0.8;

heat_sink_cutout = 24.4;

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

module left_arm() {
    // bottom left arm
    translate([0, 0, bottom_arm_gap])
        cube([motor_depth + nub_depth, wall_size, bottom_arm_height]);

    // bottom left nub
    translate([0, 0, bottom_arm_gap])
        cube([nub_depth, wall_size + nub_size, bottom_arm_height]);

    if (height > fabrikator_mini_v15_height) {
        // top left arm
        translate([0, 0, fabrikator_mini_v15_height + 1])
            cube([motor_depth + nub_depth, wall_size, height - fabrikator_mini_v15_height - 1]);
    
        // top left nub
        translate([0, 0, fabrikator_mini_v15_height + 1])
            cube([nub_depth, wall_size + nub_size, height - fabrikator_mini_v15_height - 1]);
    }

    // left back support
    translate([motor_depth + nub_depth - back_support_depth, 0, 0])
        cube([back_support_depth, wall_size, height]);

    // mid left support
    translate([nub_depth + mid_left_cutout, 0, 10])
        cube([motor_depth - back_support_depth - mid_left_cutout, wall_size, height - fabrikator_mini_v15_height + mid_left_cutout_height]);
    
    if (arm_inward_angle_left != 0) {
        // connecting piece for angled arm
        translate([motor_depth + nub_depth - back_support_depth, 0, 0])
            cube([1.5 * back_support_depth, wall_size, height]);
    }
}

module right_arm() {
    difference() {
        union() {
            // right wall
            translate([0, motor_width + wall_size, 0])
                cube([motor_depth + nub_depth, wall_size - right_wall_size_modifier, height]);
            
            // right nub
            translate([0, motor_width + wall_size - nub_size, 0])
                cube([nub_depth, wall_size + nub_size - right_wall_size_modifier, height]);
        }
        
        translate([24 - wall_size, 28, 3])
            rotate([0, 0, 90])
            ellipse(7, 20, 8);
        
        if (height > 23) {
            translate([24 - wall_size, 28, 13.5])
                rotate([0, 0, 90])
                ellipse(7, 20, 8);
        }
        
        // cut off a small nub at the top to fit the Z-axis rod holder
        translate([0, motor_width + wall_size - nub_size, height - cut_out_height])
            cube([cut_out_depth, wall_size + nub_size, cut_out_height]);
    }
    
    
    
    if (arm_inward_angle_right != 0) {
        // connecting piece for angled arm
        translate([motor_depth + nub_depth - back_support_depth, motor_width + wall_size, 0])
            cube([1.5 * back_support_depth, wall_size, height]);
    }
}

// -----------------------------------------------------------

// stepper motor
%translate([nub_depth, wall_size, 0])
    cube([motor_depth, motor_width, height + 1]);

// heat sink
%translate([nub_depth + motor_depth, ((2 * wall_size) + motor_width - heat_sink_cutout) / 2, 1.5 * top_fan_extra_layer])
    cube([10, heat_sink_cutout, heat_sink_cutout]);

difference() {
    // left arm
    translate([0, 27 * sin(arm_inward_angle_left / 1.5), 0])
        rotate([0, 0, -(arm_inward_angle_left / 1.5)])
        left_arm();
    
    // cut off small ledge
    translate([0, -1, -base_height])
        cube([motor_depth + nub_depth + wall_size, 1, motor_width + base_height + wall_size]);
}

difference() {
    // right arm
    translate([35 * sin(arm_inward_angle_right / 1.5), -27 * sin(arm_inward_angle_right / 1.5), 0])
        rotate([0, 0, arm_inward_angle_right / 1.5])
        right_arm();

    if (arm_inward_angle_right != 0) {
        // cut off small ledge
        translate([0, motor_width + (2 * wall_size), -base_height])
            cube([motor_depth + nub_depth + wall_size, 1, motor_width + base_height + wall_size]);
    }
}

// back wall
difference() {
    translate([motor_depth + nub_depth, 0, 0])
        cube([wall_size, motor_width + (2 * wall_size) - right_wall_size_modifier, height]);
    
    translate([25, 8 + wall_size, 4])
        ellipse(7, 20, 8);
    
    if (height > 23) {
        translate([25, 8 + wall_size, 15])
            ellipse(7, 20, 8);
    }
    
    translate([nub_depth + motor_depth, ((2 * wall_size) + motor_width - heat_sink_cutout) / 2, 1.5 * top_fan_extra_layer])
        cube([wall_size, heat_sink_cutout, heat_sink_cutout]);
}

// bottom part
difference() {
    // base
    translate([0, 0, -base_height])
        cube([motor_depth + nub_depth + wall_size, motor_width + (2 * wall_size) - right_wall_size_modifier, base_height + top_fan_extra_layer]);
    
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
    translate([8.5, 36, -1.3])
        rotate([90, 0, 0])
        cylinder(d = 2, h = 40);
    
    // small air hole
    translate([12.5, 36, -1])
        rotate([90, 0, 0])
        cylinder(d = 1.5, h = 40);
    
    // elliptical air hole
    translate([-1, 9 + wall_size, -3.5])
        ellipse(2, 12, 8);
}
