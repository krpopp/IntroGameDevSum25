// DRAW GUI EVENT
// Timer display
var minutes = floor(time_remaining / 60);
var seconds = floor(time_remaining mod 60);

// Format time as MM:SS
var time_text = string(minutes) + ":" + string_format(seconds, 2, 0);
if (seconds < 10) {
    time_text = string(minutes) + ":0" + string(seconds);
}

// Draw timer background
draw_set_color(c_black);
draw_rectangle(room_width/2 - 60, 10, room_width/2 + 60, 40, false);

// Change color based on time remaining
if (time_remaining > 30) {
    draw_set_color(c_green);
} else if (time_remaining > 10) {
    draw_set_color(c_yellow);
} else {
    draw_set_color(c_red);
}

// Draw timer text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(-1); // or your custom font
draw_text(room_width/2, 25, "DELIVERY TIME: " + time_text);

// Warning text for low time
if (time_remaining <= 10 && time_remaining > 0) {
    draw_set_color(c_red);
    draw_text(room_width/2, 50, "PIZZA COOLING FAST!");
}

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);