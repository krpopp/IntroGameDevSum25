randomize();
respawn_timer = 60;
player1_timer = respawn_timer;
player2_timer = respawn_timer;

with (obj_player1) {
	instance_destroy();
}


function update() {
	respawn();
}

function respawn() {
	if (instance_number(obj_player1) == 0 ) {
		if (player1_timer > 0) {
			player1_timer--;
		}
		else {
			var _player = instance_create_layer(irandom_range(10, room_width - 10), room_height - 100, "Instances", obj_player1);
			_player.y_vel = -10;
			//show_debug_message(instance_number(obj_player1));
		}
	}
}