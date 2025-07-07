draw_set_font(fnt_dp_comic);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_sprite_ext(spr_smudge, 0, smudge_x + para_offset_x - 4, smudge_y + para_offset_y, smudge_width / sprite_get_width(spr_smudge), 
    smudge_height / sprite_get_height(spr_smudge), 0, c_white, 1);

var _center_x = room_width / 2;
var _start_y = room_height / 2 + 30;
var _spacing = 30;

for (var _i = 0; _i < array_length(title_screen_options); _i++) {
	var _option_x = _center_x + para_offset_x - 4;
    var _option_y = _start_y + _i * _spacing + para_offset_y;
	
	if (mouse_x > _option_x - option_width/2 && mouse_x < _option_x + option_width/2 &&
        mouse_y > _option_y - option_height/2 && mouse_y < _option_y + option_height/2
		&& !arrow_key_priority) {
        selected_index = _i;
    }
	
    if (_i == selected_index) {
		draw_set_color(c_white);
        draw_text(_center_x + para_offset_x - 4, _start_y + _i * _spacing + para_offset_y, title_screen_options[_i]);
    } else {
		draw_set_color(c_grey);
        draw_text(_center_x + para_offset_x - 4, _start_y + _i * _spacing + para_offset_y, title_screen_options[_i]);
    }
}