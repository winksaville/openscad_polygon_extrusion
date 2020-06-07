module twisted_box() {
  translate([0, 0, 0])
  linear_extrude(height = 10, twist = 90, slices = 200) {
    difference() {
      square(10, center = true);
      // "Die" to remove the inside
      offset(r = -0.5) {
        square(10, center = true);
      }
    }
  }
}

twisted_box();