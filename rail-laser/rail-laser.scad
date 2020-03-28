include <roundedcube.scad>

$fn = 50;

rail_width = 21.0 + 0.2;
rail_height = 6.0 + 0.2 + 2;
rail_lip_width_small = 1.5 - 0.2;
rail_lip_width_big = 3.5 - 0.2;
rail_lip_height = 1.1 - 0.1;

module rail_lip(l) {
    hull() {
        translate([-1, -0.1, 0])
        cube([l + 2, 0.2, rail_lip_width_big]);
        translate([-1, rail_lip_height - 0.1, (rail_lip_width_big - rail_lip_width_small) / 2])
        cube([l + 2, 0.1, rail_lip_width_small]);
    }
}

module rail(l) {
    difference() {
        cube([l, rail_width, rail_height]);
        
        translate([0, 0, rail_height - rail_lip_width_big]) {
            rail_lip(l);
            
            translate([l, rail_width, 0])
            rotate([0, 0, 180])
            rail_lip(l);
        }
    }
}

laser_dia = 6.5;
laser_len = 14.0;

module laser() {
    cylinder(d = laser_dia, h = laser_len);
}

frame_gap = 0.2;
frame_sphere = 20;
frame_add_touch = 4.0;
frame_wall = 1.5;
frame_mount_hole = 2.0;
frame_mid_len = frame_mount_hole + (2 * frame_wall);
frame_mid_dia = laser_dia + (2 * frame_wall);
frame_tail_len = 8.0;
frame_tail_width = frame_mid_dia + 0.5;
frame_negative_width = frame_sphere * 2 / 3 + 7;
frame_hole_dia = 2.9;
frame_hole_off = 1.8;
frame_hole_neg_off = 10;
frame_hole_neg_len = 15;
frame_hole_neg_deg_a = 9;
frame_hole_neg_deg_b = frame_hole_neg_deg_a;
frame_hole_neg_rad_small = frame_mid_len + ((frame_sphere + frame_tail_len) / 2) - frame_hole_off;
frame_hole_neg_rad_large = frame_mid_len + ((frame_sphere + frame_tail_len) / 2) + frame_hole_off;
frame_len = frame_sphere + frame_mid_len + frame_tail_len;

module laser_frame_screw_arc(radius, deg) {
    for (r = [-deg : 1 : deg])
    translate([radius, 0, 0])
    rotate([0, 0, r])
    translate([-radius, 0, 0])
    cylinder(d = frame_hole_dia, h = frame_negative_width + frame_hole_neg_len);
}

module laser_frame(added_gap = 0, negative = 0) {
    difference() {
        union() {
            translate([0, 0, (frame_sphere / 2) + (frame_len - frame_sphere)])
            sphere(d = frame_sphere + added_gap);
            
            if (negative == 0) {
                translate([0, 0, frame_len - frame_sphere - frame_mid_len - 0.5])
                cylinder(d = frame_mid_dia + added_gap, h = frame_mid_len + frame_add_touch + 1.0);
                
                translate([-(frame_tail_width + added_gap) / 2, -(frame_tail_width + added_gap) / 2, frame_len - frame_sphere - frame_mid_len - frame_tail_len])
                roundedcube([frame_tail_width + added_gap, frame_tail_width + added_gap, frame_tail_len]);
            } else {
                translate([0, 0, frame_len - frame_add_touch])
                cylinder(d = laser_dia + added_gap, h = frame_mid_len + frame_add_touch);
                
                translate([-frame_negative_width / 2, -frame_negative_width / 2, frame_len - frame_sphere - frame_mid_len - frame_tail_len - (added_gap * 3) - 1])
                cube([frame_negative_width, frame_negative_width, frame_len - frame_sphere + frame_add_touch + (added_gap * 3) + 1]);
            
                translate([-frame_hole_neg_off + frame_negative_width + frame_hole_neg_len, 0, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) - frame_hole_off])
                rotate([0, -90, 0])
                laser_frame_screw_arc(frame_hole_neg_rad_large, frame_hole_neg_deg_a);
            
                translate([0, -frame_hole_neg_off, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) + frame_hole_off])
                rotate([-90, -90, 0])
                laser_frame_screw_arc(frame_hole_neg_rad_small, frame_hole_neg_deg_b);
            }
        }
        
        if (negative == 0) {
            translate([0, 0, -1])
            cylinder(d = laser_dia + (2 * frame_gap), h = frame_len + 2);
        
            translate([0, 0, (frame_len - frame_sphere - frame_mid_len) + (frame_mid_len / 2)])
            rotate([0, 90, 0]) {
                cylinder(d = frame_mount_hole, h = frame_mid_dia);
            
                rotate([-90, 0, 0])
                cylinder(d = frame_mount_hole, h = frame_mid_dia);
            }
            
            translate([-frame_tail_width / 2 - 1, 0, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) - frame_hole_off])
            rotate([0, 90, 0])
            cylinder(d = frame_hole_dia, h = frame_tail_width + 2);
            
            translate([0, -frame_tail_width / 2 - 1, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) + frame_hole_off])
            rotate([-90, 0, 0])
            cylinder(d = frame_hole_dia, h = frame_tail_width + 2);
        }
    }
}

body_width = 25.0;
body_length = 45.0;
body_height = 35.0;
body_frame_gap = 0.5;
body_frame_off = 15;
body_cube_rounding = 1.0;

body_hole_dia = 2.2;
body_hole_off_x = 2.2;
body_hole_off_z = body_hole_off_x;

module body() {
    difference() {
        //cube([body_length, body_width, body_height]);
        roundedcube([body_length, body_width, body_height], false, body_cube_rounding);
        
        translate([-1, (body_width - rail_width) / 2, body_height - rail_height + 0.1])
        rail(body_length + 2);
        
        translate([body_length - frame_len, body_width / 2, body_frame_off])
        rotate([0, 90, 0]) {
            laser_frame(body_frame_gap, 1);
            %laser_frame();
        }
        
        translate([body_hole_off_x, -1, body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = body_hole_dia, h = body_width + 2);
        translate([body_length - body_hole_off_x, -1, body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = body_hole_dia, h = body_width + 2);
        translate([body_hole_off_x, -1, body_height - rail_height - body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = body_hole_dia, h = body_width + 2);
        translate([body_length - body_hole_off_x, -1, body_height - rail_height - body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = body_hole_dia, h = body_width + 2);
        
        translate([-1, body_width / 2, body_height / 2.35])
        rotate([0, 90, 0])
        cylinder(d = 10, h = 20);
    }
}

bodies_gap = 0.05;

module body_half(half = 0) {
    difference() {
        body();
        
        if (half == 0) {
            translate([-1, (bodies_gap - body_width) / 2, -1])
            cube([body_length + 2, body_width, body_height + 2]);
        } else {
            translate([-1, (body_width - bodies_gap) / 2, -1])
            cube([body_length + 2, body_width, body_height + 2]);
            
        }
    }
}

module print() {
    translate([0, 0, body_width])
    rotate([-90, 0, 0])
    body_half(0);
    
    translate([0, body_height * 2 + 5, 0])
    rotate([90, 0, 0])
    body_half(1);
    
    translate([body_length + 10, body_height + 2, 0])
    laser_frame(0, 0);
}

//laser_frame(0, 0);
//laser_frame(0.5, 1);

//body_half(0);
//body_half(1);
//body();

print();
