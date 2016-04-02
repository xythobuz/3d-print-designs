//parametric micro quadcopter frame for lulfro and others
//Patrick Sapinski
//v1
//22/05/15

motorDiameter = 7;
motorHeight = 18;
shellThickness = 3;
armThickness = 6;
m2mDistance = 90;
batteryWidth = 40;

propLength = 50;

module makeArm() {
    translate([m2mDistance/2,0,0]) 
    difference() {
        //create the motor holder and arm
        union(){
            translate([-m2mDistance/2 + motorDiameter/2,-armThickness/2,motorHeight/2 - armThickness]) 
                cube([m2mDistance/2,armThickness,armThickness]);
            cylinder(h = motorHeight/2, r=motorDiameter/2 + shellThickness/2);
            sphere(r=motorDiameter/2 + shellThickness/2);
            
        //prop preview
        %rotate([0,0,45])cube([propLength,5,5],center=true);
        }
        //hollow out the motor holder
        sphere(r=motorDiameter/2);
        cylinder(h = motorHeight/2, r=motorDiameter/2);
        
        //hollow out the groove for the wire in the motor holder
        translate([-shellThickness,0,-shellThickness]) 
            cube([m2mDistance,armThickness - shellThickness,motorHeight],center=true);
        
        //???
        translate([-shellThickness*2,-armThickness/2 + shellThickness/2,-motorHeight/2]) 
            cube([motorHeight,armThickness - shellThickness,motorHeight + shellThickness]);
    }
}

difference() {
    union(){
        //create each arm
        rotate([0,0,45]){
                rotate([0,0,90]) makeArm();
                rotate([0,0,180]) makeArm();
                rotate([0,0,270]) makeArm();
                rotate([0,0,360]) makeArm();
        }
        
        //create the FC cube
        translate([0,0,motorHeight/2 - armThickness/2]) 
            cube([batteryWidth + shellThickness,batteryWidth + shellThickness,armThickness],center=true);
    }
    translate([0,0,motorHeight/2 - armThickness/2 - motorHeight/2 + shellThickness/2])
    union(){
        //hollow out some grooves in the arms for the wires
        rotate([0,0,45])
            cube([armThickness - shellThickness,m2mDistance/2,motorHeight/1.5],center=true);
        rotate([0,0,45])
            cube([m2mDistance/2,armThickness - shellThickness,motorHeight/1.5],center=true);
    }
    
    //hollow out the FC hole
    translate([0,0,motorHeight/2 - armThickness/2 - shellThickness/2]) 
    cube([batteryWidth,batteryWidth,armThickness],center=true);
    
    //drunk code below
    b = 20;
    h = 20;
    w = 4;
    rotate(a=[0,0,45])
        translate([2,2,motorHeight/2]) 
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
        
    rotate(a=[0,0,45 + 180])
        translate([2,2,motorHeight/2]) 
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
        
    rotate(a=[0,0,45 + 90])
        translate([2,2,motorHeight/2]) 
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
        
    rotate(a=[0,0,45 + 270])
        translate([2,2,motorHeight/2]) 
            linear_extrude(height = w, center = true, convexity = 10, twist = 0)
                polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
}
/*
//parabolic arm attempt...

module oval(w,h, height, center = false) {
    scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

    translate([0,0,2]) 
    difference() {
        cube([m2mDistance,m2mDistance,fcHeight],center=true);
            for (i = [0 : 3])
                rotate([0,0,i * 90])
                    translate([m2mDistance + 10,0,0]) 
                        oval(m2mDistance/2 + 40,m2mDistance/2, 5);
    }
*/
