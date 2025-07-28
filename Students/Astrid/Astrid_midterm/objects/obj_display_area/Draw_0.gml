	draw_set_alpha(1);
//draw_set_color(c_white);
draw_sprite_stretched(spr_display, 0, 0, room_height - 260, room_width, 260);


//ease in & ease out
	draw_set_alpha(text_alpha);//set opacity for text
	
	if (current_text != "") {
	draw_set_font(Font2);
    draw_set_color(c_white);
    draw_text_ext(251+500, room_height - 160, display_text, 30, room_width - 480);
}

	draw_set_alpha(1);

