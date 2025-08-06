

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
	
case "start":


born_timer ++;
if(born_timer >= 180){
		var new_player = instance_create_layer(random(room_width), room_height + 20, "Instances", player_name);
		audio_play_sound(snd_born,1,false);
		
		instance_destroy();
		new_player.state = "normal";
		
}
break;

case "normal":


while(to_move_y != 0) {
	var colliding = false;
	var collideWith = noone;
	

	if(dir >= 0 ) {
		
		collideWith = instance_place(x, y + dir, obj_player);
		if(collideWith != noone) {
			if(place_meeting(x, y, collideWith) == false) {
				colliding = true;
				audio_play_sound(snd_step,1,false);
				if (object_index == obj_player_red) {
					 global.score_red += 1;
				} else if (object_index == obj_player_green) {
					 global.score_green += 1;
				}

				//obj_player.x = 10;
				//collideWith.x = 10;
				collideWith.y_vel = max(0, collideWith.y_vel + 2);
				collideWith.state = "dead"; 
				var count = random_range(5,10);
		for (var i = 0; i < count; i++){
		var stars = instance_create_layer(x, y, "Instances", obj_stars);
		
		stars.direction = random (360);
		
		stars.speed = random_range(2,5);
	}
			}
		} else {
			collideWith = instance_place(x, y + dir, obj_cloud);
			if(collideWith != noone) {
				if(place_meeting(x, y, collideWith) == false) {
					colliding = true;
					audio_play_sound(snd_jump,1,false);
					with (collideWith) {
						if ( cloud_stage >= 2) {
						state = "stepped";
						
				}
			}

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

if(keyboard_check(left_key)) {
	x_vel -= accel;
} 
if(keyboard_check(right_key)) {
	x_vel += accel;
}

if (dir > 0 ){
	image_index = 2; 
}
else if (dir < 0){
	image_index = 0; 
}else{
	image_index = 1;
}

if (bbox_right + x_vel >= room_width){
	x = room_width - (bbox_right - x);
	x_vel = -x_vel; 
	audio_play_sound(snd_bounce,1,false);
}

if (bbox_left + x_vel <= 0){
	x = 0 + (x - bbox_left);
	x_vel = -x_vel;
	audio_play_sound(snd_bounce,1,false);
}

if (bbox_bottom > room_height && dir > 0){
	state = "dead";
	audio_play_sound(snd_die,1,false);
	if (object_index == obj_player_red) {
		global.score_red -= 1;
	} else if (object_index == obj_player_green) {
		global.score_green -= 1;
	}

	
			
		var count = random_range(5,10);
		for (var i = 0; i < count; i++){
		var stars = instance_create_layer(x, y, "Instances", obj_stars);
		
		stars.direction = random (360);
		
		stars.speed = random_range(2,5);
	
}
}
break;

case "dead":
		y += to_move_y;
		image_index = 3; 
		
		

        death_timer++;
        if (death_timer > 90) {
             	//instance_create_layer(20, 20, "Instances", player_name);
			
			var new_player = instance_create_layer(random(room_width), room_height + 20, "Instances", player_name);
			audio_play_sound(snd_born,1,false);
			new_player.state = "normal";
			instance_destroy();
			
			
        }

        break;

}