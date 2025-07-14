randomize();
image_speed = 0;
visible = true;
image_xscale = -1;
image_yscale = 1;

v_state = "jumping";
bounce_val = -5.5;

anim_timer = 5;

//horizontal
x_vel = 0;
x_speed = 0.3;
max_x_vel = 3.8;
x_bounce = 3.5;

//vertical
y_vel = bounce_val*2;
grav = 0.25;
max_y_vel = 12;

//hit
is_hit = false;

function create_star_part() {
	var _stars = part_system_create();
	part_system_depth(_stars, -100);
	
	var _part = part_type_create();
	part_type_sprite(_part, spr_starpart, false, false, false);
	part_type_size(_part, 0.8, 1, -0.03, 0);
	part_type_alpha2(_part, 1, 0);
	part_type_speed(_part, 7, 8, -0.02, 0);
	part_type_direction(_part, 0, 360, 0, 0);
	
	var _num = irandom_range(6, 10);
	for (var _i = 0; _i < _num; _i++) {
		part_particles_create(_stars, x, y, _part, 1);
	}
}

function die() {
	audio_play_sound(snd_death, true, false);
	if (!self.is_hit) {
		create_star_part();
	}
	with (obj_player_manager) {
		player1_timer = respawn_timer;
	}
	
	obj_player_manager.player1_spawned = false;
	global.p1_score--;
	instance_destroy();
}

function update() {
	manage_state();
	apply_gravity();
	bounce_walls();
	if (!self.is_hit) {
		self.apply_controls(); 
		self.collide();
	}
		
}

function apply_gravity() {
	y_vel += grav;
	y_vel = clamp(y_vel, -max_y_vel, max_y_vel);
	y += y_vel;
}

/* debug func
function jump() {
	if (keyboard_check_pressed(vk_space) && v_state == "falling") {
		y_vel += bounce_val;
	}
}*/

function apply_controls() {
	if (keyboard_check(ord("D"))) {
		image_xscale = -1;
		x_vel += x_speed;
	}
	else if (keyboard_check(ord("A"))) {
		image_xscale = 1;
		x_vel -= x_speed;
	}
	else {
		if (abs(x_vel) > 0) {
			x_vel -= sign(x_vel) * 0.2;
		}
	}
	
	x += x_vel;
	x_vel = clamp(x_vel, -max_x_vel, max_x_vel);
}

function bounce_walls() {
	if (x < 5) {
		image_xscale = -1;
		x_vel = x_bounce;	
		audio_play_sound(snd_wall, true, false);
	}
	else if (x > room_width - 5) {
		image_xscale = 1;
		x_vel = -x_bounce;
		audio_play_sound(snd_wall, true, false);
	}
}

function manage_state() {
	switch (v_state) {
		case "jumping":
			if (y_vel >= 0) {
				v_state = "falling";
				anim_timer = 5;
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
			if (y_vel < 0) {
				v_state = "jumping";
				anim_timer = 5;
			}
			if (anim_timer > 0) {
				image_index = 1;
				anim_timer--;
			}
			else {
				image_index = 2;
			}
			if (place_meeting(x, y - 3, obj_bottom_shadow)) {
				self.die();
				//show_debug_message("dead");
			}
			if (place_meeting(x, y + 1, obj_cloud)) {
				audio_play_sound(snd_bounce, true, false);
				var _cloud = instance_nearest(x, y, obj_cloud);
				_cloud.destroyed = true;
				y_vel = bounce_val;
				v_state = "jumping";
				anim_timer = 5;
			}	
			break;
		case "hit":
			y_vel = 6;
			if (!self.is_hit) {
				self.is_hit = true;
				create_star_part();
			}
			image_yscale = -1;
			
			if (place_meeting(x, y - 3, obj_bottom_shadow)) {
				self.die();
			}
			break;
	}
	
}

function collide() {
	if (v_state == "falling") {
		var _p = instance_place(x, y+8, obj_player2);
		if (_p != noone && _p != self && _p.y > y + 12) {
			_p.v_state = "hit";
			global.p1_score++;
			audio_play_sound(snd_hit, true, false);
		}
	}
}