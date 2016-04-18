/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the Creative Commons - Attribution license.
 */

// -----------------------------------------------------------

spoolWidth = 65; // [20:70]
spoolDiameter = 65; // [20:70]
spoolHoleDiameter = 10; // [10:30]

part = "base"; // [base, holder]
cutout = "true"; // [true, false]

// -----------------------------------------------------------

/* [Hidden] */

armWidth = 10;
wallSize = 4;
baseHeight = 2;
bottomGapDivisor = 10; // spoolDiameter / bottomGapDivisor
holderHeightDivisor = 2; // spoolHoleDiameter / holderHeightDivisor
holderWidth = 2.5;
holderExtraLength = 2;
extraGap = 0.2;
feedWidth = 14;
feedHeight = 8;
feedDiameter = 2;

$fn = 15;

// -----------------------------------------------------------

module spool() {
    translate([0, spoolDiameter / 2, spoolDiameter / 2])
    rotate([0, 90, 0])
    difference() {
        cylinder(d = spoolDiameter, h = spoolWidth);
        
        translate([0, 0, -1])
            cylinder(d = spoolHoleDiameter, h = spoolWidth + 2);
    }
}

module arm() {
    difference() {
        cube([wallSize, armWidth, (spoolDiameter / bottomGapDivisor) + ((spoolDiameter + spoolHoleDiameter) / 2)]);
        translate([-1, (armWidth - holderWidth) / 2, (spoolDiameter / bottomGapDivisor) + ((spoolDiameter + spoolHoleDiameter) / 2) - (spoolHoleDiameter / holderHeightDivisor)])
            cube([wallSize + 2, holderWidth + extraGap, (spoolHoleDiameter / holderHeightDivisor) + 1]);
    }
}

module feed() {
    difference() {
        cube([feedWidth, wallSize, feedHeight]);
        translate([feedWidth / 2, wallSize + 1, feedHeight / 2])
            rotate([90, 0, 0])
            cylinder(d = feedDiameter, h = wallSize + 2);
    }
}

module base() {
    difference() {
        union() {
            cube([spoolWidth + (2 * wallSize), spoolDiameter + wallSize, baseHeight]);
            translate([0, wallSize + ((spoolDiameter - armWidth) / 2), baseHeight])
                arm();
            translate([spoolWidth + wallSize, wallSize + ((spoolDiameter - armWidth) / 2), baseHeight])
                arm();
            translate([wallSize + (spoolWidth - feedWidth) / 2, 0, baseHeight])
                feed();
        }
        
        if (cutout == "true") {
            translate([wallSize * 2, wallSize * 2, -1])
                cube([spoolWidth - (wallSize * 2), spoolDiameter - (wallSize * 3), baseHeight + 2]);
        }
    }
    
    if (cutout == "true") {
        translate([wallSize * 2, wallSize * 2, 0])
            rotate([0, 0, atan((spoolDiameter - (wallSize * 3)) / (spoolWidth - (wallSize * 2)))])
            translate([0, -wallSize, 0])
            cube([sqrt(((spoolWidth - (wallSize * 2)) * (spoolWidth - (wallSize * 2))) + ((spoolDiameter - (wallSize * 3)) * (spoolDiameter - (wallSize * 3)))), wallSize * 2, baseHeight]);
        
        translate([wallSize * 2 + (spoolWidth - (wallSize * 2)), wallSize * 2, 0])
            rotate([0, 0, 180 - atan((spoolDiameter - (wallSize * 3)) / (spoolWidth - (wallSize * 2)))])
            translate([0, -wallSize, 0])
            cube([sqrt(((spoolWidth - (wallSize * 2)) * (spoolWidth - (wallSize * 2))) + ((spoolDiameter - (wallSize * 3)) * (spoolDiameter - (wallSize * 3)))), wallSize * 2, baseHeight]);
    }
}

module holder() {
    translate([0, wallSize + ((spoolDiameter - armWidth) / 2) + (armWidth - holderWidth) / 2 + (extraGap / 2), baseHeight + (spoolDiameter / bottomGapDivisor) + ((spoolDiameter + spoolHoleDiameter) / 2) - (spoolHoleDiameter / holderHeightDivisor)])
    union() {
        translate([wallSize + (holderExtraLength / 2), holderWidth / 2, (spoolHoleDiameter / holderHeightDivisor) / 2])
        rotate([0, 90, 0])
            cylinder(d = spoolHoleDiameter / holderHeightDivisor, h = spoolWidth - holderExtraLength);
    
        cube([wallSize + (holderExtraLength / 2), holderWidth, spoolHoleDiameter / holderHeightDivisor]);
    
        translate([wallSize + (holderExtraLength / 2) + spoolWidth - holderExtraLength, 0, 0])
            cube([wallSize + (holderExtraLength / 2), holderWidth, spoolHoleDiameter / holderHeightDivisor]);
    }
}

// -----------------------------------------------------------

%translate([wallSize, wallSize, baseHeight + (spoolDiameter / bottomGapDivisor)])
    spool();

if (part == "base") {
    base();
} else {
    %base();
}

if (part == "holder") {
    holder();
} else {
    %holder();
}
