// Enclosure for LPT_Capture CN36_USBC_FANCY
//
// requires 2  #4-40 x 1/4" pan head screws
// https://www.digikey.com/en/products/detail/keystone-electronics/9900/317321
// https://www.homedepot.com/p/Everbilt-4-40-x-3-8-in-Phillips-Slotted-Round-Head-Machine-Screws-10-Pack-831431/317478830
//
// Use the customizer pane.

STYLE = "SHELL"; // [PLATE,TRAY,SHELL]

pcb_thickness = 1.6;
pcb_x = 68;
pcb_y = 31.7;
pcb_r = 3; // corner radius

wall_thickness = 1;
post_id = 3.2; // #4-40 screw, 0.125" hole
screw_head_od = post_id*2;
post_od = screw_head_od + wall_thickness*2;
screw_head_thickness = 2.1; // #4-40 pan head, 0.08" 2.032mm

post_x = 59.74 / 2; // 59.74 between posts
post_y = pcb_y/2 - 10.7; // 10.7 from pcb edge

gap = screw_head_thickness; // space between bottom of pcb and top of bottom wall
base_thickness = gap + wall_thickness;

usb_h = 7;
usb_w = 13;
usb_y = -6.85;
usb_z = 1.75;

lip = 1;
fc = 0.1;

/* [Hidden] */

// arc smoothness
//$fn = 32;
$fa = 6;
$fs = 0.1;

include <lib/handy.scad>;

module pcb () {
  import("lib/LPT_Capture_CN36_USBC_FANCY.pcb.stl");
}

module pcb_outline (x=pcb_x,y=pcb_y,z=base_thickness,R=pcb_r,r=0) {
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
    cylinder(h=base_thickness+1,d=post_id,center=true);
    // screw head pockets
    translate([0,0,-wall_thickness])
      cylinder(h=base_thickness,d=screw_head_od,center=true);
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
  th = wall_thickness + gap + pcb_thickness;

  difference() {
  union(){
  // main tray
  difference(){
    union(){
      // main
      translate([0,0,-th/2+pcb_thickness])
        pcb_outline(x=pcb_x+wall_thickness*2+fc*2,y=pcb_y+wall_thickness*2+fc*2,z=th,R=pcb_r+wall_thickness+fc,r=wall_thickness);
    }

    union(){
      // pcb tray
      translate([0,0,th/2])
      pcb_outline(x=pcb_x+fc*2,y=pcb_y+fc*2,z=th,R=pcb_r+fc);
      // gap cavity
      translate([0,0,th/2-gap])
      pcb_outline(x=pcb_x-lip*2,y=pcb_y-lip*2,z=th,R=pcb_r-wall_thickness);
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
    cylinder(d=post_od,h=h);
    translate([0,-post_od/2,0]) cube([post_od/2,post_od,h]);
  }

  }

  screw_holes();
  }
  
}

module shell () {
  H = 17.2;
  T = 14;
  
  difference() {
    union() {
      difference() {
        hull() {
          mirror_copy([1,0,0]) {
            translate([0,-T/2+pcb_y/2,H/2-gap/2]) mirror_copy([0,1,0])
              mirror_copy([0,0,1])
                translate([pcb_x/2,T/2-wall_thickness,H/2+gap/2])
                  sphere(r=wall_thickness+fc);
            translate([pcb_x/2-pcb_r,-pcb_y/2+pcb_r,pcb_r-gap])
              sphere(r=pcb_r+fc+wall_thickness);
            *translate([pcb_x/2,-pcb_y/2+pcb_r,-gap])
              #sphere(r=fc+wall_thickness);
            translate([pcb_x/2-pcb_r,-pcb_y/2+pcb_r,pcb_r])
              sphere(r=pcb_r+fc+wall_thickness);
            *translate([pcb_x/2-pcb_r,pcb_y/2-D,H-pcb_r])
              #sphere(r=pcb_r+fc+wall_thickness);
          }
        }

        union () {
          hull() {
            translate([-pcb_x/2-fc,pcb_y/2-T+1,-fc])
              cube([pcb_x+fc*2,T+1,H+fc*2]);
            mirror_copy([1,0,0]) translate([pcb_x/2-pcb_r,-pcb_y/2+pcb_r,-fc]) {
              cylinder(r=pcb_r+fc,h=pcb_thickness+fc*2);
              translate([0,0,pcb_r+fc])
                sphere(r=pcb_r+fc);
            }
            *mirror_copy([1,0,0]) translate([pcb_x/2-pcb_r,pcb_y/2-D,H-pcb_r])
              #sphere(r=pcb_r+fc);
          }

          // gap cavity
          th = wall_thickness + gap + pcb_thickness;

          translate([0,0,th/2-gap])
            pcb_outline(x=pcb_x-lip*2,y=pcb_y-lip*2,z=th,R=pcb_r-wall_thickness);

          // usb
          x = 1;
          translate([-pcb_x/2+x,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
            hull() mirror_copy([1,0,0])
              translate([usb_w/2-usb_h/2,0,0])
              cylinder(h=wall_thickness+fc*2+x,d=usb_h);
        }
      }
      // add screw posts
      mirror_copy([1,0,0]) translate([post_x,post_y,-gap-fc]) {
        cylinder(d=post_od,h=gap);
        translate([0,-post_od/2,0]) cube([post_od/2,post_od,gap]);
      }
    }

    screw_holes();
  }
}


%pcb();

if (STYLE=="PLATE") plate();
else if (STYLE=="TRAY") tray();
else shell();