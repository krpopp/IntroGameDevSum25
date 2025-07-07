
camera_id = camera_create_view(0, 0, 640, 360);
view_camera[0] = camera_id;
view_visible[0] = true;

// def
camera_default_x = 640;
camera_default_y = 360;
approx_scale_def = 0.36;

camera_target_width = camera_default_x * approx_scale_def * 2
camera_target_height = camera_default_y * approx_scale_def * 2;

camera_target_x = room_width / 2 - camera_target_width / 2;
camera_target_y = room_height / 2 - camera_target_height / 2 - 40;
camera_speed = 0.1;

function update() {
	check_cb_state();
}


function check_cb_state() {
	var cam = view_camera[0];
	
	var cam_x = camera_get_view_x(cam);
	var cam_y = camera_get_view_y(cam);
		
	var view_w = camera_get_view_width(cam);
	var view_h = camera_get_view_height(cam);
	
	var _rev = global.weapon_instance;
	if (instance_exists(_rev) && (_rev.rev_state == "aiming" || _rev.rev_state == "shooting")) {

		var new_x = lerp(cam_x, camera_target_x, camera_speed);
		var new_y = lerp(cam_y, camera_target_y, camera_speed);
		
		var new_w = lerp(view_w, camera_target_width, camera_speed);
		var new_h = lerp(view_h, camera_target_height, camera_speed);

		camera_set_view_pos(cam, new_x, new_y);
		camera_set_view_size(cam, new_w, new_h);

	}
	else {

		var new_x = lerp(cam_x, 0, camera_speed);
		var new_y = lerp(cam_y, 0, camera_speed);
		
		var new_w = lerp(view_w, camera_default_x, camera_speed);
		var new_h = lerp(view_h, camera_default_y, camera_speed);

		camera_set_view_pos(cam, new_x, new_y);
		camera_set_view_size(cam, new_w, new_h);
	}
}