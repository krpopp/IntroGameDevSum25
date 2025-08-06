depth = -y;
if (place_meeting(x, y, obj_player) && !was_touching) {
    audio_play_sound(snd_leaves, 1, false);
    was_touching = true;
} else if (!place_meeting(x, y, obj_player)) {
    was_touching = false;
}