if (distance_to_object(obj_player) < 20 && keyboard_check_pressed(vk_space)) {
    if (!global.d_talking) {
        global.d_talking = true;
		dialogue_line ++;
    }
	else{
		dialogue_line ++;
	}
	if(dialogue_line = 3 && keyboard_check_pressed(vk_space) ){
		
		global.d_talking = false; 
		room_goto(Room3);
	}
	
	
	
}