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

height = 10.2;
wallSize = 3;
screwInner = 2.8;
screwOuter = 6.5;
length = 60;

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

module arm() {
    translate([0, screwOuter / 2, 0])
        cube([wallSize, length - screwOuter, screwOuter]);
    
    translate([0, screwOuter / 2, screwOuter / 2])
        rotate([90, 0, 90])
        half_circle(screwOuter, wallSize);
    
    translate([wallSize, length - (screwOuter / 2), screwOuter / 2])
        rotate([90, 0, 270])
        half_circle(screwOuter, wallSize);
}

%translate([wallSize, length - (screwOuter / 2), screwOuter / 2])
    rotate([0, 90, 0])
    screw();

%translate([wallSize, screwOuter / 2, screwOuter / 2])
    rotate([0, 90, 0])
    screw();

// -----------------------------------------------------------

difference() {
    union() {
        arm();
        
        translate([height + wallSize, 0, 0])
            arm();
        
        translate([wallSize, length / 3, screwOuter / 2])
            rotate([0, 90, 0])
            cylinder(d = screwOuter, h = height);
        
        translate([wallSize, length * 2 / 3, screwOuter / 2])
            rotate([0, 90, 0])
            cylinder(d = screwOuter, h = height);
    }
    
    translate([-1, screwOuter / 2, screwOuter / 2])
        rotate([0, 90, 0])
        cylinder(d = screwInner, h = height + (2 * wallSize) + 2);
    
    translate([-1, length - (screwOuter / 2), screwOuter / 2])
        rotate([0, 90, 0])
        cylinder(d = screwInner, h = height + (2 * wallSize) + 2);
}
