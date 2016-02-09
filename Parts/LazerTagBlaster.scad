//toggles comparison objects
// finger and iPhone 
// transparent
// comp=true;
 comp=false;

//toggles parts
// mini arduino and battery
// shown in blue
// show_parts=true;
 show_parts=false;

bodyLength=100;

//uncoment for parts for object parts

// will preview poorly and renders slow(sometimes?)
handle();


//body();

//this body will be inplace above the handle
translate([-20,-20,99])  body();


translate([-3,10,75]) trigger();

//used to hold body on the handle
//translate([-16.5,-20,99]) locking_key();

translate([-20,-21,100]) fire_chamber(); 

//cover();


//
//  Info
//  for module body (main component of the blaster)
//  y axis is length and the x is width
//  
//


$fn=30;
height=4;
width=4;
depth=2;
length=4;
//convexity=1;

W_T=4;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Modules/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module handle(head_size_x=40,posx=0)
{    
    difference()
    {
    translate([-12.4745,-4,74])cube([24.465,8,25]);
        translate([-3,-3,96])cube([6,7,6]);
    }
    translate([-12.4745,-4,74])cube([4.5,23,25]);
    translate([7.7,-4,74])cube([4.3,23,25]);
    //render()
    {
    difference()
        {
            
            union()
            {
            translate([-22.5,-40,0])cube([45,75,75]);
    
                
                ///trigger slide slots
            //#translate([-3,10,75]) trigger();
                
                //#translate([-3,-3,96])cube([6,7,6]);
            }
           union(){
        difference()
            {
                translate([-22.5,-40,0])cube([45,75,75]);
                    //rotate([0,0,180]) translate([-77,75,-42])  
                union(){
                            rotate([0,0,180]) translate([-77,75,-42]) import("/Users/nicolaussegler/Desktop/Gitrepos/laser_tag/Parts/component/Phase_Pistol_Grip.stl");

                    
                    

                
                        }
                        
            }
        
            translate([-3,10,75]) trigger();
            translate([-1.5,6.5,72]) cube([3,40,5]);
        }
       
        }
    }

    //rotate([0,0,180]) translate([-77,75,-42])  import("/Volumes/NJSEGLER/Parts/star_trek/Phase_Pistol_Grip.stl",convexity=10);


    //front edge round corners
    rotate([0,0,0]) translate([-13,19,80]) union()
    {
        translate([1,0,0])r_corner(c_l=24, posx=14, thickness=10,quad=4,up=1,rot=2);

        translate([.5,0,0]) r_corner(c_l=24, thickness=10,quad=4,up=1,rot=3);
    }

    

    //connection

    connection_h=25;
    translate([-20,-20,99]) union(){
    
        
        difference()
        {
            translate([posx+2*head_size_x/5-.75,6,-connection_h+1]) cube([9,10,connection_h-1]);
            
            union()
            {
                //#translate([17.5 ,10,-7]) cube([4,2,3]);
                    translate([0,10,-6]) cube([40,2,3]);
                translate([0,11,-7]) union()
                {
                    translate([20,-1.5,2]) cube([3,8,6],center=true);
                    rotate([0,90,0]) cylinder(r=2,h=40);
                }
            
                //handle section
                //translate([posx+2*head_size_x/5-.75,6,-connection_h+1]) cube([9,10,connection_h]);
                    
                translate([0,10,-18]) cube([40,2,3]);
                
                translate([0,11,-19]) union()
                {
                     translate([20,-1.5,2]) cube([3,8,6],center=true);
                     rotate([0,90,0]) cylinder(r=2,h=40);
                }
            }
        }
    }



}



module r_scal(height=4, width=4, depth=2, length=4)
{
    difference()
    {
        translate([0,width/2,height/2]) cube([length-.2, width*2, height/2],center=true);
        
        difference(){
            union(){
                cube([length, width, height],center=true);
                
                translate([0,4,height/2])  rotate(a=90,[0,90,0]) scale([.5,1,1]) cylinder(r=depth,h=height+.2,center=true);
            }
        
            union(){
                translate([0,0,height/2])  rotate(a=90,[0,90,0]) scale([.5,1,1])   cylinder(r=depth,h=height+.2,center=true);
            }
        }
    }
}


module cover(w=50, l=90, depth=W_T, h_rad=1)
{
    difference()
    {
        union()
        {
            translate([-0.5,0,0]) cube([w,l,(depth)/2+.01]);

            translate([W_T,W_T,depth/2]) cube([w-W_T*2,l-W_T*2,(depth+2)/2]);
            
           
        }

        union()
        {
            
        }
    }
}

