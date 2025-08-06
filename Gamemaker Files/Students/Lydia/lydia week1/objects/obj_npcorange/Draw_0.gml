draw_self();

if(is_talking){
	
	
	draw_set_color(c_black);	
    draw_rectangle(743,582, 850, 616, false); 
    
	
	draw_set_color(c_white);
	draw_set_alpha(0.7);
    draw_rectangle(745,584, 848, 614, true); 
	draw_set_alpha(1);
	
	draw_set_color(c_white);
	draw_set_font(Font1);
	draw_text_ext(749, 585, dialogue_text[dialogue_index],7,100);

}