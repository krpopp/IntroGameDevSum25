draw_self();

if(is_talking){
	
	
	draw_set_color(c_black);
	
    draw_rectangle(630, 410, 730, 446, false); 
    
	
	draw_set_color(c_white);
	draw_set_alpha(0.7);
    draw_rectangle(632, 412, 728, 446, true); 
	draw_set_alpha(1);
	
	draw_set_color(c_white);
	draw_set_font(Font1);
	draw_text_ext(636, 413, dialogue_text[dialogue_index],7, 80)

}