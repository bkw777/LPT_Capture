// Enclosure for LPT_Capture CN36_USBC_FANCY
//
// requires 2  #4-40 x 1/4" flat head screws (by degfault)
//
// Use the customizer pane.

STYLE = "SHELL"; // [PLATE,TRAY,SHELL]
FASTENER = "SNAP"; // [PANHEAD,FLATHEAD,SNAP]

pcb_thickness = 1.6;
pcb_w = 68;
pcb_d = 31.7;
pcb_r = 3; // corner radius

wall_thickness = 1;
post_id = 3; // #4-40 screw, 2.845 od
screw_head_od = post_id*2;
post_od = screw_head_od + wall_thickness*2;
screw_head_thickness = 2.1; // #4-40 pan head is just over 2mm thick

post_x = 59.74 / 2; // 59.74 between posts
post_y = pcb_d/2 - 10.7; // 10.7 from pcb edge


usb_h = 8;
usb_w = 14;
usb_y = -6.85;
usb_z = 1.75;

lip = 1;
fc = 0.1;

/* [Hidden] */

SHELL = (STYLE=="SHELL");
TRAY = (STYLE=="TRAY");
PLATE = (STYLE=="PLATE");
PANHEAD = (FASTENER=="PANHEAD");
FLATHEAD = (FASTENER=="FLATHEAD");
SNAP = (FASTENER=="SNAP");

// space between bottom of pcb and top of bottom wall
gap =
  (PANHEAD)?screw_head_thickness:
  (FLATHEAD)?screw_head_thickness-wall_thickness:
  1;
base_thickness = gap + wall_thickness;

// arc smoothness
//$fn = 32;
$fa = 6;
$fs = 0.1;

include <lib/handy.scad>;

module pcb () {
  import("lib/LPT_Capture_CN36_USBC_FANCY.pcb.stl");
}

module screw() {
  if (FLATHEAD) %import("lib/flathead.stl");
}

module pcb_outline (x=pcb_w,y=pcb_d,z=base_thickness,R=pcb_r,r=0) {
  hull() {
    if (r) mirror_copy([1,0,0]) translate([x/2-r,y/2-r,0]) cylinder(h=z,r=r,center=true);
    else translate([0,y/2-1,0]) cube([x,2,z],center=true);
    mirror_copy([1,0,0]) translate([x/2-R,-y/2+R,0])
      cylinder(h=z,r=R,center=true);
  }
}

module screw_posts () {
  if (!SNAP) mirror_copy([1,0,0]) translate([post_x,post_y,-gap-fc]) {
    cylinder(d=post_od,h=gap);
    translate([0,-post_od/2,0]) cube([post_od/2,post_od,gap]);
  }
}

module screw_holes () {
  if (!SNAP) mirror_copy([1,0,0]) translate([post_x,post_y,-base_thickness-fc]) {
    // screw holes
    cylinder(h=base_thickness+fc*2,d=post_id);
    // screw head pockets
    if (FLATHEAD) {
      cylinder(h=base_thickness+fc,d2=post_id,d1=screw_head_od);
      translate([0,0,fc*2]) screw();
    }
    else translate([0,0,-wall_thickness]) cylinder(h=base_thickness,d=screw_head_od);
  }
}

module plate () {
  difference() {
    translate([0,0,-base_thickness/2]) pcb_outline();

    union() {
      // pocket for solder legs
      translate([0,post_y,-base_thickness/2+wall_thickness])
        cube([40,7,base_thickness],center=true);

      screw_holes();
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
        pcb_outline(x=pcb_w+wall_thickness*2+fc*2,y=pcb_d+wall_thickness*2+fc*2,z=th,R=pcb_r+wall_thickness+fc,r=wall_thickness);
    }

    union(){
      // pcb tray
      translate([0,0,th/2-fc])
      pcb_outline(x=pcb_w+fc*2,y=pcb_d+fc*2,z=th,R=pcb_r+fc);
      // gap cavity
      translate([0,0,th/2-gap])
      pcb_outline(x=pcb_w-lip*2,y=pcb_d-lip*2,z=th,R=pcb_r-wall_thickness);
      // usb
      translate([-pcb_w/2,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
      hull() mirror_copy([1,0,0])
      translate([usb_w/2-usb_h/2,0,0])
      cylinder(h=wall_thickness+fc*2,d=usb_h);

    }    
  }

  // add screw posts
  screw_posts();

  }

  // cut screw holes
  screw_holes();
  }
  
}

module shell () {
  H = 17.2;
  T = 14;
  r = wall_thickness+fc;
  sw = pcb_w-pcb_r*2;

  difference() {
    union() {
      difference() {
        union() {
        hull() {
          translate([0,pcb_d/2-T/2,H/2-gap/2]) rounded_cube(w=pcb_w+r*2,d=T,h=H+gap+r*2,rh=r,rv=r,t=0);
          R = pcb_r+fc+wall_thickness;
          z = r*2+usb_h;
          translate([0,-pcb_d/2+pcb_r,z/2-fc-base_thickness]) rounded_cube(w=pcb_w+r*2,d=R*2,h=z,rh=R,rv=r,t=0);
        }
        if (SNAP) {
          fd = wall_thickness/2+fc+lip+1;
          br = r;
          hull() mirror_copy([1,0,0]) translate([sw/2-br,pcb_d/2+fc+x,br-fc-base_thickness]) rotate([90,0,0]) cylinder(r=br,h=fd);
        }
        }

        union () {
          hull() {
            translate([-pcb_w/2-fc,pcb_d/2-T+1,-fc])
              cube([pcb_w+fc*2,T+1,H+fc*2]);
            mirror_copy([1,0,0]) translate([pcb_w/2-pcb_r,-pcb_d/2+pcb_r,-fc]) {
              cylinder(r=pcb_r+fc,h=pcb_thickness+fc*2);
              translate([0,0,pcb_r+fc])
                sphere(r=pcb_r+fc);
            }
          }

          // gap cavity
          th = wall_thickness + gap + pcb_thickness;

          translate([0,0,th/2-gap])
            pcb_outline(x=pcb_w-lip*2,y=pcb_d-lip*2,z=th,R=pcb_r-wall_thickness);

          // cut usb
          x = wall_thickness+fc+lip+2; // make sure it goes well past the lip
          translate([x-pcb_w/2-fc-wall_thickness-fc,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
            hull() mirror_copy([1,0,0])
              translate([usb_w/2-usb_h/2,0,0])
                cylinder(h=x,d=usb_h);
        }
      }
      // replace part of lip cut away by usb
      translate([-pcb_w/2,usb_y-usb_w/2,-gap-fc]) cube([lip,usb_w,gap]);
      // add screw posts
      screw_posts();
      // add pcb top grabber
      x = wall_thickness/2;
      translate([0,lip/2-pcb_d/2-fc,x+pcb_thickness+fc]) rounded_cube(w=sw,d=lip+fc+x*2,h=wall_thickness,rh=x,rv=x);
      // add front lip
      if (SNAP) {
        h = base_thickness;
        d = wall_thickness*2+r*2;
        ft = base_thickness+fc+pcb_thickness;
        translate([0,pcb_d/2+x+fc,ft/2-fc-base_thickness]) rotate([90,0,0]) rounded_cube(w=sw,d=ft,h=wall_thickness,rh=r,rv=wall_thickness/2);
      }
    }

    // cut screw holes
    translate([0,0,-fc]) screw_holes();
  }
}


%pcb();

if (PLATE) plate();
else if (TRAY) tray();
else shell();
