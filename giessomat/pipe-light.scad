gap = 15;
wall = 3;
add_outlet = gap - wall;
support = 2;
tab_w = 8;
tab_p = 2;
tab_x = 2;
tab_d = tab_w + tab_p;
tab_h1 = 3.8;
tab_h2 = 6;

display = true;

$fn = 42;

module wall() {
    difference() {
        translate([-18, -50, -50])
        cube([18, 100, 100]);
        
        translate([1, 0, 0])
        rotate([0, -90, 0])
        cylinder(d = 15, h = 20);
    }
}

module prism(l, w, h) {
    polyhedron(
        points = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}

module prism_arc(w, n = 5, d = 0.1) {
    hull()
    for (i = [0 : n]) {
        rotate([0, 0, i / n * 90])
        translate([0, w, 0])
        rotate([0, 0, 180])
        translate([-d / 2, 0, 0]) // TODO
        prism(d, w, w);
    }
}

module addition(h) {
    translate([0, -wall, 0])
    cube([gap + wall, wall, h]);
    
    translate([gap, 0, 0])
    cube([wall, gap, h]);
    
    translate([0, gap, 0])
    cube([gap + wall, wall, h]);
    
    translate([gap - support, gap, h])
    rotate([90, 90, 0])
    prism(h + wall + gap, support, support);
    
    translate([gap, support, h])
    rotate([180, 90, 0])
    prism(h + wall, support, support);
    
    translate([gap, 0, -wall])
    rotate([0, -90, 0])
    prism_arc(support);
}

module tab() {
    difference() {
        cube([tab_w, tab_d, tab_x]);
        
        translate([tab_w / 2, (tab_d - tab_p) / 2, -0.1])
        cylinder(d1 = tab_h1, d2 = tab_h2, h = tab_x + 0.2);
    }
    
    translate([0, tab_d - tab_p, tab_x])
    prism(tab_w, tab_p, tab_p);
    
    for (i = [0 : 1])
    translate([i * tab_w, 0, 0])
    scale([i * 2 - 1, 1, 1]) {
        translate([0, tab_d - tab_p, tab_x])
        rotate([0, 90, 0])
        prism(tab_x, tab_p, tab_p);
        
        translate([0, tab_d, tab_x])
        rotate([90, 90, 0])
        prism_arc(tab_p);
    }
}

module block(base = true) {
    //%translate([0, 0, wall])
    //cube([gap, gap, gap]);
    
    if (base) {
        cube([gap, gap, wall]);
    } else {
        cube([gap, gap + wall, wall]);
    }
    
    if (base) {
        translate([0, 0, wall + gap])
        cube([gap, gap, wall]);
    }
    
    if (base) {
        translate([0, -wall, 0])
        cube([gap, wall, gap + 2 * wall]);
    } else {
        translate([0, -wall, 0])
        cube([gap, wall, gap + wall]);
    }
    
    if (base) {
        translate([gap, -wall, 0])
        cube([wall, gap + wall, gap + 2 * wall]);
    } else {
        translate([gap, -wall, 0])
        cube([wall, gap + wall * 2, gap + wall]);
    }
}

module pipeblock() {
    translate([0, -gap / 2, -gap / 2 - wall])
    block();
    
    translate([0, gap * 3 / 2 + wall, -gap / 2])
    rotate([90, 0, 0])
    block(false);
    
    translate([0, gap / 2, gap / 2 + wall])
    addition(add_outlet);
    
    translate([0, gap * 3 / 2 - support, -gap / 2])
    prism(gap, support, support);
    
    translate([0, -gap / 2, -gap / 2 + support])
    rotate([-90, 0, 0])
    prism(gap, support, support);
    
    translate([0, -gap / 2 + support, gap / 2])
    rotate([180, 0, 0])
    prism(gap, support, support);
    
    translate([gap, gap / 2, gap / 2 - support])
    rotate([90, 0, -90])
    prism(gap, support, support);
    
    translate([gap, -gap / 2 + support, gap / 2])
    rotate([90, 90, -90])
    prism(gap, support, support);
    
    translate([gap, -gap / 2, -gap / 2 + support])
    rotate([-90, 0, 90])
    prism(gap * 2, support, support);
    
    if (add_outlet > 0) {
        translate([0, gap / 2 - wall - support, gap / 2 + wall])
        prism(gap + wall, support, support);
    }
    
    translate([0, 0, tab_d + gap / 2 + wall])
    rotate([-90, 0, -90])
    tab();
    
    translate([0, -gap / 2 - tab_d - wall, tab_w / 2])
    rotate([-90, 90, -90])
    tab();
    
    translate([0, gap * 3 / 2 + wall + tab_d, tab_w / 2])
    rotate([-90, -90, -90])
    tab();
    
    translate([0, gap / 2 - tab_w / 2, -gap / 2 - wall - tab_d])
    rotate([-90, 180, -90])
    tab();
}

if (display) {
    %wall();
    
    pipeblock();
    
    translate([-18, 0, 0])
    rotate([-90, 180, 0])
    pipeblock();
} else {
    translate([0, 0, gap + wall])
    rotate([0, 90, 0])
    pipeblock();
}
