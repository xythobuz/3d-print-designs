// sparkfun 20x4 serial lcd
lcd_pcb_width = 105;
lcd_pcb_depth = 60;
lcd_pcb_height = 1.6;
lcd_bezel_width = 87.5;
lcd_bezel_depth = 41.85;
lcd_bezel_height = 9.4;
lcd_bezel_off_x = 5.4;
lcd_bezel_off_y = 9.05;
lcd_hole_dia = 2.9;
lcd_hole_off = 2.5;
lcd_hole_dist_x = 95.75 - lcd_hole_dia;
lcd_hole_dist_y = 58 - lcd_hole_dia;
lcd_negative_dist = 2.0;
lcd_spacer_height = 3;
lcd_spacer_dia = lcd_hole_dia + 5.0;
lcd_spacer_hole_dia = lcd_hole_dia + 0.3;

lcd_negative_width = lcd_bezel_width + lcd_negative_dist;
lcd_negative_depth = lcd_bezel_depth + lcd_negative_dist;
lcd_negative_off_x = lcd_bezel_off_x - (lcd_negative_width - lcd_bezel_width) / 2;
lcd_negative_off_y = lcd_bezel_off_y - (lcd_negative_depth - lcd_bezel_depth) / 2;

keypad_base_width = 51.2;
keypad_base_depth = 64.1;
keypad_base_height = 3.1;
keypad_top_width = 46.0;
keypad_top_depth = 57.3;
keypad_top_height = 5.2;
keypad_top_off_x = 2.5;
keypad_top_off_y = 3.4;
keypad_hole_dia = 2.7;
keypad_hole_off_x = 1.45 + keypad_hole_dia / 2;
keypad_hole_off_y = 1.35 + keypad_hole_dia / 2;
keypad_hole_dist_x = 48.9 - keypad_hole_dia;
keypad_hole_dist_y = 61.4 - keypad_hole_dia;
keypad_negative_dist = 1.0;
keypad_spacer_dia = keypad_hole_dia + 2.0;
keypad_spacer_hole_dia = keypad_hole_dia;
keypad_spacer_height = 0; // TODO too big and not needed

voltmeter_width = 22.85;
voltmeter_depth = 11.1;
voltmeter_height = 1.0;
voltmeter_display_height = 6.4;
voltmeter_tab_width = 3.65;
voltmeter_tab_depth = 4.4;
voltmeter_hole_dia = 2.25;
voltmeter_spacer_hole_dia = voltmeter_hole_dia;
voltmeter_negative_add = 0.5;

voltmeter_off_x = 15;
voltmeter_off_y = 6;
voltmeter_dist = voltmeter_depth + 2;

switch_width = 18.2;
switch_depth = 11.5;
switch_height = 11.0;
switch_top_width = 20.8;
switch_top_depth = 14.8;
switch_top_height = 2.1;
switch_off_x = 18;
switch_off_y = 3;
switch_add_negative = 1.0;

mount_dist = 5;
mount_support_prism = 10;
mount_width = lcd_pcb_width + mount_dist;
mount_depth = lcd_pcb_depth + keypad_base_depth + mount_dist * 2 + mount_support_prism;
mount_height = 5;
mount_support_usable_depth = 15;
mount_support_depth = mount_height + mount_support_prism + mount_support_usable_depth;
mount_hole_dia = 4.3;
mount_hole_off = 30;

wall = 5;
wall_hole = 4.3;
wall_prism = 5;
wall_height = 30;
wall_mount_off_x = 1;
wall_mount_off_y = 1;
wall_width = mount_width + wall + wall_prism + wall_mount_off_x;
wall_depth = mount_support_depth + wall + wall_mount_off_y;

text_bottom = "Gieß-o-mat";
text_bottom_font = "Liberation Sans:style=Bold";
text_bottom_h = 10;
text_bottom_d = 0.5;
text_bottom_off = 3.5;
text_bottom_spacing = 1.3;

