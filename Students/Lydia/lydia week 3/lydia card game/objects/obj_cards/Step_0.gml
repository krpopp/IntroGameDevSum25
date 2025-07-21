if(obj_dealer.state == STATES.PICK) {
	if(in_player_hand && _face_up) {
		if(position_meeting(mouse_x, mouse_y, id)) {
			target_y  = room_height * 0.79;
			if(mouse_check_button_pressed(mb_left)){
				if(global.player_choice == noone) {
					global.player_choice = id;
					global.player_choice.target_x = room_width / 3 + 100;
					global.player_choice.target_y = room_height * 0.57;
				}
			}
		} else {
			target_y = room_height * 0.8;
		}
	}
}