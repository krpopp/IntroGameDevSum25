var green = instance_exists(obj_green) ? instance_find(obj_green, 0) : noone;
var red = instance_exists(obj_red) ? instance_find(obj_red, 0) : noone;

var y_mid;
if (green != noone && red != noone) {
    y_mid = (green.y + red.y) / 2;
} else if (green != noone) {
    y_mid = green.y;
} else if (red != noone) {
    y_mid = red.y;
} else {
    exit;
}

var view_height = camera_get_view_height(view_camera[0]);

var cam_y = y_mid - view_height / 2;
cam_y = min(cam_y, room_height - view_height); 

camera_set_view_pos(view_camera[0], 0, cam_y);