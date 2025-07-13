// code copied from assignment1

camera_id = camera_create_view(0, 0, 273, 170);
view_camera[0] = camera_id;
view_visible[0] = true;

cam_w = 273;
cam_h = 170;
cam_speed = 0.5;

//camera_set_view_pos(view_camera[0], 452, -300);

function update() {
	set_camera();
}

function set_camera() {
	var _cam = view_camera[0];
	
	var _cam_y = camera_get_view_y(_cam);
	
	var _update_y = room_height - cam_h + 12;
	if (instance_exists(obj_player1)) {
		_update_y = lerp(_cam_y, obj_player1.y - cam_h / 2 + 20, cam_speed);
		_update_y = clamp(_update_y, 0, room_height - cam_h + 12);
	}
	else {
		_update_y = lerp(_cam_y, room_height - cam_h + 12, cam_speed);
	}
	
	
	camera_set_view_pos(_cam, 0, _update_y);
}