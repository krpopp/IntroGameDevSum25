draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(fnt_arial);

draw_text(20, 43, string(global.dealer_score));
draw_text(20, room_height - 43, string(global.player_score));