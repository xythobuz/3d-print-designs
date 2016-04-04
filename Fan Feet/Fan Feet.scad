/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

// -----------------------------------------------------------

fan_width = 120; // [1:200]
fan_depth = 25.5; // [1:100]

hole_diameter = 4; // [1:10]
hole_distance = 7.5; // in x and z direction

wall_size = 5; // [1:10]
height = 20; // [1:100]
width = 25; // [1:100]

// minimum: fan_depth + (2 * wall_size)
base_depth = 60; // [1:100]

// -----------------------------------------------------------

/* [Hidden] */

$fn = 15;
depth = fan_depth + (2 * wall_size);

// -----------------------------------------------------------

module foot_walls() {
    // bottom wall
    translate([0, -(base_depth - depth) / 2, 0])
        cube([width, base_depth, wall_size]);
    
    // outer wall
    translate([0, 0, wall_size])
        cube([wall_size, depth, height - wall_size]);
    
    // back wall
    translate([wall_size, 0, wall_size])
        cube([width - wall_size, wall_size, height - wall_size]);
    
    // front wall
    translate([wall_size, fan_depth + wall_size, wall_size])
        cube([width - wall_size, wall_size, height - wall_size]);
}

module foot() {
    difference() {
        // solid parts
        foot_walls();
        
        // cut out screw hole
        translate([wall_size + hole_distance, depth + (wall_size / 2), wall_size + hole_distance])
            rotate([90, 0, 0])
            cylinder(d = hole_diameter, h = depth + wall_size);
    }
}

// -----------------------------------------------------------

// Visualize fan
%translate([wall_size, wall_size, wall_size])
    cube([fan_width, fan_depth, fan_width]);

foot();

// Visualize second foot (print twice!)
%translate([fan_width + (2 * wall_size), depth, 0])
    rotate([0, 0, 180])
    foot();
