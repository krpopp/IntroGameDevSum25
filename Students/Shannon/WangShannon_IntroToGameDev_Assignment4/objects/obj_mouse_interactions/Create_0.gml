global.cult_invite = false;
depth = -1000;
image_index = 0;
image_speed = 0;

function update() {
	detect_mouse();
	go_to_mouse();
}

function detect_mouse() {
	if (global.dialogue_open1 || global.dialogue_open3) {
		image_alpha = 0;
	}
	else if (global.dialogue_open2 && !global.chocolate_bought) {
		image_index = 1;
		if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 350, 250, 400, 310)) {
			image_alpha = 1;
		}
		else {
			image_alpha = 0.5;
		}
	}
	else if (point_in_rectangle(mouse_x, mouse_y, obj_npc1.x - 6, obj_npc1.y - 30, obj_npc1.x + 6, obj_npc1.y + 30)) {
		image_alpha = 1;
		image_index = 0;
		
		if (mouse_check_button_pressed(mb_left)) {
			if (obj_dialogue.in_range1) {
				audio_play_sound(snd_talk, 0, false);
				global.dialogue_open1 = true;
				global.cult_invite = true;
			}
			else {
				// errrr
			}
		}
	}
	else if (point_in_rectangle(mouse_x, mouse_y, obj_npc3.x - 6, obj_npc3.y - 30, obj_npc3.x + 10, obj_npc3.y + 30)) {
		image_alpha = 1;
		
		if (mouse_check_button_pressed(mb_left)) {
			if (obj_dialogue.in_range3) {
				audio_play_sound(snd_talk, 0, false);
				global.dialogue_open3 = true;
				global.cult_invite = true;
			}
			else {
				// errrr
			}
		}
	}
	else {
		image_index = 0;
		image_alpha = 0.5;
	}
	
}

function go_to_mouse() {
	x = mouse_x;
	y = mouse_y;
}