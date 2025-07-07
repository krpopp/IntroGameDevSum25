draw_set_halign(fa_center);
draw_set_font(fnt_dp_comic_small);
var _x_center = room_width / 2;

if (rev_state == "loadable") {
	var bar_width = 200;
	var bar_height = 10;
	var bar_x = _x_center + bar_width / 2;
	var bar_y = 340;

	draw_sprite(spr_rope_timer, 0, _x_center, bar_y);
	var fill_width = bar_width * (loadable_timer / loadable_timer_max);
	draw_set_color(c_black); 
	draw_rectangle(bar_x - bar_width + fill_width - 8, bar_y - 5, bar_x + 8, bar_y + bar_height + 2, false);
	
	//stopwatch
	draw_sprite_ext(spr_stopwatch_timer, sw_frame, bar_x - bar_width - 8, bar_y, 1, 1, sw_rot, c_white, 1);
}

if (rev_state == "spawn" ||
	rev_state == "loadable" || rev_state == "spin revving" || rev_state == "spinning" ||
	rev_state == "closing chamber") {
	draw_sprite(spr_revolver_back, 0, x, y);
	draw_sprite_ext(spr_revolver_cylinder, cylinder_index, cylinder_x, cylinder_y, chamber_width, 1, 0, c_white, 1);
	draw_sprite_ext(spr_revolver_chambers, chambers_filled, cylinder_x, cylinder_y, 1, 1, chamber_rot, c_white, 1);
	draw_sprite(spr_revolver_front, 0, x, y);
}

if (rev_state == "aiming") {
	draw_sprite_ext(spr_revolver_aim, 0, x, y, 1, 1, aim_rot, c_white, 1);
}

if (rev_state == "loadable" || rev_state == "spin revving"
	|| rev_state == "spinning" || rev_state == "closing chamber"
	|| rev_state == "aiming") {
		draw_text(_x_center, 205, string(chambers_filled) + "/6");
}
