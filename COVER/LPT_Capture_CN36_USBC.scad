// Enclosure for LPT_Capture CN36_USBC_FANCY

pcb_thickness = 1.6;
pcb_x = 68;
pcb_y = 31.7;
pcb_cr = 3;

wall_thickness = 1;
post_hole_diameter = 3.2; // #4-40 screw, 0.125" hole
screw_head_diameter = post_hole_diameter *2;
post_diameter = screw_head_diameter + wall_thickness*2;

post_x = 59.74 / 2; // 59.74 between posts
post_y = pcb_y/2 - 10.7; // 10.7 from pcb edge

gap = 2.1; // 4-40 pan head thickness 0.08" = 2.032mm this also becomes the screw head pocket depth, so it needs to be enough to recess the screw head even if it's more than needed for the trimmed connector legs
base_thickness = gap + wall_thickness;

usb_h = 7;
usb_w = 13;
usb_y = -6.85;
usb_z = 1.75;

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

module pcb_outline (x=pcb_x,y=pcb_y,z=base_thickness,R=pcb_cr,r=0) {
  hull() {
    if (r) mirror_copy([1,0,0]) translate([x/2-r,y/2-r,0]) cylinder(h=z,r=r,center=true);
    else translate([0,y/2-1,0]) cube([x,2,z],center=true);
    mirror_copy([1,0,0]) translate([x/2-R,-y/2+R,0])
      cylinder(h=z,r=R,center=true);
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

module plate () {
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
module tray () {
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
        pcb_outline(x=pcb_x+wall_thickness*2+fc*2,y=pcb_y+wall_thickness*2+fc*2,z=th,R=pcb_cr+wall_thickness+fc,r=wall_thickness);
    }

    union(){
      // pcb tray
      translate([0,0,th/2])
      pcb_outline(x=pcb_x+fc*2,y=pcb_y+fc*2,z=th,R=pcb_cr+fc);
      // gap cavity
      translate([0,0,th/2-gap])
      pcb_outline(x=pcb_x-lip*2,y=pcb_y-lip*2,z=th,R=pcb_cr-wall_thickness);
      // usb
      translate([-pcb_x/2,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
      hull() mirror_copy([1,0,0])
      translate([usb_w/2-usb_h/2,0,0])
      cylinder(h=wall_thickness+fc*2,d=usb_h);

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

module cover () {
}

pcb();

//plate();
tray();
//cover();