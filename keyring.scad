include <braille.scad>

border = 2;
top = 5 + border;
left = border + border;
right = border;
bottom = border;

lines = [
  "⠠⠕⠏⠢⠠⠠⠎⠉⠁⠙",
  "⠀⠠⠠⠗⠕⠉⠅⠎⠖",
];
width = get_longest_line(lines);
line_count = len(lines);

module border() {
  difference() {
    linear_extrude(height=1)
      offset(r=5, chamfer=true)
        square([left + width + right, bottom + (line_count * line_spacing) + top]);
    translate([left, bottom, 0])
      linear_extrude(height=1)
        offset(r=5, chamfer=true)
          square([width, line_count * line_spacing]);
  }
}

difference() {
  braille_card(
    lines, thickness=2,
    top=top, left=left, right=right, bottom=bottom
  );
  translate([3, 3, -1])
    cylinder(r=2, h=5);
}

translate([0, 0, 2])
  border();
