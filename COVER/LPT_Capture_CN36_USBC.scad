// Enclosure for LPT_Capture CN36_USBC_FANCY
//
// Use the customizer pane to select options.
// PANHEAD or FLATHEAD requires 2  #4-40 x 1/4" screws.

NOTES = ""; // just a way to provide per-config notes in the customizer

STYLE = "SHELL"; // [SHELL,TRAY,PLATE]
FASTENER = "CLIP"; // [CLIP,PAN HEAD,FLAT HEAD,FLAT+CLIP,PAN+CLIP]
DIP_SWITCH = "LOW PROFILE"; // [LOW PROFILE,JUMPERS,PIANO,STANDARD]
LEDS = "HORIZONTAL"; // [HORIZONTAL, VERTICAL, SMT]
CN36 = "112-036-213R002"; // [112-036-213R002,1734044-1,5552742-1]

////////////////////////////////////////
SHELL = (STYLE=="SHELL");
TRAY = (STYLE=="TRAY");
PLATE = (STYLE=="PLATE");
CLIP = (FASTENER=="CLIP" || FASTENER=="FLAT+CLIP" || FASTENER=="PAN+CLIP");
PAN_HEAD = (FASTENER=="PAN HEAD" || FASTENER=="PAN+CLIP");
FLAT_HEAD = (FASTENER=="FLAT HEAD" || FASTENER=="FLAT+CLIP");
SW_LOW = (DIP_SWITCH=="LOW PROFILE");
SW_STD = (DIP_SWITCH=="STANDARD");
SW_PIANO = (DIP_SWITCH=="PIANO");
SW_JMP = (DIP_SWITCH=="JUMPERS");
LED_HORIZ = (LEDS=="HORIZONTAL");
LED_VERT = (LEDS=="VERTICAL");
LED_SMT = (LEDS=="SMT");
CN36_A = (CN36=="112-036-213R002");
CN36_B = (CN36=="1734044-1");
CN36_C = (CN36=="5552742-1");

////////////////////////////////////////

/* [Hidden] */
pcb_thickness = 1.6;
pcb_w = 68;
pcb_d = 32;
pcb_r = 3; // corner radius

/* [Global] */

// 0 = auto, based on usb_clearance and led_diameter.
rear_height = 3; // 0.1

fitment_clearance = 0.1;

fc = fitment_clearance;
wall_thickness = 1; // 0.1
rear_wall_ext = -(pcb_d/2 + fc + wall_thickness);

lip = 1;

screw_hole_id = 3; // #4-40 screw, 2.845 od

usb_clearance = 2; // 0.1

/* [Hidden] */
cn36_top_depth =
  CN36_C ? 15 :
  7;
cn36_height = 
  CN36_B ? 15.2 :
  CN36_C ? 15.8 :
  15.6;
cn36_y = 5.3;
cn36_post_seperation = 59.74;
cn_h = cn36_height;
cn_vd = cn36_top_depth;

/* [Global] */
CUT_LED_HOLES = true;
led_diameter = 5; // 0.1

/* [Hidden] */
leds_y = -7;
led1_x = 28;
led2_x = 21;
leds_ox = abs(led1_x-led2_x)/2; // x offset (half of center to center)
leds_x = min(led1_x,led2_x) + leds_ox; // center x pos
led_l = 10;

/* [Global] */
CUT_DIPSW_HOLE = false;

// 0=auto
dipsw_hole_bottom = 0; // 0.1
// 0=auto
dipsw_horiz_hole_height = 0; // 0.1
// 0=auto
dipsw_vert_hole_height = 0; // 0.1
dipsw_hole_width = 12.8; // 0.1
// 0=auto
dipsw_horiz_hole_depth = 0; // 0.1
// 0=auto
dipsw_vert_hole_depth = 0; // 0.1
// 0=auto
dipsw_horiz_hole_outside_y = 0; // 0.1
// 0=auto
dipsw_vert_hole_outside_y = 0; // 0.1
dipsw_hole_corner_radius = 0.5; // 0.1

/* [Hidden] */

sw_x = 10.0125;
sw_y = -9.144;
sw_d = 
  SW_STD ? 17 :
  SW_PIANO ? 17 :
  SW_JMP ? 17 :
  15.24; // switch body depth

sw_r = dipsw_hole_corner_radius;

//sw_inset = rear_wall_ext - sw_y + sw_d/2;

sw_w = dipsw_hole_width;

// dipsw horizontal cut cube height
sw_hh =
  dipsw_horiz_hole_height ? dipsw_horiz_hole_height :
  SW_STD ? 0 :
  SW_PIANO ? 5 :
  SW_JMP ? 9 :
  0;
