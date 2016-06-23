/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in June 2016
 *
 * Licensed under the
 * Creative Commons - Attribution - Share Alike license.
 */

// -----------------------------------------------------------

dist_x = 44;
dist_y = 68.5;
height = 35;
base_height = 2;
diameter = 6.5;
hole = 2.5;
cuts = 4;

vtx_width = 21;
vtx_height = 28;
vtx_x = ((dist_x - vtx_width) / 2) - 3;
vtx_y = 2;
vtx_off_1 = 0.15;
vtx_off_2 = 0.5;

osd_width = 51;
osd_height = 24;
osd_x = (dist_x - osd_width) / 2;
osd_y = dist_y - osd_height - 6;
osd_off_1 = 0.3;
osd_off_2 = 0.7;

display_hole = 3;
display_width = 6;
display_length = 6;
display_depth = 2;
display_depth_add = 2;
display_dist = 21;
display_off_x = 13;
display_off_y = 2.23;
display_off_z = -3.08;
display_angle = 35;

add_handle = 0; // [0,1]
handle = 3;

helper_plate = 0.2;

$fn = 25;

// -----------------------------------------------------------

module leg() {
    difference() {
        cylinder(d = diameter, h = height);
        
        translate([0, 0, -1])
            cylinder(d = hole, h = height + 2);
    }
}

module legs() {
    leg();
    
    translate([dist_x, 0, 0])
        leg();
    
    translate([dist_x, dist_y, 0])
        leg();
    
    translate([0, dist_y, 0])
        leg();
}

module handle() {
    rotate([90, 0, 0])
    translate([dist_x / 2, dist_y / 2 + handle / 2, base_height])
    difference() {
        cylinder(d = dist_x, h = handle);
        translate([0, 0, -1])
            cylinder(d = dist_x - handle, h = handle + 2);
        translate([-dist_x / 2, -dist_x / 2, -1])
            cube([dist_x, dist_x / 2, handle + 2]);
    }
}

module display_nub() {
    translate([0, 0, -display_depth_add])
    difference() {
        cube([display_width, display_length, display_depth + display_depth_add]);
        translate([display_width / 2, display_width / 2, -1])
            cylinder(d = display_hole, h = display_depth + display_depth_add + 2);
    }
}

module display() {
    translate([display_off_x, -display_length + display_off_y, display_off_z])
    rotate([display_angle, 0, 0])
    union() {
        display_nub();
        translate([display_dist, 0, 0])
            display_nub();
    }
}

module base() {
    difference() {
        cube([dist_x, dist_y, base_height]);
        
        // VTX holes
        translate([vtx_x - (cuts / 2), vtx_y + (cuts / 2) + (vtx_off_1 * vtx_height), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([vtx_x - (cuts / 2), vtx_y + (cuts / 2) + (vtx_off_2 * vtx_height), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([vtx_x + (cuts / 2) + vtx_width, vtx_y + (cuts / 2) + (vtx_off_1 * vtx_height), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([vtx_x + (cuts / 2) + vtx_width, vtx_y + (cuts / 2) + (vtx_off_2 * vtx_height), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        // OSD holes
        translate([osd_x - (cuts / 2) + (osd_off_1 * osd_width), osd_y - (cuts / 2), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([osd_x - (cuts / 2) + (osd_off_2 * osd_width), osd_y - (cuts / 2), -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([osd_x - (cuts / 2) + (osd_off_1 * osd_width), osd_y + (cuts / 2) + osd_height, -1])
            cylinder(d = cuts, h = base_height + 2);
        
        translate([osd_x - (cuts / 2) + (osd_off_2 * osd_width), osd_y + (cuts / 2) + osd_height, -1])
            cylinder(d = cuts, h = base_height + 2);
    }
    
    translate([-diameter / 2, -diameter / 2, base_height - helper_plate])
        cube([dist_x + diameter, dist_y + diameter, helper_plate]);
    
    cylinder(d = diameter, h = base_height);
    
    translate([dist_x, 0, 0])
        cylinder(d = diameter, h = base_height);
    
    translate([dist_x, dist_y, 0])
        cylinder(d = diameter, h = base_height);
    
    translate([0, dist_y, 0])
        cylinder(d = diameter, h = base_height);
    
    display();
    
    if (add_handle) {
        handle();
    }
}

// -----------------------------------------------------------

translate([dist_x, 0, base_height + height])
rotate([0, 180, 0])
union() {
    legs();
    
    translate([0, 0, height])
        base();
    
    %translate([vtx_x, vtx_y, height + base_height])
        cube([vtx_width, vtx_height, 5]);
    
    %translate([osd_x, osd_y, height + base_height])
        cube([osd_width, osd_height, 10]);
}
