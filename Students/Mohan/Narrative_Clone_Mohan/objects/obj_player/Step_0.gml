// Movement
var move_x = 0;
var move_y = 0;

if (keyboard_check(ord("W"))) {
    move_y = -move_speed;
} else if (keyboard_check(ord("S"))) {
    move_y = move_speed;
} else {
    move_y = 0;
}

if (keyboard_check(ord("A"))) {
    move_x = -move_speed;
} else if (keyboard_check(ord("D"))) {
    move_x = move_speed;
} else {
    move_x = 0;
}

// Collision
x += move_x;
if (place_meeting(x, y, obj_walls) || place_meeting(x, y, obj_npc_orange) || place_meeting(x, y, obj_npc_brown)) {
    x -= move_x;
}

y += move_y;
if (place_meeting(x, y, obj_walls) || place_meeting(x, y, obj_npc_orange) || place_meeting(x, y, obj_npc_brown)) {
    y -= move_y;
}

// Direction and animation
var frame = floor(current_time / 100) mod 4;

if (move_y > 0) {
    direction_facing = "down";
    image_index = 0 + frame;
} else if (move_y < 0) {
    direction_facing = "up";
    image_index = 4 + frame;
} else if (move_x < 0) {
    direction_facing = "left";
    image_index = 8 + frame;
} else if (move_x > 0) {
    direction_facing = "right";
    image_index = 12 + frame;
} else {
    if (direction_facing == "down")      image_index = 0;
    else if (direction_facing == "up")   image_index = 4;
    else if (direction_facing == "left") image_index = 8;
    else if (direction_facing == "right")image_index = 12;
}


// Key Collection
var nearest_key = instance_nearest(x, y, obj_key);
if (nearest_key != noone && point_distance(x, y, nearest_key.x, nearest_key.y) < key_pickup_distance) {
    with (nearest_key) instance_destroy();
    ds_list_add(inventory, "key");
    audio_play_sound(snd_key, 1, false);
}

// Door detection
if (ds_list_find_index(inventory, "key") != -1 && distance_to_object(obj_door) < door_check_distance) {
    var nearest_door = instance_nearest(x, y, obj_door);
    if (nearest_door != noone) {
        with (nearest_door) instance_destroy();
        audio_play_sound(snd_door, 1, false);
    }
}

// Dialogue
var npc_orange = instance_nearest(x, y, obj_npc_orange);
var npc_brown  = instance_nearest(x, y, obj_npc_brown);
var show_text = false;

if (npc_orange != noone && point_distance(x, y, npc_orange.x, npc_orange.y) < responsive_range) {
    show_text = true;
    if (keyboard_check_pressed(vk_space)) {
        show_dialogue(npc_orange, ds_list_find_index(inventory, "key") != -1
            ? "Great. My friend will tell you how to escape this place."
            : "The key is some way to the east of here.");
    }
}
else if (npc_brown != noone && point_distance(x, y, npc_brown.x, npc_brown.y) < responsive_range) {
    show_text = true;
    if (keyboard_check_pressed(vk_space)) {
        show_dialogue(npc_brown, "The exit is north of here, hidden behind a tree.");
    }
}


if (!show_text) {
    hide_dialogue();
}