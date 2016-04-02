/*
 * Based on "Y-Axis Bracket" by "daveth26":
 * http://www.thingiverse.com/thing:1104535
 *
 * Recreated and modified by:
 * Thomas Buck <xythobuz@xythobuz.de> in March 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

// -----------------------------------------------------------

$fn = 25;

/*
%translate([-31.784, 42.247, 0])
    import("turnigy_3d_fabrikator_y-axis_fan_cheese_fan_bracket.stl");
*/

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

// left arm
translate([0, 0, 8])
    cube([30, 2, 10]);

// left nub
translate([0, 0, 8])
    cube([1, 3, 10]);

// left support
translate([26, 0, 0])
    cube([2, 2, 8]);

// right arm
difference() {
    translate([0, 30.5, 0])
        cube([30, 2, 18]);
    
    translate([22, 28, 5])
        rotate([0, 0, 90])
        ellipse(7, 20, 8);
}
    
// right nub
translate([0, 29.5, 0])
    cube([1, 3, 18]);

// back wall
difference() {
    translate([28, 0, 0])
        cube([2, 32, 18]);
    
    translate([25, 10, 6])
        ellipse(7, 20, 8);
}

difference() {
    // base
    translate([0, 0, -5])
        cube([30, 32.5, 5]);
    
    // cut off angled bottom part
    rotate([0, -10, 0])
        translate([-2, -1, -11])
        cube([34, 34, 6]);
    
    // main fan hole
    rotate([0, -10, 0])
        translate([14.5, 16, -7])
        cylinder(d = 23, h = 10);
    
    // fan screw holes
    for (i = [1 : 2]) {
        for (j = [1 : 2]) {
            rotate([0, -10, 0])
                translate([14.5, 16, -7])
                translate([(((i % 2) == 0) ? 10 : -10),
                    (((j % 2) == 0) ? 10 : -10), 0])
                cylinder(d = 3, h = 10);
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
