use <submodules/openscad_airfoils/naca.scad>

module naca_top_airfoil(chord,t,n) {
    points = naca_top_coordinates(t,n);
    scale([chord,chord,0])
        polygon(points);
}

module airfoil_using_offset() {
  linear_extrude(height = 10) {
    difference() {
      naca_top_airfoil(100, 0.30, 2000);
      offset(r = -0.1) {
        naca_top_airfoil(100, 0.30, 2000);
      }
    }
  }
}
airfoil_using_offset();