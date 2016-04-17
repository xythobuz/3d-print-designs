/*
 * Created by:
 * Thomas Buck <xythobuz@xythobuz.de> in April 2016
 *
 * Licensed under the
 * Creative Commons - Attribution - Share Alike license.
 *
 * Idea based on the "Parametric brushed micro quadcopter"
 * by "drkow" / Patrick Sapinski:
 * http://www.thingiverse.com/thing:843597
 */

// -----------------------------------------------------------

wallSize = 2;
armSize = 6;
motorDiameter = 7.3;
baseWidth = 41;
diameter = 78;
height = 5;
bodyHeight = 8;

motorHeight = 15;

wireWidth = 2;
wireHeight = 1;

// size of a Turnigy nano-tech 1S 750mAh LiPo
batteryWidth = 25;
batteryLength = 45;
batteryHeight = 10;

// Hubsan compatible propellers/motors
propeller = 55;
realMotorHeight = 20;

$fn = 25;

// -----------------------------------------------------------

baseLength = baseWidth + (2 * wallSize);
realBaseLength = 2 * sqrt(2 * (baseLength / 2) * (baseLength / 2));
armDiameter = motorDiameter + (wallSize * 2);
realDiameter = 2 * sqrt(2 * (diameter / 2) * (diameter / 2));
armLength = ((realDiameter - realBaseLength) / 2) - armDiameter;

// -----------------------------------------------------------

module arm() {
    difference() {
        // arm
        translate([0, -armSize / 2, 0])
            cube([armLength, armSize, height]);
        
        // wire grooves
        translate([armLength / 3, -wireWidth / 2, 0])
            cube([armLength * 2 / 3, wireWidth, wireHeight]);
        translate([armLength / 3, -wireWidth / 2, 0])
            cube([wireWidth, armSize, wireHeight]);
        translate([armLength / 3, armSize / 2 - wireHeight, -height / 2])
            cube([wireWidth, wireHeight, height * 2]);
        translate([armLength / 3, -wireWidth / 2, height - wireHeight])
            cube([wireWidth, armSize, wireHeight]);
        translate([-wireWidth, -wireWidth / 2, height - wireHeight])
            cube([armLength / 2, wireWidth, wireHeight]);
    }
    
    // motor mount
    translate([armLength + (armDiameter * 2 / 5), 0, 0])
    union() {
        difference() {
            // wall
            cylinder(d = armDiameter, h = motorHeight);
        
            // motor hole
            cylinder(d = motorDiameter, h = motorHeight);
            
            // wire groove
            translate([-(motorDiameter / 2) - (wallSize * 3 / 2), -wireWidth / 2, 0])
                cube([2 * wallSize, wireWidth, wireHeight]);
        }
        
        // visualize motors
        %cylinder(d = motorDiameter, h = realMotorHeight);
        
        // visualize propellers
        %translate([0, 0, realMotorHeight])
            cylinder(d = propeller, h = 2);
    }
}

// -----------------------------------------------------------

// visualize real diameter (print bed size)
%translate([-diameter / 2, -diameter / 2, -height - batteryHeight])
    cube([diameter, diameter, height]);

// four arms
rotate([0, 0, 45])
for (i = [0 : 90 : 360]) {
    rotate([0, 0, i])
        translate([realBaseLength / 2 - (wallSize * 11 / 7), 0, 0])
        arm();
}

difference() {
    // body
    translate([-baseLength / 2, -baseLength / 2, 0])
        cube([baseLength, baseLength, bodyHeight]);
    
    // space for flight control
    translate([-baseWidth / 2, -baseWidth / 2, -bodyHeight / 2])
        cube([baseWidth, baseWidth, bodyHeight * 2]);
    
    // wire grooves
    for (i = [0 : 3]) {
        a = (i % 2) ? 1 : -1;
        b = (i < 2) ? 1 : -1;
        translate([a * (baseWidth + wallSize) / 2
                        - ((a == 1) ? (
                            (b == 1) ? wallSize / 2 : wallSize / 2)
                        : 0),
                    b * (baseWidth + wallSize) / 2
                        - ((a == 1) ? (
                            (b == 1) ? wallSize / 2 : -wallSize / 2)
                        : 0),
                    height - wireHeight])
            rotate([0, 0, a * b * 45])
            translate([-wallSize, -wireWidth / 2, 0])
            cube([wallSize * 3, wireWidth, bodyHeight]);
    }
}

// battery holder / bottom part
union() {
    translate([-baseWidth / 2, -batteryWidth / 3, 0])
        cube([baseWidth, batteryWidth * 2 / 3, wallSize]);

    translate([baseWidth / 4, batteryWidth / 3, 0])
        cube([baseWidth / 8, (baseWidth - batteryWidth * 2 / 3) / 2, wallSize]);
    
    translate([-baseWidth * 6 / 16, batteryWidth / 3, 0])
        cube([baseWidth / 8, (baseWidth - batteryWidth * 2 / 3) / 2, wallSize]);
    
    translate([baseWidth / 4, - batteryWidth / 2 - (baseWidth - batteryWidth) / 2, 0])
        cube([baseWidth / 8, (baseWidth - batteryWidth * 2 / 3) / 2, wallSize]);
    
    translate([-baseWidth * 6 / 16, - batteryWidth / 2 - (baseWidth - batteryWidth) / 2, 0])
        cube([baseWidth / 8, (baseWidth - batteryWidth * 2 / 3) / 2, wallSize]);
}

// visualize battery
%translate([-batteryLength / 2, -batteryWidth / 2, -batteryHeight])
    cube([batteryLength, batteryWidth, batteryHeight]);
