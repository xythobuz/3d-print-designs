wall = 4.0;
screw_dia = 5.2;
screw_head = 10.0;
screw_bottom = 2.0;
width = 40.0;
height = 25.0;
screw_off_x = 10.0;
screw_off_y = 10.0;
screw_dist = 24.15 - 9.35;

tie_off_z = 2.0;
cabletie_width = 3.2;
cabletie_height = 2.0;
tie_wall_side = 1.0;
tie_wall_top = 1.0;
tie_wall = 5.0;
tie_width = cabletie_width + 2 * tie_wall_side;
tie_height = cabletie_height + 2 * tie_wall_top;
tie_add_bottom = 2.0;

$fn = 42;

module cable() {
    translate([-(tie_width + tie_add_bottom) / 2, -(tie_wall + tie_add_bottom) / 2, 0])
    translate([tie_add_bottom / 2, tie_add_bottom / 2, 0])
    difference() {
        hull() {
            cube([tie_width, tie_wall, tie_height + tie_off_z]);
            
            translate([-tie_add_bottom / 2, -tie_add_bottom / 2, 0])
            cube([tie_width + tie_add_bottom, tie_wall + tie_add_bottom, 0.1]);
        }
        
        translate([(tie_width - cabletie_width) / 2, -1, (tie_height - cabletie_height) / 2 + tie_off_z])
        cube([cabletie_width, tie_wall + 2, cabletie_height]);
    }
}

module x_tie() {
    difference() {
        union() {
            cube([width, height, wall]);
            
            translate([5.5, 20 - 0.5, wall])
            rotate([0, 0, -35])
            cable();
            
            translate([22.5, 20 - 3, wall])
            cable();
        }
        
        for (i = [0, screw_dist])
        translate([width - screw_off_x - i, screw_off_y, 0]) {
            translate([0, 0, -1])
            cylinder(d = screw_dia, h = wall + 2);
            
            translate([0, 0, screw_bottom])
            cylinder(d = screw_head, h = wall + 2);
        }
    }
}

rail = 20;
rail_wall = 2.0;
rail_h = cabletie_height + 2 * rail_wall;
rail_screw = 3.2;
rail_screw_head = 6.0;
rail_screw_len = 3.5;

module rail_tie(rot) {
    difference() {
        union() {
            cube([rail, rail, rail_h]);
            
            translate([(rail - (rail / 4)) / 2, 0, rail_h])
            cube([rail / 4, rail, 1]);
        }
        
        translate([rail / 2, rail / 2, -1]) {
            cylinder(d = rail_screw, h = rail_h + 3);
            cylinder(d = rail_screw_head, h = rail_screw_len + 1);
        }
        
        for (x = [1, 4])
        if (rot) {
            translate([-1, (rail - rail_screw) / x - cabletie_width / 2, rail_wall])
            cube([rail + 2, cabletie_width, cabletie_height]);
        } else {
            translate([(rail - rail_screw) / x - cabletie_width / 2, -1, rail_wall])
            cube([cabletie_width, rail + 2, cabletie_height]);
        }
    }
}

module rail_assembly() {
    %translate([0, -50, rail_h])
    cube([20, 100, 20]);
    
    translate([0, 10, 0])
    rail_tie(0);
    
    translate([0, -10 - rail, 0])
    rail_tie(1);
}

//rail_assembly();

x_tie();
//rail_tie(0);
//rail_tie(1);
