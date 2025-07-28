window_set_fullscreen(true);

camera_id = camera_create_view(100, 200, 477, 320);
view_camera[0] = camera_id;
view_visible[0] = true;

cam_w = 477;
cam_h = 320;
cam_speed = 0.5;

//camera_set_view_pos(view_camera[0], 452, -300);

function update() {
	if (room == rm_outside) {
		set_camera();
	}
}

function set_camera() {
	var _cam = view_camera[0];
	
	var _cam_x = camera_get_view_x(_cam);
	var _cam_y = camera_get_view_y(_cam);
	
	var _update_x = lerp(_cam_x, obj_player.x - cam_w / 2, cam_speed);
	var _update_y = lerp(_cam_y, obj_player.y - cam_h / 2 + 20, cam_speed);
	
	camera_set_view_pos(_cam, _update_x, _update_y);
}