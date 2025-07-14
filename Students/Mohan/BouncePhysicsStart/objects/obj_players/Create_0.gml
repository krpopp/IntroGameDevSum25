if (object_index == obj_players && !variable_global_exists("score_red")) {
    global.score_red = 0;
    global.score_green = 0;
}

if (object_index == obj_players) {
    instance_create_layer(room_width * 0.3, room_height + 20, "Instances", obj_red);
    instance_create_layer(room_width * 0.7, room_height + 20, "Instances", obj_green);
}

if (object_index != obj_players) {
    x_vel = 0;
    y_vel = -30;
    r_x = 0;
    r_y = 0;
    grav = 0.8;
    bounce_vel = -15;
    accel = 1.5;
    state = "start";
    born_timer = 0;
    death_timer = 0;
    player_name = object_index;
    image_index = 1;
    image_speed = 0;
}

depth = -1000;
