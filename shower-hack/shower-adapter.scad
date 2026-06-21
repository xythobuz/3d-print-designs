
plug_dia = 10.5;
plug_length = 20.0;
plug_len_add = 2;

// use 4 for holder, 2 for adapter
plug_wall = 4.0; //2.0;

shower_wall = 4.0;
shower_dia_min = 25;//31.0;
shower_dia_max = 30;//35.0;
shower_length = 40.0;
shower_cut = 15.0;
shower_angle = 45;

plate_width = 20;
plate_hole = 8.5;
bolt_dia = 8.0;
bolt_len = 33;

knob_dia = 15.0;
knob_height = 4.0;
nut_dia = 15.0;
nut_height = 8.0;

$fn = 30;

include <threads.scad>;

module plug() {
    difference() {
        cylinder(d = plug_dia + plug_wall * 2, h = plug_length + plug_wall);
        
        translate([0, 0, -1])
        cylinder(d = plug_dia, h = plug_length + 1);
    }
}

module shower() {
    difference() {
        cylinder(d1 = shower_dia_min + shower_wall * 2, d2 = shower_dia_max + shower_wall * 2, h = shower_length);
        
        translate([0, 0, -1])
        cylinder(d1 = shower_dia_min, d2 = shower_dia_max, h = shower_length + 2);
        
        translate([-shower_cut / 2, 0, -1])
        cube([shower_cut, shower_dia_max, shower_length + 2]);
    }
}

module holder() {
    plug();
    
    translate([-(plug_dia + plug_wall) / 2, shower_dia_min / 2 + shower_wall + (plug_dia + plug_wall) / 2, 0])
    rotate([0, shower_angle, 0])
    shower();
    
    difference() {
        hull() {
            translate([0, 0, -plug_len_add])
            cylinder(d = plug_dia + plug_wall * 2, h = 1);
            
            translate([0, 0, plug_length + plug_wall - 1])
            cylinder(d = plug_dia + plug_wall * 2, h = 1);
        
            translate([0, 15, 26])
            cube([1, 1, 1]);
            translate([-10, 10, 10])
            cube([1, 1, 1]);
            translate([20, 5, 26])
            cube([1, 1, 1]);
            translate([20, 10, 10])
            cube([1, 1, 1]);
        }
        
        translate([0, 0, -plug_len_add - 1])
        cylinder(d = plug_dia, h = plug_length + plug_len_add + 1);
        
        translate([-(plug_dia + plug_wall) / 2, shower_dia_min / 2 + shower_wall + (plug_dia + plug_wall) / 2, 0])
        rotate([0, shower_angle, 0])
        translate([0, 0, -1])
        cylinder(d1 = shower_dia_min, d2 = shower_dia_max, h = shower_length + 2);
    }
}

module adapter_a() {
    difference() {
        union() {
            hull() {
                cylinder(d = plug_dia - 0.3, h = plug_wall);
                
                translate([-plate_width / 2, plug_dia / 2, -plate_width])
                cube([plate_width, plug_wall, plate_width]);
            }
        
            translate([0, plug_wall + plug_dia / 2, -plate_width / 2])
            rotate([90, 0, 0])
            cylinder(d = plate_hole + 5, h = 11);
        }
        
        translate([0, plug_wall + 8 + plug_dia / 2, -plate_width / 2])
        rotate([90, 0, 0])
        cylinder(d = plate_hole, h = plate_width);
    }
    
    translate([0, 0, plug_wall])
    cylinder(d = plug_dia - 0.3, h = plug_length);
}

module adapter_b() {
    difference() {
        union() {
            hull() {
                translate([0, 0, plug_length + plug_wall])
                rotate([180, 0, 0])
                plug();
                
                translate([-plate_width / 2, plug_dia / 2, -plate_width])
                cube([plate_width, plug_wall, plate_width]);
            }
        
            translate([0, plug_wall + plug_dia / 2, -plate_width / 2])
            rotate([90, 0, 0])
            cylinder(d = plate_hole + 5, h = 13);
        }
        
        translate([0, plug_wall + 6 + plug_dia / 2, -plate_width / 2])
        rotate([90, 0, 0])
        cylinder(d = plate_hole, h = plate_width);
        
        translate([0, 0, plug_wall])
        cylinder(d = plug_dia, h = plug_length + 1);
    }
}

module thread(length, internal) {
    metric_thread(diameter=bolt_dia, pitch=2.54,
        length=length, internal=internal, n_starts=1,
        thread_size=-1, angle=40, leadin=1, leadfac=1.5);
    
    //cylinder(d = bolt_dia, h = length);
}

module bolt() {
    cylinder(d = knob_dia, h = knob_height, $fn = 12);
    
    translate([0, 0, knob_height])
    thread(bolt_len, false);
}

module nut() {
    difference() {
        cylinder(d = nut_dia, h = nut_height, $fn = 12);
        
        translate([0, 0, -0.1])
        thread(nut_height + 0.2, true);
    }
}


translate([0, 0, 3])
scale([1, -1, 1])
holder();

/*
translate([0, 0, -30]) {
    adapter_a();

    translate([0, 15, -plate_width])
    rotate([0, 180, 180])
    adapter_b();


    //translate([0, -8, -10])
    //rotate([90, 0, 180])
    //bolt();

    //translate([0, 29, -10])
    //rotate([90, 0, 0])
    //nut();
}
*/
