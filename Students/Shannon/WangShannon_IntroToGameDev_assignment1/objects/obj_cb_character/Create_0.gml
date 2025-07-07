randomize();
x = room_width / 2 - 5;
y = 100;
visible = false;

enum CB_Character {
	None,
	Guardian_Angel,
	Bartender,
	Chocolatier,
	Jester,
	Doctor,
	Chef,
	Mathematician,
	Markswoman
	
}  

speaker_char = CB_Character.None;

// breathing 
breathe_timer = 0; 
breathe_speed = 0.04;
breathe_amp = 2.5;

// eye tracking
pupil_max_offset = 1;

// mouth
mouth_index = 0;
mouth_timer = 7;

// eye blinking
blink_interval_timer = 0;
blink_timer = 0;
eye_index = 0;
consecutive_blinks = 0;

state_dealer = "idle";

// OUCH!

hurt = false;
hurt_shake_strength = 0;
hurt_shake_timer = 0;
hurt_offset = 0;
times_took_damage = 0;
damage_speech_timer = -1;



/// @description					Sets current speaker to _char.
/// @param {any} _char				Character (in enum form).
function set_speaker(_char){
	speaker_char = _char;
}

/// @description					Sets current speaker state to _state.
/// @param {string} _state			Character state.
function set_state(_state){
	/* Shannon please optimize this :(
	* okayy :'D */
	switch speaker_char{
		case CB_Character.None: state_dealer = _state; break;
		case CB_Character.Guardian_Angel: state_dealer = _state; break;
		case CB_Character.Bartender: state_dealer = _state; break;
		case CB_Character.Chocolatier: state_dealer = _state; break;
		case CB_Character.Jester: state_dealer = _state; break;
		case CB_Character.Doctor: state_dealer = _state; break;
		case CB_Character.Chef: state_dealer = _state; break;
		case CB_Character.Mathematician: state_dealer = _state; break;
		case CB_Character.Markswoman: state_dealer = _state; break;
		
	}
	
}

//////

function take_damage(_strength) {
	state_dealer = "hurt";
	hurt_shake_timer = 50;
	hurt_shake_strength = _strength / 8;
	times_took_damage++;
	damage_speech_timer = 120;
	//show_debug_message("taking damage");
	
	with (obj_cb_dealer_window) {
		dealer_hp -= _strength;
		hb_bleed(_strength);
	}

}


function update() {
	breathe();
	eye_track();
	manage_visibility();
	move_mouth();
	control_blink();
	blink();
	check_hurt();
	queue_hurt_remark();
}

function manage_visibility() {
	switch (obj_cb_text_engine.panel_state) {
		case "open": 
			if (!global.is_cutscene) visible = true; 
			else visible = true;
			break;
		case "opening": visible = true; break;
		case "closed": visible = true; break;
		case "closing": visible = true; break;
	}
}

function breathe() {
	breathe_timer += breathe_speed;
	breathe_offset = sin(breathe_timer) * breathe_amp;
	
	if (breathe_timer > 2 * pi) {
		breathe_timer -= 2 * pi;
	}
}

function eye_track() {
	if (global.weapon_in_use || obj_cb_text_engine.dialogue_running) {
		pupil_offset = 0;
	}
	else {
		var screen_ratio = clamp((mouse_x - x) / 50, -1, 1);
		pupil_dest = screen_ratio * pupil_max_offset;
		pupil_offset = lerp(pupil_offset, pupil_dest, 0.07);
	}
}

function move_mouth() {
	if (!obj_cb_text_engine.text_line_ready && mouth_timer <= 0 && obj_cb_text_engine.dialogue_running
	&& obj_cb_text_engine.panel_state == "open") {
		mouth_index += irandom_range(1, 2);
		mouth_timer = 7;
	}
	else if (!obj_cb_text_engine.text_line_ready) {
		mouth_timer--;
	}
	else {
		mouth_index = 0;
	}
}

function control_blink() {
	if (blink_interval_timer <= 0) {
		if (speaker_char == CB_Character.Doctor && state_doctor == "idle" && consecutive_blinks < 1) {
			var _blink_type = irandom_range(1,2);
			if (_blink_type == 1) { // normal blink
				blink_timer = 30;
				blink_interval_timer = 200 + irandom_range(0, 200);
			}
			else { // two consecutive flirtatious blinks
				blink_timer = 30;
				blink_interval_timer = 25;
				consecutive_blinks++;
			}
		}
		else {
			blink_timer = 30;
			blink_interval_timer = 200 + irandom_range(0, 200);
			consecutive_blinks = 0;
		}
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

function check_hurt() {
	
	var _threshold = obj_cb_dealer_window.dealer_max_hp * 0.3;
	if (obj_cb_dealer_window.dealer_hp < _threshold) {
		state_dealer = "hurt";
		hurt = true;
	}
	else {
		hurt = false;
	}
	
	if (hurt_shake_timer > 0) {
	    hurt_shake_timer--;

	    var shake_progress = hurt_shake_timer / 25;
	    hurt_offset = sin(hurt_shake_timer * 0.8) * hurt_shake_strength * shake_progress;
		
	} else {
		hurt_offset = 0;
	}
}

function queue_hurt_remark() {
	if (damage_speech_timer > 0) 
		damage_speech_timer--;
	
	else if (damage_speech_timer == 0) {
		show_debug_message("running queue_hurt_remark");
		
		if (!global.dealer_defeated_bloodshed) {
			with (obj_cb_script) {
	            var _resp = damage_response;
				other.damage_speech_timer = -1;
				array_push(global.scene_queue, _resp);
				show_debug_message("pushing: " + string(_resp));
	        }
		}
	}
}

function breathing_effect() {
	
	if (speaker_char == CB_Character.None) {
		x = 319;
		y = 125;
		if (state_dealer == "idle") {
			draw_sprite_ext(spr_bartender_backhair, 0, x + 16, y + breathe_offset*0.6 - 75, 1, 1, 
				(breathe_offset * -1 + 3), c_white, 1);
			draw_sprite(spr_bartender_arms, 0, x, y + breathe_offset*0.6);
			draw_sprite(spr_bartender_torso, 0, x, y + breathe_offset*0.8);
			draw_sprite(spr_bartender_head, 0, x, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_mouth, mouth_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
			draw_sprite(spr_bartender_pupils, 0, x + 1 + pupil_offset*2, y + breathe_offset*0.4);
			draw_sprite_ext(spr_bartender_eyes, eye_index, x, y + breathe_offset*0.4, 1, 1, 
				0, c_white, 1);
		}
		else if (state_dealer == "hurt") {
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
		else if (state_dealer == "senti") {
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
	


}