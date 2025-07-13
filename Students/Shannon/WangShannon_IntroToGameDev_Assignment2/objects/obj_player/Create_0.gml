image_speed = 0;

v_state = "jumping";
bounce_val = 1;

anim_timer = 5;

//horizontal
h_vel = 0;
h_speed = 2;
max_x_vel = 4;



function update() {
	manage_state();
	apply_gravity();
	apply_controls();
	jump();
}

function apply_gravity() {
	y_vel += grav;
	y_vel = clamp(y_vel, max_y_vel, -max_y_vel);
	y = clamp (y, 0, room_height);
}

function apply_controls() {
	if (keyboard_check(ord("D"))) {
		h_vel += 0.1;
	}
	else if (keyboard_check(ord("A"))) {
		h_vel -= 0.1;
	}
	else {
		if (abs(h_vel) > 0) {
			h_vel -= 0.1;
		}
	}
	
	x += h_vel;
	
	h_vel = clamp(h_vel, -max_x_vel, max_x_vel);
}

function manage_state() {
	switch (v_state) {
		case "jumping":
			if (anim_timer > 0) {
				image_index = 1;
				anim_timer--;
			}
			else {
				image_index = 0;
			}
			y -= y_vel;
			
			break;
		case "falling":
			if (anim_timer > 0) {
					image_index = 1;
					anim_timer--;
				}
				else {
					image_index = 2;
				}
				y -= y_vel;
			
			break;
	}
	
}

function jump() {
	if (keyboard_check_pressed(vk_space)) {
		y_vel += bounce_val;
	}
}