if (instance_exists(target)) {
    // Calculate camera position (centered on player)
    var cam_x = target.x - (cam_width / 2);
    var cam_y = target.y - (cam_height / 2);
    
    // Keep camera within room bounds (optional)
    cam_x = clamp(cam_x, 0, room_width - cam_width);
    cam_y = clamp(cam_y, 0, room_height - cam_height);
    
    // Update camera position
    camera_set_view_pos(view_camera[0], cam_x, cam_y);
}

if (instance_exists(target)) {
    var cam_x = target.x - (cam_width / 2);
    var cam_y = target.y - (cam_height / 2);
    camera_set_view_pos(view_camera[0], cam_x, cam_y);
}