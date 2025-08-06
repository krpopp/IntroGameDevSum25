
draw_set_color(c_black);
//draw_text_ext(x + 40, y + 40, 
//             pair_id, 20, sprite_width - 20);
			 
if (!should_blink) {
    draw_sprite_ext(sprite_index, image_index, 
               x, y, 
               1, 1, 0, c_white, 1);
} else if(should_blink){
		switch_sprite = true;
}

if(switch_sprite){
	timer++;
	 draw_sprite_ext(spr_slot2, image_index, x, y, image_xscale, 
					 image_yscale, 0, c_red, 1);
	if(timer > 200){
		switch_sprite = false;
		timer = 0;
	}
	
}

