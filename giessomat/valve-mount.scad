width = 20;
height = 20;
hole_dia = 4.4;
hole_off = 25.4 / 2;
hole_angle = 45;
ground_height = 10 + 5;
dist = 1;
wall = 3;
base_depth = 25;
support_l = 5;
add_width = 7;
add_height = 7;
add_support = 3;
section_gap_height = 10;
section_gap_part = 5;

valve_count = 2;

$fn = 42;

w = width + add_width;
h = height + ground_height + add_height;
l_all = valve_count * w + (valve_count - 1) * dist;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module gap(l, w, h, p) {
    difference() {
        translate([-0.001, 0.001, 0])
        cube([l + 0.002, w + 0.001, h]);
        
        translate([-1, w, h])
        rotate([180, 0, 0])
        prism(l + 2, w, h / 2 - p / 2);
        
        translate([-1, 0, h / 2 - p / 2])
        rotate([-90, 0, 0])
        prism(l + 2, h / 2 - p / 2, w);
    }
}

module strengthening(l) {
    difference() {
        translate([0, wall, h - height - add_height + wall])
        cube([l, add_support, height + add_height]);
        
        translate([0, wall, wall + h - section_gap_height / 2 - (height + add_height) / 2])
        gap(l, add_support, section_gap_height, section_gap_part);
    }
    
    translate([0, wall + add_support, h - height - add_height + wall])
    rotate([180, 0, 0])
    prism(l, add_support, add_support);
}

module section(l) {
    translate([0, 0, wall])
    cube([l, wall, h]);
    
    cube([l, base_depth, wall]);
    
    translate([l, wall + support_l, wall])
    rotate([0, 0, 180])
    prism(l, support_l, support_l);
    
    translate([l, wall, 0])
    rotate([0, 0, 180])
    strengthening(l);
}

module holes() {
    rotate([0, hole_angle, 0]) {
        translate([-hole_off, -add_support, 0])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = wall + add_support + 2);
    
        translate([hole_off, -add_support, 0])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = wall + add_support + 2);
    }
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

//rotate([0, -90, 0])
all_valves();