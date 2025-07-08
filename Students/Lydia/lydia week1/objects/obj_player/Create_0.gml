var speedpl = 3; 
var going_up = false;
var going_down = false;
var going_left = false;
var going_right = false;
var dir = 0; 
var timer = 120;
var key_get = false;


if (keyboard_check(83)) { // s
    going_down = true;
    sprite_index = spr_player_walk;
    
    if (image_index < 0) {
        image_index = 0;
    } else if (image_index >= 4) {
        image_index = 0;
    }
}

if (keyboard_check(87)) { // w
    going_up = true;
    sprite_index = spr_player_walk;
    
    if (image_index < 4) {
        image_index = 4;
    } else if (image_index >= 8) {
        image_index = 4;
    }
}

if (keyboard_check(65)) { // a
    going_left = true;
    sprite_index = spr_player_walk;
   
    if (image_index < 8) {
        image_index = 8;
    } else if (image_index >= 12) {
        image_index = 8;
    }
}

if (keyboard_check(68)) { // d
    going_right = true;
    sprite_index = spr_player_walk;
    
    if (image_index < 12) {
        image_index = 12;
    } else if (image_index >= 16) {
        image_index = 12;
    }
}


if (going_down) {
    y += speedpl; 
}

if (going_up) {
    y -= speedpl; 
}

if (going_left) {
    x -= speedpl; 
}

if (going_right) {
    x += speedpl; 
}


if (!keyboard_check(83) && !keyboard_check(87) && !keyboard_check(65) && !keyboard_check(68)) {
    going_up = false;
    going_down = false;
    going_left = false;
    going_right = false;
    
    
    sprite_index = spr_player_walk;
    
   
    if (image_index >= 0 && image_index < 4) {
        image_index = 0;  
    } else if (image_index >= 4 && image_index < 8) {
        image_index = 4;  
    } else if (image_index >= 8 && image_index < 12) {
        image_index = 8;  
    } else if (image_index >= 12 && image_index < 16) {
        image_index = 12; 
    }
}
