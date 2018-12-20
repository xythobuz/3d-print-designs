inner_dia = 78;
outer_dia = 89;

lower_hei = 3;
upper_hei = 5;

letter_text_top = "DrinkRobotics.de";
letter_text_bot = "UbaBot";
letter_height = 10;
letter_off = 8;
letter_space = 1.2;
letter_depth = 3;
letter_font = "orbitron.dxf";

logo_width = 50;
logo_depth = 3;
logo_path = "logo-marvin.png";
logo_width_px = 140;
logo_scale = logo_width / logo_width_px;

print = false;
stl_part_b = false;

$fn = 50;

use <Write.scad>

module logo(add_height = 1) {
    linear_extrude(height = logo_depth + add_height)
    projection(cut = true)
    scale([logo_scale, logo_scale, 1])
        translate([-logo_width_px / 2, -logo_width_px / 2, 100 - 0.5])
        surface(file=logo_path, invert=true);
}

module deckel_beauties(add_height = 1) {
    translate([0, 0, upper_hei - letter_depth / 2])
        writecircle(letter_text_top, [0,0,0], outer_dia / 2 - letter_off, h=letter_height, t=letter_depth + add_height, space=letter_space, font=letter_font);
    
    translate([0, 0, upper_hei - letter_depth / 2])
        writecircle(letter_text_bot, [0,0,0], outer_dia / 2 - letter_off, h=letter_height, t=letter_depth + add_height, space=letter_space, ccw=true, font=letter_font);
    
    translate([0, 0, upper_hei - logo_depth])
        logo(add_height);
}

module deckel(print_b = false) {
    if (print_b) {
        translate([0, 0, lower_hei])
            deckel_beauties(0);
    } else {
        color("red")
        cylinder(d = inner_dia, lower_hei);

        color("green")
        translate([0, 0, lower_hei])
        difference() {
            cylinder(d = outer_dia, upper_hei);
            deckel_beauties(1);
        }
    }
}

if (print) {
    translate([0, 0, lower_hei + upper_hei])
    rotate([0, 180, 0])
    union() {
        deckel(stl_part_b);
    }
} else {
    deckel(false);
    
    %color("white")
    deckel(true);
}
