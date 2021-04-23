include <threads.scad>

outer_dia = 32;
thread_dia = 28.3;
thread_pitch = 3.5;
thread_width = 4.0;
thread_angle = 45 + 15;
thread_height = thread_pitch * 2;
thread_min_dia = 26;
height = 15;
top_wall = 2;
hose_hole = 6.7;
air_hole = 2.0;
bot_height = height - top_wall - thread_height;

show_cutout = false;

$fn = 42;

module cutout() {
    translate([0, 0, -0.01])
    cylinder(d = thread_dia, h = bot_height + 0.02);
    
    cylinder(d = thread_min_dia, h = bot_height + thread_height);
    
    translate([0, 0, bot_height])
    metric_thread(diameter=thread_dia, pitch=thread_pitch, length=thread_height, internal=true, thread_size=thread_width, rectangle=0, angle=thread_angle);
    
    translate([0, 0, bot_height + thread_height - 1]) {
        translate([3, 0, 0])
        cylinder(d = hose_hole, h = top_wall + 2);
        
        translate([-5, 0, 0])
        cylinder(d = air_hole, h = top_wall + 2);
    }
}

module bottlecap() {
    difference() {
        cylinder(d = outer_dia, h = height);
        cutout();
    }
}

if (show_cutout) {
    cutout();
} else {
    translate([0, 0, height])
    rotate([180, 0, 0])
    bottlecap();
}