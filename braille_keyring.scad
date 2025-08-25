include <braille.scad>

default_thickness = 2;
default_border_thickness = 1;
default_rounding = 5;
default_keyring_radius = 2;
default_keyring_offset = 3;

module border(interior, thickness = default_border_thickness, rounding = default_rounding, top = default_border, left = default_border, right = default_border, bottom = default_border) {
  echo("Thickness: ", thickness);
  echo("Rounding: ", rounding);
  echo("Interior: ", interior);
  difference() {
    linear_extrude(height=thickness)
      offset(r=rounding)
        square([left + interior.x + right, bottom + interior.y + top]);
    translate([left, bottom, 0])
      linear_extrude(height=thickness)
        offset(r=rounding)
          square([interior.x, interior.y]);
  }
}

module keyring(lines, thickness = default_thickness, border_thickness = default_border_thickness, rounding = default_rounding, top = default_border, left = default_border, right = default_border, bottom = default_border) {
  line_count = len(lines);
  width = get_longest_line(lines);
  braille_height = line_count * line_spacing;
  braille_card(lines=lines, top=top, bottom=bottom, left=left, right=right, thickness=thickness);
  translate([0, 0, thickness])
    border(interior=[width, braille_height], thickness=border_thickness, rounding=rounding, top=top, left=left, right=right, bottom=bottom);
}

module main(lines, thickness = default_thickness, border_thickness = default_border_thickness, rounding = default_rounding, top = default_border, left = default_border, right = default_border, bottom = default_border, keyring_radius = default_keyring_radius, keyring_offset = default_keyring_offset) {
  width = get_longest_line(lines);
  line_count = len(lines);
  braille_height = line_count * line_spacing;
  y = bottom + braille_height + top;
  difference() {
    keyring(lines, thickness=thickness, border_thickness=border_thickness, rounding=rounding, top=top, left=left, right=right, bottom=bottom);
    v = [keyring_offset, y - keyring_offset, -1];
    echo("Keyring hole starts at: ", v);
    echo("Keyring radius: ", keyring_radius);
    translate(v)
      cylinder(r=keyring_radius, h=thickness + border_thickness + 2);
  }
}

module mass_produce(lines, thickness = default_thickness, border_thickness = default_border_thickness, rounding = default_rounding, top = default_border, left = default_border, right = default_border, bottom = default_border, keyring_radius = default_keyring_radius, keyring_offset = default_keyring_offset, bed_x = 256, bed_y = 256) {
  module card() {
    main(lines, thickness=thickness, border_thickness=border_thickness, rounding=rounding, top=top, left=left, right=right, bottom=bottom, keyring_radius=keyring_radius, keyring_offset=keyring_offset);
  }
  max_x = left + get_longest_line(lines) + right;
  max_y = bottom + (line_spacing * len(lines)) + top;
  echo("Card width: ", max_x);
  echo("Card height: ", max_y);
  cards_x = [
    for (x = [0:max_x + 1:bed_x - max_x]) x,
  ];
  cards_y = [
    for (y = [0:max_y + 1:bed_y - max_y]) y,
  ];
  cards_coordinates = [
    for (x = cards_x, y = cards_y) [x, y],
  ];
  echo("Total cards printed: ", len(cards_coordinates));
  echo("Cards coordinates: ", cards_coordinates);
  for (v = cards_coordinates) {
    echo("Placing card: ", v);
    translate([v.x, v.y, 0])
      card();
  }
}
