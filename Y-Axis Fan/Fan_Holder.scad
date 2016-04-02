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

// cut-out for new part in Fabrikator Mini V1.5
fab_mini_v15 = "true"; // [true, false]

// default for 25mm fan: 23
fan_hole_diameter = 23; // [26]

// default for 25mm fan: 20
fan_screw_distance = 20; // [22]

// default for 25mm fan: 3
fan_screw_diameter = 3; // [1:5]

fan_hole_angled = "true"; // [true, false]

// -----------------------------------------------------------

/* [Hidden] */

fan_angle = 10;

$fn = 25;

fan_screw_pos = fan_screw_distance / 2;
fan_screw_neg = -fan_screw_pos;

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

// bottom left arm
if (fab_mini_v15 == "true") {
    translate([0, 0, 8])
        cube([30, 2, 2]);
} else {
    translate([0, 0, 8])
        cube([30, 2, height - 8]);
}

// bottom left nub
if (fab_mini_v15 == "true") {
    translate([0, 0, 8])
        cube([1, 3, 2]);
} else {
    translate([0, 0, 8])
        cube([1, 3, height - 8]);
}

if (height > 20) {
    // top left arm
    translate([0, 0, 20])
        cube([30, 2, height - 20]);
    
    // top left nub
    translate([0, 0, 20])
        cube([1, 3, height - 20]);
}

// left back support
translate([26, 0, 0])
    cube([4, 2, height]);

// mid left support
translate([15, 0, 10])
    cube([11, 2, height - 10]);

// right arm
difference() {
    translate([0, 30.5, 0])
        cube([30, 2, height]);
    
    translate([22, 28, 4])
        rotate([0, 0, 90])
        ellipse(7, 20, 8);
    
    if (height > 23) {
        translate([22, 28, 15])
            rotate([0, 0, 90])
            ellipse(7, 20, 8);
    }
}
    
// right nub
translate([0, 29.5, 0])
    cube([1, 3, height]);

// back wall
difference() {
    translate([28, 0, 0])
        cube([2, 32, height]);
    
    translate([25, 10, 4])
        ellipse(7, 20, 8);
    
    if (height > 23) {
        translate([25, 10, 15])
            ellipse(7, 20, 8);
    }
}

difference() {
    // base
    translate([0, 0, -5])
        cube([30, 32.5, 5]);
    
    // cut off angled bottom part
    rotate([0, -fan_angle, 0])
        translate([-2, -1, -11])
        cube([34, 34, 6]);
    
    // main fan hole
    if (fan_hole_angled == "true") {
        rotate([0, -fan_angle, 0])
            translate([14.5, 16, -7])
            cylinder(d = fan_hole_diameter, h = 10);
    } else {
        translate([14.5, 16, -7])
        cylinder(d = fan_hole_diameter, h = 10);
    }
    
    // fan screw holes
    for (i = [1 : 2]) {
        for (j = [1 : 2]) {
            rotate([0, -fan_angle, 0])
                translate([14.5, 16, -7])
                translate([(((i % 2) == 0) ? fan_screw_pos : fan_screw_neg),
                    (((j % 2) == 0) ? fan_screw_pos : fan_screw_neg), 0])
                cylinder(d = fan_screw_diameter, h = 10);
        }
    }
    
    // big air hole
    translate([8, 33, -1.8])
        rotate([90, 0, 0])
        cylinder(d = 2, h = 34);
    
    // small air hole
    translate([12, 33, -1.5])
        rotate([90, 0, 0])
        cylinder(d = 1.5, h = 34);
    
    // elliptical air hole
    translate([-1, 11, -3.5])
        ellipse(2, 12, 8);
}
