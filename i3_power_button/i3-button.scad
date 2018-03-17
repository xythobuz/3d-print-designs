front_width = 20;
front_height = 31;
button_hole = 16.5;
button_off = 3;
wall_size = 5;

hole_dist = 25;
hole_size = 3.2;
mount_wall = 2.0;
mount_height = 32;
mount_width_in = 4;
mount_width_out = 20;

mount_button_off_x = 10;
mount_button_off_y = 5;
support_height = 7;

$fn = 15;

module button() {
    difference() {
        cube([front_width, wall_size, front_height]);
        translate([front_width / 2, wall_size + 1, button_off + (button_hole / 2)])
            rotate([90, 0, 0])
            cylinder(d = button_hole, h = wall_size + 2);
    }
}

module mount() {
    difference() {
        cube([mount_width_in + mount_width_out, mount_height, mount_wall]);
        
        translate([mount_width_in, (mount_height - hole_dist) / 2, -1])
        union() {
            cylinder(d = hole_size, h = mount_wall + 2);
            translate([0, hole_dist, 0])
                cylinder(d = hole_size, h = mount_wall + 2);
        }
    }
}

button();

translate([-mount_width_in - mount_button_off_x, mount_button_off_y, front_height - mount_wall])
    mount();

translate([0, 0, front_height - support_height])
    cube([mount_width_out - mount_button_off_x, mount_button_off_y + mount_height, support_height]);
