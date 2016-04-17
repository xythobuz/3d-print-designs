/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

diameter = 10;
slit = 1.1;
slit_height = 2.1;
height = 4.5;
wall = 1.5;
base_size = 20;
base_height = 3;
cut_out_count = 5;
cut_out_factor = 0.35;
$fn = 30;

// -----------------------------------------------------------

translate([0, 0, base_height])
union() {
    difference() {
        cylinder(d = diameter + (2 * wall), h = height);
        cylinder(d = diameter, h = height);
    }

    translate([-(slit / 2), -(diameter / 2), 0])
        cube([slit, diameter, slit_height]);
}

difference() {
    cylinder(d = base_size, h = base_height);
    
    // cut outs for fingers
    for (i = [0 : cut_out_count]) {
        rotate([0, 0, (360 / cut_out_count) * i])
            translate([(base_size / 2), 0, 0])
            cylinder(d = base_size * cut_out_factor, h = base_height);
    }
}
