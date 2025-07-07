if (!global.menu_pause) {
	update();
}

if (keyboard_check_pressed(ord("1"))) {
	dealer_revolver_attack();
}