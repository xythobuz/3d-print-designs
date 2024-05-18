w = 13.0;
d = 12.0;
h = 21.0;

cut = 4.0;
hole = 2.25;
off = 13.0;

usb_dia = 5.8;
usb_w = 11.0;
usb_off = 1.5;

$fn = 42;

usb_bottom_h = 4.5 + 1.5;
usb_w_bottom = 7.7;

module usb_internal(h, w) {
    translate([(usb_dia - w) / 2, 0, 0]) {
        cylinder(d = usb_dia, h = h);
        
        translate([w - usb_dia, 0, 0])
        cylinder(d = usb_dia, h = h);
        
        translate([0, -usb_dia / 2, 0])
        cube([w - usb_dia, usb_dia, h]);
    }
}

module usb(h) {
    hull() {
        translate([0, 0, usb_bottom_h])
        usb_internal(h - usb_bottom_h, usb_w);
        
        usb_internal(usb_bottom_h, usb_w_bottom);
    }
}

module holder() {
    difference() {
        cube([w, d, h]);
        
        translate([w / 2, -1, off])
        rotate([-90, 0, 0])
        cylinder(d = hole, h = d + 2);
        
        translate([(w - cut) / 2, -1, -1])
        cube([cut, 5, h + 2]);
        
        translate([w / 2, usb_dia / 2 + usb_off, -1])
        usb(h + 2);
    }
}

//usb(20);
holder();
