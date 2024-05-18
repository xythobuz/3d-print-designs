clipper_dia = 20;
clipper_height = 5;

clipper_dist = 10;
clipper_floor = 2;

count_x = 2;
count_y = 1;

module clipper() {
    cylinder(d = clipper_dia, h = clipper_height + 1);
}

difference() {
    cube([count_x * (clipper_dia + clipper_dist), count_y * (clipper_dia + clipper_dist), clipper_floor + clipper_height]);

    for (x = [0 : count_x - 1]) {
        for (y = [0 : count_y - 1]) {
            translate([x * (clipper_dia + clipper_dist), y * (clipper_dia + clipper_dist), 0])
            translate([(clipper_dia + clipper_dist) / 2, (clipper_dia + clipper_dist) / 2, clipper_floor])
            clipper();
        }
    }
}
