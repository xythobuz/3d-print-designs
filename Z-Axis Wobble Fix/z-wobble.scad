
diameter_outer_min = 10;
diameter_outer_max = 12;
height = 10;
diameter_inner_min = 2.8;
diameter_inner_max = 2.8;

$fn = 20;

difference() {
    cylinder(d1 = diameter_outer_max, d2 = diameter_outer_min, h = height);
    cylinder(d = diameter_inner_max, d2 = diameter_inner_min, h = height);
}
