/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

// M2: 4; M3: 5.5; M4: 7; M5: 8
nut_size = 5.5; // [1:50]
nut_height = 2.5; // [1:50]
base_size = 20; // [1:50]
base_height = 3; // [1:50]
wall_size = 2.5; // [1:50]
cut_out_factor = 0.3; // [0.0:1.0]
cut_out_count = 5; // [0:10]
nut_size_buffer = 0.1; // [0.0:1.0]

// -----------------------------------------------------------

$fn = 25;
hexagon_size = (nut_size + nut_size_buffer);

// -----------------------------------------------------------

module hexagon(w = 1, h = 1) {
    hw = w / sqrt(3);
    for (i = [0 : 120 : 360]) {
        rotate([0, 0, i])
            translate([-hw / 2, -w / 2, 0])
            cube([hw, w, h]);
    }
}

// -----------------------------------------------------------

difference() {
    union() {
        // shaft
        translate([0, 0, base_height])
            cylinder(d = hexagon_size + (wall_size * 2), h = nut_height);
        
        // base
        cylinder(d = base_size, h = base_height);
    }
    
    // cut out for nut
    hexagon(w = hexagon_size, h = base_height + nut_height);
    
    // cut outs for fingers
    for (i = [0 : cut_out_count]) {
        rotate([0, 0, (360 / cut_out_count) * i])
            translate([(base_size / 2), 0, 0])
            cylinder(d = base_size * cut_out_factor, h = base_height);
    }
}
