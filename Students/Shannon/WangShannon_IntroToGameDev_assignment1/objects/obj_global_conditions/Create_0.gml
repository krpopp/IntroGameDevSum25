global.screen_res = "Fullscreen";
global.music_vol = 100;
global.sfx_vol = 100;

global.settings_pause = false;

window_set_fullscreen(true);


global.mouse_moving = false;
prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;

function update() {
	check_if_mouse_is_moving();
	check_fullscreen();
	
}

function check_if_mouse_is_moving() {

	if (mouse_x != prev_mouse_x || mouse_y != prev_mouse_y) {
		global.mouse_moving = true;
	} else {
		global.mouse_moving = false;
	}
	
	prev_mouse_x = mouse_x;
	prev_mouse_y = mouse_y;
		
}

function check_fullscreen() {
	if (global.screen_res == "Fullscreen" && !window_get_fullscreen()) {
		window_set_fullscreen(true);
	}
	else if (global.screen_res == "Window" && window_get_fullscreen()) {
		window_set_fullscreen(false);
	}
}



