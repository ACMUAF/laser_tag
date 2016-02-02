/**
  Demonstrate a way of creating rounded 3D shapes with walls,
  starting from a simple 2D outline.
  
  Dr. Orion Lawlor, lawlor@alaska.edu, 2016-02-01 (public domain)
*/

wall=2; // wall thickness
f=5; // chamfer radius--round corners by this much
dz=0.3; // size of 3D printer's layers (smaller == slower!)

// Simple filleted 2D outline
module shapey_2D() {
    offset(r=f) offset(r=-f) // rounds outside corners
    offset(r=-f) offset(r=f) // rounds inside corners
    difference() {
        union() 
         {
            square([150,20]);
            square([50,50]);
         }
         circle(r=10);
     }
 }
 
 // Extruded up into walled shape
 module shapey_3D() {
     // outside of shape (simple version)
     // linear_extrude(height=wall) shapey_2D();
     
     fo=f+wall; // outside radius
     
     // Walls:
     translate([0,0,fo])
     linear_extrude(height=40,convexity=10) 
        difference() { 
            shapey_2D();  // outside of walls
            offset(r=-wall) shapey_2D();  // inside of walls
        }
     
     // Fillets and floor: stepwise for 3D printer layers (lame hack!)
     for (z=[dz:dz:fo+dz]) {
         translate([0,0,z-dz])
         linear_extrude(height=dz,convexity=10) 
         difference() {
             // Outside of floor
             offset(r=-fo+fo*sqrt(1-pow(1-z/fo,2))) shapey_2D();
             // Inside of floor
             offset(r=-f+f*sqrt(1-pow(1-(z-wall)/f,2))-wall) shapey_2D();
         }
     }
 }
 
 difference() {
    shapey_3D();
     //translate([-1,-1,-1])
    //cube([50,50,50]);
 }
