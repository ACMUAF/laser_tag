/**
  Build a laser tag model.
*/
include <roundlib.scad>;

// Smoothness:
$fa=20; $fs=0.1; // coarse & fast
$fa=5; $fs=0.1; // fine & slow

show_halves=true;

//laser_plus();

//sight();

module sight_cube(){
    translate([-40,58,-22]) rotate([45,0,0]) cube([400,30,30]);
}
module sight(){
    difference()
    {
        intersection(){
            sight_cube();
            outside_3D();
        }
        translate([0,5,0]) sight_cube();
    }
}


show_collimator=false;

//port holes
misc_hole_w = 4.5;
misc_hole_h = 8.7;

//motor size 
motor_x = 17;
motor_z = 22;
motor_y = 40; 


// Thickness of exterior walls
wall=2.0;

// Thickness of clear acrylic insert
acrylic_thick=2.3;

// Start and size of acrylic insert
acrylic_size_x=30;
acrylic_size_y=30;
acrylic_x=88;
acrylic_y=21;
acrylic_hole_dx=10; // location of mounting hole in acrylic panel
acrylic_hole_dy=15; // location of mounting hole in acrylic panel

// Interior height of electronics cavities
//   Need at least 25mm for the charger box
height=25.4;

// Z height of trigger hole
trigger_hole_z=9;
trigger_hole_x=14;
trigger_x_start=20; // left side of trigger hole

// Charger access hole in back of grip
charge_hole_z=22;
charge_hole_x=20;

// Angle of the back of the grip:
grip_angle=-17;
 
// Electronics cavity:
cavity_y=height;
cavity_x_start=-20; // start point of electronics cavity
cavity_x_end=100; // nano is 45mm long, lots of extra space here

// Emitter LED:
LED_dia=6;
LED_height=8; // includes extra for legs to fit inside

// Collimator to channel LED light only straight forward:
baffle_height=20;
collimator_wall=2.0; 
collimator_dia=LED_dia+2*collimator_wall; // y-z diameter
collimator_height=collimator_wall+LED_height+baffle_height; // +x
collimator_x_start=cavity_x_end-collimator_height+8;

// Roundoff prevention
epsilon=0.05;

// Mounting screw center positions:  [X,Y,angle]
mounting_screws=[
    [-55,-85,90+grip_angle], // back of grip
    [trigger_x_start+8,2.5,0], // trigger (also trigger pivot)
    [cavity_x_end-1,0,90], // front
	[acrylic_x+acrylic_hole_dx,acrylic_y+acrylic_hole_dy,-30]
];

// Battery pack:
charger_x=23.5;
charger_y=99;

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
        // Locknut for M3x25 screw:
        locknut_z=4.5;
        locknut_d=6.4;
        cylinder(d=locknut_d,$fn=6,h=locknut_z);
        
        tapped=20; // length of threaded area
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
    difference() {
        union() {
            // Main electronics housing:
            round_2D(8.0) 
            translate([cavity_x_start,0,0])         
                square([cavity_x_end-cavity_x_start,cavity_y]);
            
            //top hump
            translate([47,25,0]) scale([3.3,1.2,1]) circle(d=40);
            
            // Reinforcing behind trigger:
            translate([trigger_x_start-wall,0,0])
                scale([-1,-1,1]) round_2D(5.0) square([25,25]);         
          
            // Plus bulb:
            translate([cavity_x_end-2,0]) scale([0.7,0.5]) circle(d=100);
        }
        
        //Minus front scoop:
        translate([cavity_x_end+37,0]) scale([0.7,0.5]) circle(d=100);
    }
}

//electronics_outline();
// Infrared beam collimator (outside size)
module collimator(rplus,hplus) {
    translate([collimator_x_start,cavity_y/2,0])
    rotate([0,90,0])
        cylinder(d=collimator_dia+2*rplus,h=collimator_height+hplus);
}

// Infrared collimator (actual printable version)
module collimator_printable() {
    thru_dia=3.0; 
    difference() {
        // Outside body:
        cylinder(d=collimator_dia,h=collimator_height,$fa=4);
        
        // Thru hole:
        cylinder(d=thru_dia,h=collimator_height+2*epsilon);
        
        // LED area:
        translate([0,0,-epsilon])
            cylinder(d=LED_dia,h=LED_height+2*epsilon);
        
        // Baffles to reduce reflections:
        baffle_z_start=LED_height+wall;
        baffle_z_end=collimator_height;
        baffle_spacing=(baffle_z_end-baffle_z_start)/4;
        for (baffle=[baffle_z_start:baffle_spacing:baffle_z_end-epsilon])
            translate([0,0,baffle])
                cylinder(d=LED_dia,h=baffle_spacing-wall);
        
        // cutaway cube (for debug only)
        //cube([100,100,100]);
    }
}

// Collimator should be printed in IR-opaque black filament
if (show_collimator) collimator_printable();

