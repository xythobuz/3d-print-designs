width = 19;
height = 25;
hole_dia = 3.3;

hole_off_x = 9.7;
hole_off_y = 14.5;

dist = 1;
wall = 4;
base_depth = 20;
support_l = 5;
add_height = 2;
ground_height = support_l + 15 - add_height;

valve_count = 4;

$fn = 42;

w = width;
h = height + ground_height;
l_all = valve_count * w + (valve_count - 1) * dist;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module section(l) {
    translate([0, 0, wall])
    cube([l, wall, h]);
    
    cube([l, base_depth, wall]);
    
    translate([l, wall + support_l, wall])
    rotate([0, 0, 180])
    prism(l, support_l, support_l * 2);
}

module holes() {
    translate([-hole_off_x / 2, 0, -hole_off_y / 2])
    rotate([-90, 0, 0])
    cylinder(d = hole_dia, h = wall + 2);

    translate([hole_off_x / 2, 0, hole_off_y / 2])
    rotate([-90, 0, 0])
    cylinder(d = hole_dia, h = wall + 2);
}

module valve() {
    difference() {
        translate([0, 0, -wall])
        section(w);
        
        translate([w / 2, -1, ground_height + (add_height + height) / 2]) {
            //holes();
            
            scale([-1, 1, 1])
            holes();
        }
    }
}

module all_valves() {
    difference() {
        translate([0, 0, wall])
        for (i = [0 : valve_count - 1]) {
            if (i == 0) {
                translate([i * w, 0, 0])
                valve();
            } else {
                translate([i * w + (i - 1) * dist, 0, -wall])
                section(dist);
                
                translate([i * w + (i - 1) * dist + dist, 0, 0])
                valve();
            }
        }
        
        for (i = [0 : valve_count - 1]) {
            translate([i * w + (i - 1) * dist + dist + w / 2, wall + support_l + (base_depth - wall - support_l) / 2, -1])
            cylinder(d = hole_dia, h = wall + 2);
        }
    }
}

rotate([0, -90, 0])
all_valves();