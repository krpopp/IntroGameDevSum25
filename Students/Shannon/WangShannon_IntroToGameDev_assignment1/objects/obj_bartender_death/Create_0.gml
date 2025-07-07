x = 320;
y = 150;

// breathing 
breathe_timer = 0; 
breathe_speed = 0.1;
breathe_amp = 1.6;
breathe_offset = sin(breathe_timer) * breathe_amp;

// mouth
mouth_index = 0;
mouth_timer = 0;
//throwup
throwing_up = false;
throwup_index = 0;
throwup_pre_timer = 0;
throwup_timer = 0;
post_throwup_timer = 0;
waiting = true;
waiting2 = true;
state = "throwup"

//leaning
leaning = false;
lean_timer = 0;

// blink
eye_index = 0;
blink_timer = 0;
blink_interval_timer = 200 + irandom_range(0, 200);

//event

slitting_throat = false;
pre_slit_timer = 100;
slit_timer = 0;
slit_index = 0;

function spawn_scene() {
	global.is_cutscene = true;
	throwup_pre_timer = 300;
	post_throwup_timer = 450;
	speaker_char = CB_Character.Bartender;
	state_bartender = "throwup";
	throwup();
}

spawn_scene();

function update() {
	bartender_last_words();
	breathe();
	throwup_animation();
	throwup();
	lean();
	move_mouth();
	control_blink();
	blink();
	check_if_slitting();
}


function bartender_last_words() {
	if (waiting) {
		if (post_throwup_timer > 0) {
			post_throwup_timer--;
		}
		else if (post_throwup_timer == 0) {
			with (obj_vn_test_script) {
				array_push(global.scene_queue, bartender_death);
			}
			waiting = false;
			waiting2_timer = 120;
		}
	}
	else if (waiting2) {
		if (waiting2_timer > 0) {
			waiting2_timer--;
		}
		else if (obj_vn_text_engine.panel_state == "closed") {
			with (obj_vn_test_script) {
				array_push(global.scene_queue, bartender_death2);
			}
			state = "dying";
			waiting2 = false;
		}
	}
}

function throwup_animation() {
	if (throwing_up) {
		if (throwup_index < 9 && throwup_timer == 0) {
			throwup_timer = 5;
			throwup_index++;
		}
		else if (throwup_index < 9 && throwup_timer > 0) {
			throwup_timer--;
		}
		else {
			throwup_index = 8;
			throwing_up = false;
			breathe_speed = 0.04;
		}
	}
}

function throwup() {
	if (!throwing_up && throwup_index == 0) {
		if (throwup_pre_timer > 0) {
			throwup_pre_timer--;
		}
		else {
			throwing_up = true;
			throwup_timer = 0;
			leaning = true;
			lean_timer = 20;
			//throwup_index = 0;
		}
	}
}


function breathe() {
	if (leaning) {
		breathe_offset += 0.9;
	}
	else if (breathe_offset > sin(breathe_timer) * breathe_amp) {
		breathe_offset -= 0.1;
	}
	else {
		if (throwup_index == 0) {
			breathe_speed += 0.0003;
			breathe_amp += 0.003;
		}
		
		breathe_timer += breathe_speed;
		breathe_offset = sin(breathe_timer) * breathe_amp;
	
		if (breathe_timer > 2 * pi) {
			breathe_timer -= 2 * pi;
		}
	}
}

function lean() {
	if (leaning) {
		if (lean_timer > 0) {
			lean_timer--;
		}
		else {
			leaning = false;
		}
	}
}

function move_mouth() {
	if (!obj_vn_text_engine.text_line_ready && mouth_timer <= 0 && obj_vn_text_engine.dialogue_running
	&& obj_vn_text_engine.panel_state == "open") {
		mouth_index += irandom_range(1, 2);
		mouth_timer = 7;
	}
	else if (!obj_vn_text_engine.text_line_ready) {
		mouth_timer--;
	}
	else {
		mouth_index = 0;
	}
}

function control_blink() {
	if (blink_interval_timer <= 0) {
		blink_timer = 30;
		blink_interval_timer = 200 + irandom_range(0, 200);
	}
	else {
		blink_interval_timer--;
	}
}

function blink() {
	blink_timer--;
	
	if (blink_timer >= 30) {
		eye_index = 0;
	}
	else if (blink_timer >= 26 || (blink_timer >= 7 && blink_timer < 15)) {
		eye_index = 1;
	}
	else if (blink_timer >= 15) {
		eye_index = 2;
	}
	else {
		eye_index = 0;
	}
}

function check_if_slitting() {
	if (slitting_throat && obj_vn_text_engine.panel_state == "closed" && state != "slitting") {
		if (pre_slit_timer > 0) {
			pre_slit_timer--;
		}
		else {
			state = "slitting";
		}
	}
	else if (state == "slitting" && slit_index < 10) {
		if (slit_timer > 0) {
			slit_timer--;
		}
		else {
			slit_timer = 7;
			slit_index++;
		}
	}
}
