function draw_update() {
	breathing_effect();
}


function breathing_effect() {
	if (speaker_char == Character.Guardian_Angel) {
		x = 315;
		y = 154;
		if (state_guardian_angel == "idle") {
			draw_sprite(spr_guardian_angel_backclothes, 0, x, y + breathe_offset);
			draw_sprite(spr_guardian_angel_torso, 0, x, y + breathe_offset);
			draw_sprite(spr_guardian_angel_arms, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_guardian_angel_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_guardian_angel_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_guardian_angel_pupils, 0, x - 1 + pupil_offset, y + breathe_offset*0.4);
			draw_sprite(spr_guardian_angel_eyes, 0, x, y + breathe_offset*0.4);
			draw_sprite(spr_guardian_angel_hood, 0, x, y + breathe_offset*0.8);
		}
		else if (state_guardian_angel == "meek") {
			draw_sprite(spr_guardian_angel_backclothes, 0, x, y + breathe_offset);
			draw_sprite(spr_guardian_angel_torso_meek, 0, x, y + breathe_offset);
			draw_sprite(spr_guardian_angel_head_meek, 0, x, y + breathe_offset*0.6);
			draw_sprite(spr_guardian_angel_eyes_meek, 0, x, y + breathe_offset*0.6);
			draw_sprite(spr_guardian_angel_hood_meek, 0, x, y + breathe_offset*0.8 + 1);
			draw_sprite(spr_guardian_angel_arms_meek, 0, x, y + breathe_offset*1.1 - 3);
		}
	}

	else if (speaker_char == Character.Bartender) {
		x = 316;
		y = 160;
		if (state_bartender == "idle") {
			draw_sprite_ext(spr_bartender_backhair, 0, x + 16, y + breathe_offset*0.6 - 75, 1, 1, 
				(breathe_offset * -1 + 3), c_white, 1);
			draw_sprite(spr_bartender_arms, 0, x, y + breathe_offset*0.6);
			draw_sprite(spr_bartender_torso, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_bartender_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_bartender_pupils, 0, x + 1 + pupil_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
		else if (state_bartender == "hurt") {
			draw_sprite_ext(spr_bartender_hurt_backhair, 0, x + 16 + hurt_offset, y + breathe_offset*0.6 - 75, 1, 1, 
				(breathe_offset * -1 + 3), c_white, 1);
			draw_sprite(spr_bartender_hurt_torso, 0, x + hurt_offset, y + breathe_offset*0.8);
			draw_sprite(spr_bartender_hurt_arms, 0, x + hurt_offset, y + breathe_offset*0.6);
			draw_sprite(spr_bartender_hurt_head, 0, x + hurt_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_hurt_mouth, mouth_index, x + hurt_offset, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_bartender_hurt_pupils, 0, x - 1 + pupil_offset * 2 + hurt_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_hurt_eyes, eye_index, x + hurt_offset, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
		else if (state_bartender == "senti") {
			draw_sprite_ext(spr_bartender_senti_backhair, 0, x + 16 + hurt_offset, y + breathe_offset*0.6 - 75, 1, 1, 
				(breathe_offset * -1 + 3), c_white, 1);
				draw_sprite(spr_bartender_senti_backarm, 0, x + hurt_offset, y + breathe_offset*0.6);
			draw_sprite(spr_bartender_senti_torso, 0, x + hurt_offset, y + breathe_offset*0.8);
			draw_sprite(spr_bartender_senti_frontarm, 0, x + hurt_offset, y + breathe_offset*0.6);
			draw_sprite(spr_bartender_senti_head, 0, x + hurt_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_senti_mouth, mouth_index, x + hurt_offset, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_bartender_senti_pupils, 0, x - 1 + pupil_offset * 2 + hurt_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_senti_eyes, eye_index, x + hurt_offset, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
	}

	else if (speaker_char == Character.Chocolatier) {
		x = 316;
		y = 153;
		if (state_chocolatier == "idle") {
			draw_sprite(spr_chocolatier_arms, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_chocolatier_torso, 0, x, y + breathe_offset);
			draw_sprite(spr_chocolatier_jacket, 0, x, y + breathe_offset*0.9);
			draw_sprite(spr_chocolatier_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_chocolatier_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_chocolatier_pupils, 0, x + 1 + pupil_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_chocolatier_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
	}
	
	else if (speaker_char == Character.Jester) {
		x = 314;
		y = 154;
		if (state_jester == "idle") {
			draw_sprite_ext(spr_jester_torsoback1, 0, x, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * 0.7, c_white, 1);
			draw_sprite_ext(spr_jester_torsoback2, 0, x, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * -0.7, c_white, 1);
			draw_sprite_ext(spr_jester_armleft, 0, x - 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * 1, c_white, 1);
			draw_sprite_ext(spr_jester_armright, 0, x - 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * -0.9, c_white, 1);
			draw_sprite(spr_jester_torso, 0, x, y + breathe_offset);
			draw_sprite_ext(spr_jester_headback1, 0, x - 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * 0.7, c_white, 1);
			draw_sprite_ext(spr_jester_headback2, 0, x + 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * -0.7, c_white, 1);
				draw_sprite_ext(spr_jester_headpieceback1, 0, x - 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * 0.7, c_white, 1);
			draw_sprite_ext(spr_jester_headpieceback2, 0, x + 3, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * -0.7, c_white, 1);
			draw_sprite(spr_jester_chinacc, 0, x, y - breathe_offset*0.3);
			draw_sprite(spr_jester_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_jester_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_jester_pupils, 0, x + 1 + (pupil_offset*1.5), y + breathe_offset*0.4);
			draw_sprite_ext(spr_jester_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_jester_headpiecefront, 0, x, y + breathe_offset*0.8 + 1);
		}
	}

	else if (speaker_char == Character.Doctor) {
		x = 298;
		y = 155;
		if (state_doctor == "idle") {
			draw_sprite(spr_doctor_umbveil, 0, x, y + breathe_offset*0.7);
			draw_sprite(spr_doctor_umbrella, 0, x, y + breathe_offset*0.7);
			draw_sprite_ext(spr_doctor_backarm, 0, x, y + breathe_offset*0.7, 1, 1, 
				breathe_offset * -0.5, c_white, 1);
			draw_sprite(spr_doctor_torso, 0, x, y + breathe_offset*0.9);
			draw_sprite(spr_doctor_head, 0, x, y + breathe_offset*0.5);
			draw_sprite_ext(spr_doctor_mouth, mouth_index, x, y + breathe_offset*0.5, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_doctor_pupils, 0, x + 1 + pupil_offset, y + breathe_offset*0.5);
			draw_sprite_ext(spr_doctor_eyes, eye_index, x, y + breathe_offset*0.5, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_doctor_frontarm, 0, x, y + breathe_offset*0.7);
		}
	}
	
	else if (speaker_char == Character.Chef) {
		x = 313;
		y = 159;
		if (state_chef == "idle") {
			draw_sprite(spr_chef_arms, 0, x, y + breathe_offset*0.7);
			draw_sprite(spr_chef_torso, 0, x, y + breathe_offset*0.9);
			draw_sprite(spr_chef_hand, 0, x, y + breathe_offset*0.7);
			draw_sprite(spr_chef_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_chef_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_chef_pupils, 0, x + pupil_offset, y + breathe_offset*0.4);
			draw_sprite_ext(spr_chef_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
	}
	
	else if (speaker_char == Character.Mathematician) {
		x = 313;
		y = 145;
		if (state_mathematician == "idle") {
			draw_sprite(spr_mathematician_backjacket, 0, x, y + breathe_offset*0.9);
			draw_sprite(spr_mathematician_torso, 0, x, y + breathe_offset*0.9);
			draw_sprite(spr_mathematician_jacket, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_mathematician_arms, 0, x, y + breathe_offset*0.6);
			draw_sprite(spr_mathematician_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_mathematician_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_mathematician_pupils, 0, x + pupil_offset - 1, y + breathe_offset*0.4);
			draw_sprite_ext(spr_mathematician_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
	}
	
	else if (speaker_char == Character.Markswoman) {
		x = 315;
		y = 155;
		if (state_markswoman == "idle") {
			draw_sprite(spr_markswoman_backjacket, 0, x, y + breathe_offset*0.7);
			draw_sprite(spr_markswoman_backhair, 0, x, y + breathe_offset*0.7);
			draw_sprite(spr_markswoman_arms, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_markswoman_torso, 0, x, y + breathe_offset*1);
			draw_sprite(spr_markswoman_jacket, 0, x, y + breathe_offset*0.8);
			draw_sprite_ext(spr_markswoman_feathers, 0, x + 26, y - 85 + breathe_offset*0.7, 1, 1, 
				breathe_offset * -3, c_white, 1);
			draw_sprite(spr_markswoman_head, 0, x, y + breathe_offset*0.7);
			draw_sprite_ext(spr_markswoman_mouth, mouth_index, x, y + breathe_offset*0.7, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_markswoman_pupil, 0, x + pupil_offset, y + breathe_offset*0.7);
			draw_sprite_ext(spr_markswoman_eye, eye_index, x, y + breathe_offset*0.7, 1, 1, 
				0, c_white, 1);
		}
	}
}


draw_update();