hole_dist = 70;
hole_dia = 13;
carrier_width = 20;
carrier_radius = 100;
carrier_length = hole_dist + 30;
carrier_wall = 1.5;

coil_width = 17.0;
coil_turns = 3;
coil_dia = 10;
coil_w = coil_width * coil_turns;

rx_post_w = 8;
rx_post_h = 50 + 20;
rx_post_wall = 1;
rx_post_box_w = 26.5;
rx_post_box_d = 12;
rx_post_box_h = 26;

carrier_circ = 2 * 3.14159 * carrier_radius + carrier_wall;
carrier_angle = (carrier_length / carrier_circ) * 360;
dist_angle = (hole_dist / carrier_circ) * 360;
post_angle = ((carrier_length - coil_dia) / carrier_circ) * 360;
bottom_angle = (coil_dia / carrier_circ) * 360;

add_rx_box = true;
add_coil_posts = false;
add_rx_post = false;
add_rx_post_box = false;

carrier_width_add = add_rx_box ? 5 : coil_dia;

$fn = 94;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

// https://3dprinting.stackexchange.com/questions/10638/creating-pie-slice-in-openscad
module pie_slice(r = 3.0, a = 30) {     
    intersection() {
        circle(r = r);
        
        square(r);
        
        rotate(a-90)
        square(r);  
    } 
}

module carrier_plate() {
    rotate([0, 0, 90 - carrier_angle / 2])
    linear_extrude(carrier_width + carrier_width_add)
    difference() {
        pie_slice(carrier_radius + carrier_wall, carrier_angle);
        pie_slice(carrier_radius, carrier_angle);
    }
}

module cable_coil() {
    hull() {
        rotate([-90, 0, 0])
        cylinder(d = coil_dia, h = coil_w);

        translate([0, -carrier_radius, -coil_dia / 2])
        rotate([0, 0, 90 - bottom_angle / 2])
        linear_extrude(coil_dia)
        difference() {
            pie_slice(carrier_radius + carrier_wall, bottom_angle);
            pie_slice(carrier_radius, bottom_angle);
        }
    }

    translate([0, -carrier_radius, -carrier_width])
    rotate([0, 0, 90 - bottom_angle / 2])
    linear_extrude(carrier_width)
    difference() {
        pie_slice(carrier_radius + carrier_wall, bottom_angle);
        pie_slice(carrier_radius, bottom_angle);
    }
}

module rx_post() {
    hull() {
        cube([rx_post_w, rx_post_w, 1]);
        
        translate([rx_post_w / 2, rx_post_w / 2, 0])
        cylinder(d = rx_post_w, h = rx_post_h);
    }
    
    if (add_rx_post_box)
    translate([-((rx_post_box_w + 2 * rx_post_wall) - rx_post_w) / 2, 0, rx_post_h])
    difference() {
        cube([rx_post_box_w + 2 * rx_post_wall, rx_post_box_d + 2 * rx_post_wall, rx_post_box_h]);
        
        translate([rx_post_wall, rx_post_wall, 1])
        cube([rx_post_box_w, rx_post_box_d, rx_post_box_h]);
    }
}

rx_box_h = 15;
rx_box_w = 10;
rx_box_d = carrier_width + carrier_width_add;
rx_box_wall = 2.0;

module rx_box() {
    translate([-rx_box_w / 2, 0, -carrier_wall])
    cube([rx_box_w, rx_box_wall, rx_box_h]);
    
    translate([-rx_box_w / 2, 0, rx_box_h])
    cube([rx_box_w, rx_box_d, rx_box_wall]);
    
    rotate([0, 180, 180])
    translate([-rx_box_w / 2, -rx_box_d / 4, -rx_box_h])
    prism(rx_box_w, rx_box_d / 4, rx_box_h / 4);
}

module carrier() {
    translate([0, -carrier_radius, 0])
    difference() {
        union() {
            carrier_plate();
            
            if (add_coil_posts)
            for (i = [1, -1])
            rotate([0, 0, i * post_angle / 2])
            translate([0, carrier_radius, carrier_width + coil_dia / 2])
            cable_coil();
            
            if (add_rx_post)
            translate([-rx_post_w / 2, carrier_radius, carrier_width + carrier_width_add])
            rotate([-90, 0, 0])
            rx_post();
            
            if (add_rx_box)
            translate([0, carrier_radius + carrier_wall, carrier_width + carrier_width_add])
            rotate([-90, 0, 0])
            rx_box();
        }
        
        for (i = [1, -1])
        rotate([0, 0, i * dist_angle / 2])
        translate([0, carrier_radius - 1, carrier_width / 2])
        rotate([-90, 0, 0])
        cylinder(d = hole_dia, h = carrier_wall + 2);
    }
}

//cable_coil();
//rx_post();
//rx_box();

carrier();
