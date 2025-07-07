visible = true;
persistent = true;

panel_width = 40;  
panel_height = 40;

// target w/h
final_width = 500;  
final_height = 300; 

panel_speed = 4;

panel_state = "closed";
// states: closed, closing, open, opening

function update() {
	open_close_animation();
	check_if_close();
}

function open_settings() {
	visible = true;
	panel_state = "opening";
	panel_width = 40;
	panel_height = 40;
}

function open_close_animation() {
	if (panel_state == "opening") {
	    if (abs(panel_height - final_height) > 1) {
	        panel_height = lerp(panel_height, final_height, 0.3);
	    }
	    else if (abs(panel_width - final_width) > 1) {
	        panel_width = lerp(panel_width, final_width, 0.4);
			panel_height = lerp(panel_height, final_height, 0.3);
	    }
	    else {
	        panel_width = final_width;
	        panel_height = final_height;
			obj_settings_manager.selected_index = 0;
	        panel_state = "open";
	    }
		
	}

	if (panel_state == "closing") {
		//show_debug_message(panel_width);
	    if (abs(panel_height - 50) > 1) {
	        panel_height = lerp(panel_height, 50, 0.4);
	    }
	    else if (abs(panel_width - 50) > 1) {
	        panel_width = lerp(panel_width, 50, 0.4);
			panel_height = lerp(panel_height, 50, 0.4);
	    }
	    else {
	        panel_width = 50;
	        panel_height = 50;
	        panel_state = "closed";
	        global.settings_pause = false;
	    }
	}
}

function check_if_close() {
	if (panel_state == "open" && keyboard_check_pressed(vk_escape)) {
		panel_state = "closing";
	}
	
	if (panel_state == "closed") {
		visible = false;
	}
}

