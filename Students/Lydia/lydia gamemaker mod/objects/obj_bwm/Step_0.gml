if (distance_to_object(obj_player) < 32 && keyboard_check_pressed(vk_space)) {
    if (!global.bwm_talking) {
        global.bwm_talking = true;
		dialogue_line ++;
    }
	else{
		dialogue_line ++;
	}
	if(dialogue_line = 16 && keyboard_check_pressed(vk_space) ){
		
		global.bwm_talking = false; 
		
	}
	if(global.player_have_glasses){
		room_goto(Room1);
		global.bwm_talking = false; 
		global.mirror_exists = true; 
		
	}
	
	
}