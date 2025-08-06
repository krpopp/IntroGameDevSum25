var green_exists = instance_exists(obj_player_green);
var red_exists = instance_exists(obj_player_red);


var y_mid;


if (green_exists && red_exists) {
    y_mid = (obj_player_green.y + obj_player_red.y) / 2;
} else if (green_exists) {
    y_mid = obj_player_green.y;
} else if (red_exists) {
    y_mid = obj_player_red.y;
} else {
    exit;
}
var view_height = 400; 

var cam_y = (obj_player_green.y + obj_player_red.y) / 2;

var max_cam_y = room_height - view_height / 2;

cam_y = clamp(cam_y, 0, max_cam_y);


camera_set_view_pos(view_camera[0], 0, cam_y - view_height / 2);
