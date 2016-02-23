/**
  Build a laser tag model.
*/
include <roundlib.scad>;

// Smoothness:
$fa=8; $fs=0.1;

// Thickness of exterior walls
wall=1.8;

// Interior height of electronics cavities
//   Need at least 25mm for the charger box
height=25.4;

// Z height of trigger hole
trigger_hole_z=9;
trigger_hole_x=25;

// Charger access hole in back of grip
charge_hole_z=22;
charge_hole_x=20;

// Angle of the back of the grip:
grip_angle=-17;
 
// Electronics cavity:
cavity_y=height;
cavity_x=100; // nano is 45mm long, lots of extra space here
cavity_x_back=-20; // start point of electronics cavity
cavity_x_front=cavity_x_back+cavity_x;

// Emitter LED:
LED_dia=6;
LED_height=8;

// Collimator to channel LED light only straight forward:
baffle_height=20;
collimator_wall=2.0; 
collimator_dia=LED_dia+2*collimator_wall; // y-z diameter
collimator_height=collimator_wall+LED_height+baffle_height; // +x
collimator_x_start=cavity_x_front-collimator_height+wall;

// Roundoff prevention
epsilon=0.05;

// Mounting screw center positions:  [X,Y,angle]
mounting_screws=[
    [-50,-70,90+grip_angle], // back of grip
    [3.5,2.5,0], // trigger (also trigger pivot)
    [72,2.5,0], // front
];

// Battery pack:
charger_x=23.5;
charger_y=97;

// Battery charger module:
module charger_outline() {
    rotate([0,0,180+grip_angle])
        square([charger_x,charger_y]);
}

// Mounting screw, including threads and top clearance
module mounting_screw() {
    overall=height+2*wall;
    translate([0,0,-overall/2-epsilon])
    {
        tapped=15; // length of threaded area
        cylinder(d=2.5,h=tapped); // tapped threads at bottom
        
        translate([0,0,tapped-epsilon])
            cylinder(d=3.2,h=overall-tapped); // shaft middle
        
        cap_z=3.0; 
        translate([0,0,overall-cap_z])
            cylinder(d=7.2,h=cap_z+2*epsilon); // cap
    }
}

// Electronics box:
module electronics_outline() {
    translate([cavity_x_back,0,0])         
    square([cavity_x,cavity_y]);
}

// Infrared collimator (outside size)
module collimator(rplus,hplus) {
    translate([collimator_x_start,cavity_y/2,0])
    rotate([0,90,0])
        cylinder(d=collimator_dia+2*rplus,h=collimator_height+hplus);
}

// Interior shapes:
module hollow_2D() {
    round_2D(3.0) // rounded interior edges
    union() {
        charger_outline();
        electronics_outline();
    }
}

// Exterior outline:
module outside_2D() {
    union() {
        offset(r=wall) hollow_2D();
        scale([-1,-1,1]) round_2D(5.0) square([25,25]); // trigger plate
        
        difference() { // finger ridges
            // Big circle on back of grip:
            translate([-25,-50])
                rotate([0,0,grip_angle])
                union() {
                    // Front of grip:
                    scale([-0.47,-0.87])
                        circle(d=100);
                    // Back of grip:
                    translate([-10,-5])
                    scale([-0.37,-0.75])
                        circle(d=100);
                }
            
            // holes for each finger
            for (finger=[1:4])
                translate([20,0])
                rotate([0,0,grip_angle])
                translate([0,-finger*20])
                circle(d=35);
        }
    }
}


// Overall laser plus, step 1 (overall frame exterior)
module laser_plus() {
    intersection() {
        // Overall outline:
        translate([0,0,-height/2-wall])
            linear_extrude(height=height+2*wall,convexity=10) 
                outside_2D();
        
        // Trim down the grip area
        union() {
            // Ignore the top half
            translate([-20-wall,-wall,-100])
                cube([200,200,200]);

            difference() {
                // Add cylinder to trim down the grip:
                rotate([0,0,grip_angle])
                    translate([-15,-110])
                        scale([0.8,1,0.8])
                            rotate([-90,0,0])
                                cylinder(d=50,h=120);
                
                // Round off backstrap area
                for (side=[-1,+1]) scale([1,1,side])
                    translate([-73.5,0,0])
                    rotate([0,45,0]) cylinder(d=50,h=50);
            }
        }
    }
}

// Overall laser minus, step 1 (major component holes here)
module laser_minus() {
    translate([0,0,-height/2])
        linear_extrude(height=height,convexity=4) 
            hollow_2D();
    
    
    // Cutout to allow charger end access
    rotate([0,0,grip_angle])
        translate([-charger_x/2,-charger_y])
            cube([charge_hole_x,100,charge_hole_z],center=true);
    
}

// Laser additions, phase 2
module laser_plus2() {
    // Reinforcing around mounting screws
    for (s=mounting_screws)
        translate([s[0],s[1],0.0]) 
        rotate([0,0,s[2]]) {
            // Shaft:
            translate([0,0,-height/2-epsilon]) 
                cylinder(d=3.2+2*wall,h=height+2*epsilon);
               
            // Cap reinforcement:
            cap=6;
            translate([0,0,height/2+wall/2-cap])
            intersection() {
                cylinder(d1=6,d2=15,h=cap+epsilon);
                translate([-10,-4,0])
                    cube([20,8,cap]);
            }
        }
    
    intersection() {
        // Collar around main beam collimator
        translate([0,0,0])
            collimator(0.5+wall,0.0);
        
        // Stop at centerline (hotglue collimator in)
        translate([0,0,-25]) cube([100,100,25+2]);
    }
        
    // Support rib below collimator
    translate([collimator_x_start,cavity_y/2,-height/2-epsilon])
        cube([collimator_height,wall,height+2*epsilon]);

}

// Laser removals, phase 2
module laser_minus2() {
    // Mounting screws
    for (s=mounting_screws) {
        translate([s[0],s[1],0.0]) mounting_screw();
    }
    
    // Cutout for trigger panel
    translate([0,-10,-trigger_hole_z/2])
        cube([trigger_hole_x,25,trigger_hole_z]);
    
    // Cutout for main beam collimator
    translate([-epsilon,0,0])
        collimator(0.5,2*epsilon);
    
    // Final cutout for battery housing
    translate([0,0,-height/2])
        linear_extrude(height=height,convexity=4) 
            round_2D(1.0) charger_outline();
}

// Overall laser (as a monolithic block)
module laser() {
    difference() {
        union() {
            difference() {
                laser_plus();
                laser_minus();
            }
            laser_plus2();
        }
        laser_minus2();
    }
}

// Slicing surface to extract top half of laser
module laser_slice_top() {
    slice_z=trigger_hole_z/2-epsilon;
    bump_z=wall/2;
    // Big cube:
    translate([-100,-100,slice_z])
        cube([200,200,200]);

    // Mid-wall bump:
    translate([0,0,slice_z-bump_z])
        linear_extrude(h=wall) offset(r=wall/2) hollow_2D();
}

// Bottom half of laser
module laser_bottom() {
    difference() {
        laser();
        laser_slice_top();
    }
}
// Top half of laser
module laser_top() {
    intersection() {
        laser();
        laser_slice_top();
    }
}

// Printable halves:

laser_bottom();

translate([90,-50,0]) 
    rotate([0,180,-90+grip_angle]) 
        laser_top();

// Test: build plate of Makerbot replicator (to make sure everything fits)
// translate([50,-30,-height/2-wall]) square([225,145],center=true);

