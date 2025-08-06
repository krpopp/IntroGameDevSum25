if (place_meeting(x,y,obj_player) && keyboard_check_pressed(vk_space)) {
	if(list_on == false){
		list_on = true; 
		audio_play_sound(snd_list,0,false);
	}
	else{
		list_on = false; 
	}
}