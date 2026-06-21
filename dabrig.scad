ba_l = 17;
ba_d = 8.5;

gap = 1.5;

m_di = 52 + gap;
m_wall = 6;
m_do = m_di + m_wall;
m_h = 42;
ma_d = ba_d + gap;
ma_ha = gap;

t_dl = 5.5;
t_ds = 3.6;
t_h = 42;

th_dl = t_dl + 1;
th_ds = t_ds + 0.5;
th_do = th_dl + 5;
th_h = 20;
th_ox = 5;

v_d = 33;
v_h = 19;

tr_di = v_d + 1;
tr_wall = m_wall;
tr_do = tr_di + tr_wall;
tr_h = v_h / 2;
tr_ox = 5;

th_r = 45;
tr1_r = -45;
tr2_r = -100;
tr_r = [tr1_r, tr2_r];

big_vat = true;
bv_d = 36; // TODO
bv_h = 29; // TODO
bva_h = 25; // TODO

$fn = $preview ? 50 : 200;

module pipe() {
    // pipe body
    translate([0, 0, -m_h])
    cylinder(d = m_di - 2, h = m_h * 3);
    
    // arm
    translate([0, (m_di - 2) / 2, ba_d / 2])
    rotate([-90, 0, 0])
    cylinder(d = ba_d, h = ba_l);
    
    // tool
    rotate([0, 0, th_r])
    translate([(m_do + th_do) / 2 + th_ox, 0, (m_h - th_h) / 2 - t_h / 4])
    cylinder(d1 = t_ds, d2 = t_dl, h = t_h);
    
    // vat
    for (r = tr_r)
    rotate([0, 0, r])
    translate([(m_do + tr_do) / 2 + tr_ox, 0, (m_h - tr_h) / 2])
    if (big_vat)
        translate([0, 0, bva_h])
        cylinder(d = bv_d, h = bv_h);
    else
        cylinder(d = v_d, h = v_h);
}

module ring() {
    difference() {
        hull() {
            // main body
            cylinder(d = m_do, h = m_h);
            
            // tool holder
            rotate([0, 0, th_r])
            translate([(m_do + th_do) / 2 + th_ox, 0, (m_h - th_h) / 2])
            cylinder(d = th_do, h = th_h);
            
            // tray
            for (r = tr_r)
            rotate([0, 0, r])
            translate([(m_do + tr_do) / 2 + tr_ox, 0, (m_h - tr_h) / 2 - tr_wall])
            cylinder(d = tr_do, h = tr_wall + tr_h);
            
        }
        
        // vat body
        for (r = tr_r)
        rotate([0, 0, r])
        translate([(m_do + tr_do) / 2 + tr_ox, 0, (m_h - tr_h) / 2])
        cylinder(d = tr_di, h = v_h + 20);
        
        // vat easing
        for (r = tr_r)
        rotate([0, 0, r])
        translate([(m_do + tr_do) / 2 + tr_ox, 0, (m_h - tr_h) / 2 + tr_h - 2])
        cylinder(d1 = tr_di, d2 = tr_di + 30, h = 30);
        
        // pipe body
        translate([0, 0, -20])
        cylinder(d = m_di, h = m_h + 40);
        
        // tool holder - bottom
        rotate([0, 0, th_r])
        translate([(m_do + th_do) / 2 + th_ox, 0, (m_h - th_h) / 2 - 20])
        cylinder(d = th_ds, h = 20);
        
        // tool holder - top
        rotate([0, 0, th_r])
        translate([(m_do + th_do) / 2 + th_ox, 0, (m_h - th_h) / 2 + th_h])
        cylinder(d = th_dl, h = 20);
        
        // tool holder - middle
        rotate([0, 0, th_r])
        translate([(m_do + th_do) / 2 + th_ox, 0, (m_h - th_h) / 2 - ($preview ? 0.1 : 0)])
        cylinder(d1 = th_ds, d2 = th_dl, h = th_h + ($preview ? 0.2 : 0));
        
        // arm cutout
        for (z = [-ma_d / 2 : ma_ha])
        translate([0, (m_di - m_wall) / 2, ma_d / 2 + z])
        rotate([-90, 0, 0])
        cylinder(d = ma_d, h = m_wall * 2);
        
    }
}

module adapter() {
    difference() {
        union() {
            cylinder(d = v_d, h = bva_h - 8);

            hull() {
                translate([0, 0, bva_h - 8])
                cylinder(d = v_d, h = 1);

                translate([0, 0, bva_h - 1])
                cylinder(d = bv_d + 6, h = 1);
            }

            translate([0, 0, bva_h])
            cylinder(d = bv_d + 6, h = 15);
        }

        translate([0, 0, -1])
        cylinder(d = v_d - 5, h = 50);

        translate([0, 0, bva_h])
        cylinder(d = bv_d + 2, h = 50);
    }
}

module assembly() {
    %pipe();

    ring();

    if (big_vat)
    color("green")
    for (r = tr_r)
    rotate([0, 0, r])
    translate([(m_do + tr_do) / 2 + tr_ox, 0, (m_h - tr_h) / 2])
    adapter();
}

//ring();
//adapter();
assembly();
