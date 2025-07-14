// Set font
draw_set_font(fnt_score);
draw_set_valign(fa_top);

// RED score - TOP LEFT
draw_set_halign(fa_left);
draw_set_color(c_red);
draw_text(20, 20, string(global.score_red));

// GREEN score - TOP RIGHT  
draw_set_halign(fa_right);
draw_set_color(c_lime);
draw_text(view_wport[0] - 20, 20, string(global.score_green));