image_speed = 0;
visible = false;
image_xscale = 1;
image_yscale = 1;
depth = obj_revolver_weapon.depth - 1;

image_index = bullet_index;
spawned = false;
touching_cylinder = false;
secured = false;
grab = false;
destroying = false;
destroy_y = 500;
grav = 5;


function update() {
	if (spawned && !destroying) {
		check_drag();
		check_touching_cylinder();
		check_grab();
	}
	else if (destroying) {
		destroy();
	}
	else {
		check_spawn();
	}
}

function check_spawn() {
	if (y < init_y) {
		y = lerp(y, init_y, 0.1);
	}
}

function check_drag() {
	if (position_meeting(mouse_x, mouse_y, self) && mouse_check_button_pressed(mb_left) && !grab) {
		grab = true;
		//show_debug_message("grab is true")
	}
}

function check_grab() {
	if (grab) {
		x = mouse_x;
		y = mouse_y;
		image_xscale = lerp(image_xscale, 1.2, 0.2);
		image_yscale = lerp(image_yscale, 1.2, 0.2);
		
		if (mouse_check_button_released(mb_left)) {
			if (touching_cylinder) {
				secured = true;
				with (obj_revolver_weapon) {
					chambers_filled++;
					next_chamber = true;
					next_chamber_timer = 20;
				}
				instance_destroy();
			}
			else {
				x = init_x;
				y = init_y;
				grab = false;
				//show_debug_message("grab is false")
			}
		}
	}
	else {
		image_xscale = lerp(image_xscale, 1, 0.2);
		image_yscale = lerp(image_yscale, 1, 0.2);
	}
}

function check_touching_cylinder() {
	var _hbo = 20; // hitbox offset
	var _rev = global.weapon_instance;
	if (mouse_x > _rev.cylinder_x - _hbo && mouse_x < _rev.cylinder_x + _hbo
		&&  mouse_y > _rev.cylinder_y - _hbo && mouse_y < _rev.cylinder_y + _hbo
		&&  grab) {
		touching_cylinder = true;
	}
	else {
		touching_cylinder = false;
	}
}

function destroy() {
	
	grav -= random_range(0.2, 0.5);
	if (y < destroy_y) {
		y -= grav;
	}
	else {
		instance_destroy();
	}
}