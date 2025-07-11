if (is_cycling) {
    sprite_timer--;
    if (sprite_timer <= 0) {
        sprite_timer = sprite_interval;
        
        if (current_sprite < array_length(sprite_list) - 1) {
            current_sprite++; 
            sprite_index = sprite_list[current_sprite];
        } else {
           
            is_cycling = false; 
        }
    }
}

//if(obj_player.dir >= 1){
//	if (instance_place(x, y-2, obj_player)){
//		instance_destroy();
//		}
//	}