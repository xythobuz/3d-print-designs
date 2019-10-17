pipe_dia = 23.0;
pipe_dist = 25.0;
hole_dia = 3.5;
wall = 5.0;
height = 10.0;
cut = 2.0;

$fn = 25;

difference() {
    translate([-(pipe_dia / 2) - (2 * wall) - hole_dia, -(pipe_dia / 2) - wall, 0])
        cube([pipe_dist + (2 * pipe_dia) + (4 * wall) + (2 * hole_dia), pipe_dia + (2 * wall), height]);
    
    translate([-(pipe_dia / 2) - (2 * wall) - hole_dia - 1, -cut / 2, -1])
        cube([pipe_dist + (2 * pipe_dia) + (4 * wall) + (2 * hole_dia) + 2, cut, height + 2]);

    translate([0, 0, -1])
        cylinder(d = pipe_dia, h = height + 2);
    translate([pipe_dist + pipe_dia, 0, -1])
        cylinder(d = pipe_dia, h = height + 2);
    
    rotate([90, 0, 0])
        translate([-pipe_dia / 2 - wall, height / 2, -pipe_dia / 2 - wall - 1])
        cylinder(d = hole_dia, h = pipe_dia + (2 * wall) + 2);
    rotate([90, 0, 0])
        translate([pipe_dist + (pipe_dia * 3 / 2) + wall, height / 2, -pipe_dia / 2 - wall - 1])
        cylinder(d = hole_dia, h = pipe_dia + (2 * wall) + 2);
    rotate([90, 0, 0])
        translate([(pipe_dist + pipe_dia) / 2, height / 2, -pipe_dia / 2 - wall - 1])
        cylinder(d = hole_dia, h = pipe_dia + (2 * wall) + 2);
}
