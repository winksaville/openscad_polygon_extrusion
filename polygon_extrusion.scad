//shape = polygon(
//  points=[
//    [0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
//
//rotate([90, 0, 0])
//  shape();

module mirror_copy(v = [1, 0, 0]) {
  //children();
  mirror(v)
    children();
}

//linear_extrude(height = 10, convexity = 10, twist = 0)

module myObject() {
  polygon(
    points=[
      [0,0],[2,1],[1,2],[1,3],[3,4],[0,5]]
    );
}

//mirror([1, 0, 0])

//mirror_copy(v=[1, 0, 0]) {
//mirror(v=[1, 0, 0]) {
//    myObject();
//}

//myObject();
//mirror(v=[1, 0, 0])
 //   myObject();

//linear_extrude(height = 10, center = true, convexity = 10, twist = 0)
//translate([2, 0, 0])
//circle(r = 1);

// Points from 2032c.dat in the archive: http://m-selig.ae.illinois.edu/ads/archives/coord_seligFmt.tar.gz
// Not necessarily in the same order as in: http://m-selig.ae.illinois.edu/ads/coord/2032c.dat

use <submodules/openscad_airfoils/naca.scad>


module naca_top_airfoil(chord,t,n) {
    points = naca_top_coordinates(t,n);
    //inner_points = [ for (0:n-1] [points
    //echo(points);
    //echo("points[0]=", points[0], "points[0][1]=", points[0][1], "points[1]=", points[1], "points[1][0]", points[1][0], "points[1][1]", points[1][1]);
    scale([chord,chord,0])
        polygon(points);
}

chord=50;
module x(c=chord) {
  linear_extrude(height=10)
      naca_top_airfoil(c, 0.30, 100);
}
//x();

module minkowski_shell(t = 0.1, unit=1) {
  t2x = t * 2;
  difference() {
    // The "shell" what's left after stamping with the "die"
    render() { // Expensive operation, render to a mesh
      minkowski() {
        children();
        cube([t2x, t2x, t2x], center=true);
      }
    }
    // The "die" portion that is substracted away
    // (i.e. the original item that is the "hole in the
    //  minkowski of the child to create the shell)
    translate([0, 0, -t2x]) scale([1, 1, 1+t2x])
      children();
  }
}

// Using minkowski
thickness=0.5;
t2x=thickness * 2;
minkowski_shell(t=thickness)
  x();

// The "die" so it can be visually compared with the offset_shell of x
translate([0, 10, 0]) {
  translate([0, 0, -t2x]) scale([1, 1, 1 + t2x]) {
    x();
  }
}

// Actual airfoil
translate([0, -10, 0]) {
  x();
}

module airfoil_using_offset() {
  translate([0, -20, 0])
  linear_extrude(height = 10) {
    difference() {
      naca_top_airfoil(50, 0.30, 100);
      offset(r = -0.5) {
        naca_top_airfoil(50, 0.30, 100);
      }
    }
  }
}
airfoil_using_offset();

module twisted_box() {
  translate([0, -45, 0])
  linear_extrude(height = 30, twist = 90, slices = 60) {
    difference() {
      //offset(r = 5) {
       square(10, center = true);
      //}
      offset(r = -1) {
        square(10, center = true);
      }
    }
  }
}
twisted_box();

module naca_outline_airfoil(chord, t, n, percent) {
    outer = naca_top_coordinates(t,n);
    offset = (1 - percent) / 2;
    inner = [ for (x = [0:n-2]) [ (outer[x][0] * percent) + offset, outer[x][1] * percent ] ];
    //echo("outer: ", outer);
    //echo("inner: ", inner);
    all = concat(outer, [for (x = [n-2:-1:0]) [inner[x][0], inner[x][1]]]); 
    //echo("all:   ", all);
    scale([chord,chord,0])
      polygon(points=all);
}

//translate([2, 2, 0])
//  naca_outline_airfoil(10, 0.30, 100, 0.90);

module top(chord, thickness, fineness=20) {
  translate([0, 0, 00])
  rotate([-90, 0, -90])
  rotate_extrude(angle=180, convexity=2, $fn=fineness)
  {
    rotate([0, 0, 90])
    naca_outline_airfoil(chord=chord, t=thickness, n=fineness, percent=0.90);
    //naca_top_airfoil(chord=chord, t=thickness, n=fineness);
    //naca_airfoil(chord=chord, t=thickness, n=fineness);
  }
}

//top(chord=100, thickness=0.30, fineness=200);

//$fa = 1;
//$fs = 0.4;
//wheel_radius = 12;
//tyre_diameter = 6;
//rotate_extrude(angle=360) {
//translate([wheel_radius - tyre_diameter/2, 0, 0])
//  circle(d=tyre_diameter);
//}

//2032c_points = [[1000,1.6],[950,12.4],[900,22.9],[800,42.8],[700,61],[600,77.1],[500,90.5],[400,100.2],[300,104.8],[250,104.4],[200,101.3],[150,93.4],[100,78],[75,66.4],[50,51.3],[25,31.7],[12.5,19.3],[0,0],[12.5,-5],[25,-4.2],[50,-1],[75,2.8],[100,6.8],[150,14.5],[200,21.7],[250,28.2],[300,33.3],[400,38.5],[500,38.6],[600,35],[700,28.6],[800,20.2],[900,10],[950,4.4]];
//
//linear_extrude(height=20)
//scale([15, 15])
//translate([0,0])
//scale (0.001)
//polygon(points=2032c_points);

