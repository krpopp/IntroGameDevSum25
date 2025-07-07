randomize();

spawn_y = 500;
hold_x = 400;
hold_y = 270;

x = hold_x;
y = spawn_y;

loadable_timer = -1;
loadable_timer_max = 190;

rev_state = "not in use";

spawn_cylinder_y = spawn_y + 10;
cylinder_x = hold_x - 27;
cylinder_y = spawn_cylinder_y;
closed_cylinder_x = hold_x + 8;
closed_cylinder_y = hold_y - 20;
closed_cylinder_rot = 0;
chambers_filled = 0;
chamber_width = 1;

//spin !!
prespin_timer = 0;
chamber_rot = 0;
cylinder_index = 0;
spin_speed = 0;
spin_max_speed = 18;
spin_acceleration = 0.3;
spin_friction = 0.15;
spin_rev_timer = 0;
def_spin_timer = irandom_range(100, 180);
spin_timer = 0;

//bullets
bullets_spawned = 0;
bullet_spawn_delay = 15;
bullet_spawn_timer = 0;
bullets_to_spawn = 6;
spawning_bullets = false;
next_chamber = false;
next_chamber_timer = 0;

// aim
aim_x = hold_x;
aim_y = 160;
aim_rot = 0;

// revert
postaim_timer = 0;

// stopwatch
sw_frame = 0;
sw_rot = 0;
tilt_timer_sw = 0;
tick_timer_sw = 0;

// draw fire part
rope_fire = noone;

function start_spawning_bullets() {
	spawning_bullets = true;
	bullets_spawned = 0;
	bullet_spawn_timer = 0;
}

function update() {
	assign_state();
	set_cylinder_rot()
	check_if_spawning_bullets();
	sw_animation();
	rope_fire_particle();
}

function assign_state() {
	switch (rev_state) {
		case "not in use":
			visible = false;
			break;
		case "spawn":
			visible = true;
			if (bullets_spawned == 0 && chambers_filled == 0) {
				start_spawning_bullets();
			}
			if (bullets_spawned == 6) {
				rev_state = "loadable";
			}
			if (hold_y < y) {
				y = lerp(y, hold_y, 0.1);
				cylinder_y = lerp(cylinder_y, hold_y + 10, 0.1);
			}
			break;
		case "loadable":
			obj_revolver_bullet.spawned = true;
			if (loadable_timer == -1) {
				loadable_timer = loadable_timer_max;
				cylinder_x = hold_x - 27; // reset all
				cylinder_y = hold_y + 10;
				chamber_rot = 0;
				chambers_filled = 0;
				spin_timer = def_spin_timer;
				spin_rev_timer = 60;
				bullets_spawned = 0;
				prespin_timer = 70;
				postaim_timer = 80;
				sw_frame = 0;
			}
			else if (loadable_timer == 0) {
				rev_state = "spin revving";
				loadable_timer = -1;
			}
			else {
				loadable_timer--;
			}
			
			if (next_chamber) {
				chamber_rot -= 3;
				next_chamber_timer--;
				if (next_chamber_timer <= 0) {
					next_chamber = false;
				}
			}
			break;
		case "spin revving":
			prespin_timer--;
			if (instance_number(obj_revolver_bullet) > 0) {
				with (obj_revolver_bullet) {
					destroying = true;
				}
			}
			if (prespin_timer <= 0) {
				chamber_rot += 2;
			
				if (spin_rev_timer > 0) {
					spin_rev_timer--;
				}
				else {
					rev_state = "spinning";
				}
			}
			break;
		case "spinning":
			chamber_rot -= spin_speed;

			if (spin_timer > 0) {
				spin_speed = lerp(spin_speed, spin_max_speed, spin_acceleration);
				spin_timer--;
			} 
			else {
				spin_speed = lerp(spin_speed, 0, spin_friction);

				if (abs(spin_speed) < 0.01) {
					spin_speed = 0;
					closed_cylinder_rot = (ceil(chamber_rot / 60)  - 1)* 60 - 30; //guarantees chamber is on top
					rev_state = "closing chamber";
				}
			}
			break;
		case "closing chamber":
			cylinder_x = lerp(cylinder_x, closed_cylinder_x, 0.1);
			cylinder_y = lerp(cylinder_y, closed_cylinder_y, 0.1);
			chamber_rot = lerp(chamber_rot, closed_cylinder_rot, 0.1);
			chamber_width = lerp(chamber_width, 1.1, 0.1);
			
			if (abs(cylinder_x - closed_cylinder_x) < 0.01) {
				rev_state = "aiming";
			}
			break;
		case "aiming":
			x = lerp(x, mouse_x, 0.2);
			x = clamp(x, 260, room_width - 260);
			y = lerp(y, aim_y, 0.2);
			aim_rot = lerp(aim_rot, (x - room_width/2)/2, 0.2);
			
			if (mouse_check_button_pressed(mb_left)) {
				var _damage = 225; // calc damage
				if (instance_exists(global.char)) {
					global.char.take_damage(_damage);
				}
				rev_state = "shooting";
			}
			
			break;
		case "shooting":
			if (postaim_timer > 0) {
				postaim_timer--;
				//show_debug_message(instance_number(obj_revolver_weapon));
				//show_debug_message(instance_number(obj_cb_character));
			}
			else {
				global.weapon_in_use = false;
				global.revolver_in_use = false;
				obj_card_manager.use_timer = 50;
				rev_state = "not in use";
				//reset everything
			}
			
			break;
	}
	
}

