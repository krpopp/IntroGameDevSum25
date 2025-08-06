var player = instance_find(obj_player, 0);
if (player != noone) {
    var door_check_distance = 3;
    if (point_distance(x, y, player.x, player.y) < door_check_distance) {
        // Check if player has key
        if (ds_list_find_index(player.inventory, "key") != -1) {
            // Remove key from inventory
            ds_list_delete(player.inventory, ds_list_find_index(player.inventory, "key"));
            audio_play_sound(snd_door, 1, false);
            instance_destroy();
        }
    }
}