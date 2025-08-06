if (place_meeting(x, y, obj_player)) {
    depth = -10001;
    var player = instance_place(x, y, obj_player);
} else {
    depth = 10;
}