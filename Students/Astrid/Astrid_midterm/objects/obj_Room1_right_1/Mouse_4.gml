
if(obj_Room1_text_1.current_page < 52){
	obj_Room1_text_1.next_page ++;
	obj_Room1_text_1.is_fading = true;
	
	audio_play_sound(snd_room3_flip, 10, false);
	audio_sound_gain(snd_room3_flip, 2, 0);
} 

else if(obj_Room1_text_1.current_page == 52){
	obj_Room1_text_1.current_page = 52;
	obj_Room1_text_1.is_fading = false;
	
	audio_play_sound(snd_noflip, 10, false);
	audio_sound_gain(snd_noflip, 1, 0);
}
//show_message(obj_Room3_text.current_page);