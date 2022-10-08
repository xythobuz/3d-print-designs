
psu_width = 112.7;
psu_height = 49.8;
psu_length = 216;
psu_screw = 4.2;
psu_screw_off_x = 29.5 + 3.2 / 2;
psu_screw_off_y = 29.35 + 3.2 / 2;
psu_screw_dist_x = 53.3 - 3.2;
psu_screw_dist_y = 154.3 - 3.2;

psu_wall_dist = 10;
mount_wall = 5.0;
mount_width = 12.0;
mount_height = 70;
mount_screw = 4.2;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module psu() {
    cube([psu_width, psu_height, psu_length]);
    
    for (x = [0, psu_screw_dist_x])
    for (y = [0, psu_screw_dist_y])
    translate([psu_screw_off_x + x, 0, psu_screw_off_y + y])
    rotate([90, 0, 0])
    cylinder(d = psu_screw - 1.0, h = 10.0);
}

module mount_geo() {
    difference() {
        union() {
            hull() {
                translate([psu_width - psu_screw_off_x - psu_screw_dist_x - mount_width, -mount_wall, -mount_width / 2])
                cube([psu_screw_dist_x + psu_screw_off_x + psu_wall_dist + mount_width, mount_wall, mount_width]);
                
                translate([psu_width + psu_wall_dist, -mount_wall, -mount_width / 2])
                cube([20, mount_wall, mount_height]);
            }
            
            translate([psu_width + psu_wall_dist + 7.5, 0, -mount_width / 2])
            cube([5, 1, mount_height]);
        }
        
        translate([psu_screw_off_x + 8, 1, mount_width / 2])
        rotate([0, 0, -90])
        prism(mount_wall + 2, psu_width - psu_screw_off_x + psu_wall_dist - 8, mount_height - mount_width - mount_wall - 8);
        
        for (x = [0, psu_screw_dist_x])
        translate([psu_screw_off_x + x, 1, 0])
        rotate([90, 0, 0])
        cylinder(d = psu_screw, h = mount_wall + 2);
        
        for (y = [0, (mount_height - mount_width) / 2, mount_height - mount_width])
        translate([psu_width + psu_wall_dist + 10, 2, y])
        rotate([90, 0, 0])
        cylinder(d = mount_screw, h = mount_wall + 3);
    }
}

module mount(type) {
    scale([1, 1, -1 * (type * 2 - 1)])
    mount_geo();
}

relais_width = 50;
relais_height = 26;
relais_depth = 17;
relais_screw = 3.2;
relais_screw_dist_x = 44.8;
relais_screw_dist_y = 21.1;
relais_mount_off_y = 30;

relais_wall_dist = relais_mount_off_y;
mount_relais_wall = 5.0;
mount_relais_screw = 4.2;
relais_screw_off_x = (relais_width - relais_screw_dist_x) / 2;
relais_screw_off_y = (relais_height - relais_screw_dist_y) / 2;
mount_relais_width = relais_width + 2 * mount_relais_wall;
mount_relais_width_add = (psu_width - relais_width) / 2 + mount_relais_wall + 20;
mount_relais_height = relais_height + 2 * mount_relais_wall;

module relais() {
    cube([relais_width, 5, relais_height]);
    
    translate([relais_width / 2 - 5, 5, relais_height / 2 - 5])
    cube([10, relais_depth - 5, 10]);
    
    for (x = [-1, 1])
    for (y = [-1, 1])
    translate([relais_width / 2 + x * relais_screw_dist_x / 2, 0, relais_height / 2 + y * relais_screw_dist_y / 2])
    rotate([90, 0, 0])
    cylinder(d = relais_screw, h = 10);
}

module cutout(l, o) {
    for (r = [0, 90, 180, 270])
    rotate([r + 45, 0, -90])
    translate([0, -l - o, o])
    prism(mount_relais_wall + 2, l, l);
}

