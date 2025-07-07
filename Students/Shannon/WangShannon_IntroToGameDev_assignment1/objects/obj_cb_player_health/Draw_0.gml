draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_cnb_xsmall);

var c_cyan = make_colour_rgb(7,185,204);
draw_set_color(c_white);

// box

var _x_center = 137;
var _y_start = 182;
var _dw_width = 52;
var _dw_height = 22;
var _offset = 3;

draw_sprite_stretched(spr_box_9, 0, _x_center - _dw_width/2, _y_start, _dw_width, _dw_height);

// bar juuice
draw_sprite_stretched(spr_player_health, 0, _x_center - _dw_width/2 + _offset, _y_start + _offset, 
_dw_width * health_ratio - _offset*2, _dw_height - _offset*2);


//draw_sprite_stretched(spr_box_8, 0, _x_center - _dw_width/4 - _button_width/2, _y_start + 10,
	//_x_center - _dw_width/4 + _button_width/2, _y_start + 10 + _button_height);

draw_text(_x_center, _y_start + 30, string(global.player_health) + "/" + string(global.player_health_max));