// dipsw vertical cut cube height
sw_hv = cn36_height+2;

// dipsw horizontal cut cube depth
sw_dh =
  dipsw_horiz_hole_depth ? dipsw_horiz_hole_depth :
  SW_PIANO ? 14 :
  0;
// dipsw vertical cut cube depth
sw_dv =
  dipsw_vert_hole_depth ? dipsw_vert_hole_depth :
  SW_STD ? 10.5 :
  SW_PIANO ? 7 :
  SW_JMP ? 10.5 :
  8;

// dipsw horizontal cut cube y pos
sw_yh =
  dipsw_horiz_hole_outside_y ? dipsw_horiz_hole_outside_y :
  rear_wall_ext - sw_r;
// dipsw verticalal cut cube y pos
sw_yv =
  dipsw_vert_hole_outside_y ? dipsw_vert_hole_outside_y :
  SW_PIANO ? rear_wall_ext - sw_r :
  sw_y-sw_dv/2;

sw_z =
  dipsw_hole_bottom ? dipsw_hole_bottom :
  SW_STD ? 1 :
  SW_PIANO ? 3 :
  SW_JMP ? 1 :
  1;
sw_zz = sw_z?sw_z:(fc+wall_thickness);

usb_h = 3.2; // thickness of usbc
usb_w = 9;
usb_cx = (usb_w - usb_h)/2;
usb_r = usb_h/2 + usb_clearance;
usb_H = usb_h + usb_clearance*2;
usb_W = usb_w + usb_clearance*2;
echo("usb hole height",usb_H);
echo("usb hole width",usb_W);
assert(usb_H>=6.5);
assert(usb_W>=12.5);

usb_y = -6.85;
usb_z = 1.7; // center of usbc above pcb top (not exactly usb_h/2)

post_id = screw_hole_id;
screw_head_od = post_id*2;
post_od = screw_head_od + wall_thickness*2;
screw_head_thickness = 2.1; // #4-40 pan head is just over 2mm thick

// rear_height=0 -> auto
rh = pcb_thickness + fc + (rear_height?rear_height:max(usb_z+usb_r,led_diameter+1));


// space between bottom of pcb and top of bottom wall
gap =
  (PAN_HEAD)?screw_head_thickness:
  (FLAT_HEAD)?screw_head_thickness-wall_thickness:
  1;
base_thickness = gap + wall_thickness;

// arc smoothness
//$fn = 32;
$fa = 6;
$fs = 0.1;

////////////////////////////////////////////////////////////////////////////////////////

minimum_wall_thickness = 0.8;
assert (wall_thickness>minimum_wall_thickness-0.1);  // >= test doesn't work?


////////////////////////////////////////////////////////////////////////////////////////

use <lib/handy.scad>;

module bisect (x=0) {
  w = pcb_w/2+fc+wall_thickness+1;
  d = 1+wall_thickness+fc+pcb_d+fc+wall_thickness+1;
  h = 1+base_thickness+fc+pcb_thickness+cn_h+fc+wall_thickness+1;
  difference() {
    children();
    translate([x,-d/2,-fc-base_thickness-1]) cube([w,d,h]);
  }
}

module pcb () {
  import("lib/LPT_Capture_CN36_USBC_FANCY.notht.pcb.stl");
}

module cn36 () {
  translate([0,cn36_y,pcb_thickness]) if (CN36_B) import("lib/cn36_1734044-1.stl");
  else if (CN36_C) import("lib/cn36_5552742-1.stl");
  else import("lib/cn36_112-036-213R002.stl");
}

module dipsw () {
  translate([sw_x,sw_y,pcb_thickness]) if (SW_JMP) translate([0,2.54,0]) import("lib/dipsw_jumpers.stl");
  else if (SW_STD) import("lib/dipsw_standard.stl");
  else if (SW_LOW) import("lib/dipsw_lowprofile.stl");
  else if (SW_PIANO) import("lib/dipsw_piano.stl");
}

module leds () {
  translate([leds_x,leds_y,pcb_thickness]) mirror_copy([1,0,0]) translate([leds_ox,0,0])
    if (LED_HORIZ) import("lib/led_horizontal.stl");
    else if (LED_VERT) import("lib/led_vertical.stl");
    else if (LED_SMT) import("lib/led_smt.stl");
}

