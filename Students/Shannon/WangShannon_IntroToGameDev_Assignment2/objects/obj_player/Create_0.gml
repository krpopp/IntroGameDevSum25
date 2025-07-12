image_speed = 0;

v_state = "jumping";
bounce_val = 1;


anim_timer = 5;



function update() {
	manage_state();
	apply_gravity();
	jump();
}

function apply_gravity() {
	y_vel += grav;
	y_vel = clamp(y_vel, max_y_vel, -max_y_vel);
	y = clamp (y, 0, room_height);
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
		
	}
	
}

function jump() {
	if (keyboard_check_pressed(vk_space)) {
		y_vel += bounce_val;
	}
}