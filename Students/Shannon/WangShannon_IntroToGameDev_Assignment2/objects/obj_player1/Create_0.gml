image_speed = 0;
visible = true;

v_state = "jumping";
bounce_val = -8;

anim_timer = 5;

//horizontal
x_vel = 0;
x_speed = 2;
max_x_vel = 4;

//vertical
y_vel = bounce_val;
grav = 0.4;
max_y_vel = 8;

function die() {
	with (obj_player_manager) {
		player1_timer = respawn_timer;
	}

	instance_destroy();
}

function update() {
	manage_state();
	apply_gravity();
	apply_controls();
	jump();
}

function apply_gravity() {
	y_vel += grav;
	y_vel = clamp(y_vel, -max_y_vel, max_y_vel);
	y += y_vel;
}

function jump() {
	if (keyboard_check_pressed(vk_space) && v_state == "falling") {
		y_vel = -bounce_val;
	}
}

function apply_controls() {
	if (keyboard_check(ord("D"))) {
		x_vel += 0.1;
	}
	else if (keyboard_check(ord("A"))) {
		x_vel -= 0.1;
	}
	else {
		if (abs(x_vel) > 0) {
			x_vel -= sign(x_vel) * 0.1;
		}
	}
	
	x += x_vel;
	
	x_vel = clamp(x_vel, -max_x_vel, max_x_vel);
}

function manage_state() {
	switch (v_state) {
		case "jumping":
			if (y_vel <= 0) {
				v_state = "falling";
			}
			if (anim_timer > 0) {
				image_index = 1;
				anim_timer--;
			}
			else {
				image_index = 0;
			}
			
			break;
		case "falling":
			if (y_vel > 0) {
				v_state = "jumping";
			}
			if (anim_timer > 0) {
					image_index = 1;
					anim_timer--;
				}
				else {
					image_index = 2;
				}
				y -= y_vel;
			if (y > room_height) {
				die();
			}
			if (place_meeting(x, y + 1, obj_cloud)) {
				var _cloud = instance_nearest(x, y, obj_cloud);
				y_vel = bounce_val;
				v_state = "jumping";
				anim_timer = 5;
			}
			
			break;
	}
	
}