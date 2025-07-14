// making changes to the player position
//every frame calculate

var cam_y = (obj_player1.y + obj_player2.y)/2;
var cam_height = camera_get_view_height(view_camera[0]);
var target_cam_y = cam_y- cam_height/2;
target_cam_y = clamp(target_cam_y, 0, room_height - cam_height);

camera_set_view_pos(view_camera[0], 0, target_cam_y);

obj_player1.y = clamp(obj_player1.y, 0, room_height+70);
obj_player2.y = clamp(obj_player2.y, 0, room_height+70);


if (!change_sprite){
	sprite_index = sprite_up;
	//obj_player1.sprite_index = spr_player1_up;
} else if(change_sprite){
	sprite_index = sprite_down;
	//obj_player1.sprite_index = spr_player1_down;
}

//add velocity every frame
y_vel += grav;
x_vel *= 0.9;
//+= the last y_vel
r_y += y_vel;
r_x += x_vel;

var to_move_y = round(r_y);
var to_move_x = round(r_x);

r_y -= to_move_y;
r_x -= to_move_x;

dir = sign(to_move_y);
var xdir = sign(to_move_x);

var _original_index = mask_index;


///////////Above are just Settings///////////////

if (again) { mask_index = -1; }
else if(! again) {mask_index = sprite_index;}


//use while loop to check collision
while(to_move_y != 0){
	var colliding = false;
	var collideWith = noone;
	
	//only care if player is falling
	if(dir >= 0){
	change_sprite = false;
		collideWith = instance_place(x, y + dir, obj_player);
		
		if(collideWith != noone){
			if(place_meeting(x, y, collideWith) == false){
				
				change_sprite = true;
				
				
				colliding = false;
				audio_play_sound(kick,0,false);
				//collideWith.y_vel = 10;
				collideWith.y += 10;
				collideWith.is_kick = true;
				collideWith.player_score--; 
				var spark = instance_create_layer(
					((x + collideWith.x) / 2)+30, 
					(y + collideWith.y) / 2,  
					"FX_Front",                
					obj_sparkle                 
					);
				spark.image_angle = point_direction(x, y, collideWith.x, collideWith.y);
			}
		} else {
			collideWith = instance_place(x, y + dir, obj_star);
			//if we are not colliding with the player, only with the cloud
			if(collideWith != noone){
				if(place_meeting(x, y, collideWith) == false){
					change_sprite = false;
					colliding = true;
					audio_play_sound(jump,0,false);
					instance_destroy(collideWith);
				}
			}
		}
	}
	if(!colliding) {
		y += dir;
		to_move_y -= dir;
		//change_sprite = true;
	} else {
		y = y + dir;
		y_vel = bounce_vel;		
		r_y = 0;
		//change_sprite = false;
		break;
	}
}

	if(is_kick){
	//y_vel = 10;
	y += dir;
	to_move_y -= dir;	
} 

if(dir <= 0 ) {
change_sprite = true;
}
else if(dir > 0 ){
	change_sprite = false;
} 


x += to_move_x;

if(keyboard_check(left_key)) {
	x_vel -= accel;
} 
if(keyboard_check(right_key)) {
	x_vel += accel;
}



//to have the players limits inthe viewport, and also be kick a little bit by
//the viewport edge

var view_left = camera_get_view_x(view_camera[0]);    
var view_right = camera_get_view_width(view_camera[0])-25;
var margin = 2;  //i didn't add margin and caused obj stuck on side.

if (x < view_left + margin) {
    x = view_left + margin;  
	audio_play_sound(walls,0,false);
    x_vel = abs(x_vel) * 1.2;  
}
if (x > view_right - margin) {
    x = view_right - margin; 
	audio_play_sound(walls,0,false);
    x_vel = -abs(x_vel) * 1.2;  
}



if (y >= room_height && y_vel >= 0) { 
	if (!is_out_of_bounds) {
	    is_out_of_bounds = true;
	    respawn_timer = 120;
		y = room_height+60;
		player_score--;
		
		audio_play_sound(die,10,false);
		//i really don't know why the sparkles are not
		//drawn on correct x positions
	var spark_x = x;
	var spark_y = room_height - sprite_height + sprite_yoffset;
	var spark = instance_create_layer(
					spark_x, 
					spark_y,  
					"FX_Front",                
					obj_sparkle);
	}
}


if (is_out_of_bounds) {
	
	respawn_timer--;
	
    if (respawn_timer <= 0) {
     y = room_height + 60;
        x = random_range(50, room_width-50); 
        y_vel = - 40; //velocity when back to top
        respawn_y = 300; //where on top
		is_out_of_bounds = false;
		is_kick = false;
    }
}


if ( y_vel < 0 && y <= respawn_y) {
    y = respawn_y;
    y_vel = grav;
}


//if( y_vel > 0 &&  y == room_height - 30 && respawn_timer > 0){
//	audio_play_sound(die,10,false);
//		//i really don't know why the sparkles are not
//		//drawn on correct x positions
//	var spark_x = x;
//	var spark_y = room_height - sprite_height + sprite_yoffset;
//	var spark = instance_create_layer(
//					spark_x, 
//					spark_y,  
//					"FX_Front",                
//					obj_sparkle);

//}


