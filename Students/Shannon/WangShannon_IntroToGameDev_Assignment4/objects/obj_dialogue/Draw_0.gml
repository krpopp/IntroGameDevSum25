draw_set_font(fnt_dpcomic)
draw_set_halign(fa_left);
draw_set_color(c_white);

if (global.dialogue_open1) {
	draw_sprite_stretched(spr_box, 0, start_x, start_y, box_w, box_h);
	draw_text(start_x + 10, start_y - 16, "Elora");
	if (!global.chocolate_bought) {
		if (global.cult_invite) {
			draw_text_ext(start_x + 10, start_y + 5, "Hmm, a cult? Maybe if you get me something to eat, I will consider.", 16, box_w - 10);
		}
		else {
			draw_text_ext(start_x + 10, start_y + 5, "You're wearing a lot of layers for a sunny day.", 16, box_w - 10);
		}
	}
	else {
		draw_text_ext(start_x + 5, start_y + 5, "Thank you! I'm so excited to be a cultist.", 16, box_w - 15);
	}
}
if (global.dialogue_open2) {
	draw_sprite_stretched(spr_box, 0, start_x, start_y, box_w, box_h);
	draw_text(start_x + 10, start_y - 16, "Chocolate Vendor");
	draw_sprite_stretched(spr_box, 0, start_x + box_w + 5, start_y, 60, box_h);
	draw_sprite_stretched(spr_chocolate, 0, start_x + box_w + 15, start_y + 10, 40, 40)
	if (!global.chocolate_bought) {
		draw_text_ext(start_x + 10, start_y + 5, "Hon hon, greetings, Monsieur! Would you like-ah chocolat?", 16, box_w - 10);
	}
	else {
		draw_text_ext(start_x + 5, start_y + 5, "Thank you! I'm so excited to be a cultist.", 16, box_w - 15);
	}
}
if (global.dialogue_open3) {
	draw_sprite_stretched(spr_box, 0, start_x, start_y, box_w, box_h);
	draw_text(start_x + 10, start_y - 16, "Dr. Xueqing");
	if (global.cult_invite) {
		draw_text_ext(start_x + 10, start_y + 5, "I'm not interested in joining your cult.", 16, box_w - 15);
	}
	else {
		draw_text_ext(start_x + 10, start_y + 5, "One of my patients called me a nurse the other day. Let's just say they can no longer walk.", 16, box_w - 15);
	}
}