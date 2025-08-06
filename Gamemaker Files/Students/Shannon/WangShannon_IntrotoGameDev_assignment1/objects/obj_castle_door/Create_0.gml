image_speed = 0;
depth = obj_player.depth + 50;
unlocked = false;
visible = true;

function update() {
	check_if_unlocked();
}

function check_if_unlocked() {
	if (place_meeting(x, y + 2, obj_player) && global.key_picked_up && !unlocked) {
		audio_play_sound(snd_door, 0, false);
		visible = false;
		x -= 50;
		unlocked = true;
	}
}
