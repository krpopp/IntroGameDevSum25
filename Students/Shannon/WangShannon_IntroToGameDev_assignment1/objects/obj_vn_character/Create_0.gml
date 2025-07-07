randomize();
x = room_width / 2 - 5;
y = 157;
visible = false;

enum Character {
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

speaker_char = Character.Bartender;

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

// GUARDIAN ANGEL
state_guardian_angel = "idle"; // idle, meek

// BARTENDER
state_bartender = "idle"; // idle, frustrated

// CHOCOLATIER
state_chocolatier = "idle"; // idle, cocky, pissed

// JESTER
state_jester = "idle"; // idle, thinking

// DOCTOR
state_doctor = "idle"; // idle, menacing

// CHEF
state_chef = "idle"; // idle, munch

// MATHEMATICIAN
state_mathematician = "idle"; // idle, frustrated

// MARKSWOMAN
state_markswoman = "idle"; // idle, pissed, sad



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
		case Character.Guardian_Angel: state_guardian_angel = _state; break;
		case Character.Bartender: state_bartender = _state; break;
		case Character.Chocolatier: state_chocolatier = _state; break;
		case Character.Jester: state_jester = _state; break;
		case Character.Doctor: state_doctor = _state; break;
		case Character.Chef: state_chef = _state; break;
		case Character.Mathematician: state_mathematician = _state; break;
		case Character.Markswoman: state_markswoman = _state; break;
		
	}
	
}

//////


function update() {
	breathe();
	eye_track();
	manage_visibility();
	move_mouth();
	control_blink();
	blink();
	
}

function manage_visibility() {
	switch (obj_vn_text_engine.panel_state) {
		case "open": 
			if (!global.is_cutscene) { visible = true; }
			visible = false; break;
		case "opening": 
			visible = false; break;
		case "closed": 
			visible = false; break;
		case "closing": 
			visible = false; break;
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
	var screen_ratio = clamp((mouse_x - x) / 50, -1, 1);
	pupil_dest = screen_ratio * pupil_max_offset;
	pupil_offset = lerp(pupil_offset, pupil_dest, 0.07);
}

function move_mouth() {
	if (!obj_vn_text_engine.text_line_ready && mouth_timer <= 0) {
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
		if (speaker_char == Character.Doctor && state_doctor == "idle" && consecutive_blinks < 1) {
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
