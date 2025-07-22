//if is picking state
if(obj_dealer.state == STATES.PICK) {
	//if has already in player hands and is not facing up
	if(in_bot_hand && !face_up) {
		//hovering animation
		if(position_meeting(mouse_x, mouse_y, id)) {
			target_y  = room_height * 0.65;
			
			//if click after hover
			if(mouse_check_button_pressed(mb_left)){
				//global.player is initially null,
				//if global.player is null when click
				if(global.player_choice_two == noone) {
					//fill global.player with the sprite id
					global.player_choice_two = id;
					
					//then is face_up
					face_up = true;
					target_y  = room_height * 0.5;
					target_x = room_width / 4 + 100;
				
				//check if match
				//} else {
				//	if(global.player_choice_two == noone) {
				//		global.player_choice_two = id;
				//		face_up = true;
				//	}
					
				//}
			}
			}
			//if doesnt click
		} else {
			target_y = room_height * 0.7;
		}

	}
}