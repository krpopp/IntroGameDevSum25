if (global.list_exists == false){
	global.rmw_talking = true; 

	if(keyboard_check_pressed(vk_space)){
		dialogue_line ++;
	}
	if(dialogue_line = 10 && keyboard_check_pressed(vk_space) ){
		room_goto(Room1);
		global.rmw_talking = false; 
		global.list_exists = true; 
		global.desk_exists = true; 
	}
	
	
}

else 
if (distance_to_object(obj_player) < 32 && keyboard_check_pressed(vk_space)) {
    if (!global.rmw_talking) {
        global.rmw_talking = true;
		dialogue_line = 11;
    }
	else{
		dialogue_line ++
	}
	
	if(dialogue_line = 25 && keyboard_check_pressed(vk_space) ){
		
		global.rmw_talking = false; 
		
	}
}

