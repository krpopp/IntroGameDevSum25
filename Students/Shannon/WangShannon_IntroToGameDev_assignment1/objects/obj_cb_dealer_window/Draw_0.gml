draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fnt_dp_comic_small);
var c_burgundy = make_colour_rgb(204,37,81);
var c_dark_burgundy = make_colour_rgb(125,19,41);


var _x_center = room_width/2;
var _y_center = room_height/2;
var _dw_width = 230;
var _dw_height = 150;

draw_sprite_stretched(spr_box_4, 0, _x_center - _dw_width/2, 30, _dw_width, _dw_height);
draw_sprite(spr_bartender_cb_bg, 0, _x_center - _dw_width/2 + 3, 33);

draw_text(_x_center, 7, "ELORA, THE COERCED");

// health bar

var _delay_bar_w = _dw_width * delayed_health_bar_w - 2;
var _hp_bar_w = _dw_width * health_bar_w - 2;

_delay_bar_w = clamp(_delay_bar_w, 0, _dw_width);
_hp_bar_w = clamp(_hp_bar_w, 0, _dw_width);

if (delayed_health_bar_w > 0) {
	draw_set_color(c_dark_burgundy);
	draw_rectangle(_x_center - _dw_width/2, 25, (_x_center - _dw_width/2) + _delay_bar_w, 29, false);
}
if (health_bar_w > 0) {
	draw_set_color(c_burgundy);
	draw_rectangle(_x_center - _dw_width/2, 25, (_x_center - _dw_width/2) + _hp_bar_w, 29, false);
}

draw_set_color(c_white);
draw_sprite_stretched(spr_box_4, 0, _x_center - _dw_width/2, 24, _dw_width, 7);

draw_set_font(fnt_cnb_xsmall);
//draw_text(_x_center, 25, string(dealer_hp) + "/" + string(dealer_max_hp));

//draw_set_halign(fa_left);


with (obj_cb_character) {
	breathing_effect();
}

draw_set_color(c_black);
draw_rectangle(_x_center - _dw_width/2, 177, 440, 500, false);
draw_set_color(c_white);
draw_rectangle(206, 176, 434, 176, false);

if (global.card_interactable && !global.dealer_defeated_bloodshed) {
	draw_set_color(c_burgundy);
	draw_set_font(fnt_dp_comic);
	draw_text(_x_center, _y_center + 20, "YOUR TURN.");
}