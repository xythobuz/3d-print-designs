mount_width = 40;
mount_height = 35;
mount_wall_depth = 30;
head_dia = 6.0;
head_height = 2.7;
hole_dia = 3.2;
hole_off = 10;
wall = 5;
switch_off = 5;
switch_height_off = 5;
prism_w = 5;

switch_width = 18.2;
switch_depth = 11.5;
switch_height = 11.0;
switch_top_width = 20.8;
switch_top_depth = 14.8;
switch_top_height = 2.1;
switch_add_negative = 1.0;

text_top = "2";
text_bottom = "1";
text_font = "Liberation Sans:style=Bold";
text_h = 10;
text_d = 0.5;
text_spacing = 1.0;
text_off = 7.5;
text_top_off = 6;
text_bottom_off = 10.5;

$fn = 42;

switches_width = switch_depth * 2 + switch_off;

module screw(h) {
    translate([0, 0, h - head_height])
    cylinder(d1 = hole_dia, d2 = head_dia, h = head_height);
    
    cylinder(d = hole_dia, h = h - head_height + 0.01);
}

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module switch(s = 0) {
    translate([-s / 2, -s / 2, s - switch_height])
    cube([switch_width + s, switch_depth + s, switch_height]);
    
    translate([-(switch_top_width - switch_width) / 2, -(switch_top_depth - switch_depth) / 2, s])
    cube([switch_top_width, switch_top_depth, switch_top_height]);
}

module light_switches() {
    difference() {
        cube([mount_width, mount_height, wall]);
    
        for (i = [0, switch_off + switch_depth]) {
            translate([i + switch_depth + (mount_width - switches_width) / 2, switch_height_off, wall])
            rotate([0, 0, 90])
            switch(switch_add_negative);
        }
    }
    
    for (i = [0, switch_off + switch_depth]) {
        %translate([i + switch_depth + (mount_width - switches_width) / 2, switch_height_off, wall])
        rotate([0, 0, 90])
        switch();
    }
}

module mount() {
    
    difference() {
        union() {
            cube([wall, wall + mount_wall_depth, mount_width]);
            
            translate([mount_height + wall, wall, 0])
            rotate([90, -90, 0])
            light_switches();
        }
        
        for (i = [0, switch_depth + switch_off]) {
            translate([-0.01, wall + mount_wall_depth - hole_off, switch_depth + (mount_width - switches_width) / 2 - switch_depth / 2 + i])
            rotate([0, 90, 0])
            screw(wall + 0.02);
        }
        
        translate([text_off, text_d, switch_depth + (mount_width - switches_width) / 2 + text_top_off])
        rotate([90, 0, 0])
        linear_extrude(height = text_d + 0.1)
        text(text_top, font = text_font, size = text_h, spacing = text_spacing, halign = "center");
        
        translate([text_off, text_d, switch_depth + (mount_width - switches_width) / 2 - text_bottom_off])
        rotate([90, 0, 0])
        linear_extrude(height = text_d + 0.1)
        text(text_bottom, font = text_font, size = text_h, spacing = text_spacing, halign = "center");
    }
    
    translate([wall, wall + prism_w, 0])
    rotate([0, -90, 180])
    prism(mount_width, prism_w, prism_w);
}

mount();
