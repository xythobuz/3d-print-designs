$fn = 42;

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

difference() {
    union() {
        color("green")
        hull() {
            cube([80, 40, 5]);
            cube([40, 80, 5]);
        }
        
        color("red")
        for (i = [0, 20])
        translate([45, 7.5 + i, 5])
        cube([35, 5, 1]);
        
        color("red")
        for (i = [0, 20])
        translate([7.5 + i, 45, 5])
        cube([5, 35, 1]);
    }
    
    translate([40, 40 + 23, -1])
    rotate([0, -90, 180])
    prism(7, 23, 23);
    
    for (i = [30, 70])
    translate([i, 10, -1])
    cylinder(d = 5.2, h = 8);
    
    for (i = [10, 70])
    translate([i, 30, -1])
    cylinder(d = 5.2, h = 8);
    
    for (i = [10, 30])
    translate([i, 70, -1])
    cylinder(d = 5.2, h = 8);
} 
