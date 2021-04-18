hole_dia = 4.1;
hole_dist = 30.0;
height = 10.0;
depth = 10.0;
width = hole_dist + (2 * 7.0);
screw_dia = 3.3;
screw_off = (screw_dia / 2) + 1.0;
gap_dia = 20.0;
gap_height = 3.0;
cut = 0.1;

$fn = 42;

module holes() {
    cylinder(d = hole_dia, h = height + 2);
    
    translate([hole_dist, 0, 0])
    cylinder(d = hole_dia, h = height + 2);
}

module fix() {
    difference() {
        cube([width, depth, height]);
        
        translate([(width - hole_dist) / 2, depth / 2, -1])
        holes();
        
        translate([-1, (depth - cut) / 2, -1])
        cube([width + 2, cut, height + 2]);
        
        translate([screw_off, -1, height / 2])
        rotate([-90, 0, 0])
        cylinder(d = screw_dia, h = depth + 2);
        
        translate([width - screw_off, -1, height / 2])
        rotate([-90, 0, 0])
        cylinder(d = screw_dia, h = depth + 2);
        
        translate([width / 2, -1, (height + gap_height) / 2])
        rotate([-90, 0, 0])
        cylinder(d = screw_dia, h = depth + 2);
        
        translate([width / 2, -1, gap_height - gap_dia / 2])
        rotate([-90, 0, 0])
        cylinder(d = gap_dia, h = depth + 2);
    }
}

module print() {
    rotate([0, -90, 0])
    difference() {
        fix();
        
        translate([-1, (depth - cut) / 2, -1])
        cube([width + 2, depth, height + 2]);
    }
}

//fix();
print();
