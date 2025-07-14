randomize();
setup_timer = 180;
respawn_timer = 110;
player1_timer = setup_timer;
player2_timer = setup_timer;

player1_spawned = false;
player2_spawned = false;

with (obj_player1) {
	instance_destroy();
}
with (obj_player2) {
	instance_destroy();
}


function update() {
	respawn1();
	respawn2();
}

function respawn1() {
	if (!player1_spawned) {
		if (player1_timer > 0) {
			player1_timer--;
		}
		else {
			player1_timer = respawn_timer;
			var _player = instance_create_layer(irandom_range(10, room_width - 10), room_height, "Instances", obj_player1);
			player1_spawned = true;
			_player.y_vel = irandom_range(-11, -9)
			_player.h_vel = irandom_range(-4, 4);
			_player.v_state = "jumping";
			audio_play_sound(snd_respawn, true, false);
			//show_debug_message(instance_number(obj_player1));
		}
	}
}

function respawn2() {
	if (!player2_spawned) {
		if (player2_timer > 0) {
			player2_timer--;
		}
		else {
			player2_timer = respawn_timer;
			var _player = instance_create_layer(irandom_range(10, room_width - 10), room_height, "Instances", obj_player2);
			player2_spawned = true;
			_player.y_vel = irandom_range(-11, -9)
			_player.h_vel = irandom_range(-4, 4);
			_player.v_state = "jumping";
			audio_play_sound(snd_respawn, true, false);
		}
	}
}