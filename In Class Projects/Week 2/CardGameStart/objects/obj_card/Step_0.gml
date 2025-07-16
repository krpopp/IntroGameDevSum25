
if(in_player_hand && !face_up) {
	if(position_meeting(mouse_x, mouse_y, id) && mouse_check_button_pressed(mb_left)) {
		if(global.player_choice_one == noone) {
			global.player_choice_one = id;
			face_up = true;
		} else {
			if(global.player_choice_two == noone) {
				global.player_choice_two = id;
				face_up = true;
			}
		}
	}
}