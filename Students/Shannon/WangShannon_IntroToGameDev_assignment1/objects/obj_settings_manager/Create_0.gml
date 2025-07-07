visible = false;
persistent = true;
settings_options = ["Music", "SFX", "Resolution"];

selected_index = 0;

global.screen_res = "Fullscreen";
global.music_vol = 100;
global.sfx_vol = 100;
settings_var_selection = [global.music_vol, global.sfx_vol, global.screen_res];

in_view = false;

screen_res_timer = 0;

function update() {
	determine_in_view();
	if (in_view) {
		check_selection();
		adjust_options();
	}
}

function determine_in_view() {
	if (obj_settings_box.panel_state == "open") {
		visible = true;
		in_view = true;
	}
	else {
		visible = false;
		in_view = false;
	}
}

function check_selection() {
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
		if (selected_index >= array_length(settings_options) - 1 ) {
			selected_index = array_length(settings_options) - 1;
			// nothing, add sfx
			return;
		}
		else {
			selected_index++;
			return;
		}
	}
	
	if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
		if (selected_index <= 0) {
			selected_index = 0;
			// nothing, add sfx
			return;
		}
		else {
			selected_index--;
			return;
		}
	}
}

function adjust_options() {
	settings_var_selection = [global.music_vol, global.sfx_vol, global.screen_res];
	var _selected = settings_options[selected_index];
	
	if (screen_res_timer > 0) {
			screen_res_timer--;
	}
		
	if (_selected == "Music") {
		if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
			global.music_vol -= 0.1;
			global.music_vol = floor(clamp(global.music_vol, 0, 100));
			return;
		}
		else if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
			global.music_vol += 0.1;
			global.music_vol = ceil(clamp(global.music_vol, 0, 100));
			return;
		}
	}
	else if (_selected == "SFX") {
		if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
			global.sfx_vol -= 0.1;
			global.sfx_vol = floor(clamp(global.sfx_vol, 0, 100));
			return;
		}
		else if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
			global.sfx_vol += 0.1;
			global.sfx_vol = ceil(clamp(global.sfx_vol, 0, 100));
			return;
		}
	}
	else if (_selected == "Resolution") {
		if ((keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))
		|| keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))
		|| keyboard_check_pressed(vk_space)) && screen_res_timer == 0) {
			
			if (global.screen_res == "Window") {
				global.screen_res = "Fullscreen";
				screen_res_timer = 15;
				return;
			}
			else {
				global.screen_res = "Window";
				screen_res_timer = 15;
				return;
			}
		}
	}
}

