include <braille.scad>

lines = ["⠠⠕⠏⠢⠠⠠⠎⠉⠁⠙", "⠀⠠⠠⠗⠕⠉⠅⠎⠖"];
line_count = len(lines);
braille_height = line_count * line_spacing;
width = get_longest_line(lines);
rounding = 5;
border_thickness = 1;

module border() {
  difference() {
    linear_extrude(height=border_thickness)
      offset(r=rounding, chamfer=true)
        square([default_border + width + default_border, default_border + braille_height + default_border]);
    translate([default_border, default_border, 0])
      linear_extrude(height=border_thickness)
        offset(r=5, chamfer=true)
          square([width, braille_height]);
  }
}

difference() {
  braille_card(lines, thickness=2);
  translate([1.5, 1.5, -1])
    cylinder(r=2, h=5);
}

translate([0, 0, 2])
  border();