text_side = "xythobuz";
text_side_font = "Liberation Sans:style=Bold";
text_side_h = 7;
text_side_d = 0.5;
text_side_off = 4.2;
text_side_spacing = 1.0;

voltmeter_text_left_1 = "Co";
voltmeter_text_left_2 = "Va";
voltmeter_text_left_3 = "Re";
voltmeter_text_left_4 = "Pu";
voltmeter_text_left_font = "Liberation Sans:style=Bold";
voltmeter_text_left_h = 8;
voltmeter_text_left_d = 0.5;
voltmeter_text_left_off_x = 11.5;
voltmeter_text_left_off_y = 1.5;
voltmeter_text_left_spacing = 1.0;

voltmeter_text_right = "V";
voltmeter_text_right_font = "Liberation Sans:style=Bold";
voltmeter_text_right_h = 8;
voltmeter_text_right_d = 0.5;
voltmeter_text_right_off_x = 4.4;
voltmeter_text_right_off_y = 1.5;
voltmeter_text_right_spacing = 1.0;

switch_text_left = "Off";
switch_text_right = "On";
switch_text_font = "Liberation Sans:style=Bold";
switch_text_h = 6.5;
switch_text_d = 0.5;
switch_text_off_x = 10.5;
switch_text_off_y = 2.5;
switch_text_dist_x = switch_top_width + 16.0;
switch_text_spacing = 1.0;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module spacer(do, di, h) {
    difference() {
        cylinder(d = do, h = h);
        
        translate([0, 0, -1])
        cylinder(d = di, h = h + 2);
    }
}

module lcd() {
    difference() {
        cube([lcd_pcb_width, lcd_pcb_depth, lcd_pcb_height]);
        
        translate([lcd_hole_off, lcd_hole_off, -1])
        cylinder(d = lcd_hole_dia, h = lcd_pcb_height + 2);
        
        translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off, -1])
        cylinder(d = lcd_hole_dia, h = lcd_pcb_height + 2);
        
        translate([lcd_hole_off, lcd_hole_off + lcd_hole_dist_y, -1])
        cylinder(d = lcd_hole_dia, h = lcd_pcb_height + 2);
        
        translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off + lcd_hole_dist_y, -1])
        cylinder(d = lcd_hole_dia, h = lcd_pcb_height + 2);
    }
    
    translate([lcd_bezel_off_x, lcd_bezel_off_y, lcd_pcb_height])
    cube([lcd_bezel_width, lcd_bezel_depth, lcd_bezel_height]);
}

module keypad(l = 0, a = 0) {
    difference() {
        // TODO rounded corners
        cube([keypad_base_width, keypad_base_depth, keypad_base_height]);
        
        translate([keypad_hole_off_x, keypad_hole_off_y, -1])
        cylinder(d = keypad_hole_dia, keypad_base_height + 2);
        
        translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y, -1])
        cylinder(d = keypad_hole_dia, keypad_base_height + 2);
        
        translate([keypad_hole_off_x, keypad_hole_off_y + keypad_hole_dist_y, -1])
        cylinder(d = keypad_hole_dia, keypad_base_height + 2);
        
        translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y + keypad_hole_dist_y, -1])
        cylinder(d = keypad_hole_dia, keypad_base_height + 2);
    }
    
    // TODO rounded corners!
    translate([keypad_top_off_x - a / 2, keypad_top_off_y - a / 2, keypad_base_height])
    cube([keypad_top_width + a, keypad_top_depth + a, keypad_top_height + l]);
}

module voltmeter_tab() {
    difference() {
        translate([0, -voltmeter_tab_depth / 2, 0])
        cube([voltmeter_tab_width, voltmeter_tab_depth, voltmeter_height]);
        
        translate([voltmeter_tab_width / 2, 0, -1])
        cylinder(d = voltmeter_hole_dia, h = voltmeter_height + 2);
    }
}

