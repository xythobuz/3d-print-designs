plate = 250;
mount_dist = 58;
trans_width = 45;
trans_depth = 30;
trans_height = 20;
hole = 5.0;
hole_dist = 2;
arm_len = 70 + (hole / 2) + hole_dist;
height = 3;
width = 9;
arm_height = 25;
top_arm_len = 35.1;

hook_width_add = 3;
hook_dia = 15;
hook_height = width;
hook_size = 2;
hook_off = 15;

print_dist = 10;
print = true;

$fn = 42;

module mount(layer) {
    difference() {
        cube([width, arm_len, height]);
        
        translate([width / 2, hole / 2 + hole_dist, -1])
        cylinder(d = hole, h = height + 2);
    }
    
    difference() {
        translate([0, arm_len - height, 0]) {
            cube([width, height, arm_height + (layer * height)]);
            
            translate([0, 0, arm_height + (layer * height)])
            cube([width, top_arm_len, height]);
        }
    
        translate([0, arm_len - height, 0])
        translate([0, 0, arm_height + (layer * height)])
        translate([width / 2, top_arm_len - 4.5, -4 * height + 2])
        cylinder(d = hole, h = (height * 4) + 2);
    }
}

module circles() {
    translate([-hook_dia / 2 + hook_size, hook_height, 0])
    rotate([90, 0, -0])
    difference() {
        cylinder(d = hook_dia, h = hook_height);
        translate([0, 0, -1])
        cylinder(d = hook_dia - hook_size * 2, h = hook_height + 2);
        
        translate([-hook_dia / 2 - 1, -hook_dia, -1])
        cube([hook_dia + 2, hook_dia, hook_height + 2]);
    }
}

module hook() {
    difference() {
        cube([width + hook_size + hook_width_add, width, height]);
        
        translate([width / 2, width / 2, -1])
        cylinder(d = hole, h = height + 2);
    }
    
    translate([width + hook_width_add, width - hook_height, height])
    cube([hook_size, hook_height, hook_off]);
    
    translate([width + hook_width_add, width - hook_height, height + hook_off])
    circles();
}

module print_arrangement() {
    rotate([0, -90, 0])
    mount(0);
    
    translate([print_dist, 10, 0])
    rotate([0, -90, 0])
    mount(1);
    
    translate([print_dist * 2, 20, 0])
    rotate([0, -90, 0])
    mount(2);
    
    translate([print_dist * 3, 30, 0])
    rotate([0, -90, 0])
    mount(3);
    
    translate([25, 0, width])
    rotate([-90, 0, 0])
    hook();
}

module preview_arrangement() {
    // plate
    translate([-plate / 2, -plate / 2, 0])
    union() {
        color("purple")
        cube([plate, plate, 1]);
        
        color("green")
        translate([mount_dist, mount_dist, 1])
        cylinder(d = hole, h = height * 2);
        
        color("green")
        translate([plate - mount_dist, mount_dist, 1])
        cylinder(d = hole, h = height * 2);
        
        color("green")
        translate([mount_dist, plate - mount_dist, 1])
        cylinder(d = hole, h = height * 2);
        
        color("green")
        translate([plate - mount_dist, plate - mount_dist, 1])
        cylinder(d = hole, h = height * 2);
        
        color("orange")
    translate([(plate - trans_width) / 2, (plate - trans_depth) / 2, 0])
        cube([trans_width, trans_depth, trans_height]);
    }

    // arms
    for (i = [0 : 3]) {
        rotate([0, 0, 45 + (90 * i)])
        translate([-width / 2, -arm_len - 27.6, 0])
        mount(i);
    }
    
    translate([-4.5, -4.5, 37])
    hook();
}

if (print) {
    print_arrangement();
} else {
    preview_arrangement();
}
