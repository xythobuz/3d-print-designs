compensate_dia = 0.5;
compensate_width = 0.5;

teeth = 12;
tooth_dia = 2.75 + compensate_dia;
tooth_off = (17.3 + compensate_width - tooth_dia) / 2;
gear_h = 15.0;

adapter_wall = 5;
adapter_dia = tooth_off * 2 + tooth_dia + adapter_wall;
adapter_h = gear_h + adapter_wall;

use_male_socket = false;

// male socket
socket_h = gear_h;
socket_dia = 7.0;
socket_fn = 6;
socket_flare = 3.0;

// female socket
sock_h = 10.0;
sock_w = 6.4 + 0.4;
sock_imp_d = 0.6 + 0.1;
sock_imp_o = 4.0;
sock_imp_w = 3.0;
sock_imp_d2 = 0.4;

$fn = 42;

module gear(h) {
    cylinder(d = tooth_off * 2, h = h);
    
    for (r = [0 : 360 / teeth : 360])
    rotate([0, 0, r])
    translate([tooth_off, 0, 0])
    cylinder(d = tooth_dia, h = h);
}

module female_socket() {
    difference() {
        cylinder(d = adapter_dia, h = sock_h + 0.1);
        
        translate([-sock_w / 2, -sock_w / 2, 0.1])
        cube([sock_w, sock_w, sock_h + 1]);
        
        translate([sock_w / 2, 0, sock_imp_o + 0.1])
        sphere(d = 2 * sock_imp_d);
        
        translate([sock_w / 2, 0, sock_imp_o + 0.1])
        cylinder(d = 2 * sock_imp_d2, h = sock_h);
    }
}

module adapter() {
    difference() {
        union() {
            cylinder(d = adapter_dia, h = adapter_h);
    
            if (use_male_socket)
            translate([0, 0, adapter_h]) {
                cylinder(d = socket_dia, h = socket_h, $fn = socket_fn);
                
                hull() {
                    cylinder(d = socket_dia, h = socket_flare, $fn = socket_fn);
                    translate([0, 0, -socket_flare])
                    cylinder(d = adapter_dia, h = socket_flare);
                }
            }
        }
        
        translate([0, 0, -1])
        gear(gear_h + 1);
        
        if (use_male_socket)
        translate([0, 0, gear_h - 0.1])
        cylinder(d1 = tooth_off * 2 + tooth_dia, d2 = 5, h = socket_flare * 2 + 0.1);
    }
    
    if (!use_male_socket)
    translate([0, 0, adapter_h])
    female_socket();
}

//gear(gear_h);
adapter();
