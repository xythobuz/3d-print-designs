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
            cube([60, 20, 5]);
            cube([20, 60, 5]);
        }
        
        color("red")
        translate([25, 7.5, 5])
        cube([35, 5, 1]);
        
        color("red")
        translate([7.5, 25, 5])
        cube([5, 35, 1]);
    }
    
    translate([20, 20 + 23, -1])
    rotate([0, -90, 180])
    prism(7, 23, 23);
    
    for (i = [10, 30, 50])
    translate([i, 10, -1])
    cylinder(d = 5.2, h = 8);
    
    for (i = [30, 50])
    translate([10, i, -1])
    cylinder(d = 5.2, h = 8);
} 
