lack_foot_width = 50;
lack_foot_height = 100;
lack_foot_dist = 5;

bracket_height = 70;
bracket_width = 40;
bracket_wall = 10;

screw_head_length = 4.5;
screw_head_dia_max = 8.0;
screw_head_dia_min = 3.2;
screw_body_dia = 2.4;
screw_body_length = 25;

$fn = 20;

module screw() {
    cylinder(d1 = screw_body_dia, d2 = screw_head_dia_min, h = screw_body_length + 0.1);
    translate([0, 0, screw_body_length])
    cylinder(d1 = screw_head_dia_min, d2 = screw_head_dia_max, h = screw_head_length);
}

module screw_block() {
    translate([bracket_width / 3, screw_body_length + screw_head_length - bracket_wall - 0.1, 10])
    rotate([90, 0, 0])
    screw();
    
    translate([bracket_width * 2 / 3, screw_body_length + screw_head_length - bracket_wall - 0.1, 20])
    rotate([90, 0, 0])
    screw();
}

module bracket_body() {
    translate([-bracket_wall, -bracket_wall, 0])
    cube([bracket_width + bracket_wall, bracket_wall, bracket_height]);
    
    translate([-bracket_wall, 0, 0])
    cube([bracket_wall, bracket_width, bracket_height]);
}

module bracket() {
    difference() {
        bracket_body();
        
        screw_block();
        translate([0, 0, bracket_height / 2 + lack_foot_dist])
        screw_block();
        
        translate([0, bracket_width, 0])
        rotate([0, 0, -90])
        screw_block();
        
        translate([0, bracket_width, bracket_height / 2 + lack_foot_dist])
        rotate([0, 0, -90])
        screw_block();
    }
}

// feet visualization
%translate([0, 0, -lack_foot_height])
cube([lack_foot_width, lack_foot_width, lack_foot_height]);
translate([0, 0, lack_foot_dist])
%cube([lack_foot_width, lack_foot_width, lack_foot_height]);

translate([0, 0, (lack_foot_dist - bracket_height) / 2])
bracket();
