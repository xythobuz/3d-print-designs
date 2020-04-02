include <roundedcube.scad>

$fn = 50;

bodies_gap = 0.05;

laser_dia = 6.5;
laser_len = 14.0;

bat_width = 18.0;
bat_length = 30.0;
bat_height = 9.0;
bat_case_add = 1.0;

switch_hole_dia = 2.2;
switch_hole_dist = 15.0;
switch_length = 19.6;
switch_length_body = 10.6;
switch_width = 5.7;
switch_height = 12.0 + 2.0;
switch_nub = 3.0;

body_width = 25.0;
body_length = 50.0;
body_height = 42.0;
body_frame_offset = 2.5;
body_frame_gap = 0.5;
body_cube_rounding = 1.0;
body_bat_off = 5.5;
body_switch_off_x = bat_height + 6.0;
body_switch_off_y = 4.0;
body_switch_add = 0.5;
body_hole_dia_left = 2.5;
body_hole_dia_right = 2.2;
body_hole_off_x = 2.2;
body_hole_off_z = body_hole_off_x;
body_rail_lock_off_x = 10.0;
body_rail_lock_off_z = 4.0;

rail_width = 21.2;
rail_height = 8.2;
rail_lip_width_small = 1.3;
rail_lip_width_big = 3.3;
rail_lip_height = 1.0;

rail_lock_width = 20.0;
rail_lock_depth = 10.0;
rail_lock_base_height = 3.0;
rail_lock_pin_size = 5.0;
rail_lock_pin_width = 10.0;
rail_lock_pin_height = 5.0;
rail_lock_tab_len = 1.0;
rail_lock_tab_depth = 2.0;
rail_lock_whole_width = body_width + (2 * rail_lock_tab_len);
rail_lock_tab_width = (rail_lock_whole_width - rail_lock_width) / 2;
rail_lock_travel = 5.0;
rail_lock_spring_dia = 7.0;
rail_lock_spring_hole = 1.0;

frame_gap = 0.25;
frame_sphere = 20;
frame_add_touch = 4.0;
frame_wall = 1.5;
frame_mount_hole = 3.0;
frame_mount_hole_off = 6.0;
frame_mid_len = (frame_mount_hole / 4) + (2 * frame_wall);
frame_mid_dia = laser_dia + (2 * frame_wall);
frame_tail_len = 8.0;
frame_tail_width = frame_mid_dia + 0.5;
frame_negative_width = frame_sphere * 2 / 3 + 7;
frame_hole_dia = 2.9;
frame_hole_dia_arch = 3.3;
frame_hole_off = 1.8;
frame_hole_neg_off = 10;
frame_hole_neg_len = 15;
frame_hole_neg_deg_a = 9;
frame_hole_neg_deg_b = frame_hole_neg_deg_a;

frame_hole_neg_rad_small = frame_mid_len + ((frame_sphere + frame_tail_len) / 2) - frame_hole_off;
frame_hole_neg_rad_large = frame_mid_len + ((frame_sphere + frame_tail_len) / 2) + frame_hole_off;
frame_len = frame_sphere + frame_mid_len + frame_tail_len;

//body_frame_off = body_height - rail_height - (frame_sphere / 2) - body_frame_offset;
body_frame_off = (frame_sphere / 2) + body_frame_offset;

