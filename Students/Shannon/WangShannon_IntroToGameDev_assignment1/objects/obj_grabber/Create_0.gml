image_index = 0;
image_speed = 0;
depth = obj_revolver_weapon.depth - 10;
visible = false;

grabbing = false;

function update() {
		if (global.revolver_in_use && obj_revolver_weapon.rev_state == "loadable") {
			visible = true;
			grab();
			follow_mouse();
			manage_index();
		}
		else {
			visible = false;
		}
}

function grab() {
	if (mouse_check_button(mb_left)) {
		grabbing = true;
	}
	if (mouse_check_button_released(mb_left)) {
		grabbing = false;
	}
}

function follow_mouse() {
	x = mouse_x;
	y = mouse_y;
}

function manage_index() {
	if (grabbing) {
		image_index = lerp(image_index, 2, 0.8);
	}
	else {
		image_index = lerp(image_index, 0, 0.8);
	}
}