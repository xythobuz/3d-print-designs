
height = 25;
outer_diameter = 5;
inner_diameter = 2;

$fn = 6;

difference() {
    cylinder(d = outer_diameter, h = height);
    translate([0, 0, -1])
        cylinder(d = inner_diameter, h = height + 2);
}
