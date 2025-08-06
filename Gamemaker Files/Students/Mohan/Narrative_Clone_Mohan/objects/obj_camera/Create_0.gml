target_y = obj_player.y;
camera_y = obj_player.y - 200; 
camera_x = obj_player.x;
camera_pan_done = false;

var cam_width = 800;
var cam_height = 450;

camera_id = camera_create_view(camera_x - cam_width / 2, camera_y - cam_height / 2, cam_width, cam_height, 0, -1, 0, 0, cam_width, cam_height);
view_camera[0] = camera_id;
view_visible[0] = true;