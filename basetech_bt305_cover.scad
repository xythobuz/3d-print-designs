// 0=none, 1=usb, 2=bluetooth
add_optional_module = 2;

face_width = 130;
face_height = 150;
face_wall = 6.0;

border_bottom = 3.55;
border_top = 3.65;

inner_width = 126.65;
inner_height = 148;
inner_depth = 10;

top_wall_height = 15.0;
top_support_height = 12;
top_support_depth = 1.9;
bottom_wall_width = 119.5;
bottom_wall_height = 6.75;

cutout_width = 118.4;
cutout_height = 145;
cutout_bottom = 1.7;
bottom_cut_width = cutout_width + 4;
bottom_cut_height = 3;
bottom_cut_depth = inner_depth;

connector_dist_x = 0;//12;
connector_dist_y = 17;//30;//15;
connector_off_x = 25; //18;
connector_off_y = 58;//65; //105;
connector_dia_outer = 14.0;
connector_len_top = 21.7;
connector_dia_post = 4.3;
connector_len_post = 15.5;
connector_ring_dia = 7.5;
conenctor_ring_tab_width = 2.0;
connector_ring_tab_len = 1.0;
connector_ring_height = 2.7 + 0.3;

screw_a_head_height = 2.0;
screw_a_head_d1 = 6.2;
screw_a_head_d2 = 3.5;
screw_a_off_z = top_wall_height + top_support_height / 2;
screw_a_dist = 22.0 - screw_a_head_d2;

screw_b_head_height = 2.0;
screw_b_head_d1 = 7.5;
screw_b_head_d2 = 5.0;
screw_b_off_z = 9.8 + screw_b_head_d2 / 2;
screw_b_dist = 82.8 - screw_b_head_d2;

open_size_w = 77;//71;
open_size_h = 40;//39;
open_off_x = 46;
open_off_y = 6;
disp_w = 79;
disp_h = 43;
disp_d = 38;

pcb_width = 96;//93;//72;
pcb_length = 72;//93;
pcb_height = 42;
pcb_off_x = 85;
pcb_off_y = 6;
pcb_screw_dist_length = 64;//86;
pcb_screw_dist_width = 86;//64;
pcb_hole_dia = 3.2;

button_width = 10.0;
button_length = 30;
button_post_height = 11.15;
button_post_dia = 7.0;
button_post_hole = 2.4;
button_pcb_width = 42.2;
button_pcb_height = 31.8;
button_pcb_depth = 1.5;
button_pcb_hole_dist_x = 32;
button_pcb_hole_dist_y = 12;
button_off_x = 6.3;
button_off_y = 15;
button_off_top = 14.8 + 14.15 / 2;

nut_width = 20;
nut_height = 17;
nut_depth = 1.0;
nut_gap = 0.5;
nut_holder_width = (inner_width - cutout_width) / 2;
nut_holder_height = 22.75;
nut_holder_depth = 10 + border_bottom + inner_depth;
nut_holder_off_y = 53.4;

bt_width = 20.5;
bt_height = 40.6;
bt_depth = 1.0;
bt_hole_dia = 3.2;
bt_hole_dist_x = 1.4 + bt_hole_dia / 2;
bt_hole_dist_y = 1.7 + bt_hole_dia / 2;
bt_off_x = 8;
bt_off_y = 105;
bt_post_height = 2;
bt_post_dia = 6;

text_depth = 2;
text_type = "RD DPH5005";
text_type_font = "Liberation Sans:style=Bold";
text_type_size = 10;
text_type_off_x = 8;
text_type_off_y = 75;//13;

text_author = "xythobuz   2021";
text_author_font = "Liberation Sans:style=Bold";
text_author_size = 8;
text_author_off_x = 25;
text_author_off_y = 6;

text_max = [ "0-50 Volt", "0-5 Amps", "0-150 Watt" ];
text_max_font = "Liberation Sans:style=Bold";
text_max_size = 10;
text_max_line_space = 3;
text_max_off_x = 15;
text_max_off_y = 97;

$fn = 42;

module screw(type, length = 30) {
    if (type == 0) {
        translate([0, 0, -0.01])
        cylinder(d2 = screw_a_head_d1, d1 = screw_a_head_d2, h = screw_a_head_height);
        
        translate([0, 0, -length])
        cylinder(d = screw_a_head_d2, h = length);
    } else {
        translate([0, 0, -0.01])
        cylinder(d2 = screw_b_head_d1, d1 = screw_b_head_d2, h = screw_b_head_height);
        
        translate([0, 0, -length])
        cylinder(d = screw_b_head_d2, h = length);
    }
}

module text_cutouts() {
    translate([face_width - text_type_off_x, face_height - text_type_off_y, text_depth])
    rotate([0, 180, 0])
    linear_extrude(text_depth + 1)
    text(text_type, size = text_type_size, font = text_type_font);
    
    translate([face_width - text_author_off_x, text_author_off_y, text_depth])
    rotate([0, 180, 0])
    linear_extrude(text_depth + 1)
    text(text_author, size = text_author_size, font = text_author_font);
    
