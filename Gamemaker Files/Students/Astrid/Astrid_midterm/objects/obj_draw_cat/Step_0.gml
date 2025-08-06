if (image_index >= sprite_get_number(sprite_index) - 1 && image_speed > 0) {
	pause_at_end = true;
  if(pause_at_end){
        pause_timer--;
        if (pause_timer <= 0) {
            pause_at_end = false;
            image_index = 0; 
            image_speed = 1;  
        }
    }
}

  if (!pause_at_end) {
        pause_at_end = true;
        pause_timer = pause_duration;
        image_speed = 0; 
    }
