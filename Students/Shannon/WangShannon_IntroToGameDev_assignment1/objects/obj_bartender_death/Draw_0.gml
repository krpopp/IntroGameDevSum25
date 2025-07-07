if (state == "throwup") {
		draw_sprite_ext(spr_bartender_throwup_backhair, 0, x + 2, y + breathe_offset*1, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_throwup_backarm, 0, x, y + breathe_offset*0.4, 1, 1 - (0.005*breathe_offset), 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_throwup_legs, 0, x, y + breathe_offset*0.7, 1, 1 - (0.01*breathe_offset), 
			0, c_white, 1);
		draw_sprite(spr_bartender_throwup_torso, 0, x, y + breathe_offset*0.6);
		draw_sprite(spr_bartender_throwup_frontarm, 0, x, y + breathe_offset*0.7 + 3);
		draw_sprite_ext(spr_bartender_throwup_blood, throwup_index, x, y, 1, 1, 
			0, c_white, 1);
		draw_sprite(spr_bartender_throwup_head, 0, x, y + breathe_offset*1.1);
		draw_sprite_ext(spr_bartender_throwup_eyes, 0, x, y + breathe_offset*1.1, 1, 1, 
			0, c_white, 1);
}
else if (state == "dying") {
		draw_sprite_ext(spr_bartender_throwup_backhair, 0, x + 9, y + breathe_offset*0.6 - 10, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_throwup_backarm, 0, x, y + breathe_offset*0.4, 1, 1 - (0.005*breathe_offset), 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_throwup_legs, 0, x, y + breathe_offset*0.7, 1, 1 - (0.01*breathe_offset), 
			0, c_white, 1);
		draw_sprite(spr_bartender_throwup_torso, 0, x, y + breathe_offset*0.6);
		draw_sprite(spr_bartender_dying_frontarm, 0, x, y + breathe_offset*0.7 - 1);
		draw_sprite(spr_bartender_dying_head, 0, x, y + breathe_offset*0.4);
		draw_sprite_ext(spr_bartender_throwup_blood, throwup_index, x, y, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_dying_mouth, mouth_index, x, y + breathe_offset*0.4 + 2, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_dying_pupils, 0, x, y + breathe_offset*0.4, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_dying_eyes, eye_index, x, y + breathe_offset*0.4 + 2, 1, 1, 
			0, c_white, 1);
}
else if (state == "slitting") {
		draw_sprite_ext(spr_bartender_throatslit_animation, slit_index, x, y, 1, 1, 
			0, c_white, 1);
		draw_sprite_ext(spr_bartender_throwup_blood, throwup_index, x, y, 1, 1, 
			0, c_white, 1);
}		