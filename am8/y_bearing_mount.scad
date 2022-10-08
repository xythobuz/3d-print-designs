bearing_dia = 15.0;
bearing_len = 23.8;
mount_hole = bearing_dia + 0.4;
hole_dia = 4.2;
hole_dist_x = 24.0;
hole_dist_y = 18.0;
screw_nut = 7.75;
screw_nut_off = 2.5;
base_side = 5.0;
base_wall = 5.0;
mount_bearing_dist = 13.0;
shim_width = 16.0;
cutout = 5.0;
top_screw_dia = 3.2;
top_screw_head = 6.0;
top_screw_head_off = base_side;
top_screw_nut = 6.2;
top_screw_nut_off = 3.0;

base_width = hole_dist_x + base_side * 2;
base_length = hole_dist_y + base_side * 2;

$fn = 42;

module bearing() {
    difference() {
        cylinder(d = bearing_dia, h = bearing_len);
        
        translate([0, 0, -1])
        cylinder(d = 8.0, h = bearing_len + 2);
    }
}

module mount() {
    %translate([0, (base_length - bearing_len) / 2, bearing_dia / 2 + mount_bearing_dist])
    rotate([-90, 0, 0])
    bearing();
    
    difference() {
        union() {
            // base
            translate([-base_width / 2, 0, 0])
            cube([base_width, base_length, base_wall]);
            
            hull() {
                // bearing outer hull
                translate([0, 0, bearing_dia / 2 + mount_bearing_dist])
                rotate([-90, 0, 0])
                cylinder(d = mount_hole + 2 * base_side, h = base_length);
                
                // top clamp for screw
                translate([-cutout / 2 - base_side, 0, bearing_dia + mount_bearing_dist])
                cube([cutout + 2 * base_side, base_length, base_wall + 1]);
            }
            
            // shim
            translate([-shim_width / 2, 0, base_wall])
            cube([shim_width, base_length, mount_bearing_dist - base_wall]);
        }
        
        // screw holes for mounting to carriage
        for (x = [-hole_dist_x / 2, hole_dist_x / 2])
        for (y = [-hole_dist_y / 2, hole_dist_y / 2])
        translate([x, base_length / 2 + y, -1])
        cylinder(d = hole_dia, h = base_wall + 2);
        
        // nut holes for mounting to carriage
        for (x = [-hole_dist_x / 2, hole_dist_x / 2])
        for (y = [-hole_dist_y / 2, hole_dist_y / 2])
        translate([x, base_length / 2 + y, screw_nut_off])
        rotate([0, 0, 90])
        cylinder(d = screw_nut, h = base_wall - screw_nut_off + 1, $fn = 6);
        
        // bearing hole
        translate([0, -1, bearing_dia / 2 + mount_bearing_dist])
        rotate([-90, 0, 0])
        cylinder(d = mount_hole, h = base_length + 2);
        
        // top cutout
        translate([-cutout / 2, -1, bearing_dia + mount_bearing_dist - 1])
        cube([cutout, base_length + 2, base_side + 5]);
        
        // top screw
        translate([-base_width / 2, base_length / 2, mount_bearing_dist + bearing_dia + base_wall / 2])
        rotate([0, 90, 0])
        cylinder(d = top_screw_dia, h = base_width);
        
        // top screw head
        translate([cutout / 2 + top_screw_head_off, base_length / 2, mount_bearing_dist + bearing_dia + base_wall / 2])
        rotate([0, 90, 0])
        cylinder(d = top_screw_head, h = base_width);
        
        // top screw nut
        translate([-cutout / 2 - top_screw_nut_off - base_width, base_length / 2, mount_bearing_dist + bearing_dia + base_wall / 2])
        rotate([0, 90, 0])
        rotate([0, 0, 90])
        cylinder(d = top_screw_nut, h = base_width, $fn = 6);
    }
}

rotate([90, 0, 0])
mount();
