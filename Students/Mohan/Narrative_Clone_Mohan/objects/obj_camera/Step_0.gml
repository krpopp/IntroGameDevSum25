if (!camera_pan_done) {
    camera_x = lerp(camera_x, obj_player.x, 0.15);
	camera_y = lerp(camera_y, obj_player.y, 0.15);
	camera_set_view_pos(camera_id, camera_x - 400, camera_y - 225);
} else {
    camera_x = obj_player.x;
    camera_y = obj_player.y;
}

camera_set_view_pos(camera_id, camera_x - 400, camera_y - 225);
