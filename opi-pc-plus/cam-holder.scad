//import("/Users/thomas/Downloads/y-corner.stl");

// holder
edge = 20;
height = 40;
hole_off = 10;
hole_size = 8.0;
hole_wiggle = 0.75;

// adaptor
length = 50;
forw_height = 20;

// cam
cam_width = 27.0;
cam_height = 5.0;
cam_wall = 3.0;
cam_holes = 3.2;
cam_hole_off = 3.3;
cam_hole_dist = 20.0;
cam_mount_height = 15.0;
cam_mount_dist = 10.0;

mock_pole_height = 60.0 + 40;
mock_pole_off = 10.0;

$fn = 20;

module prism(l, w, h) {
    #polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module holder() {
    difference() {
        translate([-edge / 2, -edge / 2, 0])
            cube([edge, edge, height]);
        
        translate([-edge / 2 - 1, 0, hole_off])
            rotate([0, 90, 0])
            cylinder(d = hole_size + hole_wiggle, h = edge + 2);
        
        translate([-edge / 2 - 1, 0, height - hole_off])
            rotate([0, 90, 0])
            cylinder(d = hole_size + hole_wiggle, h = edge + 2);
    }
}

module adaptor() {
    translate([-edge / 2, -edge / 2 - length, height - forw_height])
    difference() {
        cube([edge, length, forw_height]);
        
        translate([edge / 2, hole_off, -1])
            cylinder(d = hole_size + hole_wiggle, h = forw_height + 2);
    }
}

module cam_plate() {
    difference() {
        cube([cam_width, cam_wall, cam_mount_height]);
        
        translate([cam_hole_off, cam_wall + 1, cam_mount_height - cam_height])
            rotate([90, 0, 0])
            cylinder(d = cam_holes, h = cam_wall + 2);
        
        translate([cam_hole_off + cam_hole_dist, cam_wall + 1, cam_mount_height - cam_height])
            rotate([90, 0, 0])
            cylinder(d = cam_holes, h = cam_wall + 2);
    }
}

module cam_mount() {
    translate([0, -edge / 2 - length + hole_off, height - forw_height + mock_pole_height - mock_pole_off * 2 - 40])
    rotate([0, 0, 180])
    difference() {
        union() {
            cylinder(d = hole_size + hole_wiggle + cam_wall * 2, h = cam_height);
            
            translate([-cam_width / 2, cam_mount_dist, 0])
                cam_plate();
            
            translate([-cam_width / 2 + cam_width / 2 - ((hole_size + hole_wiggle) / 2 + cam_wall), 0, 0])
                cube([cam_width - 2 * (cam_width / 2 - ((hole_size + hole_wiggle) / 2 + cam_wall)), cam_mount_dist + ((hole_size + hole_wiggle) / 2) - 2, cam_height]);
            
            translate([-(hole_size + hole_wiggle) / 2 - cam_wall, 0, 0])
                rotate([0, -90, 0])
                prism(cam_height, cam_mount_dist, cam_width / 2 - ((hole_size + hole_wiggle) / 2 + cam_wall));
            
            translate([(hole_size + hole_wiggle) / 2 + cam_wall, 0, cam_height])
                rotate([0, 90, 0])
                prism(cam_height, cam_mount_dist, cam_width / 2 - ((hole_size + hole_wiggle) / 2 + cam_wall));
        }
        
        translate([0, 0, -1])
            cylinder(d = hole_size + hole_wiggle, h = cam_height + 2);
    }
}

module cam_holder_mount() {
    holder();
    adaptor();

    %translate([0, -edge / 2 - length + hole_off, height - forw_height - mock_pole_off])
        cylinder(d = hole_size, h = mock_pole_height);

    translate([0, 0, 35])
    cam_mount();
}

cam_holder_mount();
