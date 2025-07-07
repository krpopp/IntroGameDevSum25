randomize();
image_index = 0;
image_speed = 0;

fall_speed = random_range(0.5, 0.8);
rotation_speed = random_range(-1.2, 1.2);
scale = random_range(0.3, 0.5);
card_alpha = random_range(0.4, 0.7);

x = random_range(0, room_width);
y = -sprite_height * scale;

center_x = room_width / 2;
center_y = 150;

para_sensitivity = scale / 2;

para_offset_x = 0;
para_offset_y = 0;

function update() {
	rain_card();
	manage_parallax();
}

function rain_card() {
	if (!global.settings_pause) {
		y += fall_speed;
		image_angle += rotation_speed;

		if (y > room_height + sprite_height * scale) {
		    instance_destroy();
		}
	}
}

function manage_parallax() {
	if (!global.settings_pause) {
		var _mousexpos = device_mouse_x_to_gui(0);
		var _mouseypos = device_mouse_y_to_gui(0);

		var _change_x = _mousexpos - center_x;
		var _change_y = _mouseypos - center_y;

		var _target_para_x = _change_x * para_sensitivity;
		var _target_para_y = _change_y * para_sensitivity;

		para_offset_x = lerp(para_offset_x, _target_para_x, 0.15);
		para_offset_y = lerp(para_offset_y, _target_para_y, 0.15);
	}
	
}