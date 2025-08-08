var player = instance_find(obj_player, 0);
if (player != noone) {
    var pickup_distance = 24;
    if (point_distance(x, y, player.x, player.y) < pickup_distance) {
        ds_list_add(player.inventory, "key");
        audio_play_sound(snd_key, 1, false);
        instance_destroy();
    }
}