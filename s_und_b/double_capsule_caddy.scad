include <../../threads.scad>
use <../../knurledFinishLib_v2_1.scad>

di = 15.0;
do = di + 5.0;
h_capsules = 35.0;
h_finger = 10.0;
h_th_male = 5.0;
h_th_male_add = 2.0;
h_th_female = h_th_male + 2.0;
th_p = 1.5;
th_dia = di + ((do - di) / 2);
h_o_ring = 1.25;
wall_cap = 3.0;
di_cap = di - 3.0;
h_body = h_capsules + 2 * h_th_female;
h_cap = h_finger + h_th_male + h_th_male_add;

t_top = "FULL FULL ";
t_bot = "EMPTY EMPTY ";
t_len = max(len(t_bot), len(t_top));
t_d = 1.0;
t_off = 5.0;

cut_for_visualization = true;
$fn = 42;

// https://openhome.cc/eGossip/OpenSCAD/TextCylinder.html
module text_wrap(t, l) {
    for (i = [0 : l - 1])
    rotate([0, 0, i * 360 / l]) 
    translate([0, do / 2 - t_d, 0]) 
    rotate([90, 0, 180])
    linear_extrude(t_d + 2.0)
    text(t[i],
    font = "Liberation Sans Mono; Style = Bold",
    size = do * 3.141 / l,
    valign = "center", halign = "center");
}

module body() {
    color("green")
    difference() {
        cylinder(d = do, h = h_body);
        
        translate([0, 0, -1])
        cylinder(d = di, h = h_body + 2);
        
        translate([0, 0, h_capsules + h_th_female])
        metric_thread(diameter=th_dia, pitch=th_p, length=h_th_female, internal=true, leadin=1);
        
        metric_thread(diameter=th_dia, pitch=th_p, length=h_th_female, internal=true, leadin=3);
        
        translate([0, 0, h_body - t_off])
        text_wrap(t_top, len(t_top));
        
        translate([0, 0, t_off])
        rotate([180, 0, 0])
        text_wrap(t_bot, len(t_bot));
    }
}

module cap() {
    color("orange")
    difference() {
        union() {
            translate([0, 0, h_th_male + h_th_male_add])
            //cylinder(d = do, h = h_finger);
            knurl(k_cyl_hg = h_finger, k_cyl_od = do, knurl_wd = 1, knurl_hg = 1, knurl_dp = 1);
            
            translate([0, 0, h_th_male])
            cylinder(d = di, h = h_th_male_add);
            
            metric_thread(diameter=th_dia, pitch=th_p, length=h_th_male, internal=false);
        }
        
        translate([0, 0, -1])
        cylinder(d = di_cap, h = h_cap + 1 - wall_cap);
    }
    
    %color("blue")
    translate([0, 0, h_th_male + h_th_male_add - h_o_ring])
    difference() {
        cylinder(d = do, h = h_o_ring);
        
        translate([0, 0, -1])
        cylinder(d = di, h = h_o_ring + 2);
    }
}

module assembly() {
    difference() {
        union() {
            body();
            
            translate([0, 0, h_body - h_th_male - h_th_male_add + h_o_ring])
            cap();
            
            translate([0, 0, h_th_male + h_th_male_add - h_o_ring])
            rotate([180, 0, 0])
            cap();
        }
        
        if (cut_for_visualization)
        translate([-20, 0, -20])
        cube([40, 20, 100]);
    }
}

module print() {
    body();
    
    for (i = [0 : 1])
    translate([(do + 10) * (i + 1), 0, h_cap])
    rotate([180, 0, 0])
    cap();
}

//assembly();
print();
