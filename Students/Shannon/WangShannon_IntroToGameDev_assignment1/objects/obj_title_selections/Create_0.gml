
sprite_smudge = spr_smudge;

arrow_key_priority = false;

title_screen_options = ["New Game", "Load Game", "Settings", "Quit"];
selected_index = 0;

option_width = 300;
option_height = 25;

smudge_x = room_width / 2;
smudge_y = room_height / 2 + 30;
smudge_target_x = 0;
smudge_target_y = 0;
smudge_width = 200;
smudge_height = 200;

pause_title = false;

center_x = room_width / 2;
center_y = 150;

para_sensitivity = 0.03;

para_offset_x = 0;
para_offset_y = 0;

function update() {
	check_selection();
	manage_smudge();
	manage_parallax();
	arrow_key_priority_check();
}

function manage_parallax() {
	var _mousexpos = device_mouse_x_to_gui(0);
	var _mouseypos = device_mouse_y_to_gui(0);

	var _change_x = _mousexpos - center_x;
	var _change_y = _mouseypos - center_y;

	var _target_para_x = _change_x * para_sensitivity * 0.8;
	var _target_para_y = _change_y * para_sensitivity * 0.3;

	para_offset_x = lerp(para_offset_x, _target_para_x, 0.15);
	para_offset_y = lerp(para_offset_y, _target_para_y, 0.15);
	
}

function check_selection() {
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
		if (selected_index >= array_length(title_screen_options) - 1 ) {
			selected_index = array_length(title_screen_options) - 1;
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
	
	var _option_x = room_width/2 + para_offset_x - 4;
    var _option_y = room_height/2 + 30 + selected_index * 30 + para_offset_y;
	
	if (keyboard_check_pressed(vk_space) || 
		keyboard_check_pressed(vk_enter) ||
		((mouse_check_button_pressed(mb_left) && 
		(mouse_x > _option_x - option_width/2 && mouse_x < _option_x + option_width/2 &&
        mouse_y > _option_y - option_height/2 && mouse_y < _option_y + option_height/2)))) {
			
		var _selected = title_screen_options[selected_index];
		
		if (_selected == "New Game") {
			// create new game file
			
			// temp
			//room_goto(cutscene_praying);
			room_goto(visual_novel_opening);
		}
		else if (_selected == "Load Game") {
			// go to load menu (this is temp)
			room_goto(combat_opening);
		}
		else if (_selected == "Settings") {
			global.settings_pause = true;
			with (obj_settings_box) {
				open_settings();
			}
		}
		else {
			game_end()
		}
	}
}

// manage spr_smudge drawn behind selected 
function manage_smudge() {
	var _center_x = room_width / 2;
	var _start_y = room_height / 2 + 30;
	var _spacing = 30;

	smudge_target_x = _center_x;
	smudge_target_y = _start_y + selected_index * _spacing;

	var _text = title_screen_options[selected_index];
	smudge_width = string_width(_text) + 150;

	var _smoothing = 0.2;
	smudge_x = lerp(smudge_x, smudge_target_x, _smoothing);
	smudge_y = lerp(smudge_y, smudge_target_y, _smoothing);
	
	
}

function arrow_key_priority_check() {
	if (global.mouse_moving) {
		arrow_key_priority = false;
	} else {
		arrow_key_priority = true;
	}
}



