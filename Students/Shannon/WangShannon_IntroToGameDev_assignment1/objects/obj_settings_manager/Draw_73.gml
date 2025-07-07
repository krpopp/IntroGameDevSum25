draw_set_font(fnt_dp_comic);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _center_x = room_width / 2;
var _start_y = room_height / 2 - 40;
var _spacing = 30;

for (var _i = 0; _i < array_length(settings_options); _i++) {
	var _text = string(settings_var_selection[_i]);
    if (_i == selected_index) {
		draw_set_color(c_white);
        draw_text(_center_x, _start_y + _i * _spacing, settings_options[_i] + ": < " + _text + " >");
    } else {
		draw_set_color(c_grey);
        draw_text(_center_x, _start_y + _i * _spacing, settings_options[_i] + ":  " + _text);
    }
}