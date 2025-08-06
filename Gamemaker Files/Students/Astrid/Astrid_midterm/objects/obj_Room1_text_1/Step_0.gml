if (is_fading) {
    fade_alpha -= ease_out;
    if (fade_alpha <= 0) {
        current_page = next_page;
        is_fading = false;
    }
} 

else if(!is_fading){
	
	if (fade_alpha < 1) {
	    fade_alpha += ease_in;
	}
}

if (current_page == 3 && keyboard_check_pressed(vk_space)){
	room_goto(Room1);
}