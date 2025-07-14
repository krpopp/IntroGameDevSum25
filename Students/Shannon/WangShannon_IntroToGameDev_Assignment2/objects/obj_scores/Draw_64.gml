draw_set_font(fnt_depixel);

draw_set_halign(fa_left);

draw_text_color(10, 10, global.p1_score, #eb021a, #eb021a, #a10010, #a10010, 1);

draw_set_halign(fa_right);

draw_text_color(display_get_gui_width() -10, 10, global.p2_score, #0bd961, #0bd961, #039c43, #039c43, 1);