module screw () {
  if (FLAT_HEAD) %import("lib/flathead.stl");
  if (PAN_HEAD) %import("lib/panhead.stl");
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
  x = cn36_post_seperation/2;
  if (PAN_HEAD || FLAT_HEAD) mirror_copy([1,0,0]) translate([x,cn36_y,-gap-fc]) {
    cylinder(d=post_od,h=gap);
    translate([0,-post_od/2,0]) cube([post_od/2,post_od,gap]);
  }
}

module screw_holes () {
  x = cn36_post_seperation/2;
  if (PAN_HEAD || FLAT_HEAD) mirror_copy([1,0,0]) translate([x,cn36_y,-base_thickness-fc]) {
    // screw holes
    cylinder(h=base_thickness+fc*2,d=post_id);
    // screw head pockets
    if (FLAT_HEAD) {
      cylinder(h=base_thickness+fc,d2=post_id,d1=screw_head_od);
      translate([0,0,fc*2]) screw();
    }
    else {
      translate([0,0,-wall_thickness]) cylinder(h=base_thickness,d=screw_head_od);
      translate([0,0,gap]) screw();
    }

  }
}

/////////////////////////////////////////////////////////////////////////////////////////
// FULL MODELS
/////////////////////////////////////////////////////////////////////////////////////////

// Simplest and smallest
// todo: snap option
module plate () {
  difference() {
    translate([0,0,-base_thickness/2]) pcb_outline();

    union() {
      t = base_thickness;
      // pockets for solder legs
      translate([0,0,-t/2+wall_thickness]) {
        // cn36
        translate([0,cn36_y,0]) cube([40,7,t],center=true);
        // dipsw
        translate([sw_x,sw_y,0]) cube([10,10,t],center=true);
        // leds
        translate([leds_x,leds_y,0]) cube([leds_ox*4-1,3,t],center=true);
      }

      screw_holes();
    }

  }
}

// Slightly fancier than plate()
// protects the pcb edge
// easy to print
// does not require rounded_cube()
// todo: snap option
module tray () {
  th = wall_thickness + gap + pcb_thickness;

