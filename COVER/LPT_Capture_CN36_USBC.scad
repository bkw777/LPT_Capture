// Enclosure for LPT_Capture CN36_USBC_FANCY

pcb_thickness = 1.6;
pcb_x = 68;
pcb_y = 31.7;
pcb_cr = 3;

wall_thickness = 1;
post_hole_diameter = 3.2;
screw_head_diameter = post_hole_diameter *2;
post_diameter = screw_head_diameter + wall_thickness*2;

post_x = 29.87;
post_y = 5.15;

gap = 2; // this also becomes the screw head pocket depth, so it needs to be enough to recess the screw head even if it's more than needed for the trimmed connector legs
base_thickness = gap + wall_thickness;

// arc smoothness
//$fn = 32;
$fa = 6;
$fs = 0.1;

fc = 0.1;
e = 0.002;

include <lib/handy.scad>;

module pcb () {
  %import("lib/LPT_Capture_CN36_USBC_FANCY.pcb.stl");
}

module pcb_outline (x=pcb_x,y=pcb_y,z=base_thickness,r=pcb_cr) {
  hull() {
    translate([0,y/2-1,0])
      cube([x,2,z],center=true);
    mirror_copy([1,0,0]) translate([x/2-r,-y/2+r,0])
      cylinder(h=z,r=r,center=true);
  }
}

module screw_holes () {
  mirror_copy([1,0,0]) translate([post_x,post_y,-base_thickness/2]) {
    // screw holes
    cylinder(h=base_thickness+1,d=post_hole_diameter,center=true);
    // screw head pockets
    translate([0,0,-wall_thickness])
      cylinder(h=base_thickness,d=screw_head_diameter,center=true);
  }
}

module basic () {
  difference() {
    translate([0,0,-base_thickness/2]) pcb_outline();

    union() {
      screw_holes();
      // pin legs pocket
      translate([0,post_y,-base_thickness/2+wall_thickness])
      cube([40,7,base_thickness],center=true);
    }

  }
}

// incomplete, just the bottom tray yet
module fancy () {
  //gap = 1;
  lip = 1;
  th = wall_thickness + gap + pcb_thickness;

  difference() {
  union(){
  // main tray
  difference(){
    union(){
      // main
      translate([0,0,-th/2+pcb_thickness])
        pcb_outline(x=pcb_x+wall_thickness*2+fc*2,y=pcb_y+wall_thickness*2+fc*2,z=th,r=pcb_cr+wall_thickness+fc);
    }

    union(){
      // pcb tray
      translate([0,0,th/2])
      pcb_outline(x=pcb_x+fc*2,y=pcb_y+fc*2,z=th,r=pcb_cr+fc);
      // gap cavity
      translate([0,0,th/2-gap])
      pcb_outline(x=pcb_x-lip*2,y=pcb_y-lip*2,z=th,r=pcb_cr-wall_thickness);
      // usb
      uh = 3.5;
      uw = 9.3;
      upad = 3;
      translate([-pcb_x/2+0.01,-6.85,pcb_thickness+uh/2]) rotate([90,0,-90])
      hull() mirror_copy([1,0,0])
      translate([uw/2-uh/2,0,0])
      cylinder(h=wall_thickness+1,d=uh+upad*2);

    }    
  }

  // add screw posts
  h = gap; // gap+wall_thickness/2;
  mirror_copy([1,0,0]) translate([post_x,post_y,-h]){
    cylinder(d=post_diameter,h=h);
    translate([0,-post_diameter/2,0]) cube([post_diameter/2,post_diameter,h]);
  }

  }

  translate([0,0,0]) screw_holes();
  }
  
}

pcb();

//basic();
fancy();