    for (i = [0 : len(text_max) - 1])
    translate([face_width - text_max_off_x, face_height - text_max_off_y - i * (text_max_size + text_max_line_space), text_depth])
    rotate([0, 180, 0])
    linear_extrude(text_depth + 1)
    text(text_max[i], size = text_max_size, font = text_max_font);
}

module nut_holder(only_cutout = 0) {
    difference() {
        if (!only_cutout)
        color("green")
        cube([nut_holder_width, nut_holder_height, nut_holder_depth]);
        
        union() {
            translate([(nut_holder_width - nut_depth - 2 * nut_gap) / 2, (nut_holder_height - nut_width - 2 * nut_gap) / 2, nut_holder_depth - nut_height - nut_gap])
            cube([nut_depth + 2 * nut_gap, nut_width + 2 * nut_gap, nut_height + nut_gap + 1]);
            
            translate([-1, (nut_holder_height - nut_width / 2) / 2, nut_holder_depth - nut_height])
            cube([nut_holder_width / 2 + 1, nut_width / 2, nut_height + 1]);
            
            translate([nut_holder_width / 2, (nut_holder_height - nut_width / 2) / 2, nut_holder_depth - nut_height / 2])
            cube([nut_holder_width / 2 + 1, nut_width / 2, nut_height / 2 + 1]);
        }
    }
    
    %color("red")
    if (!only_cutout)
    translate([(nut_holder_width - nut_depth) / 2, (nut_holder_height - nut_width) / 2, nut_holder_depth - nut_height])
    cube([nut_depth, nut_width, nut_height]);
}

module face_body() {
    // base / face plate
    cube([face_width, face_height, border_bottom]);
    
    // side supports
    translate([(face_width - inner_width) / 2, 0, border_bottom])
    cube([inner_width, inner_height, inner_depth]);
    
    // top support wall
    translate([0, face_height - border_bottom, 0])
    cube([face_width, border_bottom, top_wall_height]);
    
    // second top support wall
    translate([(face_width - inner_width) / 2, face_height - border_bottom, top_wall_height])
    cube([inner_width, top_support_depth, top_support_height]);
    
    // bottom support wall
    translate([(face_width - bottom_wall_width) / 2, 0, inner_depth + border_bottom])
    cube([bottom_wall_width, cutout_bottom, bottom_wall_height]);
}

module connector_ring_tab(s) {
    difference() {
        union() {
            cylinder(d = connector_ring_dia + s * 3, h = connector_ring_height + s * 2);
            
            translate([-conenctor_ring_tab_width / 2, 0, 0])
            cube([conenctor_ring_tab_width + s, connector_ring_dia / 2 + connector_ring_tab_len + s, connector_ring_height + s * 2]);
        }
        
        if (s != 0)
        translate([0, 0, -1])
        cylinder(d = connector_dia_post, h = connector_ring_height + 2);
    }
}

module connector() {
    translate([0, 0, -connector_len_post + 0.1])
    cylinder(d = connector_dia_post, h = connector_len_post + 0.1);
    
    connector_ring_tab(0);
    
    translate([0, 0, connector_ring_height])
    cylinder(d = connector_dia_outer, h = connector_len_top);
}

module pcb_holes(h) {
    for (i = [-pcb_screw_dist_length / 2, pcb_screw_dist_length / 2])
    for (j = [-pcb_screw_dist_width / 2, pcb_screw_dist_width / 2])
    translate([i, j, -1])
    cylinder(d = pcb_hole_dia, h = h + 2);
}

module pcb() {
    difference() {
        cube([pcb_length, pcb_width, pcb_height]);
        
        translate([pcb_length / 2, pcb_width / 2, 0])
        pcb_holes(pcb_height);
    }
}

module disp() {
    cube([open_size_w - 4, open_size_h - 4, disp_d]);
    
    translate([-(disp_w - open_size_w + 4) / 2, -(disp_h - open_size_h + 4) / 2, -2])
    cube([disp_w, disp_h, 2]);
}

module button(posts = 1, pcb = 1, switch = 1) {
    color("orange")
    if (pcb)
    translate([0, 0, 0.1])
    difference() {
        translate([0, -0, 0])
        cube([button_pcb_width, button_pcb_height, button_pcb_depth]);
        
        for (i = [1, -1])
        translate([button_pcb_width / 2 + i * button_pcb_hole_dist_x / 2, button_pcb_height - button_off_top - i * button_pcb_hole_dist_y / 2, -1])
        cylinder(d = button_post_hole + 1, h = button_pcb_depth + 2);
        
        translate([button_pcb_width / 2, button_pcb_height - button_off_top, -1])
        cylinder(d = 12, h = button_pcb_depth + 2);
    }
    
    color("green")
    if (posts)
    for (i = [1, -1])
    translate([button_pcb_width / 2 + i * button_pcb_hole_dist_x / 2, button_pcb_height - button_off_top - i * button_pcb_hole_dist_y / 2, -button_post_height])
    difference() {
        cylinder(d = button_post_dia, h = button_post_height);
        
        translate([0, 0, -1])
        cylinder(d = button_post_hole, h = button_post_height + 2);
    }
    