module voltmeter() {
    cube([voltmeter_width, voltmeter_depth, voltmeter_height + voltmeter_display_height]);
    
    translate([-voltmeter_tab_width, voltmeter_depth / 2, 0])
    voltmeter_tab();
    
    translate([voltmeter_width, voltmeter_depth / 2, 0])
    voltmeter_tab();
}

module mount_voltmeters() {
    for (i = [0 : 3]) {
        translate([0, -voltmeter_dist * i, -1]) {
            translate([-voltmeter_negative_add / 2, -voltmeter_negative_add / 2, 0])
            cube([voltmeter_width + voltmeter_negative_add, voltmeter_depth + voltmeter_negative_add, mount_height + 2]);
            
            translate([-voltmeter_tab_width / 2, voltmeter_depth / 2, 0])
            cylinder(d = voltmeter_spacer_hole_dia, h = mount_height + 2);
            
            translate([voltmeter_width + voltmeter_tab_width / 2, voltmeter_depth / 2, 0])
            cylinder(d = voltmeter_spacer_hole_dia, h = mount_height + 2);
        }
    }
}

module switch(s = 0) {
    translate([-s / 2, -s / 2, s - switch_height])
    cube([switch_width + s, switch_depth + s, switch_height]);
    
    translate([-(switch_top_width - switch_width) / 2, -(switch_top_depth - switch_depth) / 2, s])
    cube([switch_top_width, switch_top_depth, switch_top_height]);
}

switch_mount_base = 11;
switch_mount_hole = 3.2;
switch_mount_base_height = 2;
switch_mount_wall = 3;
switch_mount_add = 3;
switch_mount_width = switch_top_width + 2 * switch_mount_add;
switch_mount_depth = switch_top_depth + 2 * switch_mount_add;
switch_mount_height = 20;

module switch_mount() {
    translate([switch_mount_wall, 0, 0])
    difference() {
        union() {
            cube([switch_mount_base + switch_mount_base_height, switch_mount_base, switch_mount_base_height]);
            
            translate([switch_mount_base_height, 0, switch_mount_base_height])
            rotate([0, 0, 90])
            prism(switch_mount_base, switch_mount_base_height, switch_mount_base_height);
        }
        
        translate([switch_mount_base / 2 + switch_mount_base_height, switch_mount_base / 2, -1])
        cylinder(d = switch_mount_hole, h = switch_mount_base_height + 2);
    }
    
    cube([switch_mount_wall, switch_mount_base, switch_mount_height]);
    
    translate([0, switch_mount_wall, switch_mount_height])
    //scale([-1, 1, 1])
    rotate([90, 0, 0])
    difference() {
        translate([0, 0, -switch_mount_base + switch_mount_wall])
        union() {
            cube([switch_mount_width, switch_mount_depth, switch_mount_base]);
            
            translate([switch_mount_wall, -switch_mount_base_height, switch_mount_base])
            rotate([0, 90, 0])
            prism(switch_mount_base, switch_mount_base_height, switch_mount_base_height);
        }
    
        translate([(switch_mount_width - switch_width) / 2, (switch_mount_depth - switch_depth) / 2, switch_mount_wall]) {
            scale([1, 1, 10])
            switch(switch_add_negative);
        
            %switch();
        }
    }
}

module mount_part() {
    translate([0, mount_height, 0])
    difference() {
        // baseplate
        cube([mount_width, mount_depth, mount_height]);
        
        translate([mount_dist / 2, keypad_base_depth + mount_support_prism + mount_dist * 3 / 2, 0]) {
            // hole for lcd bezel
            translate([lcd_negative_off_x, lcd_negative_off_y, -1])
            cube([lcd_negative_width, lcd_negative_depth, mount_height + 2]);
            
            // holes for lcd screws
            translate([lcd_hole_off, lcd_hole_off, -1])
            cylinder(d = lcd_spacer_hole_dia, h = mount_height + 2);
        
            translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off, -1])
            cylinder(d = lcd_spacer_hole_dia, h = mount_height + 2);
        
