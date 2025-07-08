var speedpl = 3; 
var move_step = 3;


var going_up = false;
var going_down = false;
var going_left = false;
var going_right = false;


depth = -y;







if (keyboard_check_pressed(83)){ 
    dir = 2; 
}//s

else if (keyboard_check_pressed(87)) {
    dir = 1; 
}//w

else if (keyboard_check_pressed(65)) { 
    dir = 3; 
}//a

else if (keyboard_check_pressed(68)) { 
    dir = 4; 
}//d

if (keyboard_check(83)) { 
    going_down = true;
}

if (keyboard_check(87)) { 
    going_up = true;
}

if (keyboard_check(65)) { 
    going_left = true;
}

if (keyboard_check(68)) { 
    going_right = true;
}

if (going_down) { 
	var y_target = y + move_step;
	
	if (!place_meeting(x,y_target, obj_house)&& !place_meeting(x, y_target, obj_npcorange)&& !place_meeting(x, y_target, obj_npcblue)){
    y = y_target;
	y_target = y + move_step; 
	
	}
}

if (going_up) { 
    var y_target = y - move_step;
	
	if (!place_meeting(x,y_target, obj_house) && !place_meeting(x, y_target, obj_door) && !place_meeting(x, y_target, obj_npcorange)&& !place_meeting(x, y_target, obj_npcblue)){
    y = y_target;
	y_target = y - move_step; 
	
	}
	
	if (place_meeting(x, y_target, obj_door) && key_get == true){
	instance_destroy(obj_door);
	audio_play_sound(snd_door,1,false);
}
}

if (going_left) { 
    var x_target = x - move_step;
	
	if (!place_meeting(x_target,y, obj_house)&& !place_meeting(x_target, y, obj_npcorange)&& !place_meeting(x, y, obj_npcblue)){
    x = x_target;
	x_target = x - move_step; 
	
	}
}

if (going_right) { 
    var x_target = x + move_step;
	
	if (!place_meeting(x_target,y, obj_house)&& !place_meeting(x_target, y, obj_npcorange)&& !place_meeting(x_target, y, obj_npcblue)){
    x = x_target;
	x_target = x + move_step; 
	
	}
}

if (place_meeting(x, y, obj_key)){
	instance_destroy(obj_key);
	key_get = true;
	audio_play_sound(snd_key,1,false);
}





if (dir == 1) { 
    sprite_index = spr_player_walk; 
    if (image_index < 4) {
        image_index = 4;
    } else if (image_index >= 8) {
        image_index = 4;
    }
}

else if (dir == 2) { 
    sprite_index = spr_player_walk; 
    if (image_index < 0) {
        image_index = 0;
    } else if (image_index >= 4) {
        image_index = 0;
    }
}

else if (dir == 3) { 
    sprite_index = spr_player_walk; 
    if (image_index < 8) {
        image_index = 8;
    } else if (image_index >= 12) {
        image_index = 8;
    }
}

else if (dir == 4) { 
    sprite_index = spr_player_walk; 
    if (image_index < 12) {
        image_index = 12;
    } else if (image_index >= 16) {
        image_index = 12;
    }
}

if (!keyboard_check(83) && !keyboard_check(87) && !keyboard_check(65) && !keyboard_check(68)) {
    dir = 0;
}

if (!keyboard_check(83)) { 
    going_down = false; 
}

if (!keyboard_check(87)) { 
    going_up = false;
}

if (!keyboard_check(65)) { 
    going_left = false;
}

if (!keyboard_check(68)) { 
    going_right = false;
}

if (dir == 0) {
    sprite_index = spr_player_walk; 

    if (image_index < 4) {
        image_index = 0; 
    }
    else if (image_index >= 4 && image_index < 8) {
        image_index = 4; 
    }
    else if (image_index >= 8 && image_index < 12) {
        image_index = 8; 
    }
    else if (image_index >= 12 && image_index < 16) {
        image_index = 12; 
    }
}

if(place_meeting(x, y, obj_exit)){
	room_goto(Room2);
	audio_play_sound(snd_exit,1,false);
}