module peg_screw(height=40,radius=5)
{
    ///screw body
    translate([0,0,2]) cylinder(r=radius,h=height);
    ///screw tip
    translate([0,0,2]) cylinder(r=radius*.60,h=13*height/10);
    ///screw head
    difference(){
    cylinder(r=radius*2,h=2.5);
    
    cube([radius*4,2,3],center=true);
    }
}


module twin_plate_screw(height=10,head_rad=10,body_rad=5)
{
    ///headM
    cylinder(h=2,r=head_rad);
    
    //bodyF
    translate([21,0,0]) cylinder(h=2,r=head_rad);
    
    //bodyM
    translate([0,0,2]) cylinder(r=body_rad-1,h=height);
    
    
    //bodyF
    difference()
    {
        translate([21,0,2]) cylinder(r=body_rad,h=height);
        translate([21,0,2]) cylinder(r=body_rad-1,h=height+.5);
    }
}

module body(posx=0,posy=0,posz=0,head_size_x=40,head_size_y=90,head_size_z=35,body_size_y=bodyLength,nose_size_y=40)
{
    //head
    difference()
    {   //body
        translate([posx,posy,posz])cube([head_size_x,head_size_y,head_size_z]);
        //hole
        union(){
            //main hole
        translate([posx+W_T,posy+W_T,posz+W_T])cube([head_size_x-W_T*2,head_size_y,head_size_z-W_T*2]);
            
            
            //trigger hole
            translate([posx+W_T*3+1,posy+W_T*4,posz-1])cube([head_size_x-W_T*6-2,50,W_T*2]);
            
            
            //corners
        translate([posx,posy,posz]) cube([5,head_size_y,5]);   
        translate([posx+head_size_x-5,posy,posz]) cube([5,head_size_y,5]); 
        translate([posx+head_size_x-5,posy,posz+head_size_z-5]) cube([5,head_size_y,5]);
        translate([posx,posy,posz+head_size_z-5]) cube([5,head_size_y,5]);
            
            translate([posx+5,posy,posz+head_size_z-5]) cube([head_size_x-10,5,5]);
            translate([posx+5,posy,posz]) cube([head_size_x-10,5,5]);
            translate([posx,posy,posz+5]) cube([5,5,head_size_z-10]);
            translate([posx+head_size_x-5,posy,posz+5]) cube([5,5,head_size_z-10]);
         
        }
    }
    
    //top trigger slide
    
    difference()
    {
        union()
        {
            translate([9,25,3]) cube([head_size_x-W_T*4-2,35,W_T*3]);
        }
        
        union()
        {
            translate([17,30,-24]) trigger();
            #translate([18.5,25,7])cube([3,40,3]);
            #translate([16,25,3])cube([8,40,5]);
        }
        
    }
    
    
    //body
    
        difference()
        {   //body
            union(){
                translate([posx,posy+head_size_y,-head_size_z]) cube([head_size_x,body_size_y,head_size_z*2]);
                //backplate for body section
                translate([posx,posy+head_size_y-W_T-1,-head_size_z]) cube([head_size_x,5,head_size_z]);
                //frontplate for body section
                
            }//end union
            //hole
            union()
            {
                
                translate([posx+W_T,posy+head_size_y,-head_size_z+W_T]) cube([head_size_x-W_T*2,head_size_y*2+1,(head_size_z*2)-W_T*2]);
                
                
                translate([posx-.1,posy+head_size_y,posz+30]) cube([5.1,body_size_y+4,5.1]);
                translate([posx+35,posy+head_size_y,posz+30]) cube([5.1,body_size_y+4,5.1]);
                translate([posx-.1,posy+head_size_y-(W_T+1),posz-35.1]) cube([5.1,body_size_y+5.1,5.1]);
                translate([posx+35,posy+head_size_y-(W_T+1),posz-35.1]) cube([5.1,body_size_y+5.1,5.1]);
                
                translate([posx,posy+head_size_y-5,posz-35.1]) cube([head_size_x,5,5.1]);
                
                translate([posx,posy+head_size_y-5,posz])rotate([0,90,0]) cube([head_size_x,5,5]);
                translate([posx+35,posy+head_size_y-5,posz])rotate([0,90,0]) cube([head_size_x,5,5]);
                
                //cover hole
                
                translate([-.5,head_size_y+10,head_size_z-10]) rotate([0,90,0]) cover(l=body_size_y-20);
                
                
                
            }//end union
        }//end difference
            
