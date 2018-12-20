// Soda bottle cap Co2 dispensing adapter
// Made in July 2017 by xythobuz@xythobuz.de
// Licensed under CC-BY-SA-NC

// Necks & Caps for DIY projects
// Xavan June 2016
// https://www.thingiverse.com/thing:1654620
// Minimum Radius: ~15mm
// License: CC-BY
include <NecksCaps.scad>;

// cap-type specific
diameter = 30.4;
wall_height = 1.5;

// Universal Hose Coupler & Funnel Maker
// Mooncactus January 2013
// https://www.thingiverse.com/thing:44850
// License: CC-BY-SA
include <HoseAdapter.scad>;

channel_diameter = 4;
wall_size = 4;
pipe_diameter = 4;
pipe_wall_size = 2.2;
pipe_height = 20;

hose_offset = 6.5;

thread_diameter = 5;
thread_pitch = 0.8;
thread_height = 15;

thread2_diameter = 5;
thread2_pitch = 0.8;
thread2_height = 10;

oring_height = 2.2;
oring_dia_add = 4.2;

// OpenSCAD Threads
// http://dkprojects.net/openscad-threads/
//include <threads.scad>;

// threads are not really useful in these sizes...
module metric_thread(dia, pitch, height, internal) {
    cylinder(d = dia - pitch, h = height);
}

module cap() {
    rotate([180, 0, 0])
        //38mm3start (); // diameter: 42, radius: 21
        28PCO1810 (); // diameter: 30.43, radius: 15.215
        //28PCO1881 (); // diameter: 30.4, radius: 15.2
    
    cylinder(d = diameter, h = channel_diameter + (2 * wall_size));
}

module adapter() {
    difference() {
        cap();
        
        // gas input hole
        translate([-diameter / 2 - 1, 0, (channel_diameter / 2) + wall_size])
            rotate([0, 90, 0])
            cylinder(d = channel_diameter, h = diameter / 2 - wall_size + 1);
        
        // liquid output hole
        translate([wall_size, 0, (channel_diameter / 2) + wall_size])
            rotate([0, 90, 0])
            cylinder(d = channel_diameter, h = diameter / 2 - wall_size + 1);
        
        // gas input outlet
        translate([-wall_size, 0, wall_size + channel_diameter - 20])
            cylinder(d = channel_diameter, h = 20);
        
        // liquid output inlet
        translate([wall_size, 0, wall_size + channel_diameter - 20])
            cylinder(d = channel_diameter, h = 20);
        
        // gas input thread
        translate([-diameter / 2 - 1, 0, (channel_diameter / 2) + wall_size])
        rotate([0, 90, 0]) {
            metric_thread(thread2_diameter, thread2_pitch, thread2_height + 1, internal = true);
            cylinder(d = thread2_diameter + oring_dia_add, h = oring_height + 1);
        }
        
        // liquid output thread
        translate([diameter / 2 - thread2_height, 0, (channel_diameter / 2) + wall_size])
        rotate([0, 90, 0]) {
            metric_thread(thread2_diameter, thread2_pitch, thread2_height + 1, internal = true);
            translate([0, 0, thread2_height - oring_height])
                cylinder(d = thread2_diameter + oring_dia_add, h = oring_height + 1);
        }
    }
    
    // liquit output inlet
    translate([wall_size, 0, -pipe_height - wall_height])
    difference() {
        cylinder(d = pipe_diameter + (2 * pipe_wall_size), h = pipe_height);
        
        translate([0, 0, -1])
            cylinder(d = pipe_diameter, h = pipe_height + 2);
        
        translate([0, 0, -1])
            metric_thread(thread_diameter, thread_pitch, thread_height + 1, internal = true);
    }
    
    /*
    // inlet hose adapter
    translate([-diameter - hose_offset, 0, 6])
        rotate([0, 90, 0])
        tube_adapter();
    
    // outlet hose adapter
    translate([diameter + hose_offset, 0, 6])
        rotate([0, -90, 0])
        tube_adapter();
    */
}

translate([0, 0, channel_diameter + (2 * wall_size)])
rotate([180, 0, 0])
    adapter();
