cage_width = 104.9;
cage_length = 160.0;
cage_wall = 1.3;
cage_hold_large = 12.0;
cage_hold_small = 8.0;
cage_hold_length = 19.7;
cage_hold_off_bot = 13.4;
cage_hold_off_left = 16.6;
cage_hold_off_top = 56.9;
cage_hold_off_right = 49.6;
cage_lip = 9.9 + 2.0;
cage_lip_hole = 3.4;
cage_lip_hole_dist = 37;
cage_lip_hole_off = 29.0;
cage_lip_hole_off_y = 2.0;

lip_wall = 1.6;
lip_width = cage_lip_hole_dist + 10.0;

rail_height = 7.5;
rail_height_front = 13.0;
rail_radius = 7.0;
rail_length = 117;
rail_width = lip_wall + 2;
rail_dist = 27.5;
rail_off_front = 7.8;

nub_small = 6.6;
nub_small_height = cage_wall + 0.4;
nub_large = cage_hold_large - 1.5;
nub_large_height = 1.5;

stable_cut_height = 15.0;
stable_cut_depth = 20.0;
stable_cut_width = 7.5;

$fn = 20;

module cage_hold() {
    translate([cage_hold_large / 2, cage_hold_large / 2, 0])
    union() {
        cylinder(d = cage_hold_large, h = cage_wall + 2);
    
        translate([0, cage_hold_length - (cage_hold_large / 2) - (cage_hold_small / 2), 0])
            cylinder(d = cage_hold_small, h = cage_wall + 2);
    }
}

module cage() {
    // cage bottom
    difference() {
        cube([cage_width, cage_length, cage_wall]);
        
        translate([cage_hold_off_left, cage_hold_off_bot, -1])
            cage_hold();
        
        translate([cage_hold_off_left + cage_hold_large + cage_hold_off_right, cage_hold_off_bot, -1])
            cage_hold();
        
        translate([cage_hold_off_left, cage_hold_off_bot + cage_hold_length + cage_hold_off_top, -1])
            cage_hold();
        
        translate([cage_hold_off_left + cage_hold_large + cage_hold_off_right, cage_hold_off_bot + cage_hold_length + cage_hold_off_top, -1])
            cage_hold();
    }
    
    // cage lip
    difference() {
        cube([cage_width, cage_wall, cage_lip]);
        
        translate([cage_lip_hole_off, cage_wall + 1, cage_lip / 2 + cage_lip_hole_off_y])
            rotate([90, 0, 0])
            cylinder(d = cage_lip_hole, h = cage_wall + 2);
        translate([cage_lip_hole_off + cage_lip_hole_dist, cage_wall + 1, cage_lip / 2 + cage_lip_hole_off_y])
            rotate([90, 0, 0])
            cylinder(d = cage_lip_hole, h = cage_wall + 2);
    }
}

module rail() {
    // main rail
    cube([rail_width, rail_length - (rail_height / 2), rail_height]);
    
    // rounded end
    translate([0, rail_length - (rail_height / 2), rail_height / 2])
        rotate([0, 90, 0])
        cylinder(d = rail_height, h = rail_width);
    
    // front hdd insert
    difference() {
        translate([0, 0, -((rail_height_front - rail_height) / 2)])
            cube([rail_width, rail_radius, rail_height_front]);
        
        translate([-1, rail_radius, -rail_radius / 2])
            rotate([0, 90, 0])
            cylinder(d = rail_radius, h = rail_width + 2);
        
        translate([-1, rail_radius, rail_height + rail_radius / 2])
            rotate([0, 90, 0])
            cylinder(d = rail_radius, h = rail_width + 2);
    }
}

module nub() {
    // nub itself
    translate([0, 0, nub_small_height + nub_large_height])
        cylinder(d = nub_large, h = nub_large_height);
    translate([0, 0, nub_large_height])
        cylinder(d = nub_small, h = nub_small_height);
    cylinder(d = nub_large, h = nub_large_height);
    
    // support pillar up to main plate
    translate([0, 0, nub_small_height + (2 * nub_large_height)])
        cylinder(d = nub_small, h = cage_lip - nub_large_height);
}

module mount_nubs() {
    translate([cage_hold_off_left + (cage_hold_large / 2), cage_hold_off_bot + cage_hold_length - (cage_hold_small / 2), -nub_large_height - ((nub_small_height - cage_wall) / 2)])
        nub();
    
