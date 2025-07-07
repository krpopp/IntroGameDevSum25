
draw_set_font(fnt_dp_comic);
	
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _center_x = room_width / 2;
var _start_y = room_height / 2 - 40;
var _spacing = 40;

for (var _i = 0; _i < array_length(menu_options); _i++) {
	var _text = string(menu_options[_i]);
    if (_i == selected_index) {
		draw_set_color(c_white);
		draw_sprite_stretched(spr_ui_selector, 0, _center_x - (selector_width / 2), 
		selector_y, selector_width, selector_height);
        draw_text(_center_x, _start_y + _i * _spacing, menu_options[_i]);
    } else {
		draw_set_color(c_grey);
        draw_text(_center_x, _start_y + _i * _spacing, menu_options[_i]);
    }
}