
charge_dia = 16.2;
charge_height = 55.0;
charge_wall = 2.5;

ignite_dia = 6.8;
ignite_height = 17.0;
ignite_wall = 1.2;

cable_dia = 5.0;

base_width = 25;
base_height = 10.0;
base_wall = 3.0;

hole_dia = 5.0;
hole_len = 8.0;
hole_angle = 45.0;
hole_off = 2.0;
hole_off2 = 5.0;

$fn = 42;

module charge() {
    difference() {
        cylinder(d = charge_dia + (2 * charge_wall), h = charge_height + charge_wall);
        
        translate([0, 0, charge_wall])
        cylinder(d = charge_dia, h = charge_height + 1);
        
        translate([0, 0, -1])
        cylinder(d = cable_dia, h = charge_wall + 2);
        
        translate([charge_dia / 2 + charge_wall + hole_off, 0, hole_off2])
        rotate([0, -hole_angle, 0])
        cylinder(d = hole_dia, h = hole_len);
        
        translate([-charge_dia / 2 - charge_wall - hole_off, 0, hole_off2])
        rotate([0, hole_angle, 0])
        cylinder(d = hole_dia, h = hole_len);
        
        translate([0, charge_dia / 2 + charge_wall + hole_off, hole_off2])
        rotate([hole_angle, 0, 0])
        cylinder(d = hole_dia, h = hole_len);
        
        translate([0, -charge_dia / 2 - charge_wall - hole_off, hole_off2])
        rotate([-hole_angle, 0, 0])
        cylinder(d = hole_dia, h = hole_len);
    }
}

module ignite() {
    difference() {
        cylinder(d = ignite_dia + (2 * ignite_wall), h = ignite_height + ignite_wall);
        
        translate([0, 0, ignite_wall])
        cylinder(d = ignite_dia, h = ignite_height + 1);
        
        translate([0, 0, -1])
        cylinder(d = cable_dia, h = ignite_wall + 2);
    }
}

module top() {
    charge();

    translate([0, 0, charge_wall])
    ignite();
}

module pillars() {
    hull() {
        cube([base_wall, base_wall, base_wall]);
        
        translate([base_width / 2, base_width / 2, base_height + base_wall])
        cylinder(d = charge_dia + (2 * charge_wall), h = 1);
    }
    
    hull() {
        translate([base_width - base_wall, 0, 0])
        cube([base_wall, base_wall, base_wall]);
        
        translate([base_width / 2, base_width / 2, base_height + base_wall])
        cylinder(d = charge_dia + (2 * charge_wall), h = 1);
    }
    
    hull() {
        translate([0, base_width - base_wall, 0])
        cube([base_wall, base_wall, base_wall]);
        
        translate([base_width / 2, base_width / 2, base_height + base_wall])
        cylinder(d = charge_dia + (2 * charge_wall), h = 1);
    }
    
    hull() {
        translate([base_width - base_wall, base_width - base_wall, 0])
        cube([base_wall, base_wall, base_wall]);
        
        translate([base_width / 2, base_width / 2, base_height + base_wall])
        cylinder(d = charge_dia + (2 * charge_wall), h = 1);
    }
}

module base() {
    cube([base_width, base_width, base_wall]);
    
    difference() {
        pillars();
        
        translate([base_width / 2, base_width / 2, base_wall + 1])
        cylinder(d = cable_dia, h = base_height + 2);
    }
    
    translate([base_width / 2, base_width / 2, base_height + base_wall])
    top();
}

base();