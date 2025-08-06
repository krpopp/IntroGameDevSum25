function update() {
	check_if_space_pressed();
}

function check_if_space_pressed() {
	if (keyboard_check_pressed(vk_space)) {
		room_goto(rm_outside);
	}
}