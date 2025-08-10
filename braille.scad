// Braille dot settings
dot_radius = 0.75; // 1.5 mm diameter
dot_height = 0.6; // Height of the dot
dot_spacing_x = 2.5; // Distance between columns in a cell
dot_spacing_y = 2.5; // Distance between rows in a cell
cell_spacing = 6; // Distance between Braille characters
line_spacing = 10; // Space between lines.

// The default border for `braille_card`.
default_border = 2;

// Returns all the bits from `string`.
function getBitsFromString(string) =
  [
    for (c = string) getBitsFromCharacter(c),
  ];

/*
Get the bits from a single character.

Each bit in the resulting vector is either 1 (the dot should be raised) or 0 (the dot should be ignored).

If the given `character` is not a braille character (less than 10240), it returns a vector of six zeros. This is particularly useful for the space character (32).
*/
function getBitsFromCharacter(character) =
  getBits(ord(character));

/*
Get the bits from a single char code.

If you wish to get the bits from a character, use `getBitsFromCharacter` which converts the given character then calls this function..
*/
function getBits(charCode) =
  charCode <= 10240 ? [0, 0, 0, 0, 0, 0]
  : [
    (charCode % 2) != 0 ? 1 : 0, // Dot 1
    (floor(charCode / 2) % 2) != 0 ? 1 : 0, // Dot 2
    (floor(charCode / 4) % 2) != 0 ? 1 : 0, // Dot 3
    (floor(charCode / 8) % 2) != 0 ? 1 : 0, // Dot 4
    (floor(charCode / 16) % 2) != 0 ? 1 : 0, // Dot 5
    (floor(charCode / 32) % 2) != 0 ? 1 : 0, // Dot 6
  ];

// Generate a Braille dot
module braille_dot() {
  cylinder(h=dot_height, r=dot_radius, $fn=16);
}

/*
Draw a Braille cell.

The `dots` argument must be a list of integers, like that returned by `getBitsFromCharacter`.
*/
module braille_cell(character) {
  dots = getBitsFromCharacter(character);
  for (i = [0:5]) {
    if (dots[i]) {
      // Column: left (0) or right (1)
      col = i == 3 || i == 4 || i == 5 ? 1 : 0;
      row = [0, 1, 2, 0, 1, 2][i];
      v = [(col * dot_spacing_x) + (dot_spacing_x / 2), ( -row * dot_spacing_y) - (dot_spacing_y / 2), 0];
      translate(v)
        braille_dot();
    }
  }
}

// Print a line of braille text.
module braille_line(string) {
  for (i = [0:len(string) - 1]) {
    x = i * cell_spacing;
    y = dot_spacing_y * 4;
    z = 0;
    translate([x, y, z])
      braille_cell(string[i]);
  }
}

// Get how much horizontal space would be taken up by `characters`.
function get_width(characters) =
  len(characters) * cell_spacing;

// Get the dimensions of a braille `string`.
//
// Returns `[width, height]`.
function get_dimensions(string) =
  [
    get_width(string),
    line_spacing,
  ];

// Get the longest line in `lines`.
function get_longest_line(lines) =
  max(
    [
      for (line = lines) get_width(getBitsFromString(line)),
    ]
  );

// A braille card.
module braille_card(lines, thickness = 1, rounding = 5, top = default_border, left = default_border, right = default_border, bottom = default_border) {
  line_count = len(lines);
  echo("Line count: ", line_count);
  width = get_longest_line(lines);
  echo("Width: ", left + width + right);
  echo("Height: ", bottom + (line_count * line_spacing) + top);
  linear_extrude(height=thickness)
    offset(r=rounding)
      square([left + width + right, bottom + (line_count * line_spacing) + top]);
  reversed_lines = [
    for (i = [line_count - 1:-1:0]) lines[i],
  ];
  for (i = [0:line_count - 1]) {
    v = [left, bottom + (i * line_spacing), thickness];
    echo("Line ", i + 1, ": ", v);
    translate(v)
      braille_line(reversed_lines[i]);
  }
}
