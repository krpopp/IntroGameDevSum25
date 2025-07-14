
if(in_player_hand && !face_up) {
	if(position_meeting(mouse_x, mouse_y, id) && mouse_check_button_pressed(mb_left)) {
		show_debug_message("hovering on card!");
		face_up = true;
	}
}