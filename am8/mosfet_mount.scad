mosfet_width = 70;
mosfet_height = 60;
mosfet_depth = 2;

mosfet_holes_x = 63;
mosfet_holes_y = 53;
mosfet_dia = 3.2;

wall = 5.0;
mosfet_wall_dist = 5.0;
mosfet_mount_dist = 2.0;
mount_dia = 4.2;

cutout_len = 30;
cutout_dist = 4;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module mosfet() {
    cube([mosfet_width, mosfet_height, mosfet_depth]);
    
    for (x = [-1, 1])
    for (y = [-1, 1])
    translate([mosfet_width / 2 + x * mosfet_holes_x / 2, mosfet_height / 2 + y * mosfet_holes_y / 2, -mosfet_mount_dist - wall - 1])
    cylinder(d = mosfet_dia - 0.2, h = mosfet_mount_dist + wall + 1);
}

module mount() {
    translate([0, -wall, 0])
    difference() {
        union() {
            cube([mosfet_width + mosfet_wall_dist + 20, wall, mosfet_height]);
            
            translate([mosfet_width + mosfet_wall_dist + 7.5, wall, 0])
            cube([5, 1, mosfet_height]);
            
            for (x = [-1, 1])
            for (y = [-1, 1])
            translate([mosfet_width / 2 + x * mosfet_holes_x / 2, wall, mosfet_height / 2 + y * mosfet_holes_y / 2])
            rotate([-90, 0, 0])
            cylinder(d = 7, h = mosfet_mount_dist);
        }
        
        for (i = [-15, 15])
        translate([mosfet_width + mosfet_wall_dist + 10, -1, mosfet_height / 2 + i])
        rotate([-90, 0, 0])
        cylinder(d = mount_dia, h = wall + 3);
        
        for (x = [-1, 1])
        for (y = [-1, 1])
        translate([mosfet_width / 2 + x * mosfet_holes_x / 2, -1, mosfet_height / 2 + y * mosfet_holes_y / 2])
        rotate([-90, 0, 0])
        cylinder(d = mosfet_dia, h = wall + mosfet_mount_dist + 2);
        
        for (i = [0, 1, 2, 3])
        translate([mosfet_width / 2, 0, mosfet_height / 2])
        rotate([0, 90 * i, 0])
        translate([cutout_len * sqrt(2) / 2 + cutout_dist, -1, -cutout_len * sqrt(2) / 2])
        rotate([45, 0, 90])
        prism(wall + 2, cutout_len, cutout_len);
    }
}

module assembly() {
    %translate([0, mosfet_mount_dist, mosfet_height])
    rotate([-90, 0, 0])
    mosfet();
    
    mount();
}

rotate([90, 0, 0])
assembly();
