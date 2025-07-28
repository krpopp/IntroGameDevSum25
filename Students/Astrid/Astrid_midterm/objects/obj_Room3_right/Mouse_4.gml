
if(obj_Room3_text.current_page < 52){
	obj_Room3_text.next_page ++;
	obj_Room3_text.is_fading = true;
	
	audio_play_sound(snd_room3_flip, 10, false);
	audio_sound_gain(snd_room3_flip, 2, 0);
} 

else if(obj_Room3_text.current_page == 52){
	obj_Room3_text.current_page = 52;
	obj_Room3_text.is_fading = false;
	
	audio_play_sound(snd_noflip, 10, false);
	audio_sound_gain(snd_noflip, 1, 0);
}
//show_message(obj_Room3_text.current_page);