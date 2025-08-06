event_inherited();

//@Override
function die() {
	audio_play_sound(snd_death, true, false);
	if (!self.is_hit) {
		create_star_part();
	}
	with (obj_player_manager) {
		player2_timer = respawn_timer;
	}
	obj_player_manager.player2_spawned = false;
	global.p2_score--;
	instance_destroy();
}

//@Override
function apply_controls() {
	if (keyboard_check(vk_right)) {
		image_xscale = -1;
		x_vel += x_speed;
	}
	else if (keyboard_check(vk_left)) {
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

//@Override
function collide() {
	if (v_state == "falling") {
		var _p = instance_place(x, y+8, obj_player1);
		if (_p != noone && _p != self && _p.y > y + 12) {
			_p.v_state = "hit";
			audio_play_sound(snd_hit, true, false);
			global.p2_score++;
		}
	}
}