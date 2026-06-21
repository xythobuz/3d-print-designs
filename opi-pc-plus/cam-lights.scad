light_height = 8;
light_wall = 3;
light_wall_add = 2;
light_dia = 150;
light_cut = 20;
lights_off = 5.8;

light_h = light_height + (2 * light_wall_add);

module lights_ring() {
    $fn = 50;
    translate([0, light_dia / 2, 0])
    difference() {
        cylinder(h = light_h, d = light_dia);
        
        translate([0, 0, -1])
            cylinder(h = light_h + 2, d = light_dia - light_wall - light_wall_add);
        
        translate([0, 0, light_wall_add])
            cylinder(h = light_height, d = light_dia - light_wall);
        
        translate([-light_dia / 2, -light_dia / 2 + light_cut, -1])
            cube([light_dia, light_dia, light_h + 2]);
    }
}

module lights_mount() {
    translate([0, -edge / 2 - length + hole_off, height - forw_height + mock_pole_height - mock_pole_off * 2 - 10])
    difference() {
        union() {
            cylinder(d = hole_size + hole_wiggle + cam_wall * 2, h = light_h);
            
            translate([0, lights_off, 0])
                lights_ring();
        }
        
        translate([0, 0, -1])
            cylinder(d = hole_size + hole_wiggle, h = light_h + 2);
    }
}

include <cam-holder.scad>
use <../Webcam Holder/cam_bracket.scad>

module fab_min_mount() {
    translate([-13.5, -60.5, 120])
    union() {
        rotate([90, 0, 90])
        webcam_shaft();
    
        translate([27, -6, -5])
        rotate([0, 180, 0])
        cam_plate();
    
        hull() {
            translate([0, -6, -9])
            cube([27, 3, 8]);
            translate([9, -1, -5.5])
            cube([9, 10, 5.5]);
        }
    }
}

//translate([0, 0, -15])
//lights_mount();

// for use with orangepi cam you just need this
//cam_holder_mount();

// orangepi cam
//use <opi-cam-mount.scad>
//color("white")
//%translate([13, -37, 75])
//    rotate([90, 0, 180])
//    cam_holder();

// Fabrikator Mini Cam Holder
fab_min_mount();
