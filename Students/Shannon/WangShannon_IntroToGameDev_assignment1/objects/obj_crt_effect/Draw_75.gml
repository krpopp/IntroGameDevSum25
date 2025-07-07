// NOT MINE

if (room == title_screen ||
	(room == visual_novel_opening && global.menu_pause ||
	room == combat_opening && global.menu_pause)) {
		
	if (!surface_exists(application_surface)) return;

	shader_set(shd_crt_effect);

	var u_time = shader_get_uniform(shd_crt_effect, "u_time");

	shader_set_uniform_f(u_time, current_time / 1000.0);

	draw_surface(application_surface, 0, 0);

	shader_reset();

}
else {
		
	if (!surface_exists(application_surface)) return;

	shader_set(shd_crt_effect_min);

	var u_time = shader_get_uniform(shd_crt_effect, "u_time");

	shader_set_uniform_f(u_time, current_time / 1000.0);

	draw_surface(application_surface, 0, 0);

	shader_reset();

}