            translate([lcd_hole_off, lcd_hole_off + lcd_hole_dist_y, -1])
            cylinder(d = lcd_spacer_hole_dia, h = mount_height + 2);
        
            translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off + lcd_hole_dist_y, -1])
            cylinder(d = lcd_spacer_hole_dia, h = mount_height + 2);
        }
        
        translate([lcd_pcb_width - keypad_base_width + mount_dist / 2, mount_support_prism + mount_dist / 2, 0]) {
            // hole for keypad upper part
            translate([0, 0, -keypad_base_height - 1])
            keypad(mount_height, keypad_negative_dist);
        
            // holes for keypad screws
            translate([keypad_hole_off_x, keypad_hole_off_y, -1])
            cylinder(d = keypad_spacer_hole_dia, h = mount_height + 2);
            
            translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y, -1])
            cylinder(d = keypad_spacer_hole_dia, h = mount_height + 2);
            
            translate([keypad_hole_off_x, keypad_hole_off_y + keypad_hole_dist_y, -1])
            cylinder(d = keypad_spacer_hole_dia, h = mount_height + 2);
            
            translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y + keypad_hole_dist_y, -1])
            cylinder(d = keypad_spacer_hole_dia, h = mount_height + 2);
        }
        
        // holes for voltmeters
        translate([mount_dist / 2 + voltmeter_tab_width + voltmeter_off_x, mount_support_prism + keypad_base_depth + voltmeter_off_y - voltmeter_depth, 0])
        mount_voltmeters();
        
        // hole for switch
        translate([mount_dist / 2 + switch_off_x, mount_support_prism + switch_off_y, mount_height])
        switch(switch_add_negative);
    }
    
    // lcd spacers
    translate([0, mount_height, -lcd_spacer_height])
    translate([mount_dist / 2, keypad_base_depth + mount_support_prism + mount_dist * 3 / 2, 0]) {
        translate([lcd_hole_off, lcd_hole_off, 0])
        spacer(lcd_spacer_dia, lcd_spacer_hole_dia, lcd_spacer_height);
        
        translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off, 0])
        spacer(lcd_spacer_dia, lcd_spacer_hole_dia, lcd_spacer_height);
        
        translate([lcd_hole_off, lcd_hole_off + lcd_hole_dist_y, 0])
        spacer(lcd_spacer_dia, lcd_spacer_hole_dia, lcd_spacer_height);
        
        translate([lcd_hole_off + lcd_hole_dist_x, lcd_hole_off + lcd_hole_dist_y, 0])
        spacer(lcd_spacer_dia, lcd_spacer_hole_dia, lcd_spacer_height);
    }
    
    // keypad spacers
    translate([0, mount_height, -keypad_spacer_height])
    translate([lcd_pcb_width - keypad_base_width + mount_dist / 2, mount_support_prism + mount_dist / 2, 0]) {
        translate([keypad_hole_off_x, keypad_hole_off_y, 0])
        spacer(keypad_spacer_dia, keypad_spacer_hole_dia, keypad_spacer_height);
        
        translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y, 0])
        spacer(keypad_spacer_dia, keypad_spacer_hole_dia, keypad_spacer_height);
        
        translate([keypad_hole_off_x, keypad_hole_off_y + keypad_hole_dist_y, 0])
        spacer(keypad_spacer_dia, keypad_spacer_hole_dia, keypad_spacer_height);
        
        translate([keypad_hole_off_x + keypad_hole_dist_x, keypad_hole_off_y + keypad_hole_dist_y, 0])
        spacer(keypad_spacer_dia, keypad_spacer_hole_dia, keypad_spacer_height);
    }
    
    // bottom mounting plate
    translate([0, 0, mount_height - mount_support_depth])
    difference() {
        cube([mount_width, mount_height, mount_support_depth]);
        
        translate([mount_hole_off, -1, mount_support_usable_depth / 2])
        rotate([-90, 0, 0])
        cylinder(d = mount_hole_dia, h = mount_height + 2);
        
        translate([mount_width - mount_hole_off, -1, mount_support_usable_depth / 2])
        rotate([-90, 0, 0])
        cylinder(d = mount_hole_dia, h = mount_height + 2);
    }
    
    // prism support
    translate([0, mount_support_prism + mount_height, 0])
    rotate([180, 0, 0])
    prism(mount_width, mount_support_prism, mount_support_prism);
}

