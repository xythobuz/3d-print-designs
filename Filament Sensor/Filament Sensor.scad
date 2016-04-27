
sensor_width = 7;
sensor_tower_width = 4.5;
sensor_length = 25;
sensor_height = 11;
sensor_gap = 3;
sensor_bottom = 3.5;
sensor_hole_diameter = 3;
sensor_hole_distance = 2.4;

pcb_width = 10.5;
pcb_length = 33;
pcb_height = 1.8;
pcb_sensor_x = 0.25;
pcb_conn_x = 0.7;
conn_length = 5.8;
conn_height = 7;

filament_width = 2;
wall_size = 2;
filament_top_distance = 3;
sensor_y_gap = 0.2;

flag_wall = 0.75;
flag_width = 6.5;
flag_gap = 2;
flag_height = 5;

part = "flag"; // "gantry" or "flag"

$fn = 25;

module sensor() {
    difference() {
        cube([sensor_length, sensor_width, sensor_bottom]);
        
        translate([sensor_hole_distance, sensor_width / 2, -1])
            cylinder(d = sensor_hole_diameter, h = sensor_bottom + 2);
        
        translate([sensor_length - sensor_hole_distance, sensor_width / 2, -1])
            cylinder(d = sensor_hole_diameter, h = sensor_bottom + 2);
    }
    
    translate([(sensor_length - sensor_gap - (2 * sensor_tower_width)) / 2, 0, sensor_bottom])
        cube([sensor_tower_width, sensor_width, sensor_height - sensor_bottom]);
    
    translate([(sensor_length - sensor_gap - (2 * sensor_tower_width)) / 2 + sensor_gap + sensor_tower_width, 0, sensor_bottom])
        cube([sensor_tower_width, sensor_width, sensor_height - sensor_bottom]);
}

module pcb() {
    difference() {
        cube([pcb_length, pcb_width, pcb_height]);
        
        translate([pcb_length - sensor_length - pcb_sensor_x, (pcb_width - sensor_width) / 2, 0])
            translate([sensor_hole_distance, sensor_width / 2, -1])
            cylinder(d = sensor_hole_diameter, h = pcb_height + 2);
        
        translate([pcb_length - sensor_length - pcb_sensor_x, (pcb_width - sensor_width) / 2, 0])
            translate([sensor_length - sensor_hole_distance, sensor_width / 2, -1])
            cylinder(d = sensor_hole_diameter, h = pcb_height + 2);
    }
    
    translate([pcb_length - sensor_length - pcb_sensor_x, (pcb_width - sensor_width) / 2, pcb_height])
        sensor();
    
    translate([pcb_conn_x, 0, -conn_height])
        cube([conn_length, pcb_width, conn_height]);
}

module gantry() {
    difference() {
        cube([sensor_hole_diameter + wall_size, sensor_width + (2 * wall_size), wall_size]);
        
        translate([sensor_hole_distance, wall_size + (sensor_width / 2), -1])
            cylinder(d = sensor_hole_diameter, h = wall_size + 2);
    }
    
    difference() {
        translate([sensor_length - sensor_hole_diameter - wall_size, 0, 0])
            cube([sensor_hole_diameter + wall_size, sensor_width + (2 * wall_size), wall_size]);
        
        translate([sensor_length - sensor_hole_distance, wall_size + (sensor_width / 2), -1])
            cylinder(d = sensor_hole_diameter, h = wall_size + 2);
    }
    
    translate([sensor_hole_diameter + wall_size, 0, 0])
        cube([sensor_length - (2 * (sensor_hole_diameter + wall_size)), wall_size - sensor_y_gap, wall_size]);
    
    translate([sensor_hole_diameter + wall_size, sensor_width + wall_size + sensor_y_gap, 0])
        cube([sensor_length - (2 * (sensor_hole_diameter + wall_size)), wall_size - sensor_y_gap, wall_size]);
    
    difference() {
        translate([sensor_length - (2 * (sensor_tower_width + sensor_gap)), 0, wall_size])
            cube([sensor_gap + wall_size, wall_size - sensor_y_gap, sensor_height - sensor_bottom - wall_size]);
        
        translate([sensor_length / 2, wall_size + 1, sensor_height - sensor_bottom - filament_top_distance])
            rotate([90, 0, 0])
            cylinder(d = filament_width, h = wall_size + 2);
    }
    
    difference() {
        translate([sensor_length - (2 * (sensor_tower_width + sensor_gap)), sensor_width + wall_size + sensor_y_gap, wall_size])
            cube([sensor_gap + wall_size, wall_size - sensor_y_gap, sensor_height - sensor_bottom - wall_size]);
        
        translate([sensor_length / 2, sensor_width + (2 * wall_size) + 1, sensor_height - sensor_bottom - filament_top_distance])
            rotate([90, 0, 0])
            cylinder(d = filament_width, h = wall_size + 2);
    }
}

module flag() {
    translate([sensor_length / 2, flag_width + wall_size + (sensor_width - flag_width) / 2, sensor_height - sensor_bottom - filament_top_distance])
    rotate([90, 0, 0])
    union() {
        difference() {
            translate([-sensor_gap / 4, (filament_width + flag_wall) / 2 - 0.3, 0])
                cube([sensor_gap / 2, flag_height, flag_width]);
            
            translate([-sensor_gap / 4 - 1, (filament_width + flag_wall) / 2 - 0.3, (flag_width - flag_gap) / 2])
                cube([sensor_gap / 2 + 2, flag_height + 1, flag_gap]);
        }
        difference() {
            cylinder(d = filament_width + flag_wall, h = flag_width);
            translate([0, 0, -1])
                cylinder(d = filament_width / 2, h = flag_width + 2);
        }
    }
}

%translate([-(pcb_length - sensor_length - pcb_sensor_x), (-(pcb_width - sensor_width) / 2) + wall_size, -pcb_height - sensor_bottom])
    pcb();

if (part == "gantry") {
    gantry();
} else {
    %gantry();
}

if (part == "flag") {
    flag();
} else {
    flag();
}