if(obj_dealer.state == STATES.PICK) {
	if(in_player_hand && _face_up) {
		if(position_meeting(mouse_x, mouse_y, id)) {
			target_y  = room_height * 0.79;
			if(mouse_check_button_pressed(mb_left)){
				if(global.player_choice == noone) {
					global.player_choice = id;
					global.player_choice.target_x = room_width / 3 + 100;
					//global.player_choice.target_y = room_height * 0.57;
					global.player_choice.target_y = 461;
				}
			}
		} else {
			target_y = room_height * 0.8;
		}
	}
}

if(abs(x - target_x) > 1) {
	x = lerp(x, target_x, 0.1);
} else {
	x = target_x;
}

if(abs(y - target_y) > 1) {
	y = lerp(y, target_y, 0.1);
} else {
	y = target_y;
}

if(_face_up) {
	sprite_index = spr_cards;
	image_index = face_index;
} else {
	sprite_index = spr_cards;
	image_index = 3;
}
