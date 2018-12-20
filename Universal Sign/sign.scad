
// ----------------------------------------------------

/*
sign_width = 86;
sign_length = 20;
text_str = "xythobuz.de";
text_font = "Liberation Sans:style=Bold";
text_size_off = 4;
text_double = false;
sign_base_height = 3;
sign_border_height = 2;
sign_border_width = 3;
fillet = 0.5;
*/

// ----------------------------------------------------


sign_width = 105;
sign_length = 22;
text_str = "xythobuz.de";
text_str2 = "Thomas Buck";
text_font = "Liberation Sans:style=Bold";
text_size_off = 5;
text_double = true;
text_double_off = 11;
sign_base_height = 3;
sign_border_height = 4;
sign_border_width = 3;
fillet = 1.0;


// ----------------------------------------------------

/*
sign_width = 65;
sign_length = 20;
text_str = "Toolbox";
text_font = "Liberation Sans:style=Bold";
text_size_off = 3;
text_double = false;
sign_base_height = 3;
sign_border_height = 2;
sign_border_width = 3;
fillet = 0.5;
*/

// ----------------------------------------------------

/*
sign_width = 80;
sign_length = 20;
text_str = "Toolbox";
text_str2 = "Bodensee";
text_font = "Liberation Sans:style=Bold";
text_size_off = 3;
text_double = true;
text_double_off = 13;
sign_base_height = 3;
sign_border_height = 2;
sign_border_width = 3;
fillet = 0.5;
*/

// ----------------------------------------------------

draw_bottom = true;
draw_walls = true;
draw_text = false;

color_base = "grey";
color_walls = "grey";
color_text = "white";

// ----------------------------------------------------

text_size = sign_length - (2 * sign_border_width) - text_size_off;

include <rounded.scad>

// ----------------------------------------------------

if (draw_bottom) {
    if (text_double) {
        // base
        color(color_base)
        rounded_cube(sign_width, sign_length + text_double_off, sign_base_height, fillet, fillet, fillet, false, true, true);
    } else {
        // base
        color(color_base)
        rounded_cube(sign_width, sign_length, sign_base_height, fillet, fillet, fillet, false, true, true);
    }
}

if (draw_walls) {
    // top walls
    color(color_walls)
    translate([0, 0, sign_base_height])
    difference() {
        union() {
            rounded_cube(sign_width, sign_border_width, sign_border_height, fillet, fillet, fillet, false, true, false);
            
            if (text_double) {
                rounded_cube(sign_border_width, sign_length + text_double_off, sign_border_height, fillet, fillet, fillet, false, true, false);
                
                translate([sign_width - sign_border_width, 0, 0])
                rounded_cube(sign_border_width, sign_length + text_double_off, sign_border_height, fillet, fillet, fillet, false, true, false);
                
                translate([0, sign_length + text_double_off - sign_border_width, 0])
                rounded_cube(sign_width, sign_border_width, sign_border_height, fillet, fillet, fillet, false, true, false);
            } else {
                rounded_cube(sign_border_width, sign_length, sign_border_height, fillet, fillet, fillet, false, true, false);
                
                translate([sign_width - sign_border_width, 0, 0])
                rounded_cube(sign_border_width, sign_length, sign_border_height, fillet, fillet, fillet, false, true, false);
                
                translate([0, sign_length - sign_border_width, 0])
                rounded_cube(sign_width, sign_border_width, sign_border_height, fillet, fillet, fillet, false, true, false);
            }
        }
    }
}

if (draw_text) {
    if (text_double) {
        // text
        color(color_text)
        translate([sign_width / 2, sign_length / 2 + text_double_off, sign_base_height])
            linear_extrude(height = sign_border_height)
            text(text = text_str, font = text_font, size = text_size, valign = "center", halign = "center");
        
        color(color_text)
        translate([sign_width / 2, sign_length / 2, sign_base_height])
            linear_extrude(height = sign_border_height)
            text(text = text_str2, font = text_font, size = text_size, valign = "center", halign = "center");
    } else {
        // text
        color(color_text)
        translate([sign_width / 2, sign_length / 2, sign_base_height])
            linear_extrude(height = sign_border_height)
            text(text = text_str, font = text_font, size = text_size, valign = "center", halign = "center");
    }
}
