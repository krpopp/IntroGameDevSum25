

def_x = 60;
def_y = 150;

flower_type = "Lily"
flower_desc = "description"
flower_status = "READY"
flower_y = def_y;


float_timer = 0;
float_speed = 0.03;
float_amp = 2.4;

mouse_hover = false;

hitbox_width = 70;
hitbox_height = 140;

function update() {
	float();
	is_hovering();
}

function float() {
	float_timer += float_speed;
	float_offset = sin(float_timer) * float_amp;
	
	if (float_timer > 2 * pi) {
		float_timer -= 2 * pi;
	}
}

function is_hovering() {
	if (mouse_x >= def_x - hitbox_width/2 && mouse_x <= def_x + hitbox_width/2
		&& mouse_y >= def_y - hitbox_height/2 && mouse_y <= def_y + hitbox_height/2
		&& !obj_cb_text_engine.dialogue_running) {
		mouse_hover = true;
		flower_y = lerp(flower_y, def_y - 10, 0.1);
	}
	else {
		mouse_hover = false;
		flower_y = lerp(flower_y, def_y, 0.1);
	}
}