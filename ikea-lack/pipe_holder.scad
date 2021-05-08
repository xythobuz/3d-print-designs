tube = 16.5;
wall = 6;
depth = 12;
mount = 1;
wall_off = 3;
tab = 11;
hole = 4.1;

head_min = hole;
head_max = 7.9;
head_height = 2.5;

fix_height = 9;
fix_wall = 4;
fix_dia = 40;
fix_hole = 2.8;

double = true;

$fn = 42;

module fix() {
    difference() {
        cylinder(d = fix_dia, h = fix_height);
        
        translate([0, 0, -1])
        cylinder(d = tube, h = fix_height + 2);
            
        translate([0, -1, fix_height / 2])
        rotate([90, 0, 0])
        cylinder(d = fix_hole, h = fix_dia / 2);
            
        translate([1, 0, fix_height / 2])
        rotate([0, 90, 0])
        cylinder(d = fix_hole, h = fix_dia / 2);
    }
}

module tab() {
    difference() {
        cube([wall + wall_off, tab, depth]);
        
        translate([-1, tab / 2, depth / 2])
        rotate([0, 90, 0]) {
            cylinder(d = hole, h = wall + wall_off + 2);
            
            translate([0, 0, wall + wall_off + 1 - head_height])
            cylinder(d1 = head_min, d2 = head_max, h = head_height + 0.01);
        }
    }
}

module main_part() {
    hull() {
        cylinder(d = tube + (2 * wall), h = depth);
        
        translate([-tube / 2 - wall_off, tube / 2 + wall, 0])
        cube([wall + wall_off, mount, depth]);
        
        translate([-tube / 2 - wall_off, -tube / 2 - wall - mount, 0])
        cube([wall + wall_off, mount, depth]);
    }
    
    translate([-tube / 2 - wall_off, tube / 2 + wall + mount, 0])
    tab();
    
    translate([-tube / 2 - wall_off, -tube / 2 - wall - mount - tab, 0])
    tab();
}

module whole() {
    difference() {
        main_part();
        
        translate([0, 0, -1])
        cylinder(d = tube, h = depth + 2);
        
        translate([-100 - tube / 2 - wall_off, -50, -50])
        cube([100, 100, 100]);
    }
}

translate([fix_dia + 10, 0, 0])
fix();

whole();

if (double) {
    translate([0, 0, depth])
    whole();
}
