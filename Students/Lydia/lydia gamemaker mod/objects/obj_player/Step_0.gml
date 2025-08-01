
var move_step = 3;
var move = false;

depth = -y;


var UP = 1;
var DOWN = 2;
var LEFT = 3;
var RIGHT = 4;


var going_up = keyboard_check(ord("W"));
var going_down = keyboard_check(ord("S"));
var going_left = keyboard_check(ord("A"));
var going_right = keyboard_check(ord("D"));



if (keyboard_check_pressed(ord("W"))) dir = UP;
if (keyboard_check_pressed(ord("S"))) dir = DOWN;
if (keyboard_check_pressed(ord("A"))) dir = LEFT;
if (keyboard_check_pressed(ord("D"))) dir = RIGHT;

if(global.rmw_talking|| global.bwm_talking){
	going_down = false;
	going_up = false;
	going_left = false;
	going_right = false; 
	dir = DOWN;
}
if (going_down) {
    var y_target = y + move_step;
    if (!place_meeting(x, y_target, obj_house) &&
        !place_meeting(x, y_target, obj_rmw) &&
        !place_meeting(x, y_target, obj_bwm) &&
		!place_meeting(x, y_target, obj_house_outside)) {
        y = y_target;
        move = true;
    }
}

if (going_up) {
    var y_target = y - move_step;
    if (!place_meeting(x, y_target, obj_house) &&
        !place_meeting(x, y_target, obj_rmw) &&
        !place_meeting(x, y_target, obj_bwm) &&
		!place_meeting(x, y_target, obj_house_outside)) {
        y = y_target;
        move = true;
    }
}

if (going_left) {
    var x_target = x - move_step;
    if (!place_meeting(x_target, y, obj_house) &&
        !place_meeting(x_target, y, obj_rmw) &&
        !place_meeting(x_target, y, obj_bwm) &&
		!place_meeting(x_target, y, obj_house_outside)) {
        x = x_target;
        move = true;
    }
}

if (going_right) {
    var x_target = x + move_step;
    if (!place_meeting(x_target, y, obj_house) &&
        !place_meeting(x_target, y, obj_rmw) &&
        !place_meeting(x_target, y, obj_bwm)&&
		!place_meeting(x_target, y, obj_house_outside)) {
        x = x_target;
        move = true;
    }
}


sprite_index = spr_player_walk;

if (move) {
    image_speed = 1;

    switch (dir) {
        case DOWN:
            if (image_index < 4 || image_index > 8) image_index = 4;
            break;
        case UP:
            if (image_index < 14 || image_index > 18) image_index = 14;
            break;
        case LEFT:
            if (image_index < 24 || image_index > 28) image_index = 24;
            break;
        case RIGHT:
            if (image_index < 36 || image_index > 40) image_index = 36;
            break;
    }
} else {
    image_speed = 1;

    switch (dir) {
        case DOWN:
            if (image_index < 0 || image_index > 4) image_index = 0;
            break;
        case UP:
            if (image_index < 9 || image_index > 13) image_index = 9;
            break;
        case LEFT:
            if (image_index < 19 || image_index > 23) image_index = 19;
            break;
        case RIGHT:
            if (image_index < 30 || image_index > 34) image_index = 30;
            break;
    }
}


if (place_meeting(x,y,obj_glasses) ){
	global.player_have_glasses = true; 
	instance_destroy(obj_glasses);
	audio_play_sound(snd_glasses,0,false);
}