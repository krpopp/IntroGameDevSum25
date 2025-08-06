

if (global.dialogue_open1) {
	draw_sprite_ext(spr_elora_backhair, 0, x + 18, y + breathe_offset*0.6 - 75, 1, 1, 
				(breathe_offset * -1 + 3), c_white, 1);
	draw_sprite_ext(spr_elora_backarm, 0, x, y + breathe_offset*0.5, 1, 1, 0, c_white, 1);
	draw_sprite_ext(spr_elora_torso, 0, x, y + breathe_offset*0.6, 1, 1, 0, c_white, 1);
	draw_sprite_ext(spr_elora_frontarm, 0, x, y + breathe_offset*0.5 + 3, 1, 1, 0, c_white, 1);
	draw_sprite_ext(spr_elora_head, 0, x, y + breathe_offset*0.4, 1, 1, 0, c_white, 1);
	draw_sprite_ext(spr_elora_mouth, 0, x, y + breathe_offset*0.4, 1, 1, 
		0, c_white, 1);
	draw_sprite_ext(spr_elora_pupils, 0, x, y + breathe_offset*0.4, 1, 1, 0, c_white, 1);
	draw_sprite_ext(spr_elora_eyes, 0, x, y + breathe_offset*0.4, 1, 1, 
		0, c_white, 1);
}
else if (global.dialogue_open2) {
	draw_sprite(spr_megalo_arms, 0, x, y + breathe_offset*0.8);
	draw_sprite(spr_megalo_torso, 0, x, y + breathe_offset);
	draw_sprite(spr_megalo_jacket, 0, x, y + breathe_offset*0.9);
	draw_sprite(spr_megalo_head, 0, x, y + breathe_offset*0.4);
	draw_sprite_ext(spr_megalo_mouth, 0, x, y + breathe_offset*0.4, 1, 1, 
		0, c_white, 1);
	draw_sprite(spr_megalo_pupils, 0, x, y + breathe_offset*0.4);
	draw_sprite_ext(spr_megalo_eyes, 0, x, y + breathe_offset*0.4, 1, 1, 
		0, c_white, 1);
}
else if (global.dialogue_open3) {
	draw_sprite(spr_xueqing_umbveil, 0, x, y + breathe_offset*0.6);
	draw_sprite(spr_xueqing_umbrella, 0, x, y + breathe_offset*0.6);
	draw_sprite_ext(spr_xueqing_backarm, 0, x, y + breathe_offset*0.6, 1, 1, 
		breathe_offset * -0.5, c_white, 1);
	draw_sprite(spr_xueqing_torso, 0, x, y + breathe_offset*0.7);
	draw_sprite(spr_xueqing_head, 0, x, y + breathe_offset*0.5);
	draw_sprite_ext(spr_xueqing_mouth, 0, x-1, y + breathe_offset*0.5, 1, 1, 
		0, c_white, 1);
	draw_sprite(spr_xueqing_pupils, 0, x, y + breathe_offset*0.5);
	draw_sprite_ext(spr_xueqing_eyes, 0, x, y + breathe_offset*0.5, 1, 1, 
		0, c_white, 1);
	draw_sprite(spr_xueqing_frontarm, 0, x, y + breathe_offset*0.6);
}