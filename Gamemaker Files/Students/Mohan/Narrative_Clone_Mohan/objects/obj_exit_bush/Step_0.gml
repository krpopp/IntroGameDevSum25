if (place_meeting(x, y, obj_player)) {
    depth = -10001;
    var player = instance_place(x, y, obj_player);
    if (player != noone && ds_list_find_index(player.inventory, "key") != -1) {
        audio_play_sound(snd_exit, 1, false);
        room_goto(rm_start);
    }
} else {
    depth = 10;
}