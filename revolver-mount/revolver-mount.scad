include <rounded.scad>;

handle_width = 32;
handle_depth = 31;
handle_height = 20;
handle_wall = 3;
handle_off = 5;

// distance between table and bottom of barell
mount_off_bottom = 82;

// distance between center of handle and center of barell mount
mount_off_handle = 141;

mount_post_dia = 15;
mount_post_off = 5;
mount_post_height_remove = 10;

mount_grip_width = 10;
mount_grip_depth = 9;
mount_grip_height = 6;
mount_grip_wall = 2;

ammo_dia = 10.5;
ammo_height = 10;
ammo_dist = 5;
ammo_box_wall = 2;

ammo_count_width = 7;
ammo_count_depth = 3;

ammo_box_width = ammo_count_width * (ammo_dia + ammo_dist);
ammo_box_depth = ammo_count_depth * (ammo_dia + ammo_dist);

base_depth = 50;
base_height = 2;

base_fillet = (base_height / 2) - 0.01;
handle_fillet = (handle_wall / 2) - 0.01;
ammo_box_fillet = (ammo_box_wall / 2) - 0.01;

handle_center = handle_off + handle_wall + (handle_width / 2);
base_width = handle_center + mount_off_handle + (mount_post_dia / 2) + mount_post_off;

$fn = 30;

module ammo() {
    difference() {
        rounded_cube(ammo_box_width,
                ammo_box_depth,
                ammo_box_wall + ammo_height,
                rx=ammo_box_fillet, ry=ammo_box_fillet,
                rz=ammo_box_fillet,
                noback=false, nobottom=true, notop=true);
        
        translate([(ammo_dia + ammo_dist) / 2,
                (ammo_dia + ammo_dist) / 2,
                ammo_box_wall])
        for (y = [0 : ammo_count_depth - 1]) {
            for (x = [0 : ammo_count_width - 1]) {
                translate([x * (ammo_dia + ammo_dist),
                        y * (ammo_dia + ammo_dist),
                        0])
                cylinder(d = ammo_dia, h = ammo_height + 1);
            }
        }
    }
}

module mount() {
    // base plate
    color("blue")
    rounded_cube(base_width, base_depth, base_height,
            rx=base_fillet, ry=base_fillet, rz=base_fillet,
            noback=false, nobottom=true, notop=true);
    
    // handle holder
    color("green")
    translate([handle_off,
            (base_depth - handle_depth) / 2 - handle_wall,
            base_height])
    difference() {
        rounded_cube(handle_width + (2 * handle_wall),
                handle_depth + (2 * handle_wall),
                handle_height,
                rx=handle_fillet, ry=handle_fillet,
                rz=handle_fillet,
                noback=false, nobottom=true, notop=true);
        
        translate([handle_wall, handle_wall, 0])
        rounded_cube(handle_width, handle_depth,
                handle_height + 1,
                rx=handle_fillet, ry=handle_fillet,
                rz=handle_fillet,
                noback=false, nobottom=true, notop=true);
    }
    
    // front holder
    color("yellow")
    translate([handle_center + mount_off_handle,
            base_depth / 2,
            base_height])
    difference() {
        hull() {
            cylinder(d = mount_post_dia,
                    h = mount_off_bottom
                        - mount_post_height_remove);
            
            translate([-mount_grip_width / 2,
                    -mount_grip_depth / 2 - mount_grip_wall,
                    mount_off_bottom])
            cube([mount_grip_width,
                    mount_grip_depth + (2 * mount_grip_wall),
                    mount_grip_height]);
        }
        
        translate([-mount_grip_width / 2 - 1,
                -mount_grip_depth / 2,
                mount_off_bottom])
        cube([mount_grip_width + 2,
                mount_grip_depth,
                mount_grip_height + 1]);
    }
    
    color("red")
    translate([2 * handle_center, (base_depth - ammo_box_depth) / 2, base_height - ammo_box_wall])
    ammo();
}

mount();

//ammo();
