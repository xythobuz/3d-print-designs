/*
 * Inspired by the "TinyBoy / Fabrikator mini Cam holder"
 * by "andy_a":
 * http://www.thingiverse.com/thing:1434698
 *
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

//import("/Users/thomas/Downloads/TinyBoy___Fabrikator_mini_Cam_holder/files/tinyboy__fabrikator_mini_cam_holder.stl");

// -----------------------------------------------------------

$fn = 20;

// -----------------------------------------------------------

module quarter_circle(d, h) {
    difference() {
        cylinder(d = d, h = h);
        
        translate([0, -(d / 2) - 1, -1])
            cube([(d / 2) + 1, d + 2, h + 2]);
        
        translate([-(d / 2) - 1, 0, -1])
            cube([(d / 2) + 2, (d / 2) + 1, h + 2]);
    }
}

module webcam_shaft_center() {
    difference() {
        cube([9.5, 3.5, 8]);
        
        translate([4.5, 4, 4])
            rotate([90, 0, 0])
            cylinder(d = 3, h = 4.5);
    }
}

module webcam_shaft_end() {
    difference() {
        union() {
            // rectangular part
            translate([0, -5.5, 0])
                cube([5, 5.5, 9.5]);
            
            // front radius
            translate([5, -2.75, 0])
                cylinder(d = 5.5, h = 9.5);
            
            translate([0, 0, 9.5])
                rotate([90, 0, 0])
                quarter_circle(19, 5.5);
        }
    
        // axis hole
        translate([4.5, -2.75, -1])
            cylinder(d = 4.5, h = 11.5);
    }
}

module webcam_shaft() {
    translate([-0.5, -5.5, 9.5])
        webcam_shaft_center();

    translate([9, 0, 0])
        webcam_shaft_end();

    translate([9, -5.5, 27])
        rotate([0, 180, 180])
        webcam_shaft_end();
}

// -----------------------------------------------------------

translate([0, 0.5, 5.5])
    rotate([90, 0, 90])
    webcam_shaft();