  difference() {
    union() {
      // main tray
      difference() {
        union() {
          // main
          translate([0,0,-th/2+pcb_thickness])
            pcb_outline(x=pcb_w+wall_thickness*2+fc*2,y=pcb_d+wall_thickness*2+fc*2,z=th,R=pcb_r+wall_thickness+fc,r=wall_thickness);
        }

        union() {
          // pcb tray
          translate([0,0,th/2-fc])
          pcb_outline(x=pcb_w+fc*2,y=pcb_d+fc*2,z=th,R=pcb_r+fc);
          // gap cavity
          translate([0,0,th/2-gap])
          pcb_outline(x=pcb_w-lip*2,y=pcb_d-lip*2,z=th,R=pcb_r-wall_thickness);
          // usb
          translate([-pcb_w/2,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
          hull() mirror_copy([1,0,0])
          translate([usb_cx,0,0])
          cylinder(h=wall_thickness+fc*2,r=usb_r);

        }
      }

      // add screw posts
      screw_posts();
    }

  // cut screw holes
  screw_holes();
  }
  
}

// Full Fancy
// Difficult to print with FDM, suggest commercial SLS or MJF
// todo: expose LEDs
module shell () {
  sw = pcb_w-14;
  rw = pcb_w/2;
  r = wall_thickness;
  R = pcb_r+fc+wall_thickness;
  orh = base_thickness+rh+r;
  fh = cn_h+fc;
  ofh = base_thickness + fc + pcb_thickness + fh + wall_thickness;

  difference() {
    union() {
      difference() {
        union() {
          hull() {
            // add outside front
            
            translate([0,pcb_d/2-cn_vd/2,ofh/2-base_thickness]) rounded_cube(w=pcb_w+r*2,d=cn_vd,h=ofh,rh=r,rv=r,t=0);
            // add outside rear
            translate([0,-pcb_d/2+pcb_r,orh/2-base_thickness]) rounded_cube(w=pcb_w+r*2,d=R*2,h=orh,rh=R,rv=r,t=0);
          }
          // add front lip floor
          if (CLIP) {
            fd = wall_thickness/2+fc+lip+1;
            br = base_thickness/2;
            hull() mirror_copy([1,0,0]) translate([sw/2-br,pcb_d/2+fc+x,br-base_thickness]) rotate([90,0,0]) cylinder(r=br,h=fd);
          }
        }

        union() {
          hull() {
            // cut inside front
            translate([-pcb_w/2-fc,pcb_d/2-cn_vd+1,-fc])
              cube([pcb_w+fc*2,cn_vd+1,fc+pcb_thickness+fh]);
            // cut inside rear
            mirror_copy([1,0,0]) translate([pcb_w/2-pcb_r,-pcb_d/2+pcb_r,-fc])
              cylinder(r=pcb_r+fc,h=rh);
          }

          // gap cavity
          th = wall_thickness + gap + pcb_thickness;
          translate([0,0,th/2-gap])
            pcb_outline(x=pcb_w-lip*2,y=pcb_d-lip*2,z=th,R=pcb_r-wall_thickness);

          // cut usb
          // depth of cut
          //x = fc+wall_thickness+fc; // just the wall
          //x = fc+lip+fc+wall_thickness+fc; // just past the lip
          x = fc+pcb_r+fc+wall_thickness+fc; // entire possible curvature at the rear corner
          translate([x-pcb_w/2-fc-wall_thickness-fc,usb_y,pcb_thickness+usb_z]) rotate([90,0,-90])
            hull() mirror_copy([1,0,0])
              translate([usb_cx,0,0])
                cylinder(h=x,r=usb_r);
          // cut LEDs
          if (CUT_LED_HOLES) translate([0,-pcb_d/2-fc-wall_thickness-fc,pcb_thickness+3]) {
            _d = led_diameter + fc;
            translate([led1_x,0,0]) rotate([-90,0,0]) cylinder(h=led_l,d=_d);
            translate([led2_x,0,0]) rotate([-90,0,0]) cylinder(h=led_l,d=_d);
          }
          // cut DIP Switch
          if (CUT_DIPSW_HOLE) {
            translate([sw_x,sw_yh+sw_dh/2,sw_hh/2+pcb_thickness+sw_zz])
              rounded_cube(w=sw_w,d=sw_dh,h=sw_hh,rh=sw_r,rv=sw_r);
            translate([sw_x,sw_yv+sw_dv/2,sw_hv/2+pcb_thickness+sw_zz])
              rounded_cube(w=sw_w,d=sw_dv,h=sw_hv,rh=sw_r,rv=sw_r);
          }
        }
      }
      // replace part of lip cut away by usb
      translate([-pcb_w/2,usb_y-usb_W/2,-gap-fc]) cube([lip,usb_W,gap]);
      // add screw posts
      screw_posts();
      x = wall_thickness/2;
      // add rear lip
      // w=rw to avoid interfering with leds
      translate([0,lip/2-pcb_d/2-fc,x+pcb_thickness+fc]) rounded_cube(w=rw,d=lip+fc+x*2,h=wall_thickness,rh=x,rv=x);
      // add pcb guide ribs
      mirror_copy([1,0,0]) translate([rw/2,0,0]) {
        // top
        hull() {
          // outside edges pulled fc in from real exterior
          _r = wall_thickness/2;
          // top rear
          translate([0,-pcb_d/2,rh-fc]) rotate([0,90,0]) cylinder(h=wall_thickness,r=r,center=true);
          // bottom rear
          translate([0,-pcb_d/2-_r,_r+pcb_thickness+fc]) rotate([0,90,0]) cylinder(h=wall_thickness,r=_r,center=true);
          // bottom front
          _R = min(rh,lip+wall_thickness);
          translate([0,-pcb_d/2+lip,_R+pcb_thickness+fc]) rotate([0,90,0]) cylinder(h=wall_thickness,r=_R,center=true);
          // top front
          translate([0,pcb_d/2+wall_thickness-cn_vd-fc,_r+pcb_thickness+fh]) rotate([0,90,0]) cylinder(h=wall_thickness,r=_r,center=true);
        }
        // bottom
        hull() {
          t = base_thickness-fc;
          s = wall_thickness-fc-fc;
          translate([0,-pcb_d/2+lip,-t/2-fc]) cube([wall_thickness,lip,t],center=true);
          translate([0,-pcb_d/2+lip+6,-s/2-fc-gap-fc]) cube([wall_thickness,lip,s],center=true);
        }
      }
      // add front lip wall
      if (CLIP) {
        // limitation of rounded_cube(), must draw with larger radius horizontal,
        // then rotate, depth becomes height
        t = base_thickness+pcb_thickness;
        translate([0,pcb_d/2+x+fc,t/2-base_thickness]) rotate([90,0,0]) rounded_cube(w=sw,d=t,h=wall_thickness,rh=base_thickness/2,rv=wall_thickness/2);
      }
    }

    // cut screw holes
    translate([0,0,-fc]) screw_holes();
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
// OUTPUT
/////////////////////////////////////////////////////////////////////////////////////////

%pcb();
%cn36();
%dipsw();
%leds();

//bisect(x=17)
//bisect(x=12)
//bisect()
if (PLATE) plate();
else if (TRAY) tray();
else shell();