function set_cylinder_rot() {
	var _rot = ((chamber_rot mod 360) + 360) mod 360;
	cylinder_index = floor((_rot * 6) / (360 / 7)) mod 7;
}

function check_if_spawning_bullets() {
	if (spawning_bullets) {
		bullet_spawn_timer--;

		if (bullet_spawn_timer <= 0 && bullets_spawned < bullets_to_spawn) {
			var _i = bullets_spawned;
			var _spacing = 50;
			var _fall = 15;
			var _bullx = _i < 3 ? 190 + _i * _spacing : 210 + (_i - 3) * _spacing;
			var _bully = _i < 3 ? 270 : 300;

			var _bullet = instance_create_layer(_bullx, _bully - _fall, "Weapons", obj_revolver_bullet, {
				bullet_index: _i,
				init_x: _bullx,
				init_y: _bully,
				spawn_y: _bully - _fall,
				revolver: self
			});

			_bullet.visible = true;
			bullets_spawned++;
			bullet_spawn_timer = bullet_spawn_delay;
		}

		if (bullets_spawned == bullets_to_spawn) {
			spawning_bullets = false;
		}
	}
}

function sw_animation() {
	// tilting
	tilt_timer_sw += 0.05;
	sw_rot = sin(tilt_timer_sw) * 10;
	if (tilt_timer_sw > 2 * pi ) {
		tilt_timer_sw -= 2 * pi;
	}
	
	// ticking
	if (tick_timer_sw > 0) {
		tick_timer_sw--;
	}
	
	if (tick_timer_sw == 0) {
		sw_frame++;
		tick_timer_sw = 30;
	}
	else if (tick_timer_sw == 8) {
		sw_frame++;
	}
	
	if (sw_frame > 7) {
		sw_frame -= 8;
	}
}

function rope_fire_particle() {
	if (rev_state == "loadable") {
		if (rope_fire == noone) {
			rope_fire = part_system_create(part_rope_timer_fire);
		}
		else {
			var _fire_x = room_width/2 - 100 + 200 * (loadable_timer / loadable_timer_max) - 8
			_fire_x = clamp(_fire_x, 230, 540);
			part_system_position(rope_fire, _fire_x, 340);
		}
	}
	else if (rope_fire != noone) {
		part_system_clear(rope_fire);
		rope_fire = noone;
	}
}