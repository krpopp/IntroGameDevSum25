depth = obj_player.depth + 50;

function update() {
	check_if_touching_player();
}

function check_if_touching_player() {
	if (place_meeting(x, y, obj_player)) {
		audio_play_sound(snd_exit, 0, false);
		room_goto(rm_start);
	}
}

//hello