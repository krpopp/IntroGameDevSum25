if(obj_dealer.state == STATES.PICK) {

	if(in_player_hand && obj_dealer.pick_timer > 30) {
		_face_up = true; 
		
		if(position_meeting(mouse_x, mouse_y, id)) {
			if(global.player_choice == noone){
			target_y  = room_height * 0.79;
			
				if(mouse_check_button_pressed(mb_left)){
						audio_play_sound(snd_move,1,false);
						global.player_choice = id;
						global.player_choice.target_x = room_width / 3 + 100;
						//global.player_choice.target_y = room_height * 0.57;
						global.player_choice.target_y = room_height * 0.57;
				
				}
			}
			
		} 
		else{
			target_y  = room_height * 0.8;
		}
	}
}


if(abs(x - target_x) > 1) {
	x = lerp(x, target_x, 0.2);
} else {
	x = target_x;
}

if(abs(y - target_y) > 1) {
	y = lerp(y, target_y, 0.2);
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
