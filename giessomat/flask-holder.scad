flask_dia = 88;
flask_height = 150;
flask_dist = 10;

holder_dia = 90;
holder_depth = holder_dia;
holder_width_factor = 4;
holder_width = flask_dist + holder_dia / holder_width_factor;
holder_height = 5;

rim_height = 20;
rim_width = 3;
rim_dia = holder_dia + (2 * rim_width);

screw_dia = 4.3;
head_dia = 8.0;
bite = 3.0;

single_screw_off = 10;
double_screw_off = 10;

tank_w = 25;
tank_d = 35;
tank_h = 60;
tank_wall = 5;
tank_prism = 15;
tank_screw_off = (tank_d - tank_wall - tank_prism) / 2;

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module screw(h = flask_height) {
    translate([0, 0, -1])
    cylinder(d = screw_dia, h = h + 1);
    
    translate([0, 0, bite])
    cylinder(d = head_dia, h = h - bite);
}

module tank_mount() {
    difference() {
        union() {
            cube([tank_w, tank_d, tank_wall]);
            
            translate([0, tank_d - tank_wall, 0])
            cube([tank_w, tank_wall, tank_h]);
            
            translate([0, tank_d - tank_wall - tank_prism, tank_wall])
            prism(tank_w, tank_prism, tank_prism);
        }
        
        translate([tank_w / 2, tank_screw_off, 0])
        screw(tank_h);
    }
}

module flasks() {
    translate([holder_dia / 2, holder_dia / 2, 0])
    cylinder(d = flask_dia, h = flask_height);
    
    translate([holder_dia * 3 / 2 + flask_dist, holder_dia / 2, 0])
    cylinder(d = flask_dia, h = flask_height);
    
    translate([holder_dia * 5 / 2 + flask_dist * 2, holder_dia / 2, 0])
    cylinder(d = flask_dia, h = flask_height);
}

module rim() {
    translate([rim_dia / 2, rim_dia / 2, 0])
    difference() {
        cylinder(d = rim_dia, h = rim_height);
        
        translate([0, 0, -1])
        cylinder(d = holder_dia, h = rim_height + 2);
        
        translate([-holder_dia / 2 + holder_dia / holder_width_factor, -rim_dia / 2 - 1, -1])
        cube([rim_dia, rim_dia + 2, rim_height + 2]);
    }
}

module single_holder(screws = true) {
    difference() {
        union() {
            hull() {
            cube([holder_width, holder_depth, holder_height]);
            
            translate([flask_dist - rim_width, -rim_width, holder_height])
            rim();
            }
        }
        
        translate([holder_dia / 2 + flask_dist, holder_dia / 2, -1])
        cylinder(d = holder_dia, h = holder_height + rim_height + 2);
        
        if (screws) {
            translate([single_screw_off, single_screw_off, 0])
            screw();
            
            translate([single_screw_off, holder_depth - single_screw_off, 0])
            screw();
        }
    }
}

module double_holder() {
    difference() {
        union() {
            translate([holder_width, holder_depth, 0])
            rotate([0, 0, 180])
            single_holder(false);
            
            translate([holder_width - flask_dist, 0, 0])
            single_holder(false);
        }
        
        translate([holder_width - flask_dist / 2, double_screw_off, 0])
        screw();
        
        translate([holder_width - flask_dist / 2, holder_depth - double_screw_off, 0])
        screw();
    }
}

module holders() {
    translate([flask_dist, 0, 0]) {
        %flasks();

        translate([-flask_dist, 0, 0])
        single_holder();

        translate([holder_dia - holder_width + flask_dist, 0, 0])
        double_holder();

        translate([2 * (holder_dia + flask_dist) - holder_width, 0, 0])
        double_holder();

        translate([3 * (holder_dia + flask_dist), holder_depth, 0])
        rotate([0, 0, 180])
        single_holder();
    }
}

//screw();
//rim();

//holders();
//single_holder();
//double_holder();

tank_mount();