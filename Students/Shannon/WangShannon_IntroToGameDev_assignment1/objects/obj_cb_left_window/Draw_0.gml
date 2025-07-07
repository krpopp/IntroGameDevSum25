draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_cnb_xsmall);

var c_burgundy = make_colour_rgb(204,37,81);
draw_set_color(c_white);

// box

var _x_center = 138;
var _y_start = 31;
var _dw_width = 128;
var _dw_height = 149;

draw_sprite_stretched(spr_box_10, 0, _x_center - _dw_width/2, 31, _dw_width, _dw_height);

var _button_width = 40;
var _button_height = 15;

//draw_sprite_stretched(spr_box_8, 0, _x_center - _dw_width/4 - _button_width/2, _y_start + 10,
	//_x_center - _dw_width/4 + _button_width/2, _y_start + 10 + _button_height);

draw_text(_x_center, _y_start + 20, bleeding_status);