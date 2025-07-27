

// basics
player_spd = 1.2;
player_idle = true;
player_dir = "down";
image_speed = 0;
image_xscale = 0.9;
image_yscale = 0.9;

// walk animation
walk_timer = 5;
anim = 0;
down_anim = [1, 0, 2, 0];
up_anim = [4, 3, 5, 3];
left_anim = [7, 8, 9, 6];
right_anim = [11, 12, 13, 10];

// collision checks
coll_objs = [obj_castle, obj_castle_door, obj_npc1, obj_npc2];
can_move_down = true;
can_move_up = true;
can_move_right = true;
can_move_left = true;

function walk() {
	switch (player_dir) {
		case "down": image_index = down_anim[anim]; break;
		case "up": image_index = up_anim[anim]; break;
		case "right": image_index = right_anim[anim]; break;
		case "left": image_index = left_anim[anim]; break;
	}
	//show_debug_message(image_index);
	
	if (anim < 3) {
		anim++;
	}
	else {
		anim = 0;
	}
}

function update() {
	player_movement();
	player_animation();;
	check_collisions();
}

function player_movement() {
	if (keyboard_check(ord("W")) || keyboard_check(vk_up)) {
		player_idle = false;
		player_dir = "up";
		if (can_move_up) {
			y -= player_spd;
		}
	}
	if (keyboard_check(ord("S")) || keyboard_check(vk_down)) {
		player_idle = false;
		player_dir = "down";
		if (can_move_down) {
			y += player_spd;
		}
	}
	if (keyboard_check(ord("A")) || keyboard_check(vk_left)) {
		player_idle = false;
		player_dir = "left";
		if (can_move_left) {
			x -= player_spd;
		}
		
	}
	if (keyboard_check(ord("D")) || keyboard_check(vk_right)) {
		player_idle = false;
		player_dir = "right";
		if (can_move_right) {
			x += player_spd;
		}
	}
	if (!keyboard_check(ord("W")) && !keyboard_check(ord("A")) && !keyboard_check(ord("S"))
	&& !keyboard_check(ord("D")) && !keyboard_check(vk_up) && !keyboard_check(vk_down)
	&& !keyboard_check(vk_left) && !keyboard_check(vk_right)){
		player_idle = true;
		anim_index = 0;
	}
}

function player_animation() {	
	if (player_idle) {
		switch (player_dir) {
			case "down": image_index = 0; break;
			case "up": image_index = 3; break;
			case "left": image_index = 6; break;
			case "right": image_index = 10; break;
		}
	}
	else {
		if (walk_timer > 0) {
			walk_timer--;
		}
		else {
			walk();
			walk_timer = 7;
		}
	}
}

function check_collisions() {
	
	var _down_array = [0, 0, 0, 0];
	var _up_array = [0, 0, 0, 0];
	var _right_array = [0, 0, 0, 0];
	var _left_array = [0, 0, 0, 0];
	
	for (var _i = 0; _i < array_length(coll_objs); _i++) {
		var _obj = coll_objs[_i];
		
		_down_array[_i] += place_meeting(x, y + 2, _obj) ? false : true;
		_up_array[_i] += place_meeting(x, y - 2, _obj) ? false : true;
		_right_array[_i] += place_meeting(x + 2, y, _obj) ? false : true;
		_left_array[_i] += place_meeting(x - 2, y, _obj) ? false : true;
	}
	
	can_move_down = array_contains(_down_array, false) ? false : true;
	can_move_up = array_contains(_up_array, false) ? false : true;
	can_move_right = array_contains(_right_array, false) ? false : true;
	can_move_left = array_contains(_left_array, false) ? false : true;
}