        translate([posx+1,posy+head_size_y+body_size_y-W_T-1,0]) cube([head_size_x-3,5,head_size_z-3]);

    
    
        //large chamber corners
        r_corner(posx=0,posy=posy+head_size_y,posz=35,c_l=body_size_y);
        r_corner(posx=30,posy=posy+head_size_y,posz=35,c_l=body_size_y, quad=1);
        r_corner(posx=30,posy=posy+head_size_y,posz=posz-25,c_l=body_size_y, quad=2);
        r_corner(posx=0,posy=posy+head_size_y,posz=posz-25,c_l=body_size_y, quad=3);
        r_corner(posx=30,posy=posy+head_size_y,posz=posz-25,c_l=head_size_x-10, quad=3,rot=1,thickness=10);        
        r_corner(posx=0,posy=posy+head_size_y,posz=posz-25,c_l=head_size_x-5, quad=2,rot=2,up=3,thickness=10);        
        r_corner(posx=30,posy=posy+head_size_y,posz=posz-25,c_l=head_size_x-5, quad=2,rot=3,up=3,thickness=10); 
 
        //small chamber corners
        r_corner(posx=posx,posy=posy+5,posz=posz+10,c_l=head_size_y-5,quad=3);
        r_corner(posx=posx+head_size_x-10,posy=posy+5,posz=posz+10,c_l=head_size_y-5,quad=2);
        r_corner(posx=posx+head_size_x-10,posy=posy+5,posz=posz+head_size_z,c_l=head_size_y-5,quad=1);
        r_corner(posx=posx,posy=posy+5,posz=posz+head_size_z,c_l=head_size_y-5);
        
        r_corner(posx=posx,posy=posy+5,posz=posz+10,c_l=head_size_z-10, quad=2,rot=2,up=3);   
        r_corner(posx=posx+head_size_x-10,posy=posy+5,posz=posz+10,c_l=head_size_z-10, quad=2,rot=3,up=3);
        r_corner(posx=posx+head_size_x-10,posy=posy+5,posz=posz+head_size_z,c_l=head_size_x-10, quad=2,rot=3,up=2); 
        
        r_corner(posx=posx+head_size_x-10,posy=posy+5,posz=posz+10,c_l=head_size_x-10, quad=3,rot=3,up=2);  
        
        //corner 3-way caps    
        r_corner_cap(xpos=35,ypos=posy+head_size_y,zpos=-30,c_h=10, quad=4, rot=3,thickness=10);        
        r_corner_cap(xpos=5,ypos=posy+head_size_y,zpos=-30,c_h=10, quad=3, rot=3,thickness=10);
        
        //corner 3-way caps small chamber
        r_corner_cap(xpos=posx+5,ypos=posy+5,zpos=posz+head_size_z-5,c_h=10, quad=4, rot=1);
        r_corner_cap(xpos=posx+head_size_x-5,ypos=posy+5,zpos=posz+head_size_z-5,c_h=10, quad=4, rot=2);
        r_corner_cap(xpos=posx+head_size_x-5,ypos=posy+5,zpos=posz+5,c_h=10, quad=4, rot=3);
        r_corner_cap(xpos=posx+5,ypos=posy+5,zpos=posz+5,c_h=10, quad=4, rot=4);
        
        
        //intersection()
        //{
            //r_corner(posx=-50,posy=0,posz=posz+5,c_l=40,c_h=10,thickness=10, quad=3);
            //r_corner(posx=-50,posy=5,posz=posz,c_l=40,c_h=10,thickness=10, quad=2,rot=2,up=3);
        //}
    
    
    
    
    
    
    
    
    
    
    
    nose(posx=posx,posy=posy,posz=posz,head_size_x=head_size_x,head_size_y=head_size_y,head_size_z=head_size_z,body_size_y=body_size_y,nose_size_y=nose_size_y);
    
    connection_h=25;
    
    //handle connection
    
    //#translate([posx+head_size_x/5,16,-1]) cube([1,1,1]);
    
    difference()
    {
        union()
        {
            translate([posx+head_size_x/5,6,-connection_h+1]) cube([7,10,connection_h]);
    
            translate([posx+3*head_size_x/5+.5,6,-connection_h+1]) cube([7,10,connection_h]);
        }
        
        translate([0,0,-1]) union()
        {
            //#translate([17.5 ,10,-6]) cube([4,2,3]);
            translate([0,10,-6]) cube([40,2,4]);
            translate([0,11,-6]) rotate([0,90,0]) cylinder(r=2,h=40);
            
            //handle section
            //translate([posx+2*head_size_x/5-.75,6,-connection_h+1]) cube([9,10,connection_h]);
            
            #translate([0,10,-17]) cube([40,2,3]);
            translate([0,11,-18]) rotate([0,90,0]) cylinder(r=2,h=40);
        }
        
    }
    
     
    
}


