width = 67;
height = 67.5;
hole_nub = 5;
hole = 2;
hole_width = 60;
hole_height = 40;
hole_offset_top = 3;
wall_size = 1.4;

depth_top = 3.6;
depth_pcb = 1.6;
depth_bottom = 4.1;
depth_gap = 0.4;
depth = depth_top + depth_pcb + depth_bottom + depth_gap;
screw_nub_depth = depth_bottom + depth_gap;

$fn = 20;

module nub() {
    difference() {
        cylinder(d = hole_nub, h = screw_nub_depth);
        translate([0, 0, -1])
            cylinder(d = hole, h = screw_nub_depth + 2);
    }
}

module nubs() {
    nub();
    
    translate([hole_width, 0, 0])
        nub();
    
    translate([0, hole_height, 0])
        nub();
    
    translate([hole_width, hole_height, 0])
        nub();
}

// base
cube([width + (2 * wall_size), height + (2 * wall_size), wall_size]);

// left wall
difference() {
    translate([0, 0, wall_size])
        cube([wall_size, height + (2 * wall_size), depth]);
    
    translate([-1, wall_size + height - hole_offset_top - hole_height + hole_nub, wall_size])
        cube([wall_size + 2, hole_nub, hole]);
}

// bottom wall
translate([0, 0, wall_size])
    cube([width + (2 * wall_size), wall_size, depth]);

// right wall
translate([width + wall_size, 0, wall_size])
    cube([wall_size, height + (2 * wall_size), depth]);

// top wall
translate([0, height + wall_size, wall_size])
    cube([width + (2 * wall_size), wall_size, depth]);

translate([wall_size + (width - hole_width) / 2, wall_size + height - hole_height - hole_offset_top, wall_size])
    nubs();
