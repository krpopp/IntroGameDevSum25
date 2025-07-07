selected_index = 0;
menu_options = ["Continue", "Options", "Main Menu"];

selector_x = 270;
selector_y = 140;
selector_width = 175;
selector_height = 40;
selector_target_y = 0;

function manage_selector() {
	var _center_x = room_width / 2;
	var _start_y = room_height / 2 - 40;
	var _spacing = 40;

	selector_target_y = _start_y + selected_index * _spacing - 20;

	var _text = menu_options[selected_index];

	var _smoothing = 0.2;
	selector_y = lerp(selector_y, selector_target_y, _smoothing);
}

function update() {
	control_visibility();
	if (!global.settings_pause) {
		if (obj_menu_box.menu_state == "open") {
			navigate_menu();
			manage_selector();
		}
	}
}


function control_visibility() {
	if (obj_menu_box.menu_state == "open") {
		visible = true;
	}
	else {
		visible = false;
	}
}

function navigate_menu() {
	if (obj_menu_box.menu_state == "open") {
		if ((keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down))
		&& selected_index != array_length(menu_options) - 1) {
			selected_index++;
			return;
		}
		if ((keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up))
		&& selected_index != 0) {
			selected_index--;
			return;
		}
		if (keyboard_check_pressed(vk_space)
			|| keyboard_check_pressed(vk_enter)) {
			var selected = menu_options[selected_index];
			
			if (selected == "Continue") {
				obj_menu_box.menu_state = "closing";
			}
			else if (selected == "Options") {
				global.settings_pause = true;
				with (obj_settings_box) {
					obj_settings_manager.selected_index = 0;
					open_settings();
				}
			}
			else if (selected == "Main Menu") {
				obj_menu_box.menu_state = "closed";
				room_goto(title_screen);
			}
		}
	}
}

