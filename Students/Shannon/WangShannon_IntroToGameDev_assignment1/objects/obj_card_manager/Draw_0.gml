draw_set_font(fnt_jupiter_crash_xsmall);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

var c_burgundy = make_colour_rgb(204,37,81);
var _box_width = 100;
var _box_height = 60;
var _x_center = room_width/2;
var _y_center = room_height/2;


for (var _i = 0; _i < ds_list_size(global.card_hand_list); _i++) {
	var _card = ds_list_find_value(global.card_hand_list, _i);
	
	var _text_width = string_width(_card.card_type);
	
	if (instance_exists(_card)) {
		if (_card.mouse_hover && global.card_interactable) {
			draw_sprite_stretched(spr_box_2, 0, _card.hand_x - _text_width/2 - 10, _card.hand_y + 20, _text_width + 20, 26);
			draw_text(_card.hand_x, _card.hand_y + 33, _card.card_type);
			
			draw_sprite_stretched(spr_box_2, 0, _card.hand_x + _text_width/2 + 5, _card.hand_y, _box_width, _box_height);
			draw_set_halign(fa_left);
			draw_set_font(fnt_cnb_xsmall);
			draw_text(_card.hand_x + _text_width/2 + 13, _card.hand_y + 15, _card.card_desc);
		}
	}
	
}
