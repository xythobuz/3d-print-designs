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

// -----------------------------------------------------------

height = 10;
bodyHeight = 25;
wallSize = 3;
lipSize = 3;
fullSize = 28;
gap = 5;
screwInner = 2.8;
screwOuter = 6.5;

$fn = 25;

// -----------------------------------------------------------

module screw() {
    difference() {
        cylinder(d = screwOuter, h = height);
        translate([0, 0, -1])
            cylinder(d = screwInner, h = height + 2);
    }
}

// -----------------------------------------------------------

// lower body
cube([wallSize, fullSize - wallSize, bodyHeight]);

// upper border
translate([0, fullSize - wallSize, 0])
    cube([(2 * wallSize) + gap, wallSize, bodyHeight]);

// upper lip
translate([wallSize + gap, fullSize - (2 * wallSize), 0])
    cube([wallSize, wallSize, bodyHeight]);

// lower border
translate([wallSize, 0, 0])
    cube([lipSize, lipSize, bodyHeight]);

//translate([-7, 3.5, (bodyHeight - height) / 2])
    //screw();

translate([-7, 8.5, (bodyHeight - height) / 2])
    screw();

translate([-7, 13.5, (bodyHeight - height) / 2])
    screw();

translate([-7, 18.5, (bodyHeight - height) / 2])
    screw();

//translate([-7, 23.5, (bodyHeight - height) / 2])
    //screw();

translate([-5.5, 5.75, (bodyHeight - height) / 2])
    cube([5.5, 15.5, height]);
