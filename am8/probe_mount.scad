$fn = 42;

w = 3.0;
mount_dia = 3.6;

z_offset_from_original = 2.0;

module carriage_mount() {
    //import("/home/thomas/3D Printing/core-xz-anet-am8-conversion-model_files/X-carriege/bl_touch_mount.stl");
    
    difference() {
        translate([-4, -11.5, 0])
        cube([8, 15.5, w]);
        
        for (y = [0, 8])
        translate([0, -y, -1])
        cylinder(d = mount_dia, h = w + 2);
    }
}

module probe_mount() {
    //%translate([11, 18.1, 14])
    //rotate([90, 0, 0])
    //import("/home/thomas/3D Printing/core-xz-anet-am8-conversion-model_files/X-carriege/bl_touch_mount.stl");
    
    difference() {
        union() {
            hull() {
                translate([-5.75, -3, 0])
                cube([11.5, 6, 5]);
                
                for (y = [-1, 1])
                translate([0, 9 * y, 0])
                cylinder(d = 8, h = 5);
            }
        
            hull() {
                translate([0, 9, 0])
                cylinder(d = 8, h = 5);
                
                translate([-3, 12, 0])
                cube([9, 2, 5]);
            }
        
            hull() {
                translate([-3, 14, 0])
                cube([9, 1, 5]);
                
                translate([6, 15.1, 0.5])
                cube([1, 3, 15.5]);
            }
        }
        
        translate([0, 0, -1])
        cylinder(d = 5.0, h = 5.0 + 2);
        
        for (y = [-1, 1])
        translate([0, 9.0 * y, -1])
        cylinder(d = 3.3, h = 5.0 + 2);
    }
}

module mount() {
    probe_mount();
    
    translate([11, 18.1, 14 - z_offset_from_original])
    rotate([90, 0, 0])
    carriage_mount();
}

mount();
