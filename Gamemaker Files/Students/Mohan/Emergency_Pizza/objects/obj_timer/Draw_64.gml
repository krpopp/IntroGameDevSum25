var minutes = floor(time_remaining / 60);
var seconds = floor(time_remaining mod 60);
var time_text = "DELIVERY TIME: " + string(minutes) + ":" + string_format(seconds, 2, 0);

draw_set_font(fnt_main); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var tx = room_width / 2;
var ty = 25;

var tw = string_width(time_text);
var th = string_height(time_text);

draw_set_color(c_black);
draw_rectangle(tx - tw / 2 - 4, ty - th / 2 - 2, tx + tw / 2 + 4, ty + th / 2 + 2, false);

if (time_remaining > 30) {
    draw_set_color(c_lime);
} else if (time_remaining > 10) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_red);
}

draw_text(tx, ty, time_text);


if (time_remaining <= 10 && time_remaining > 0) {
    draw_text(tx, ty + 30, "PIZZA COOLING FAST!");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