module texts_voltmeters() {
    for (i = [0 : 3])
    translate([voltmeter_width + voltmeter_text_right_off_x, voltmeter_text_right_off_y - voltmeter_dist * i, -voltmeter_text_right_d]) {
        linear_extrude(height = voltmeter_text_right_d + 0.1)
        text(voltmeter_text_right, font = voltmeter_text_right_font, size = voltmeter_text_right_h, spacing = voltmeter_text_right_spacing, halign = "center");
    }
    
    translate([-voltmeter_tab_width - voltmeter_text_left_off_x, voltmeter_text_left_off_y - voltmeter_dist * 0, -voltmeter_text_left_d])
    linear_extrude(height = voltmeter_text_left_d + 0.1)
    text(voltmeter_text_left_1, font = voltmeter_text_left_font, size = voltmeter_text_left_h, spacing = voltmeter_text_left_spacing, halign = "center");
    
    translate([-voltmeter_tab_width - voltmeter_text_left_off_x, voltmeter_text_left_off_y - voltmeter_dist * 1, -voltmeter_text_left_d])
    linear_extrude(height = voltmeter_text_left_d + 0.1)
    text(voltmeter_text_left_2, font = voltmeter_text_left_font, size = voltmeter_text_left_h, spacing = voltmeter_text_left_spacing, halign = "center");
    
    translate([-voltmeter_tab_width - voltmeter_text_left_off_x, voltmeter_text_left_off_y - voltmeter_dist * 2, -voltmeter_text_left_d])
    linear_extrude(height = voltmeter_text_left_d + 0.1)
    text(voltmeter_text_left_3, font = voltmeter_text_left_font, size = voltmeter_text_left_h, spacing = voltmeter_text_left_spacing, halign = "center");
    
    translate([-voltmeter_tab_width - voltmeter_text_left_off_x, voltmeter_text_left_off_y - voltmeter_dist * 3, -voltmeter_text_left_d])
    linear_extrude(height = voltmeter_text_left_d + 0.1)
    text(voltmeter_text_left_4, font = voltmeter_text_left_font, size = voltmeter_text_left_h, spacing = voltmeter_text_left_spacing, halign = "center");
}

module mount() {
    difference() {
        mount_part();
        
        translate([mount_width / 2, text_bottom_off, mount_height - text_bottom_d])
        linear_extrude(height = text_bottom_d + 0.1)
        text(text_bottom, font = text_bottom_font, size = text_bottom_h, spacing = text_bottom_spacing, halign = "center");
        
        translate([mount_width - text_side_off, mount_height + keypad_base_depth + mount_support_prism + mount_dist * 3 / 2 + lcd_hole_off + lcd_hole_dist_y / 2, mount_height - text_side_d])
        rotate([0, 0, 90])
        linear_extrude(height = text_side_d + 0.1)
        text(text_side, font = text_side_font, size = text_side_h, spacing = text_side_spacing, halign = "center");
        
        translate([mount_dist / 2 + 2 * voltmeter_tab_width + voltmeter_off_x, mount_height + mount_support_prism + keypad_base_depth + voltmeter_off_y - voltmeter_depth, mount_height])
        texts_voltmeters();
    
        translate([switch_text_off_x, mount_height + mount_support_prism + switch_off_y + switch_text_off_y, mount_height - switch_text_d]) {
            linear_extrude(height = switch_text_d + 0.1)
            text(switch_text_left, font = switch_text_font, size = switch_text_h, spacing = switch_text_spacing, halign = "center");
            
            translate([switch_text_dist_x, 0, 0])
            linear_extrude(height = switch_text_d + 0.1)
            text(switch_text_right, font = switch_text_font, size = switch_text_h, spacing = switch_text_spacing, halign = "center");
        }
    }
}

