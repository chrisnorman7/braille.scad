# braille.scad

## Description

A module which lets you write braille using unicode braille characters.

## Example

```scad
use <braille.scad>

difference() {
  braille_card(
    [
      "⠠⠕⠏⠢⠠⠠⠎⠉⠁⠙",
      "⠀⠠⠠⠗⠕⠉⠅⠎⠖",
    ], thickness=2
  );
  translate([5, 5, -1])
    cylinder(r=2, h=5);
}
```