    color("red")
    if (switch)
    translate([(button_pcb_width - button_width) / 2, button_pcb_height - button_width / 2 - button_off_top, -button_length])
    cube([button_width, button_width, button_length]);
}

module bluetooth_pcb(post, pcb, holes) {
    color("blue")
    if (pcb)
    difference() {
        cube([bt_width, bt_height, bt_depth]);
        
        for (i = [bt_hole_dist_x, bt_width - bt_hole_dist_x])
        for (j = [bt_hole_dist_y, bt_height - bt_hole_dist_y])
        translate([i, j, -1])
        cylinder(d = bt_hole_dia, h = bt_depth + 2);
    }
    
    color("green")
    if (post)
    for (i = [bt_hole_dist_x, bt_width - bt_hole_dist_x])
    for (j = [bt_hole_dist_y, bt_height - bt_hole_dist_y])
    translate([i, j, -bt_post_height])
    difference() {
        cylinder(d = bt_post_dia, h = bt_post_height);
        
        translate([0, 0, -1])
        cylinder(d = bt_hole_dia, h = bt_post_height + 2);
    }
    
    if (holes)
    for (i = [bt_hole_dist_x, bt_width - bt_hole_dist_x])
    for (j = [bt_hole_dist_y, bt_height - bt_hole_dist_y])
    translate([i, j, -15])
    cylinder(d = bt_hole_dia, h = 21);
}

module face() {
    difference() {
        color("green")
        face_body();
        
        // inner cutout
        translate([(face_width - cutout_width) / 2, cutout_bottom, face_wall])
        cube([cutout_width, cutout_height, inner_depth + border_bottom + top_support_height]);
        
        translate([(face_width - bottom_cut_width) / 2, cutout_bottom, face_wall])
        cube([bottom_cut_width, bottom_cut_height, bottom_cut_depth]);
        
        // holes for power connectors
        for (i = [0 : 2])
        translate([connector_off_x + ((i == 1) ? connector_dist_x : 0), i * connector_dist_y + connector_off_y, connector_ring_height - 0.01])
        rotate([180, 0, 90])
        connector();
        
        // top screws
        for (i = [0 : 1])
        translate([i * screw_a_dist + (face_width - screw_a_dist) / 2, face_height - screw_a_head_height - border_bottom + top_support_depth + 0.1, screw_a_off_z])
        rotate([-90, 0, 0])
        screw(0);
        
        // bottom screws
        for (i = [0 : 1])
        translate([i * screw_b_dist + (face_width - screw_b_dist) / 2, screw_b_head_height - 0.1, screw_b_off_z])
        rotate([90, 0, 0])
        screw(1);
        
        // DPH5005
        translate([open_off_x, face_height - open_size_h - open_off_y, -1])
        cube([open_size_w, open_size_h, face_wall + 2]);
    
        // nut_holders
        translate([(inner_width) / 2 + (face_width - inner_width) / 2, nut_holder_off_y, 0])
        for (i = [-1, 1])
        scale([i, 1, 1])
        translate([(inner_width) / 2 - nut_holder_width, 0, 0])
        nut_holder(1);
        
        text_cutouts();
        
        translate([pcb_off_x, pcb_off_y + pcb_width / 2, -1])
        pcb_holes(face_wall + 2);
    
        translate([button_off_x, button_off_y, face_wall + button_post_height])
        button(0, 0, 1);
    
        // bluetooth
        if (add_optional_module == 2)
        translate([bt_off_x, bt_off_y, face_wall + bt_post_height])
        bluetooth_pcb(0, 0, 1);
    }
    
    // nut_holders
    translate([(inner_width) / 2 + (face_width - inner_width) / 2, nut_holder_off_y, 0])
    for (i = [-1, 1])
    scale([i, 1, 1])
    translate([(inner_width) / 2 - nut_holder_width, 0, 0])
    nut_holder();
    
    // power connectors
    for (i = [0 : 2])
    translate([connector_off_x + ((i == 1) ? connector_dist_x : 0), i * connector_dist_y + connector_off_y, connector_ring_height - 0.01])
    rotate([180, 0, 90]) {
        %color("blue")
        connector();
        
        color("cyan")
        translate([0, 0, -face_wall + 2 * 0.3])
        connector_ring_tab(-0.3);
    }
        
    // DPH5005
    %color("orange")
    translate([open_off_x + 2, face_height - open_size_h - open_off_y + 2, 0])
    disp();
    
    %color("orange")
    translate([-pcb_length / 2 + pcb_off_x, pcb_off_y, face_wall + 2])
    pcb();
    
    translate([button_off_x, button_off_y, face_wall + button_post_height]) {
        button(1, 0, 0);
        %button(0, 1, 1);
    }
    
    // bluetooth
    if (add_optional_module == 2)
    translate([bt_off_x, bt_off_y, face_wall + bt_post_height]) {
        bluetooth_pcb(1, 0, 0);
        %bluetooth_pcb(0, 1, 0);
    }
}

face();