// Housing to hold collimator
module collimator_housing() {
    intersection() {
        // Collar around main beam collimator
        translate([0,0,0])
            collimator(0.5+wall,10.0);
        
        // Trim edge of collimator to outside of gun
        translate([0,0,-height/2+epsilon])
            linear_extrude(height=height) outside_2D();
    }
        
    // Support rib below collimator
    translate([collimator_x_start,cavity_y/2,-height/2-epsilon])
        cube([collimator_height,wall,height+2*epsilon]);
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
        
        difference() { // finger ridges
            // Big circle on back of grip:
            translate([-27,-50,0]) scale([1.3,1,1])
                rotate([0,0,grip_angle])
                union() {
                    // Front of grip:
                    scale([-0.47,-0.87])
                        circle(d=100);
                    // Back of grip:
                    translate([-11,-10])
                    scale([-0.45,-0.75])
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

module outside_3D() {
    translate([0,0,-height/2-wall]) linear_extrude(height=height+2*wall,convexity=10) 
                outside_2D();
}

// Intersection to trim and bevel the grip area
module grip_trim() {
	union() {
		// Ignore the top half
		translate([-20-wall,-wall,-100])
			cube([200,200,200]);
	
		// Ignore the right half
		translate([-10,-25,-100])
			rotate([0,0,grip_angle])
			cube([200,200,200]);

		difference() {
			// Add cylinder to trim down the grip:
			rotate([0,0,grip_angle])
				translate([-23,-110])
					scale([1.25,1,0.8])
						rotate([-90,0,0])
							cylinder(d=50,h=120);
		
			// Round off backstrap area
			for (side=[-1,+1]) scale([1,1,side])
				translate([-74,0,0])
				rotate([0,45,0]) cylinder(d=50,h=50);
		}
	}
}

// Overall laser plus, step 1 (overall frame exterior)
module laser_plus() {
    intersection()
    {

            // Overall outline:
            outside_3D();
        
            // Trim down the grip area
            grip_trim();
    }
}
// Overall laser minus, step 1 (major component holes here)
module laser_minus() {
    // Main electronics housing
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
    
    collimator_housing();
    sight();
}

// Laser removals, phase 2
module laser_minus2() {
    // Mounting screws
    for (s=mounting_screws) {
        translate([s[0],s[1],0.0]) 
            rotate([0,0,s[2]])
                mounting_screw();
    }
    
    // Cutout for trigger panel
    translate([trigger_x_start,-10,-trigger_hole_z/2])
        cube([trigger_hole_x,25,trigger_hole_z]);
    
    // Cutout for main beam collimator
    translate([-epsilon,0,0])
        collimator(0.5,100+2*epsilon);
    
    // Final cutout for battery housing
    translate([0,0,-height/2])
        linear_extrude(height=height,convexity=4) 
            round_2D(1.0) charger_outline();
    
    //port holes for usb and power switch
    translate([-22.5,12,-7]) cube([2*wall,misc_hole_h,misc_hole_w]);

    translate([9,-10,-15]) cube([misc_hole_w,misc_hole_h,wall+0.5]);

	
    //motor hole
	motor_pos_x=-67;
	motor_pos_y=-73;
    translate([motor_pos_x,motor_pos_y,-motor_z/2]) rotate([0,0,grip_angle])   
		intersection() {
			cube([motor_x,motor_y,motor_z]);
			translate([motor_x/2,0,+motor_z/2])
			rotate([-90,0,0])
				cylinder(d=motor_z,h=motor_y);
		}

	//wires for the motor
    translate([motor_pos_x+5+motor_x,motor_pos_y-11+motor_y,-5]) cube([20,5,5]);
    
	// The sight bevel
    translate([0,1.5*wall,0])sight_cube();

	// acrylic insert in sight
	translate([acrylic_x,acrylic_y,-acrylic_thick/2])
		cube([acrylic_size_x,acrylic_size_y,acrylic_thick]);
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
module laser_slice_top(extra_inside=0.0) {
    //slice_z=trigger_hole_z/2-epsilon;
    bump_z=wall/2;
    slice_z=0+bump_z/2;
    // Big cube:
    translate([-100,-100,slice_z])
        cube([300,200,200]);

    // Mid-wall bump:
    translate([0,0,slice_z-bump_z])
        linear_extrude(h=wall) offset(r=wall/2+extra_inside) hollow_2D();
}

// Bottom half of laser
module laser_bottom() {
    difference() {
        laser();
        laser_slice_top(+0.1);
    }
}
// Top half of laser
module laser_top() {
    intersection() {
        laser();
        laser_slice_top(-0.1);
    }
}

// Printable halves:
if (show_halves) {
    laser_bottom();

    translate([120,-70,0]) 
        rotate([0,180,-90+grip_angle]) 
            laser_top();
}

// Test: build plate of Makerbot replicator (to make sure everything fits)
// translate([50,-40,-height/2-wall]) square([225,145],center=true);