module rail_lip(l) {
    hull() {
        translate([-1, -0.001, 0])
        cube([l + 2, 0.2, rail_lip_width_big]);
        translate([-1, rail_lip_height - 0.001, (rail_lip_width_big - rail_lip_width_small) / 2])
        cube([l + 2, 0.001, rail_lip_width_small]);
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

module rail_lock_internal(add = 0.0) {
    if (add == 0) {
        cube([rail_lock_width + add, rail_lock_depth + add, rail_lock_base_height + add], center = true);
    
        translate([(rail_lock_width + add + rail_lock_tab_width + add) / 2, 0, 0])
        cube([rail_lock_tab_width + add, rail_lock_tab_depth + add, rail_lock_base_height + add], center = true);
        
        translate([-(rail_lock_width + add + rail_lock_tab_width + add) / 2, 0, 0])
        cube([rail_lock_tab_width + add, rail_lock_tab_depth + add, rail_lock_base_height + add], center = true);
    } else {
        translate([0, 0, -rail_lock_travel / 2]) {
            cube([rail_lock_width + add + 0.001, rail_lock_depth + add, rail_lock_base_height + add + rail_lock_travel + 0.001], center = true);
        
            translate([(rail_lock_width + add + rail_lock_tab_width + add) / 2, 0, 0])
            cube([rail_lock_tab_width + add, rail_lock_tab_depth + add, rail_lock_base_height + add + rail_lock_travel], center = true);
            
            translate([-(rail_lock_width + add + rail_lock_tab_width + add) / 2, 0, 0])
            cube([rail_lock_tab_width + add, rail_lock_tab_depth + add, rail_lock_base_height + add + rail_lock_travel], center = true);
        }
    }
    
    translate([0, 0, (rail_lock_base_height + add + rail_lock_pin_height + add) / 2])
    cube([rail_lock_pin_width + add, rail_lock_pin_size + add, rail_lock_pin_height + add], center = true);
}

module rail_lock(add = 0.0) {
    if (add == 0) {
        difference() {
            rail_lock_internal(add);
            
            translate([0, 0, -rail_lock_spring_hole - rail_lock_base_height / 2])
            cylinder(d = rail_lock_spring_dia, h = rail_lock_spring_hole + 1);
            
            translate([0, -rail_lock_pin_size / 2, (rail_lock_base_height + add + rail_lock_pin_height + add) / 2 - -rail_lock_pin_size / 2])
            rotate([45, 0, 0])
            cube([rail_lock_pin_width + 2, rail_lock_pin_size, rail_lock_pin_height], center = true);
        }
    } else {
        rail_lock_internal(add);
    
        translate([0, 0, -rail_lock_spring_hole - (rail_lock_base_height + add) / 2 - rail_lock_travel])
        cylinder(d = rail_lock_spring_dia, h = rail_lock_spring_hole);
    }
}

module laser() {
    cylinder(d = laser_dia, h = laser_len);
}

module laser_frame_screw_arc(radius, deg) {
    for (r = [-deg : 1 : deg])
    translate([radius, 0, 0])
    rotate([0, 0, r])
    translate([-radius, 0, 0])
    cylinder(d = frame_hole_dia_arch, h = frame_negative_width + frame_hole_neg_len);
}

module laser_frame(added_gap = 0, negative = 0) {
    difference() {
        union() {
            // top sphere
            translate([0, 0, (frame_sphere / 2) + (frame_len - frame_sphere)])
            sphere(d = frame_sphere + added_gap);
            
            if (negative == 0) {
                // mid section
                translate([0, 0, frame_len - frame_sphere - frame_mid_len - 0.5])
                cylinder(d = frame_mid_dia + added_gap, h = frame_mid_len + frame_add_touch + 1.0);
                
                // bottom cube
                translate([-(frame_tail_width + added_gap) / 2, -(frame_tail_width + added_gap) / 2, frame_len - frame_sphere - frame_mid_len - frame_tail_len]) {
                    cube([frame_tail_width + added_gap, frame_tail_width + added_gap, frame_tail_len]);
                    //roundedcube([frame_tail_width + added_gap, frame_tail_width + added_gap, frame_tail_len]);
                }
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
            // cutout for laser itself
            translate([0, 0, -1])
            cylinder(d = laser_dia + (2 * frame_gap), h = frame_len + 2);
        
            // holding screws for laser
            translate([0, 0, frame_len - (frame_mount_hole / 2) - frame_mount_hole_off])
            rotate([0, 90, 45]) {
                cylinder(d = frame_mount_hole, h = frame_sphere);
            
                rotate([-90, 0, 0])
                cylinder(d = frame_mount_hole, h = frame_sphere);
            }
            
            // x-axis holes
            translate([-frame_tail_width / 2 - 1, 0, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) - frame_hole_off])
            rotate([0, 90, 0])
            cylinder(d = frame_hole_dia, h = frame_tail_width + 2);
            
            // y-axis holes
            translate([0, -frame_tail_width / 2 - 1, frame_len - frame_sphere - frame_mid_len - frame_tail_len + (frame_tail_len / 2) + frame_hole_off])
            rotate([-90, 0, 0])
            cylinder(d = frame_hole_dia, h = frame_tail_width + 2);
        }
    }
}

module battery(add = 0.0) {
    translate([-add / 2, -add / 2, -add / 2])
    cube([bat_height + add, bat_width + add, bat_length + add]);
}

module switch(add = 0.0) {
    translate([(switch_length - (switch_length_body + add * 2)) / 2, -add, 0])
    cube([(switch_length_body + add * 2), switch_width + add * 2, switch_height]);
    
    translate([(switch_length - switch_nub) / 2, (switch_width - switch_nub) / 2, switch_height])
    cube([switch_nub, switch_nub, switch_nub]);
    
    translate([(switch_length - switch_length_body) / 4, switch_width / 2, 0]) {
        cylinder(d = switch_hole_dia, h = switch_height + (switch_nub * 4));
        translate([switch_hole_dist, 0, 0])
        cylinder(d = switch_hole_dia, h = switch_height + (switch_nub * 4));
    }
}

module body(hole_dia) {
    difference() {
        // main body part
        cube([body_length, body_width, body_height]);
        //roundedcube([body_length, body_width, body_height], false, body_cube_rounding);
        
        // cutout for rail
        translate([-1, (body_width - rail_width) / 2, body_height - rail_height + 0.001])
        rail(body_length + 2);
        
        // cutout and preview for laser frame
        translate([body_length - frame_len, body_width / 2, body_frame_off])
        rotate([0, 90, 0]) {
            laser_frame(body_frame_gap, 1);
            %laser_frame();
        }
        
        // cutout and preview for battery
        translate([body_bat_off, (body_width - bat_width) / 2, (body_height - rail_height - bat_length) / 2]) {
            battery(bat_case_add);
            %battery();
        }
        
        // cutout and preview for switch
        translate([body_switch_off_x, body_width - switch_height + 0.001, body_height - rail_height - body_switch_off_y])
        rotate([-90, 0, 0]) {
            switch(body_switch_add);
            %switch(0);
            
            // cutout for cabling
            // TODO not very nice,
            // with hardcoded values
            translate([-0.001, -2.5, -8])
            cube([18.5, 30, 9.5]);
        }
        
        // cutout and preview for rail locking mechanism
        translate([body_length - body_rail_lock_off_x, body_width / 2, rail_lock_base_height / 2 + body_height - rail_height - body_rail_lock_off_z])
        rotate([0, 0, 90]) {
            rail_lock(0.5);
            %rail_lock();
        }
        
        // outside screw holes
        translate([body_hole_off_x, -1, body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = body_width + 2);
        translate([body_length - body_hole_off_x, -1, body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = body_width + 2);
        translate([body_hole_off_x, -1, body_height - rail_height - body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = body_width + 2);
        translate([body_length - body_hole_off_x, -1, body_height - rail_height - body_hole_off_z])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = body_width + 2);
    }
}

module body_half(half) {
    difference() {
        if (half == 0) {
            body(body_hole_dia_left);
        } else {
            body(body_hole_dia_right);
        }
        
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
    
    translate([body_length + 10, 20, rail_lock_base_height / 2])
    rotate([0, 0, 90])
    rail_lock(0);
    
    // simple brim
    //translate([-10, -10, 0])
    //cube([80, 95, 0.2]);
}

//laser_frame();
rail_lock();

//body_half(0);
//body_half(1);

//print();
