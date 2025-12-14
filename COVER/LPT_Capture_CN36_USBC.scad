// Enclosure for LPT_Capture CN36_USBC_FANCY

pcb_thickness = 1.6;
pcb_x = 68;
pcb_y = 31.7;
pcb_cr = 3;

wall_thickness = 1;
post_height = 3;
post_diameter = 8;
post_hole_diameter = 3.2;
post_x = 29.87;
post_y = 5.15;

base_thickness = 3;

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

module basic () {
  translate([0,0,-base_thickness/2]) difference() {

  pcb_outline();

  union() {
    mirror_copy([1,0,0]) translate([post_x,post_y,0]) {
      // screw holes
      cylinder(h=base_thickness+1,d=post_hole_diameter,center=true);
      // screw head pockets
      translate([0,0,-wall_thickness])
      cylinder(h=base_thickness,d=post_hole_diameter*2,center=true);
    }

    // pin legs pocket
    translate([0,post_y,wall_thickness])
    cube([40,7,base_thickness],center=true);

  }


  }
}

// incomplete, just the bottom tray yet
module fancy () {
  gap = 1;
  lip = 1;
  th = wall_thickness + gap + pcb_thickness;
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
      translate([0,0,wall_thickness])
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
}

pcb();

basic();
//fancy();