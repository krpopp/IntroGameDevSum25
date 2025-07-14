// Initialize global scores once (only for controller instance)
if (object_index == obj_players && !variable_global_exists("score_red")) {
    global.score_red = 0;
    global.score_green = 0;
}

// Only spawn if this is the controller instance
if (object_index == obj_players) {
    instance_create_layer(room_width * 0.3, room_height + 20, "Instances", obj_red);
    instance_create_layer(room_width * 0.7, room_height + 20, "Instances", obj_green);
}

// Player variables (for children)
if (object_index != obj_players) {
    // Movement and physics
    x_vel = 0;
    y_vel = -20;
    r_x = 0;
    r_y = 0;
    grav = 0.35;
    bounce_vel = -10;
    accel = 0.4;
    
    // State control
    state = "start";
    born_timer = 0;
    death_timer = 0;
    
    // Store player type for respawning
    player_name = object_index;
    
    // Sprite
    image_index = 1;
    image_speed = 0;
}