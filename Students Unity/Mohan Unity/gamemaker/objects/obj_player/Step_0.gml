var movementX = 0;
var movementY = 0;

if (keyboard_check(ord("W"))) {
    movementY = -move_speed;
} else if (keyboard_check(ord("S"))) {
    movementY = move_speed;
} else {
    movementY = 0;
}

if (keyboard_check(ord("A"))) {
    movementX = -move_speed;
} else if (keyboard_check(ord("D"))) {
    movementX = move_speed;
} else {
    movementX = 0;
}

x += movementX;
if (place_meeting(x, y, obj_walls) || place_meeting(x, y, obj_npc_orange) || place_meeting(x, y, obj_npc_brown)) {
    x -= movementX;
}

y += movementY;
if (place_meeting(x, y, obj_walls) || place_meeting(x, y, obj_npc_orange) || place_meeting(x, y, obj_npc_brown)) {
    y -= movementY;
}

var animationFrame = floor(current_time / 100) mod 4;

if (movementY > 0) {
    direction_facing = "down";
    image_index = 0 + animationFrame;
} else if (movementY < 0) {
    direction_facing = "up";
    image_index = 4 + animationFrame;
} else if (movementX < 0) {
    direction_facing = "left";
    image_index = 8 + animationFrame;
} else if (movementX > 0) {
    direction_facing = "right";
    image_index = 12 + animationFrame;
} else {
    if (direction_facing == "down")      image_index = 0;
    else if (direction_facing == "up")   image_index = 4;
    else if (direction_facing == "left") image_index = 8;
    else if (direction_facing == "right")image_index = 12;
}

var nearestKey = instance_nearest(x, y, obj_key);
if (nearestKey != noone && point_distance(x, y, nearestKey.x, nearestKey.y) < key_pickup_distance) {
    with (nearestKey) instance_destroy();
    ds_list_add(inventory, "key");
    audio_play_sound(snd_key, 1, false);
}

if (ds_list_find_index(inventory, "key") != -1 && distance_to_object(obj_door) < door_check_distance) {
    var nearestDoor = instance_nearest(x, y, obj_door);
    if (nearestDoor != noone) {
        with (nearestDoor) instance_destroy();
        audio_play_sound(snd_door, 1, false);
    }
}

var npcOrange = instance_nearest(x, y, obj_npc_orange);
var npcBrown  = instance_nearest(x, y, obj_npc_brown);
var shouldShowText = false;

if (npcOrange != noone && point_distance(x, y, npcOrange.x, npcOrange.y) < responsive_range) {
    shouldShowText = true;
    if (keyboard_check_pressed(vk_space)) {
        show_dialogue(npcOrange, ds_list_find_index(inventory, "key") != -1
            ? "Great. My friend will tell you how to escape this place."
            : "The key is some way to the east of here.");
    }
}
else if (npcBrown != noone && point_distance(x, y, npcBrown.x, npcBrown.y) < responsive_range) {
    shouldShowText = true;
    if (keyboard_check_pressed(vk_space)) {
        show_dialogue(npcBrown, "The exit is north of here, hidden behind a tree.");
    }
}

if (!shouldShowText) {
    hide_dialogue();
}