module nose(posx=0,posy=0,posz=0,head_size_x=40,head_size_y=90,head_size_z=35,body_size_y=120,nose_size_y=35)
{
       //nose
    
    ///////////
    //testing// //fire_chamber(posx=posx,posy=posy,posz=posz,head_size_x=head_size_x,head_size_y=head_size_y,head_size_z=head_size_z,body_size_y=body_size_y,nose_size_y=nose_size_y);
    //testing//
    ///////////
    
    
    translate([0,-6.55,2.55]) union(){
    translate([posx+head_size_x-10,posy+head_size_y+body_size_y,-head_size_z+5]) rotate([41,0,0]) r_corner(quad=2,c_l=side-3,thickness=10);
    
    translate([posx,posy+head_size_y+body_size_y,-head_size_z+5]) rotate([41,0,0]) r_corner(quad=3,c_l=side-3,thickness=10);
    //center front slope
    translate([posx+5,posy+head_size_y+body_size_y+6.55,-head_size_z-2.55]) rotate([41,0,0]) cube([head_size_x-10,side-3,5]);
        }
    difference()
        {
            translate([0,posy+head_size_y+body_size_y,posz-head_size_z+5]) union() //union start
            {
                translate([posx+head_size_x-W_T,0,0]) cube([W_T,35,head_size_z-5]);
                translate([posx,0,0]) cube([W_T,35,head_size_z-5]); 
            
                difference()
                {
                    translate([posx,posy-5,posz+head_size_z-8]) cube([40,39.1,4.3]); 
                
                    translate([posx+head_size_x/2,posy+(nose_size_y/2)-5,posz+head_size_z-8]) cylinder(r=8,h=4.5);
                }//end difference
                
            }//end union
        
    translate([posx,posy+head_size_y+body_size_y-1,-head_size_z+5]) rotate([-49,0,0]) cube([40,40,side-3]);
            
        }//end difference
    
    
    intersection(){
        //translate([posx+head_size_x-10,posy+head_size_y+body_size_y-1.4,-head_size_z+3.74]) rotate([41,0,0]) r_corner(quad=2,c_l=side-1.1,thickness=10);
    
    //translate([posx+head_size_x-10,posy+head_size_y+body_size_y+.1,-head_size_z+6.2]) r_corner(quad=2,c_l=5,thickness=10);
    }
    
    
    
    side=sqrt(pow(nose_size_y,2)+pow(head_size_z-1,2));
    zdiff=sin(sqrt(pow(nose_size_y,2)+pow(head_size_z-1,2)));
    render()
    {
    *difference()
    {
        translate([posx,posy+head_size_y+body_size_y+1,-head_size_z]) cube([head_size_x,nose_size_y,head_size_z-1]);
        
        
            
        translate([posx,posy+head_size_y+body_size_y+(nose_size_y)+1,-01]) rotate([-139,0,0]) cube([head_size_x,sqrt(pow(nose_size_y,2)+pow(head_size_z-1,2)),sqrt(pow(nose_size_y,2)+pow(head_size_z-1,2))]);
        
    } 
    
    // fire chamber attachment
    difference(){
        
        union()
        {
            translate([posx-4,posy+head_size_y+body_size_y-10,head_size_z/2+6]) cube([4,15,6]);
    
            translate([posx-4,posy+head_size_y+body_size_y-10,head_size_z/2-6]) cube([4,15,6]);
        }
        
        #translate([posx-2,posy+head_size_y+body_size_y-3,head_size_z/2-7])cylinder(r=1,h=20);
    }
}
}
//nose();

/////

//standoff cube
//translate([posx,posy+head_size_y+body_size_y,1]) cube([1,1,1]);

////


//atatch cube


module fire_chamber(posx=0,posy=0,posz=0,head_size_x=40,head_size_y=90,head_size_z=33,body_size_y=120,nose_size_y=35)
{
    translate([0,0,2]) difference()
    {
        translate([posx,posy+head_size_y+body_size_y+1,0]) cube([head_size_x,nose_size_y,head_size_z]);
        
        union()
        {
            translate([posx+W_T,posy+head_size_y+body_size_y+1,W_T]) cube([head_size_x-W_T*2,nose_size_y-W_T,head_size_z-W_T*2]);
            
            #translate([posx+head_size_x/2,posy+(nose_size_y/2)+body_size_y+head_size_y,posz]) cylinder(r=8,h=4.5);
        } 
    }
    
