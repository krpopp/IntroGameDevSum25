draw_set_font(fnt_score); // Apply your custom font

draw_set_color(c_white);
draw_set_halign(fa_left);

// Top left score
draw_set_valign(fa_top);
draw_text(20, 20, string(get_score_top()));

// Bottom left score
draw_set_valign(fa_bottom);
draw_text(20, display_get_gui_height() - 20, string(get_score_bottom()));
