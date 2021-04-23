pipe_od = 4.0;
pipe_id = 2.0;
pipe_od_max = 6.0;
barb_height = 4;
barb_count = 2;
barb_off = 1;
pipe_height = 15;
filter_height = 8;
filter_dia = 15;
filter_wall = 2.0;
filter_hole_dia = filter_dia - 2 * filter_wall;
hole_count_x = 20;
hole_count_y = 1;
hole_width = 0.8;
hole_height = filter_height - 2 * filter_wall;
hole_off = filter_wall;
adapter_height = 4;

show_open = false;

$fn = 42;

module pipe() {
    difference() {
        union() {
            cylinder(d = pipe_od, h = pipe_height);
            
            for (i = [1 : barb_count]) {
                translate([0, 0, i * (pipe_height / (barb_count + 1)) - barb_off])
                cylinder(d1 = pipe_od_max, d2 = pipe_od, h = barb_height);
            }
        }
        
        translate([0, 0, -1])
        cylinder(d = pipe_id, h = pipe_height + 2);
    }
}

module filter() {
    difference() {
        cylinder(d = filter_dia, h = filter_height);
        
        translate([0, 0, hole_off])
        for (i = [1 : hole_count_x]) {
            for (j = [0 : hole_count_y - 1]) {
                translate([0, 0, (hole_height + hole_off) * j])
                rotate([0, 0, 360 / hole_count_x * i])
                cube([hole_width, filter_dia, hole_height]);
            }
        }
        
        translate([0, 0, filter_wall])
        cylinder(d = filter_hole_dia, h = filter_height - filter_wall + 1);
        
        translate([0, 0, filter_height - filter_wall - 1])
        cylinder(d = pipe_id, h = filter_wall + 2);
    }
}

module adapter() {
    difference() {
        cylinder(d1 = filter_dia, d2 = pipe_od, h = adapter_height);
        
        translate([0, 0, -0.1])
        cylinder(d1 = filter_hole_dia, d2 = pipe_id, h = adapter_height + 0.2);
    }
}

module part() {
    difference() {
        union() {
            filter();
            
            translate([0, 0, filter_height])
            adapter();
            
            translate([0, 0, filter_height + adapter_height])
            pipe();
        }
        
        if (show_open) {
            translate([-50, -filter_dia, -50])
            cube([100, filter_dia, 100]);
        }
    }
}

part();