    //atachment system
    
    difference(){
    translate([posx-4,posy+head_size_y+body_size_y-5,head_size_z/2]) cube([4,15,6]);
    //#translate([posx-3,posy+head_size_y+body_size_y+1,head_size_z/2]) cube([1,10,6]);
        
        translate([posx-2,posy+head_size_y+body_size_y-2,head_size_z/2])cylinder(r=1,h=6);
        
    }
    
    
    
}

//fire_chamber();

//
//posx,posy,posz  are to position the corner. It should be placed at the outer corner of the whatever corner you are making
//c_w is the width of bounding cube, c_w = outer radus*2 
//inner raduis = outer radius - thickness
//c_l is the length of the edge
//c_h should be the same as c_w although later it may be able to have better variance
//
module r_corner(posx=0,posy=0,posz=0,thickness=W_T,c_w=10,c_h=10,c_l=30,quad=0,rot=0,up=0)
{
   translate([posx+c_w/2,posy,posz-c_h/2]) rotate([90*up,90*quad,90*rot]) difference()
   { 
        difference()
        {
            //edge cyl
            translate([[0,posy+(c_l/2),12]]) rotate([-90,0,0]) cylinder(r=c_h/2,h=c_l);
            //core cyl
            translate([0,-.05,0]) rotate([-90,0,0]) cylinder(r=(c_h/2)-thickness,h=c_l+.1);
        }
    
        difference()
        {
            //full cube
            translate([0,(c_l/2),0]) cube([c_w,c_l+.1,c_h],center=true);
            //corner cube
            translate([-c_w/4,(c_l/2),c_w/4]) cube([c_w/2+.1,c_l+.1,c_h/2+.1],center=true); 
        }
    }
    
}
//r_corner();

module r_corner_cap(xpos=0,ypos=0,zpos=0,thickness=W_T,c_h=20,quad=2,rot=2)
{
   translate([xpos,ypos,zpos])difference()
   { 
        difference()
        {
            //edge sphere
            sphere(r=c_h/2,center=true);
            //core sphere
            translate([0,-.05,0]) sphere(r=(c_h/2)-thickness);
        }
        
        rotate([quad*90,rot*90,0]) translate([-c_h/2,-c_h/2,-c_h/2]) difference()
        {
            cube([c_h,c_h,c_h]);
            // mark this one v
            cube([c_h/2,c_h/2,c_h/2]);
        } 
    }
    
}

module trigger(x=0,y=0,z=0)
{
    difference()
    {
        cube([6,30,30]);
        
        union()
        {
        
            translate([0,10,0]) union()
            {
                scale([12,1,1.5]) translate([0,30,10]) rotate([90,0,90]) cylinder(r=14,h=6);
            
            
                //holes top to bottom
            
            
                translate([0,13,25]) rotate([90,0,90]) cylinder(r=2,h=7);
            
                translate([0,12,15]) scale([1,1,2]) rotate([90,0,90]) cylinder(r=2,h=7);
            
                translate([0,13,5]) rotate([90,0,90]) cylinder(r=2,h=7); 
            }
            translate([0,0,10]) cube([6,10,10]); 
        }
    }
    
    translate([2,0,-3]) cube([2,20,3]);
    translate([2,0,30]) cube([2,20,3]);
    
    #translate([2,-3,22]) cube([2,4,3]);
    
}


module locking_key()
{
    
    rad=2;
    
    translate([15,10,-18]) cube([3,2,3]);
    translate([0,10-.5,-18]) cube([4,3,4]);
    translate([0,11,-19]) rotate([0,90,0]) cylinder(r=2,h=30);    
}


//r_corner_cap();

//parts
module ard(){
    cube([45,18,10]);
}

module bat(){
    cylinder(r=9,h=66);
}

//for comparison
module iPhone(){
    cube([7.6,123.8,58.6]);
}


module finger(){
    cylinder(r=14,h=100);
}
//rotate([90,0,90])finger();


/////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////Other Stuff/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

*translate([-80,0,0]) twin_plate_screw();
*translate([-40,0,0]) peg_screw(height=20,radius=2);

//parts
if(show_parts==true)
{
color("blue") translate([100,100,0]) ard();
color("blue") translate([ 80,120,0]) rotate([90,0,0]) bat();
}
//comparison
if(comp==true)
{
#translate([-50, 40,70]) rotate([0,90,0]) finger();
#translate([40,60,60]) iPhone();
}

//translate([70,-80,50]) cylinder(r=9,h=66);
