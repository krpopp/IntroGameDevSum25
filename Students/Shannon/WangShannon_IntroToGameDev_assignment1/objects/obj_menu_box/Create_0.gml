menu_state = "closed";
global.menu_pause = false;

visible = false;

function update() {
	open_close_menu();
	pause_game_if_open();
}

function open_close_menu() {
	if (menu_state == "closed" && keyboard_check_pressed(vk_escape)) {
		visible = true;
		menu_state = "opening";
		return;
	}
	else if (menu_state == "open") {
		if (keyboard_check_pressed(vk_escape)) {
			obj_menu_manager.selected_index = 0;
			menu_state = "closing";
			//show_debug_message("closing");
			return;
		}
	}
	else if (menu_state == "opening") {
		
		if (visible) { //replace this later
			// open animation
			menu_state = "open";
			return;
		}
		else {
			menu_state = "open";
			return;
		}
	}
	else if (menu_state == "closing") {
		// close animaiton
		visible = false;
		menu_state = "closed";
	}
}

function pause_game_if_open() {
	if (menu_state == "opening" || menu_state == "open" || menu_state == "closing") {
		global.menu_pause = true;
	}
	else {
		global.menu_pause = false;
	}
}

