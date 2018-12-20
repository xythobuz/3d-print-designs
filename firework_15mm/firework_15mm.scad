
charge_dia = 16.2;
charge_height = 42.0;
charge_wall = 2.5;

base_add = 2.5;
bottom_pins = 3.0;

ignite_dia = 7.0;
ignite_height = 20.0;
ignite_wall = 1.2;

cable_dia = 5.0;
cable_width = 2.0;

hole_dia = 7.0;
hole_len = 15.0;
hole_angle = 45.0;
hole_off = 4.0;
hole_off2 = 2.0;

mount_height = 2.0;
mount_width = 6.0;
mount_len = 10.0;
mount_hole = 3.2;

$fn = 42;

module gas_holes() {
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

module mount_tabs() {
    for (i = [0 : 90 : 360]) {
        rotate([0, 0, i + 45])
        translate([charge_dia / 2, -mount_width / 2, 0])
        difference() {
            union() {
                cube([mount_len, mount_width, mount_height]);
                
                translate([mount_len, mount_width / 2, 0])
                cylinder(d = mount_width, h = mount_height);
            }
            
            translate([mount_len, mount_width / 2, -1])
            cylinder(d = mount_hole, h = mount_height + 2);
        }
    }
}

module charge() {
    difference() {
        // outer shell
        cylinder(d = charge_dia + (2 * charge_wall), h = charge_height + charge_wall + base_add);
        
        // bore hole
        translate([0, 0, charge_wall + base_add])
        cylinder(d = charge_dia, h = charge_height + 1);
        
        // cable hole
        translate([0, 0, -1])
        cylinder(d = cable_dia, h = charge_wall + base_add + 2);
        
        // cable cut on bottom
        translate([0, -cable_dia / 2, -1])
        cube([charge_dia, cable_dia, cable_width + 1]);
        
        translate([0, 0, base_add])
        gas_holes();
        
        translate([0, 0, charge_height / 2 + base_add])
        gas_holes();
    }
    
    // pins to hold up long charges
    for (i = [0 : 90 : 360]) {
        rotate([0, 0, i + 45])
        translate([(charge_dia - bottom_pins) / 2, 0, charge_wall + base_add])
        sphere(d = bottom_pins);
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

    translate([0, 0, charge_wall + base_add])
    ignite();
    
    mount_tabs();
}

top();