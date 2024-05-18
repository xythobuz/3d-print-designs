mill_h = 136;
mill_do = 54.9;
mill_di = 48.7;
mill_ih = 13.4;

hat_do_bot = mill_di - 1;
hat_h_bot = mill_ih - 1;
hat_do_top = mill_do;
hat_h_top = 5;
hat_wall = 3;
hat_di_bot = hat_do_bot - 2 * hat_wall;

boot_wall = 3;
boot_h = 20;
boot_support = 5;
boot_di_min = mill_do + 1;
boot_di_max = boot_di_min + 20;
boot_do_min = boot_di_min + 2 * boot_wall;
boot_do_max = boot_di_max + 2 * boot_wall;

rubber_ridge_w = 3;
rubber_ridge_h = 2;

mode = "print"; // [ "hat", "boot", "assembly", "assembly_cut", "print" ]
prev_mode = "inverted"; // [ "normal", "inverted" ]

$fn = $preview ? 42 : 100;

module mill() {
    difference() {
        cylinder(d = mill_do, h = mill_h);

        translate([0, 0, mill_h - mill_ih])
        cylinder(d = mill_di, h = mill_ih + 0.1);

        translate([0, 0, 5])
        cylinder(d = mill_di, h = mill_h - mill_ih - 10);
    }
}

module hat() {
    difference() {
        cylinder(d = hat_do_bot, h = hat_h_bot + 0.1);

        translate([0, 0, -0.1])
        cylinder(d = hat_di_bot, h = hat_h_bot + 0.2);
    }

    translate([0, 0, hat_h_bot])
    difference() {
        cylinder(d = hat_do_top, h = hat_h_top);
        
        translate([0, 0, hat_h_top - rubber_ridge_h / 2])
        for (r = [0, 90])
        rotate([0, 0, r])
        cube([rubber_ridge_w, hat_do_top + 0.2, rubber_ridge_h + 0.1], center = true);
    }
}

module boot() {
    difference() {
        union() {
            cylinder(d = boot_do_min, h = boot_wall);

            translate([0, 0, boot_wall])
            cylinder(d1 = boot_do_min, d2 = boot_do_max, h = boot_h);
        }

        translate([0, 0, boot_wall - 0.1])
        cylinder(d1 = boot_di_min, d2 = boot_di_max, h = boot_h + 0.2);
        
        translate([0, 0, -0.1])
        cylinder(d = boot_di_min, h = boot_wall + 0.2);
    }

    translate([0, 0, boot_wall / 2])
    for (r = [0, 90])
    rotate([0, 0, r])
    cube([boot_di_min, boot_support, boot_wall], center = true);

    translate([0, 0, -boot_wall])
    difference() {
        cylinder(d = hat_do_bot, h = boot_wall);
        translate([0, 0, -0.1])
        cylinder(d = hat_do_bot - 2 * boot_wall, h = boot_wall + 0.2);
    }

    translate([0, 0, -boot_wall])
    difference() {
        cylinder(d = boot_do_min, h = boot_wall);
        translate([0, 0, -0.1])
        cylinder(d = boot_di_min, h = boot_wall + 0.2);

        translate([0, 0, rubber_ridge_h / 2])
        for (r = [0, 90])
        rotate([0, 0, r])
        cube([rubber_ridge_w, boot_do_min + 0.2, rubber_ridge_h + 0.1], center = true);
    }

    translate([0, 0, -boot_wall + boot_wall / 2])
    for (r = [0, 90])
    rotate([0, 0, r])
    cube([hat_do_bot - 2 * boot_wall, boot_support, boot_wall], center = true);
}

module assembly() {
    color("blue")
    if ($preview)
    translate([0, 0, boot_wall])
    mill();

    if (prev_mode == "normal") {
        color("red")
        translate([0, 0, mill_h - hat_h_bot + boot_wall + 0.2])
        hat();
        
        color("green")
        boot();
    } else if (prev_mode == "inverted") {
        color("green")
        translate([0, 0, mill_h + boot_wall])
        boot();
    }
}

module print() {
    translate([0, 0, hat_h_bot + hat_h_top])
    rotate([180, 0, 0])
    hat();

    translate([hat_do_top / 2 + boot_do_max / 2 + 5, 0, boot_wall])
    boot();
}

if (mode == "hat") {
    hat();
} else if (mode == "boot") {
    boot();
} else if (mode == "print") {
    print();
} else if (mode == "assembly") {
    assembly();
} else if (mode == "assembly_cut") {
    difference() {
        assembly();

        translate([-100, 0, -10])
        cube([200, 100, 200]);
    }
}
