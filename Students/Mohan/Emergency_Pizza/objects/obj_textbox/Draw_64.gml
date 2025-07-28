if (is_showing) {
    // Draw DARKER black background
    draw_set_alpha(0.95);
    draw_set_color(c_black);
    draw_rectangle(0, room_height - box_height, room_width, room_height, false);
    
    // Draw WHITE BORDER INSIDE the black box
    draw_set_alpha(1);
    draw_set_color(c_white);
    var border_offset = 5; // Distance from edge of black box
    draw_rectangle(border_offset, 
                   room_height - box_height + border_offset, 
                   room_width - border_offset, 
                   room_height - border_offset, 
                   true); // true = outline only
    
    // Optional: Double border for more style
    draw_rectangle(border_offset + 2, 
                   room_height - box_height + border_offset + 2, 
                   room_width - border_offset - 2, 
                   room_height - border_offset - 2, 
                   true);
    
    // Draw text with your font
    draw_set_font(fnt_main);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_ext(text_margin, room_height - box_height + text_margin, 
                  text_array[current_text], 
                  25, room_width - (text_margin * 2));
    
    // Draw instruction
    draw_set_color(c_yellow);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    if (current_text < array_length(text_array) - 1) {
        draw_text(room_width - text_margin, room_height - 10, "Press ENTER for next >");
    } else {
        draw_text(room_width - text_margin, room_height - 10, "Press ENTER to close >");
    }
    
    // Reset alignment and font
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(-1);
}