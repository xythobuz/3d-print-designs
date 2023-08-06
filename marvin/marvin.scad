$fn = 100;

base = 35;
body = 20;

module rc(a, b, c, r, to) {
    hull() {
        if (to)
        translate([0, 0, r])
        cube([a, b, c - r * 2]);
        else
        cube([a, b, c - r]);
        
        for (y = [r, b - r])
        translate([0, y, c - r])
        rotate([0, 90, 0])
        cylinder(r = r, h = a);

        if (to)
        for (y = [r, b - r])
        translate([0, y, r])
        rotate([0, 90, 0])
        cylinder(r = r, h = a);
    }
}

module stem() {
    translate([-152, 36, 0])
    cube([106, 4, 2]);
    
    hull() {
        #translate([-34.5, 10, 0])
        cube([4.5, 0.1, 2]);
        
        #translate([-50, 39.9, 0])
        cube([4, 0.1, 2]);
    }
}

// https://www.thingiverse.com/thing:776622
module glasses() {
    f = body / 122;
    
    scale([f, f, f])
    translate([0, -61, -40])
    union() {
        translate([-10, -24, -20])
        rotate([90, 0, -90])
        import("dealwithit_main_hole.stl");
        
        for (y = [0, 124])
        rotate([90, 0, 0])
        translate([138, 0, -y])
        //import("dealwithit_stem.stl");
        stem();
    }
}

// https://openhome.cc/eGossip/OpenSCAD/SectorArc.html
module sector(radius, angles, fn = $fn) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}
module arc(radius, angles, width = 1, fn = $fn) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}

module glas() {
    difference() {
        cylinder(d1 = 9, d2 = 12, h = 20);
        
        translate([0, 0, 1])
        scale([0.8, 0.8, 1.1])
        cylinder(d1 = 9, d2 = 12, h = 20);
    }
}

module gripper() {
    difference() {
        cylinder(d = 12, h = 3);
        
        translate([-20, -10, -10])
        cube([20, 20, 20]);
        
        translate([0, 0, -1])
        cylinder(d = 5.5, h = 5);
    }
}

module arm() {
    hull() {
        translate([5, 0, -5.5])
        rotate([0, 90, 0])
        cylinder(d = 5, h = 1);
        
        translate([15, -5, -10])
        rotate([0, 90, -45])
        cylinder(d = 5, h = 1);
    }
    hull() {
        translate([15, -5, -10])
        rotate([0, 90, -45])
        cylinder(d = 5, h = 1);
        
        translate([22, -15, 0])
        rotate([0, 90, -90])
        cylinder(d = 5, h = 1);
    }
    
    translate([0, 0, -7])
    gripper();
    
    // glass
    rotate([180, 0, 0])
    scale(0.6)
    glas();
}

module marvin() {
    // base
    color("green")
    hull() {
        translate([0, 0, 10])
        rotate([0, 90, 0])
        rc(10, base, base, 3, true);

        translate([(base - body) / 2, (base - body) / 2, 15])
        cube([body, body, 1]);
    }
    
    // feet
    color("blue")
    for (x = [3, base - 3])
    for (y = [3, base - 3])
    translate([x, y, 0])
    sphere(r = 3);

    // body
    translate([(base - body) / 2, (base - body) / 2, 15]) {
        difference() {
            rc(body, body, 40, 2, false);
            
            // face
            translate([-1, 2.5, 25.5])
            rc(2, 15, 12, 2, true);
        }
        
        // mouth
        color("yellow")
        translate([-1, 2.5, 25.5])
        translate([2.5, 4, 0])
        rotate([0, -90, 0])
        rotate([0, 0, -50])
        linear_extrude(1.7)
        arc(3, [10, 120], 1);
    }
    
    // arm
    translate([-2, 42, -3]) {
        translate([0, 0, 40])
        arm();
        
        //%cylinder(d = 0.2, h = 40);
        
        // puddle
        //cylinder(d = 10, h = 0.5);
        
        // TODO ice cubes
    }
    
    // glasses
    color("black")
    translate([base / 2 - 8.3, base / 2, 50.5])
    glasses();
    
    // lamp
    color("red")
    translate([base / 2, base / 2, 55])
    sphere(r = 2);
}

translate([0, 0, 3])
marvin();
