knob_dia = 40.0;
knob_height = 15.0;
knob_wall = 4.0;

post_dia = 13.8 - 0.5;
post_height = 32.0;

pipe_off_x = 6.5 - 0.5;
pipe_off_z = 22.0;
pipe_dia = 20.0;

$fn = 25;

difference() {
    cylinder(d = knob_dia, h = knob_height, $fn = 12);
    
    translate([0, 0, knob_wall])
    cylinder(d = knob_dia - knob_wall * 2, h = knob_height);
}

difference() {
    translate([0, 0, knob_wall])
    cylinder(d = post_dia, h = post_height);

    translate([post_dia / 2 + pipe_off_x, 10, knob_wall + pipe_off_z])
    rotate([90, 0, 0])
    cylinder(d = pipe_dia, h = 20);
}
