if(!is_talking && distance_to_object(obj_player) < 20 && keyboard_check_pressed(vk_space)){
	is_talking = true; 
	audio_play_sound(snd_talk,1,false);
}

if(is_talking && distance_to_object(obj_player) > 40){
is_talking = false; 	
}

if(obj_player.key_get == true){
	dialogue_index = 1; 
	
}

depth = -y; 