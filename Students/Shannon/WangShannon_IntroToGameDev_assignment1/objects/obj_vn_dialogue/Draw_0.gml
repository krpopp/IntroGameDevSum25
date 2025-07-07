/*draw_set_color(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_dp_comic_small);

//show_debug_message(draw_queue);
var _e; var _xmod; var _ymod; var _alph;
for (var _i = 0; _i < array_length(draw_queue); _i++){
	_e = draw_queue[_i];
	
	if (is_array(_e.fx) && array_length(_e.fx) > 0){
		if (array_length(_e.fx) > 1){script_execute(_e.fx[0],_e.fx[1]);}
		else{script_execute(_e.fx[0]);}
	}
	
	if (vfx_choice && point_in_rectangle(mouse_x,mouse_y,_e.x,_e.y,_e.x+string_width(_e.txt),_e.y+string_height(_e.txt))){
		if (choice_ind == -1){
			choice_ind = _i;
			choice_lock = true;
		}
		choice_timer += c_ct_speed;
		if (choice_timer > 1){choice_timer = 1;}
	}
	else{
		if (choice_ind == _i){
			choice_ind = -1;
			choice_timer = 0;
			choice_lock = false;
		}
	}
	
	_xmod = random_range(-1*vfx_shake,vfx_shake);
	_ymod = random_range(-1*vfx_shake,vfx_shake);
	
	_alph = vfx_alpha;
	if (!vfx_choice_immune && choice_lock && choice_ind != _i){_alph *= 1-0.75*choice_timer;}
	draw_text_color(_e.x+_xmod,_e.y+_ymod,_e.txt,vfx_color,vfx_color,vfx_color,vfx_color,_alph);
	
	//if (extra_skip > 0){draw_text(mouse_x,mouse_y,extra_skip);}
}*/

draw_set_font(fnt_dp_comic);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);