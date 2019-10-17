height = 67.5;
width = 50.0;
depth = 15.0;
large_hole = 31.0;
small_hole = 6.4;
large_hole_off = 6.5;
small_hole_off = 15.0;
small_hole_depth = 39.0;
screw_large = 4.2;
screw_small = 3.5;
screw_head = 8.5;
screw_head_depth = 4.5;
screw_large_depth = 23.0;
screw_small_depth = 40.0;
screw_off = 5.0;
gap = 2.0;

$fn = 25;

difference() {
    cube([width, height, depth]);
    
    translate([width / 2, height - (large_hole / 2) - large_hole_off, -1])
    cylinder(d = large_hole, h = depth + 2);
    
    translate([-1, height - (large_hole / 2) - large_hole_off - (gap / 2), -1])
    cube([width + 2, gap, depth + 2]);
    
    translate([-1, (small_hole / 2) + small_hole_off, depth / 2])
    rotate([0, 90, 0])
    cylinder(d = small_hole, h = small_hole_depth + 1);
    
    translate([10, (small_hole / 2) + small_hole_off, depth / 2])
    rotate([90, 0, 0])
    cylinder(d = screw_small, h = small_hole_depth + 1);
    
    translate([30, (small_hole / 2) + small_hole_off, depth / 2])
    rotate([90, 0, 0])
    cylinder(d = screw_small, h = small_hole_depth + 1);
    
    translate([screw_off, height + 1, depth / 2])
    rotate([90, 0, 0]) {
        cylinder(d = screw_head, h = screw_head_depth + 1);
        cylinder(d = screw_large, h = screw_large_depth);
        cylinder(d = screw_small, h = screw_small_depth);
    }
    
    translate([width - screw_off, height + 1, depth / 2])
    rotate([90, 0, 0]) {
        cylinder(d = screw_head, h = screw_head_depth + 1);
        cylinder(d = screw_large, h = screw_large_depth);
        cylinder(d = screw_small, h = screw_small_depth);
    }
}