module assembly_voltmeters() {
    for (i = [0 : 3]) {
        translate([0, -voltmeter_dist * i, 0])
        voltmeter();
    }
}

module wall_tab() {
    difference() {
        cube([wall, wall_depth, wall_height]);
        
        translate([-1, wall_depth / 2, wall_height / 2])
        rotate([0, 90, 0])
        cylinder(d = wall_hole, h = wall + 2);
    }
}

module wall_support() {
    difference() {
        prism(wall, wall_height, wall_width - wall);
        
        translate([-1, wall, 0])
        prism(wall + 2, wall_height - wall, wall_width - wall * 4);
    }
}

module wall() {
    difference() {
        cube([wall_width, wall_depth, wall]);
        
        translate([wall + wall_prism + wall_mount_off_x + mount_hole_off, mount_support_depth - mount_support_usable_depth / 2, -1])
        cylinder(d = mount_hole_dia, h = wall + 2);
        
        translate([wall + wall_prism + wall_mount_off_x + mount_width - mount_hole_off, mount_support_depth - mount_support_usable_depth / 2, -1])
        cylinder(d = mount_hole_dia, h = wall + 2);
    }
    
    translate([0, 0, wall])
    wall_tab();
    
    translate([0, 0, -wall_height])
    wall_tab();
    
    translate([wall, 0, -wall])
    rotate([90, 0, 90])
    prism(wall_depth, wall_prism, wall_prism);
    
    translate([wall + wall_prism, 0, wall])
    rotate([0, 0, 90])
    prism(wall_depth, wall_prism, wall_prism);
    
    translate([wall, wall_depth - wall, -wall_height])
    rotate([90, 0, 90])
    wall_support();
    
    translate([wall, wall_depth, wall_height + wall])
    rotate([-90, 0, -90])
    wall_support();
}

module assembly() {
    color("purple")
    wall();
    
    translate([wall + wall_prism + wall_mount_off_x, mount_height, wall])
    rotate([90, 0, 0]) {
        mount();
        
        color("yellow")
        translate([mount_dist / 2, keypad_base_depth + mount_support_prism + mount_height + mount_dist * 3 / 2, -lcd_pcb_height - lcd_spacer_height])
        lcd();
        
        color("red")
        translate([lcd_pcb_width - keypad_base_width + mount_dist / 2, mount_height + mount_support_prism + mount_dist / 2, -keypad_base_height - keypad_spacer_height])
        keypad();
        
        color("green")
        translate([mount_dist / 2 + voltmeter_tab_width + voltmeter_off_x, mount_height + mount_support_prism + keypad_base_depth + voltmeter_off_y - voltmeter_depth, -voltmeter_height - 0])
        assembly_voltmeters();
        
        color("blue")
        translate([mount_dist / 2 + switch_off_x, mount_height + mount_support_prism + switch_off_y, mount_height])
        switch();
    }
}

module print() {
    translate([0, mount_height, mount_width])
    rotate([0, 90, -90])
    mount();
    
    translate([20, wall_height + mount_support_depth, wall_depth])
    rotate([-90, 0, 0])
    wall();
    
    translate([0, -10, 0])
    rotate([90, 0, 0])
    switch_mount();
}

//lcd();
//keypad();
//voltmeter();
//switch();
//switch_mount();

assembly();
//print();
