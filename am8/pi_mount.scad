pi_width = 85;
pi_height = 56;
pi_hole_dist_x = 58;
pi_hole_dist_y = 49;
pi_hole_off_x = 3.5;
pi_hole_off_y = 3.5;
pi_hole = 2.8;

wall = 5.0;
pi_wall_dist = 10;
pi_mount_dist = 5.0;
pi_mount_post_top = 6.3;
pi_mount_post_bot = 10.0;
mount_dia = 4.2;

mount_width = pi_hole_dist_x + pi_wall_dist + 20 + pi_hole_off_x + pi_hole / 2 + wall;
mount_height = pi_height + 5;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module cutout(l, o) {
    for (r = [0, 90, 180, 270])
    rotate([r + 45, 0, -90])
    translate([0, -l - o, o])
    prism(wall + 2, l, l);
}

module holes(h, d1 = pi_hole, d2 = pi_hole) {
    for (x = [0, pi_hole_dist_x])
    for (y = [0, pi_hole_dist_y])
    translate([pi_hole_off_x + x, 0, pi_hole_off_y + y])
    rotate([90, 0, 0])
    cylinder(d1 = d1, d2 = d2, h = h);
}

module pi() {
    cube([pi_width, 2.0, pi_height]);
    
    translate([0, 10, 0])
    holes(20);
}

module mount() {
    difference() {
        union() {
            cube([mount_width, wall, mount_height]);
            
            translate([7.5, wall, 0])
            cube([5, 1, mount_height]);
            
            translate([20 + pi_wall_dist, pi_mount_dist + wall, (mount_height - pi_height) / 2])
            holes(pi_mount_dist, pi_mount_post_top, pi_mount_post_bot);
        }
        
        for (z = [mount_height / 4, mount_height / 4 * 3])
        translate([10, -1, z])
        rotate([-90, 0, 0])
        cylinder(d = mount_dia, h = wall + 3);
        
        translate([20 + pi_wall_dist, wall + pi_mount_dist + 1, (mount_height - pi_height) / 2])
        holes(wall + pi_mount_dist + 2);
        
        translate([63, wall + 1, 30])
        cutout(30, 2);
    }
}

module assembly() {
    %cube([20, 40, 100]);
    
    %translate([20 + pi_wall_dist, pi_mount_dist, 20])
    pi();
    
    translate([0, -wall, 20 - (mount_height - pi_height) / 2])
    mount();
}

assembly();
