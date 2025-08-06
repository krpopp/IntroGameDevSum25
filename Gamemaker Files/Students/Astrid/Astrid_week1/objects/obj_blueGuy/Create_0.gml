move_spd = 4;
message = false;

//set a distance as half of the camera width and height
//so that we can use it later to have the obj at the center of camera
half_camera_width = camera_get_view_width(view_camera[0])/2;
half_camera_height = camera_get_view_height(view_camera[0])/2;

//to have the dialogue disappear when away from npc1
distance_between_npc1_x = obj_npc1.x - x;
distance_between_npc1_y = obj_npc1.y - y;

distance_between_npc2_x = obj_npc2.x - x;
distance_between_npc2_y = obj_npc2.y - y;

//for updating the textbox
chatbox_visible = false;

