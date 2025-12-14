// b.kenyon.w@gmail.com - handy box
// fillets and handy things made from fillets

/*
   screw_post(h=10,od=6,id=3,fr=2,ch=0,o=0)

     cylindrical screw post with filleted base

     h = height
     od = main cylinder OD
     id = screw hole ID - default no hole
     fr = base fillet radius
     ch = screw hole chamfer depth - default no chamfer
     o = fillet ID shrink offset - usually unset

   rounded_cube(w=60,d=40,h=20,rh=2,rv=1,t=0)

     draws a cube with rounded corners

     w = width
     d = depth
     h = height
     rh = horizontal radius
     rv = vertical radius
     t = wall thickness - if set, makes a hollow box

   fillet_polar(o=false,R=1,r=1,A=90,a=90,as=0)

     creates both internal and external radial fillets
     used to create screw_post() and rounded_cube()
  
     o = outside true/false - default false (inside/concave)
     R = big radius
     r = small radius
     A = big angle
     a = small angle
     as = small angle start angle

   fillet_linear(o=false,l=1,r=1,a=90)
   
     o = outside - true/false - default false (inside/concave)
     l = length
     r = radius
     a = angle

*/

//$fs = 0.5;
//$fa = 1;
//$fn = 96;
//$fn = 72;
//$fn = 36;
//$fn = 12;

// examples:
//translate([60,0,0]) screw_post(h=10,od=6,id=3,fr=2,ch=0.6);
//difference() { rounded_cube(w=70,d=55,h=25,rh=3,rv=1,t=2); translate([0,-40,0]) cube([40,40,20]); }
//difference() { rounded_cube(w=70,d=55,h=25,rh=3,rv=1); translate([0,-40,0]) cube([40,40,20]); }
//fillet_linear(l=40);
//fillet_polar(R=2,r=1);

module screw_post(h=10,od=6,id=0,fr=2,o=0,ch=0) {
 x = (o) ? o : ($fn>=3) ? 0 : 0.025;
 difference() {
  union(){
   translate([0,0,h/2]) cylinder(h=h,d=od,center=true);
   translate([0,0,fr+x]) fillet_polar(R=-od/2+x,r=fr+x,A=360,as=90);
  }
  if(id>0) {
   translate([0,0,h/2]) cylinder(h=h+0.1,d=id,center=true);
   if(ch) translate([0,0,h-id/2-ch]) cylinder(h=od/2,d1=0,d2=od);
  }
 }
}

module rounded_cube(w=60,d=40,h=20,rh=2,rv=1,t=0) {
  _w=t+w+t;
  _d=t+d+t;
  _h=t+h+t;
  if (rh==0&&rv==0) {
    // plain cube
    if(t) difference() {
      cube([_w,_d,_h],center=true);
      cube([w,d,h],center=true);
    }
    else cube([w,d,h],center=true);
  }
  else if (rv==0) {
    // rounded plate
    if(t) difference() {
      _hbrp(w=_w,d=_d,h=_h,r=rh+t);
      _hbrp(w=w,d=d,h=h,r=rh);
    }
    else _hbrp(w=w,d=d,h=h,r=rh);
  } else {
    // rounded cube
    if(t) difference() {
      _hbrc(w=_w,d=_d,h=_h,rh=rh+t,rv=rv+t);
      _hbrc(w=w,d=d,h=h,rh=rh,rv=rv);
    }
  else _hbrc(w=w,d=d,h=h,rh=rh,rv=rv);
  }
}

module _hbrc(w=60,d=40,h=20,rh=2,rv=1) { // rounded cube
 hull() {
  mirror_copy([0,0,1])
   mirror_copy([0,1,0])
    mirror_copy([1,0,0])
     translate([w/2-rh,d/2-rh,h/2-rv])
      fillet_polar(o=true,R=rh,r=rv);
 }
}

module _hbrp(w=60,d=40,h=20,r=2) { // rounded plate
 hull() {
   mirror_copy([0,1,0])
    mirror_copy([1,0,0])
     translate([w/2-r,d/2-r,-h/2])
      fillet_linear(o=true,l=h,r=r,a=90);
 }
}

module fillet_polar(o=false,R=1,r=1,A=90,a=90,as=0) {
 rotate_extrude(angle=A)
  translate([R-r,0,0])
   rotate([0,0,-as])
    _hbf(o,r,a);
}

module fillet_linear(o=false,l=1,r=1,a=90) {
 linear_extrude(height=l,center=false)
  _hbf(o,r,a);
}

module _hbf(o=false,r=1,a=90) { // 2d fillet
 if(o) intersection() { circle(r=r); _hbw(r=r,a=a); }
 else difference() { _hbw(r=r,a=a); circle(r=r); }
}

module _hbw (r=1,a=90) { // 2d wedge polygon
  polygon([ [0,0], [0,r], [r*tan(a/2),r], [r*sin(a),r*cos(a)] ]);
}

module mirror_copy(v) {
 children();
 mirror(v) children();
}

module xy_array(xo=10,xc=4,yo=10,yc=2,center=false) {
 xe = (xc-1)*xo;
 ye = (yc-1)*yo;
 tx = center ? -xe/2 : 0;
 ty = center ? -ye/2 : 0;
 translate([tx,ty,0])
 for (i=[0:xo:xe]) {
  for (j=[0:yo:ye]) {
    translate([i,j,0])
     children();
  }
 }
}
