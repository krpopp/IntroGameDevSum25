if (object_index == obj_players) exit;

y_vel += grav;
x_vel *= 0.9;
r_x += x_vel;
r_y += y_vel;
var to_move_x = round(r_x);
var to_move_y = round(r_y);
r_x -= to_move_x;
r_y -= to_move_y;
var dir = sign(to_move_y);

if (x_vel > 0) {
    image_xscale = 1;
} else if (x_vel < 0) {
    image_xscale = -1; 
}

switch(state){
    case "spawn":
        born_timer++;
        if(born_timer >= 60){
            var spawn_x = (object_index == obj_green) ? room_width / 3 : room_width * 2 / 3;
            var new_player = instance_create_layer(spawn_x, room_height + 20, "Instances", object_index);
            audio_play_sound(snd_spawn, 1, false);
            new_player.state = "normal";
            instance_destroy();
        }
        break;
        
    case "normal":
        while(to_move_y != 0) {
            var colliding = false;
            var collideWith = noone;
            
            if(dir >= 0) {
                if (object_index == obj_red) {
                    collideWith = instance_place(x, y + dir, obj_green);
                } else {
                    collideWith = instance_place(x, y + dir, obj_red);
                }
                
                if(collideWith != noone) {
                    if(place_meeting(x, y, collideWith) == false) {
                        colliding = true;
                        audio_play_sound(snd_step, 1, false);
                        
                        // Stomper gets the point
                        if (object_index == obj_red) {
                            global.score_red += 1;
                        } else {
                            global.score_green += 1;
                        }
                        
                        collideWith.y_vel = max(0, collideWith.y_vel + 2);
                        collideWith.state = "dead";
                        
                        var count = random_range(5, 10);
                        for (var i = 0; i < count; i++){
                            var stars = instance_create_layer(collideWith.x, collideWith.y, "Instances", obj_star);
                            stars.direction = random(360);
                            stars.speed = random_range(2, 5);
                        }
                    }
                } else {
                    collideWith = instance_place(x, y + dir, obj_cloud);
                    if(collideWith != noone) {
                        if(place_meeting(x, y, collideWith) == false) {
                            colliding = true;
                            audio_play_sound(snd_jump, 1, false);
                            collideWith.cloud_state = "stepped";
                        }
                    }
                }
            }
            
            if(!colliding) {
                y += dir;
                to_move_y -= dir;
            } else {
                y = y + dir;
                y_vel = bounce_vel;
                r_y = 0;
                break;
            }
        }
        
        x += to_move_x;
        
        if (object_index == obj_red) {
            if(keyboard_check(ord("A"))) {
                x_vel -= accel;
            } 
            if(keyboard_check(ord("D"))) {
                x_vel += accel;
            }
        } else if (object_index == obj_green) {
            if(keyboard_check(vk_left)) {
                x_vel -= accel;
            } 
            if(keyboard_check(vk_right)) {
                x_vel += accel;
            }
        }
        
        if (dir > 0){
            image_index = 2; 
        } else if (dir < 0){
            image_index = 0; 
        } else {
            image_index = 1;
        }
        
        if (bbox_right + x_vel >= room_width){
            x = room_width - (bbox_right - x);
            x_vel = -x_vel;
            audio_play_sound(snd_bounce, 1, false);
        }
        if (bbox_left + x_vel <= 0){
            x = 0 + (x - bbox_left);
            x_vel = -x_vel;
            audio_play_sound(snd_bounce, 1, false);
        }
        
        if (bbox_bottom > room_height && dir > 0){
		    state = "dead";
		    audio_play_sound(snd_die, 1, false);
    
		    if (object_index == obj_red) {
		        global.score_red -= 1;  
		    } else {
		        global.score_green -= 1;  
		    }
    
		    // Create stars
		    var count = random_range(5, 10);
		    for (var i = 0; i < count; i++){
		        var stars = instance_create_layer(x, y, "Instances", obj_star);
		        stars.direction = random(360);
		        stars.speed = random_range(2, 5);
		    }
		}
        break;
        
    case "dead":
        y += to_move_y;
        image_index = 3; 
        
        death_timer++;
        if (death_timer > 30) {
            var spawn_x = (object_index == obj_green) ? room_width / 3 : room_width * 2 / 3;
            var new_player = instance_create_layer(spawn_x, room_height + 20, "Instances", object_index);
            audio_play_sound(snd_spawn, 1, false);
            new_player.state = "normal";
            instance_destroy();
        }
        break;
}