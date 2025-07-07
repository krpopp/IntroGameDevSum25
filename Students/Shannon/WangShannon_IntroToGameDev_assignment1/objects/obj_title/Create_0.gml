x = (room_width - sprite_width) / 2;
y = 25;

center_x = room_width / 2 - 10;
center_y = 100;

title_sensitivity = 0.03;
bs_sensitivity = 0.02;

title_offset_x = 0;
title_offset_y = 0;
bs_offset_x = 0;
bs_offset_y = 0;

function update() {
	manage_parallax();
}

function manage_parallax() {
	var _mousexpos = device_mouse_x_to_gui(0);
	var _mouseypos = device_mouse_y_to_gui(0);

	var _change_x = _mousexpos - center_x;
	var _change_y = _mouseypos - center_y;

	var _target_title_x = _change_x * title_sensitivity;
	var _target_title_y = _change_y * title_sensitivity;
	var _target_bs_x = _change_x * bs_sensitivity;
	var _target_bs_y = _change_y * bs_sensitivity;

	title_offset_x = lerp(title_offset_x, _target_title_x, 0.1);
	title_offset_y = lerp(title_offset_y, _target_title_y, 0.1);
	bs_offset_x = lerp(bs_offset_x, _target_bs_x, 0.1);
	bs_offset_y = lerp(bs_offset_y, _target_bs_y, 0.1);
	
}

