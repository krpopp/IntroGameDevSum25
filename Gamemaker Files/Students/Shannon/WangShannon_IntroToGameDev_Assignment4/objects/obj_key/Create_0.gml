global.key_picked_up = false;
visible = true;

function update() {
	check_if_picked_up();
}

function check_if_picked_up() {
	if (place_meeting(x, y, obj_player) && !global.key_picked_up) {
		audio_play_sound(snd_key, 0, false);
		global.key_picked_up = true;
		visible = false;
	}
}