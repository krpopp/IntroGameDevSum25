if (is_showing) {
    // Black background
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(0, room_height - box_height, room_width, room_height, false);
    
    // White border
    draw_set_alpha(1);
    draw_set_color(c_white);
    var border_offset = 5;
    draw_rectangle(border_offset, 
                   room_height - box_height + border_offset, 
                   room_width - border_offset, 
                   room_height - border_offset, 
                   true);
    draw_rectangle(border_offset + 2, 
                   room_height - box_height + border_offset + 2, 
                   room_width - border_offset - 2, 
                   room_height - border_offset - 2, 
                   true);

    // Text
    draw_set_font(fnt_main);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_ext(text_margin, room_height - box_height + text_margin, 
                  text_array[current_text], 
                  25, room_width - (text_margin * 2));
    
    // Navigation tip
    draw_set_color(c_yellow);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    if (current_text < array_length(text_array) - 1) {
        draw_text(room_width - text_margin, room_height - 10, "Press ENTER for next >");
    } else {
        draw_text(room_width - text_margin, room_height - 10, "Press ENTER to close >");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
	
	if (show_choices) {
	    draw_set_font(fnt_main); 
	    draw_set_color(c_yellow);
	    draw_set_halign(fa_left);
	    draw_set_valign(fa_top);

		var choice_x = 440;              // more to the right
		var choice_y_start = room_height - 140; // higher up

		draw_text(choice_x, choice_y_start, "1. Veggie Pizza");
		draw_text(choice_x, choice_y_start + 32, "2. Meat Pizza");

	    draw_set_font(-1); // reset to default if needed
	}
}

