// Enclosure for LPT_Capture CN36_USBC_FANCY
//
// Use the customizer pane to select options.
// PANHEAD or FLATHEAD requires 2  #4-40 x 1/4" screws.

STYLE = "SHELL"; // [PLATE,TRAY,SHELL]
FASTENER = "SNAP-TOGETHER"; // [PAN-HEAD,FLAT-HEAD,SNAP-TOGETHER]

wall_thickness = 1; // 0.1
screw_hole_id = 3; // #4-40 screw, 2.845 od

usb_h = 8;
usb_w = 14;

cn36_top_depth = 7; // [7,15]
cn36_height = 15.6;

LEDS = true;
led_diameter = 5; // 0.1

// short end inside ceiling height above pcb, 0 = auto based on usb_h and led_diameter
rear_height = 0; //0.1

// dip switch access
DIPSW = true;
sw_w = 12.8;
sw_d = 13;
sw_d2 = 6;
sw_h = 5; // cn36_height+2;
sw_h2 = cn36_height+2;
sw_r = 0.5;
sw_x = 10;
sw_z = 3;

lip = 1;
fitment_clearance = 0.1;

CONFIGURATION_NOTES = "";

/* [Hidden] */

fc = fitment_clearance;

pcb_thickness = 1.6;
pcb_w = 68;
pcb_d = 32;
pcb_r = 3; // corner radius

post_id = screw_hole_id;
screw_head_od = post_id*2;
post_od = screw_head_od + wall_thickness*2;
screw_head_thickness = 2.1; // #4-40 pan head is just over 2mm thick

post_x = 59.74 / 2; // 59.74 between posts
post_y = pcb_d/2 - 10.7; // 10.7 from pcb edge

usb_y = -6.85;
usb_z = 1.7;

// rear_height=0 -> auto
rh = pcb_thickness + fc + (rear_height?rear_height:max(usb_z+usb_h/2,led_diameter+1));

cn_h = cn36_height;
cn_vd = cn36_top_depth;

led1_x = 28;
led2_x = 21;
led_l = 10;

sw_zz = sw_z?sw_z:(fc+wall_thickness);

SHELL = (STYLE=="SHELL");
TRAY = (STYLE=="TRAY");
PLATE = (STYLE=="PLATE");
PANHEAD = (FASTENER=="PAN-HEAD");
FLATHEAD = (FASTENER=="FLAT-HEAD");
SNAP = (FASTENER=="SNAP-TOGETHER");

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

////////////////////////////////////////////////////////////////////////////////////////

minimum_wall_thickness = 0.8;
assert (wall_thickness>minimum_wall_thickness-0.1);  // >= test doesn't work?


////////////////////////////////////////////////////////////////////////////////////////

include <lib/handy.scad>;

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
  if (!SHELL || !LEDS) import("lib/LPT_Capture_CN36_USBC_FANCY.alt.pcb.stl");
  else import("lib/LPT_Capture_CN36_USBC_FANCY.pcb.stl");
}

module screw () {
  if (FLATHEAD) %import("lib/flathead.stl");
  if (PANHEAD) %import("lib/panhead.stl");
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
      // pocket for solder legs
      translate([0,post_y,-base_thickness/2+wall_thickness])
        cube([40,7,base_thickness],center=true);

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
          // add front lip
          if (SNAP) {
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
              translate([usb_w/2-usb_h/2,0,0])
                cylinder(h=x,d=usb_h);
          // cut LEDs
          if (LEDS) translate([0,-pcb_d/2-fc-wall_thickness-fc,pcb_thickness+3]) {
            _d = led_diameter + fc;
            translate([led1_x,0,0]) rotate([-90,0,0]) cylinder(h=led_l,d=_d);
            translate([led2_x,0,0]) rotate([-90,0,0]) cylinder(h=led_l,d=_d);
          }
          // cut DIP Switch
          if (DIPSW) {
            translate([sw_x,sw_d/2-pcb_d/2-fc-wall_thickness-fc-sw_r,sw_h/2+pcb_thickness+sw_zz])
              rounded_cube(w=sw_w,d=sw_d,h=sw_h,rh=sw_r,rv=sw_r);
            translate([sw_x,sw_d2/2-pcb_d/2-fc-wall_thickness-fc-sw_r,sw_h2/2+pcb_thickness+sw_zz])
              rounded_cube(w=sw_w,d=sw_d2,h=sw_h2,rh=sw_r,rv=sw_r);
          }
        }
      }
      // replace part of lip cut away by usb
      translate([-pcb_w/2,usb_y-usb_w/2,-gap-fc]) cube([lip,usb_w,gap]);
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
      // add front lip
      if (SNAP) {
        // limitation of rounded_cube(), must draw with larger radius horizontal,
        // then rotate, depth becomes height
        t = base_thickness+pcb_thickness;
        translate([0,pcb_d/2+x+fc,t/2-base_thickness]) rotate([90,0,0]) rounded_cube(w=sw,d=t,h=wall_thickness,rh=r,rv=wall_thickness/2);
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

//bisect(x=17)
//bisect()
if (PLATE) plate();
else if (TRAY) tray();
else shell();