module mount_relais() {
    difference() {
        union() {
            translate([-mount_relais_wall, -mount_relais_wall, -mount_relais_wall])
            cube([mount_relais_width + mount_relais_width_add, mount_relais_wall, mount_relais_height]);
                
            translate([mount_relais_width + mount_relais_width_add - mount_relais_wall - 12.5, 0, -mount_relais_wall])
            cube([5, 1, mount_relais_height]);
        }
        
        for (x = [-1, 1])
        for (y = [-1, 1])
        translate([relais_width / 2 + x * relais_screw_dist_x / 2, 1, relais_height / 2 + y * relais_screw_dist_y / 2])
        rotate([90, 0, 0])
        cylinder(d = relais_screw, h = 10);
        
        for (y = [0, mount_relais_height - mount_relais_wall * 2])
        translate([mount_relais_width + mount_relais_width_add - mount_relais_wall - 10, 2, y])
        rotate([90, 0, 0])
        cylinder(d = mount_relais_screw, h = mount_relais_wall + 3);
        
        translate([24, 1, 13])
        cutout(15, 2);
        translate([70, 1, 13])
        cutout(15, 2);
    }
}

psu2_width = 70.25;
psu2_height = 31.2;
psu2_length = 39.0;
psu2_screw = 3.2;
psu2_screw_off_x = 5.0 - 3.2 / 2;
psu2_screw_off_y = 11.6 + 3.2 / 2;
psu2_screw_dist_x = 59.6 + 3.2;
psu2_screw_dist_y = 0;

module psu2() {
    cube([psu2_width, psu2_height, psu2_length]);
    
    for (x = [0, psu2_screw_dist_x])
    for (y = [0, psu2_screw_dist_y])
    translate([psu2_screw_off_x + x, 0, psu2_screw_off_y + y])
    rotate([90, 0, 0])
    cylinder(d = psu2_screw - 1.0, h = 10.0);
}

psu2_mount_off_y = relais_mount_off_y;
psu2_wall_dist = (psu_width - psu2_width) / 2 + psu_wall_dist;
mount2_wall = 5.0;
mount2_width = 8.0;
mount2_height = 50;
mount2_screw = 4.2;

module mount2() {
    difference() {
        union() {
            hull() {
                translate([psu2_width - psu2_screw_off_x - psu2_screw_dist_x - mount2_width, -mount2_wall, -mount2_width / 2])
                cube([psu2_screw_dist_x + psu2_screw_off_x + psu2_wall_dist + mount2_width, mount2_wall, mount2_width]);
                
                translate([psu2_width + psu2_wall_dist, -mount2_wall, -mount2_width / 2])
                cube([20, mount2_wall, mount2_height]);
            }
            
            translate([psu2_width + psu2_wall_dist + 7.5, 0, -mount2_width / 2])
            cube([5, 1, mount2_height]);
        }
        
        translate([psu2_screw_off_x + 8, 1, mount2_width / 2])
        rotate([0, 0, -90])
        prism(mount2_wall + 2, psu2_width - psu2_screw_off_x + psu2_wall_dist - 8, mount2_height - mount2_width - mount2_wall - 8 + 5);
        
        for (x = [0, psu2_screw_dist_x])
        translate([psu2_screw_off_x + x, 1, 0])
        rotate([90, 0, 0])
        cylinder(d = psu2_screw, h = mount2_wall + 2);
        
        for (y = [0, mount2_height - mount2_width])
        translate([psu2_width + psu2_wall_dist + 10, 2, y])
        rotate([90, 0, 0])
        cylinder(d = mount2_screw, h = mount2_wall + 3);
    }
}

module assembly() {
    %psu();
    
    %translate([psu_width + psu_wall_dist, 0, 0])
    cube([20, 40, 400]);
    
    for (i = [0, 1])
    translate([0, 0, psu_screw_off_y + i * psu_screw_dist_y])
    mount(i);
    
    %translate([(psu_width - relais_width) / 2, 0, psu_length + relais_mount_off_y])
    relais();
    
    %translate([(psu_width - psu2_width) / 2, 0, psu_length + relais_mount_off_y + relais_height + psu2_mount_off_y])
    psu2();
    
    translate([(psu_width - psu2_width) / 2, 0, psu_length + relais_mount_off_y + relais_height + psu2_mount_off_y + psu2_screw_off_y])
    mount2();
    
    translate([(psu_width - relais_width) / 2, 0, psu_length + relais_mount_off_y])
    mount_relais();
}

module print() {
    translate([0, 0, mount_wall])
    rotate([90, 0, 0])
    mount(0);
    
    translate([0, 40, mount_wall])
    rotate([90, 0, 0])
    mount(1);
    
    translate([-150, 40, mount2_wall])
    rotate([90, 0, 0])
    mount2();
    
    translate([-150, -30, mount_relais_wall])
    rotate([90, 0, 0])
    mount_relais();
}

//assembly();
//print();
mount_relais();