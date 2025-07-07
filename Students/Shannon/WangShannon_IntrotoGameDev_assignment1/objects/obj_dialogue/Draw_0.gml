draw_set_font(fnt_depixel)
draw_set_halign(fa_left);
draw_set_color(c_white);

if (dialogue_open1) {
	draw_sprite_stretched(spr_box, 0, start_x, start_y, box_w, box_h);
	if (!global.key_picked_up) {
		draw_text_ext(start_x + 5, start_y + 5, "The key is some way to the east of here.", 12, box_w - 10);
	}
	else {
		draw_text_ext(start_x + 5, start_y + 5, "Great. My friend will tell you how to escape this place.", 12, box_w - 10);
	}
}
if (dialogue_open2) {
	draw_sprite_stretched(spr_box, 0, start_x, start_y, box_w, box_h);
	draw_text_ext(start_x + 5, start_y + 5, "The exit is north of here, hidden behind a tree.", 12, box_w - 10);
}