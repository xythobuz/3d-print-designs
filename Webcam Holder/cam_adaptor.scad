/*
 * Inspired by the "TinyBoy / Fabrikator mini Cam holder"
 * by "andy_a":
 * http://www.thingiverse.com/thing:1434698
 *
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution - Share alike license.
 */

height = 10;
wallSize = 3;
screwInner = 2.8;
screwOuter = 6.5;
fitGap = 0.4;

width = 30;
length = 30;

$fn = 20;

// -----------------------------------------------------------

module half_circle(d, h) {
    difference() {
        cylinder(d = d, h = h);
        
        translate([0, -(d / 2) - 1, -1])
            cube([(d / 2) + 1, d + 2, h + 2]);
    }
}

module screw() {
    difference() {
        cylinder(d = screwOuter, h = height);
        translate([0, 0, -1])
            cylinder(d = screwInner, h = height + 2);
    }
}

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

module all() {
    %translate([9, -9.5 - fitGap, 2])
        rotate([90, 0, 180])
        webcam_shaft();
    
    difference() {
        translate([0, 0, 0])
            cube([9.5, 8 - (2 * fitGap), wallSize]);
        
        translate([5, 4 - fitGap, -1])
            cylinder(d = 3, h = wallSize + 2);
    }
    
    translate([width, height, length])
        rotate([90, 0, 0])
        screw();
    
    translate([9.5, 0, 0])
        cube([width - 10, 8 - (2 * fitGap), wallSize]);
    
    translate([width - (wallSize / 2), 0, 0])
        cube([wallSize, 8 - (2 * fitGap), length - 2]);
    
    translate([width / 2, 0, wallSize / 2])
        rotate([0, 45, 0])
        cube([wallSize / 2, 8 - (2 * fitGap), sqrt(((width / 2) * (width / 2)) + ((length / 2) * (length / 2)))]);
}

translate([width + (screwOuter / 2), 0, 0])
    rotate([90, 0, 180])
    all();