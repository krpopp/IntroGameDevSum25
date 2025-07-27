// CREATE EVENT
target = obj_player; // Object to follow
cam_width = 320;     // Camera view width
cam_height = 180;    // Camera view height

// Set up the camera
view_enabled = true;
view_visible[0] = true;
view_wport[0] = 256;  // Window width
view_hport[0] = 192;   // Window height
view_camera[0] = camera_create_view(0, 0, cam_width, cam_height);