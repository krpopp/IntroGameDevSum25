var red = instance_exists(obj_red) ? instance_find(obj_red, 0) : noone;
var green = instance_exists(obj_green) ? instance_find(obj_green, 0) : noone;

var center_y;

if (red != noone && green != noone) {
    center_y = (red.y + green.y) / 2;
} else if (red != noone) {
    center_y = red.y;
} else if (green != noone) {
    center_y = green.y;
} else {
    center_y = room_height / 2;
}

var view_height = 512;
var target_y = clamp(center_y - view_height / 2, 0, room_height - view_height);

camera_set_view_pos(view_camera[0], 0, target_y);
