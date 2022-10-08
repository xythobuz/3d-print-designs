pcb_width = 70.25;
pcb_height = 103.75;
pcb_depth = 2;

pcb_holes = [
    [ 32.05, 5.53 ],
    [ 29.41, 37.34 ],
    [ pcb_width - 3.22, 23.39 ],
    [ pcb_width - 3.02, pcb_height - 18.20 ],
    [ 2.56, pcb_height - 2.53 ]
];
hole_support_dia = 2.53 * 2; // min value of pcb_holes * 2
pcb_dia = 3.2;

wall = 5.0;
pcb_wall_dist = 15;
pcb_mount_dist = 5.0;
mount_dia = 4.2;

mounting_holes = [
    pcb_height * 1 / 8,
    pcb_height * 4 / 8,
    pcb_height * 7 / 8
];

cutouts = [
    [ 12.5, 2, 10, -30 ],
    [ 12.5, 2, 35, -30 ],
    [ 12.5, 2, -15, -30 ],
    
    [ 12.5, 2, 10, -5 ],
    [ 12.5, 2, 35, -5 ],
    [ 12.5, 2, -15, -5 ],
    
    [ 12.5, 2, 10, 30 ],
    [ 12.5, 2, 35, 30 ],
    [ 12.5, 2, -15, 30 ],
    
    /*
    [ 20, 4, -5, -22.5 ],
    [ 20, 4, 35, -22.5 ],
    [ 25, 4, 32.5, 22.5 ],
    [ 10, 4, -12.5, 35 ],
    [ 10, 4, -12.5, 10 ],
    */
];

$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module holes(dia, height) {
    for (h = [0 : len(pcb_holes) - 1])
    translate([pcb_width - pcb_holes[h][0], pcb_holes[h][1], 0])
    cylinder(d = dia, h = height);
}

module pcb() {
    cube([pcb_width, pcb_height, pcb_depth]);
    
    translate([0, 0, -pcb_mount_dist - wall - 1])
    holes(pcb_dia - 0.2, pcb_mount_dist + wall + 1);
}

module mount() {
    translate([0, -wall, 0])
    difference() {
        union() {
            cube([pcb_width + pcb_wall_dist + 20, wall, pcb_height]);
            
            translate([pcb_width + pcb_wall_dist + 7.5, wall, 0])
            cube([5, 1, pcb_height]);
            
            translate([0, wall, pcb_height])
            rotate([-90, 0, 0])
            holes(hole_support_dia, pcb_mount_dist);
        }
        
        for (i = mounting_holes)
        translate([pcb_width + pcb_wall_dist + 10, -1, i])
        rotate([-90, 0, 0])
        cylinder(d = mount_dia, h = wall + 3);
        
        translate([0, -1, pcb_height])
        rotate([-90, 0, 0])
        holes(pcb_dia, wall + pcb_mount_dist + 2);
        
        for (c = [0 : len(cutouts) - 1])
        for (i = [0, 1, 2, 3])
        translate([pcb_width / 2 + cutouts[c][2], 0, pcb_height / 2 + cutouts[c][3]])
        rotate([0, 90 * i, 0])
        translate([cutouts[c][0] * sqrt(2) / 2 + cutouts[c][1], -1, -cutouts[c][0] * sqrt(2) / 2])
        rotate([45, 0, 90])
        prism(wall + 2, cutouts[c][0], cutouts[c][0]);
    }
}

module assembly() {
    %translate([0, pcb_mount_dist, pcb_height])
    rotate([-90, 0, 0])
    pcb();
    
    mount();
}

//translate([0, 0, pcb_height])
//rotate([0, 180, 0])

rotate([90, 0, 0])

assembly();
