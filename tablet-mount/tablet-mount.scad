tablet_width = 335;
tablet_height = 223;
tablet_depth = 9.0;
tablet_depth_tolerance = 0.5;

clamp_width = 30;
clamp_height_small = 14;
clamp_height_large = 20;
clamp_wall = 5;

clamp_bottom_dist = 200;
clamp_side_dist = 40;

rail_dia = 8.0;
rail_hole = rail_dia + 0.4;
rail_dist = 2;
rail_add_len = 50;
rail_clamp_width = clamp_width;
rail_clamp_add_height = 4;
rail_clamp_off = 20;

$fn = 20;

print_view = true;

module clamp(height, back_height) {
    cube([clamp_width, (2 * clamp_wall) + tablet_depth + tablet_depth_tolerance, clamp_wall]);
    
    translate([0, 0, clamp_wall])
        cube([clamp_width, clamp_wall, back_height]);
    
    translate([0, clamp_wall + tablet_depth + tablet_depth_tolerance, clamp_wall])
        cube([clamp_width, clamp_wall, height]);
}

module rail_clamp() {
    translate([0, -clamp_wall - (rail_hole / 2) - rail_dist, 0])
    difference() {
        hull() {
            translate([0, (clamp_wall + rail_hole + rail_dist) / 2, rail_clamp_width / 2])
                cube([rail_hole + (2 * clamp_wall) + rail_clamp_add_height, clamp_wall + rail_dist, rail_clamp_width], center = true);
            
            cylinder(d = rail_hole + (2 * clamp_wall), h = rail_clamp_width);
        }
        
        translate([0, 0, -1])
            cylinder(d = rail_hole, h = rail_clamp_width + 2);
    }
}

module clamp_corner() {
    // bottom clamp
    translate([(tablet_width - clamp_bottom_dist) / 2, 0, 0])
        clamp(clamp_height_small, tablet_height / 2 - (clamp_side_dist / 2));
    
    // side clamp
    translate([-clamp_wall, 0, clamp_wall + ((tablet_height) / 2) - (clamp_side_dist / 2)])
        rotate([0, 90, 0])
        clamp(clamp_height_large, (tablet_width - clamp_bottom_dist) / 2);
    
    // bottom rail mount
    translate([(tablet_width - clamp_bottom_dist) / 2, 0, rail_clamp_off])
        rotate([0, 90, 0])
        rail_clamp();
    
    // side rail mount
    translate([rail_clamp_off - 5, 0, clamp_wall + ((tablet_height) / 2) - clamp_width - (clamp_side_dist / 2)])
        rail_clamp();
}

module rail_to_rail() {
    difference() {
        hull() {
            translate([rail_clamp_width / 2, 0, rail_clamp_width / 2])
                rotate([180, 90, 0])
                rail_clamp();
            
            translate([0, 0, 0])
                rail_clamp();
        }
        
        translate([0, -clamp_wall - (rail_hole / 2) - rail_dist, -1])
            cylinder(d = rail_hole, h = rail_clamp_width + 2);
            
        translate([rail_clamp_width / 2 + 1, clamp_wall + (rail_hole / 2) + rail_dist, rail_clamp_width / 2])
            rotate([180, 90, 0])
            cylinder(d = rail_hole, h = rail_clamp_width + 2);
    }
}

module visualization() {
    %translate([0, clamp_wall + (tablet_depth_tolerance / 2), clamp_wall])
        cube([tablet_width, tablet_depth, tablet_height]);

    color("yellow")
    clamp_corner();
    
    color("green")
    translate([0, 0, tablet_height + (2 * clamp_wall)])
        scale([1, 1, -1])
        clamp_corner();
    
    color("blue")
    translate([tablet_width, 0, 0])
        scale([-1, 1, 1])
        clamp_corner();
    
    color("red")
    translate([tablet_width, 0, tablet_height + (2 * clamp_wall)])
        scale([-1, 1, -1])
        clamp_corner();
    
    color("cyan")
    translate([tablet_width / 2, -rail_clamp_off - 2.5, rail_hole / 2 + 1])
        rail_to_rail();
    color("cyan")
    translate([tablet_width / 2, -rail_clamp_off - 2.5, tablet_height - rail_hole / 2 - rail_clamp_off])
        rail_to_rail();
    
    // center rail
    translate([tablet_width / 2, -rail_clamp_off * 3 / 2 - rail_hole / 2 + 0.5, -5])
        cylinder(d = rail_dia, h = tablet_height + 20);
    
    // top/bottom rails
    translate([(tablet_width - clamp_bottom_dist - rail_add_len) / 2, -rail_hole / 2 - rail_dist - 5, clamp_wall + rail_clamp_off - 5])
        rotate([0, 90, 0])
        cylinder(d = rail_dia, h = clamp_bottom_dist + rail_add_len);
    translate([(tablet_width - clamp_bottom_dist - rail_add_len) / 2, -rail_hole / 2 - rail_dist - 5, tablet_height + clamp_wall - rail_clamp_off + 5])
        rotate([0, 90, 0])
        cylinder(d = rail_dia, h = clamp_bottom_dist + rail_add_len);
    
    // side rails
    translate([rail_clamp_off - 5, -rail_hole / 2 - rail_dist - 5, clamp_wall + ((tablet_height - clamp_side_dist - rail_add_len) / 2) - clamp_width])
        cylinder(d = rail_dia, h = clamp_side_dist + rail_add_len + (2 * clamp_width));
    translate([tablet_width - rail_clamp_off + 5, -rail_hole / 2 - rail_dist - 5, clamp_wall + ((tablet_height - clamp_side_dist - rail_add_len) / 2) - clamp_width])
        cylinder(d = rail_dia, h = clamp_side_dist + rail_add_len + (2 * clamp_width));
}

module printplate_corners() {
    clamp_corner();
    
    //translate([0, 50, 0])
    //    rotate([0, 180, 0])
    //    scale([-1, 1, -1])
    //    clamp_corner();
    
    //translate([0, 100, clamp_wall])
    //    rotate([0, 90, 0])
    //    scale([-1, 1, 1])
    //    clamp_corner();
    
    //translate([0, 150, clamp_wall])
    //    rotate([0, -90, 0])
    //    scale([1, 1, -1])
    //    clamp_corner();
}

module printplate_rail_to_rail() {
    translate([25, 60, 0])
    rotate([0, 0, -90]) {
        rail_to_rail();
        translate([rail_clamp_width + 10, 0, 0])
            rail_to_rail();
    }
}

if (print_view) {
    printplate_corners();
    //printplate_rail_to_rail();
} else {
    visualization();
}
