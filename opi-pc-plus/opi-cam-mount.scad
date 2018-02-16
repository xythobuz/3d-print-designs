opi_cam_width = 19.0;
opi_cam_height = 54.4;
opi_cam_depth = 4.5;

opi_cam_bottom_depth = 1.4;
opi_cam_bottom_height = 30.0;
opi_cam_bottom_off_y = 7.5;

opi_lens_width = 8.6;
opi_lens_height = 8.6;
opi_lens_off_x = 5.0;
opi_lens_off_y = 9.0;

cable_cut_width = 15.0;
wall_size = 2.0;

cable_tie_width = 3.0;
cable_tie_height = 2.0;
cable_tie_off_1 = 9.0;
cable_tie_off_2 = 47.0;

screw_holes = 3.2;
screw_plate = 10.0;

lens_gap = 0.5;
top_gap = 0.5;

$fn = 10;

module cam() {
    cube([opi_cam_width, opi_cam_height, opi_cam_depth]);
    
    translate([opi_lens_off_x, opi_cam_height - opi_lens_height - opi_lens_off_y, opi_cam_depth])
        cube([opi_lens_width, opi_lens_height, 5]);
    
    translate([0, opi_cam_bottom_off_y, -opi_cam_bottom_depth])
        cube([opi_cam_width, opi_cam_bottom_height, opi_cam_bottom_depth]);
}

module holder_bottom_walls() {
    difference() {
        cube([opi_cam_width + (4 * wall_size), opi_cam_height + (4 * wall_size), wall_size + opi_cam_bottom_depth]);
        
        translate([2 * wall_size, (2 * wall_size) + opi_cam_bottom_off_y, wall_size])
            cube([opi_cam_width, opi_cam_bottom_height, opi_cam_bottom_depth + 1]);
    }
    
    // inner walls
    translate([wall_size, wall_size, wall_size])
        cube([opi_cam_width + (2 * wall_size), wall_size, opi_cam_depth + opi_cam_bottom_depth]);
    translate([wall_size, opi_cam_height + (2 * wall_size), wall_size])
        cube([opi_cam_width + (2 * wall_size), wall_size, opi_cam_depth + opi_cam_bottom_depth]);
    translate([wall_size, 2 * wall_size, wall_size])
        cube([wall_size, opi_cam_height, opi_cam_depth + opi_cam_bottom_depth]);
    translate([opi_cam_width + (2 * wall_size), 2 * wall_size, wall_size])
        cube([wall_size, opi_cam_height, opi_cam_depth + opi_cam_bottom_depth]);
    
    // outer walls
    translate([0, 0, wall_size])
        cube([opi_cam_width + (4 * wall_size), wall_size, opi_cam_depth + opi_cam_bottom_depth + wall_size]);
    translate([0, opi_cam_height + (3 * wall_size), wall_size])
        cube([opi_cam_width + (4 * wall_size), wall_size, opi_cam_depth + opi_cam_bottom_depth + wall_size]);
    translate([0, wall_size, wall_size])
        cube([wall_size, opi_cam_height + (2 * wall_size), opi_cam_depth + opi_cam_bottom_depth + wall_size]);
    translate([opi_cam_width + (3 * wall_size), wall_size, wall_size])
        cube([wall_size, opi_cam_height + (2 * wall_size), opi_cam_depth + opi_cam_bottom_depth + wall_size]);
}

module screws() {
    difference() {
        cube([(4 * wall_size) + opi_cam_width, screw_plate, wall_size]);
        
        translate([3.3, screw_plate / 2, -1])
            cylinder(d = screw_holes, h = wall_size + 2);
        translate([23.3, screw_plate / 2, -1])
            cylinder(d = screw_holes, h = wall_size + 2);
        //translate([13.3, screw_plate / 2, -1])
        //    cylinder(d = screw_holes, h = wall_size + 2);
        //translate([((4 * wall_size) + opi_cam_width) / 3, screw_plate / 2, -1])
        //    cylinder(d = screw_holes, h = wall_size + 2);
        //translate([((4 * wall_size) + opi_cam_width) * 2 / 3, screw_plate / 2, -1])
        //    cylinder(d = screw_holes, h = wall_size + 2);
    }
}

module holder_bottom() {
    difference() {
        holder_bottom_walls();
        
        // ribbon cable
        translate([((opi_cam_width + (4 * wall_size)) - cable_cut_width) / 2, -1, wall_size + opi_cam_bottom_depth])
            cube([cable_cut_width, (2 * wall_size) + 2, opi_cam_depth]);
        
        // cable-tie center
        translate([wall_size, ((4 * wall_size) + opi_cam_height - cable_tie_width) / 2, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
        translate([opi_cam_width + (2 * wall_size), ((4 * wall_size) + opi_cam_height - cable_tie_width) / 2, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
        
        // cable-tie bottom
        translate([wall_size, (2 * wall_size) + cable_tie_off_1, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
        translate([opi_cam_width + (2 * wall_size), (2 * wall_size) + cable_tie_off_1, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
        
        // cable-tie top
        translate([wall_size, (2 * wall_size) + cable_tie_off_2, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
        translate([opi_cam_width + (2 * wall_size), (2 * wall_size) + cable_tie_off_2, -1])
            cube([cable_tie_height, cable_tie_width, (3 * wall_size) + opi_cam_depth + opi_cam_bottom_depth]);
    }
    
    translate([0, -screw_plate, 0])
        screws();
}

module holder_top() {
    difference() {
        translate([top_gap, top_gap, 0])
            cube([opi_cam_width + (2 * wall_size) - (2 * top_gap), opi_cam_height + (2 * wall_size) - (2 * top_gap), wall_size]);
        
        // camera lens
        translate([wall_size + opi_lens_off_x - lens_gap, wall_size + opi_cam_height - opi_lens_height - opi_lens_off_y - lens_gap, -1])
        cube([opi_lens_width + (2 * lens_gap), opi_lens_height + (2 * lens_gap), wall_size + 2]);
        
        // cable-tie center
        translate([0, ((2 * wall_size) + opi_cam_height - cable_tie_width) / 2, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        translate([opi_cam_width + wall_size, ((2 * wall_size) + opi_cam_height - cable_tie_width) / 2, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        
        /*
        // cable-tie bottom
        translate([0, wall_size + cable_tie_off_1, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        translate([opi_cam_width + wall_size, wall_size + cable_tie_off_1, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        
        // cable-tie top
        translate([0, wall_size + cable_tie_off_2, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        translate([opi_cam_width + wall_size, wall_size + cable_tie_off_2, -1])
            cube([cable_tie_height, cable_tie_width, wall_size + 2]);
        */
    }
}

holder_bottom();

%translate([2 * wall_size, 2 * wall_size, wall_size])
    cam();


translate([wall_size, wall_size, wall_size + opi_cam_depth + opi_cam_bottom_depth])
    holder_top();