    translate([cage_hold_off_left + (cage_hold_large / 2) + cage_hold_off_right + cage_hold_large, cage_hold_off_bot + cage_hold_length - (cage_hold_small / 2), -nub_large_height - ((nub_small_height - cage_wall) / 2)])
        nub();
    
    translate([cage_hold_off_left + (cage_hold_large / 2), cage_hold_off_bot + cage_hold_length - (cage_hold_small / 2) + cage_hold_off_top + cage_hold_length, -nub_large_height - ((nub_small_height - cage_wall) / 2)])
        nub();
    
    translate([cage_hold_off_left + (cage_hold_large / 2) + cage_hold_off_right + cage_hold_large, cage_hold_off_bot + cage_hold_length - (cage_hold_small / 2) + cage_hold_off_top + cage_hold_length, -nub_large_height - ((nub_small_height - cage_wall) / 2)])
        nub();
}

module mount_lip() {
    difference() {
        translate([cage_lip_hole_off - ((lip_width - cage_lip_hole_dist) / 2), 0, 0])
        cube([lip_width, lip_wall, cage_lip]);
        
        translate([cage_lip_hole_off, cage_wall + 1, cage_lip / 2 + cage_lip_hole_off_y])
            rotate([90, 0, 0])
            cylinder(d = cage_lip_hole, h = cage_wall + 2);
        translate([cage_lip_hole_off + cage_lip_hole_dist, cage_wall + 1, cage_lip / 2 + cage_lip_hole_off_y])
            rotate([90, 0, 0])
            cylinder(d = cage_lip_hole, h = cage_wall + 2);
    }
}

add_after_rail = 15;

module rail_wall() {
    difference() {
        cube([lip_wall, rail_length + add_after_rail, rail_dist + rail_height + (rail_dist / 2)]);
        
        // bubbles
        translate([-1, 10, 10])
        for (i = [0 : 15 : (rail_length + add_after_rail - 20)]) {
            translate([0, i, 0])
                rotate([0, 90, 0])
                cylinder(d = 7, h = lip_wall + 2);
            
            translate([0, i + 8, 10])
                rotate([0, 90, 0])
                cylinder(d = 7, h = lip_wall + 2);
            
            translate([0, i + 4, 32.5])
                rotate([0, 90, 0])
                cylinder(d = 7, h = lip_wall + 2);
        }
    }
}

module stabilizer() {
    difference() {
        translate([-lip_wall, 0, -lip_wall])
            cube([stable_cut_width + lip_wall, stable_cut_depth, stable_cut_height + (2 * lip_wall)]);
        
        translate([0, -1, 0])
            cube([stable_cut_width + 1, stable_cut_depth + 2, stable_cut_height]);
    }
}

module mount() {
    // model of the bottom of the cage
    %cage();
    
    // nubs fitting 2.5" HDD slots on bottom
    mount_nubs();
    
    // screwed-on lip
    translate([0, -lip_wall, 0])
        mount_lip();
    
    // main horizontal plate
    translate([0, -lip_wall, cage_lip])
        cube([cage_width, rail_length + add_after_rail, lip_wall]);

    // left rail support
    difference() {
        translate([-lip_wall, -lip_wall, cage_lip])
            rail_wall();
        
        translate([-rail_width + 1, -rail_off_front, cage_lip + rail_dist])
            rail();
    }
    
    // left rail stabilizer
    translate([-stable_cut_width - lip_wall, -lip_wall, cage_lip + rail_dist - (stable_cut_height - rail_height) / 2])
        stabilizer();
    
    // right rail support
    difference() {
        translate([cage_width, -lip_wall, cage_lip])
            rail_wall();
        
        translate([cage_width - 1, -rail_off_front, cage_lip + rail_dist])
            rail();
    }
    
    // right rail stabilizer
    translate([cage_width + stable_cut_width + lip_wall, -lip_wall, stable_cut_height + cage_lip + rail_dist - (stable_cut_height - rail_height) / 2])
        rotate([0, 180, 0])
        stabilizer();
    
    // bottom/top horizontal plate
    translate([-lip_wall, -lip_wall, cage_lip + rail_dist + rail_height + (rail_dist / 2)])
        cube([cage_width + (2 * lip_wall), rail_length + add_after_rail, lip_wall]);
}

mount();
