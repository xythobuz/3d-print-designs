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
length = 5;
screwInner = 2.8;
screwOuter = 6.5;

overlap = (screwOuter - screwInner) / 2;
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

screw();

translate([screwOuter + length, 0, 0])
    screw();

translate([(screwOuter / 2) - overlap, -wallSize / 2, 0])
    cube([length + (2 * overlap), wallSize, height]);