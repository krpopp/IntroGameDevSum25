// making changes to the player position
//every frame calculate

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
		collideWith = instance_place(x, y + dir, obj_player);
		if(collideWith != noone){
			if(place_meeting(x, y, collideWith) == false){
				colliding = true;
				
				//collideWith.y_vel = 10;
				collideWith.y += 10;
				collideWith.is_kick = true;
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
					colliding = true;
					instance_destroy(collideWith);
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



	if(is_kick){
	//y_vel = 10;
	y += dir;
	to_move_y -= dir;	
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
    x_vel = abs(x_vel) * 1.2;  
}
if (x > view_right - margin) {
    x = view_right - margin;  
    x_vel = -abs(x_vel) * 1.2;  
}



//revicing by setting a timer,
//after 1 second of away from viewport, bounce back to the top
if (y > room_height + 64 && !is_out_of_bounds) {
    is_out_of_bounds = true;
    respawn_timer = 120;
}




if (is_out_of_bounds) {
 respawn_timer--;
    if (respawn_timer <= 0) {
        y = room_height + 64;
        x = random_range(50,room_width-50); 
        y_vel = - 40; //velocity when back to top
        is_out_of_bounds = false;
        respawn_y = 200; //where on top
    }
}

if (y_vel < 0 && y <= respawn_y) {
    y = respawn_y;
    y_vel = grav; 
    is_out_of_bounds = false;
	is_kick= false;
}


//i never know you can add layers and rename layers
if(y >= room_height && y <= room_height + 20) {
	if(y_vel >= 0){
		
		//i really don't know why the sparkles are not
		//drawn on correct x positions
	var spark_x = x + sprite_xoffset;
	var spark_y = room_height - sprite_height + sprite_yoffset;

	var spark = instance_create_layer(
					spark_x, 
					spark_y,  
					"FX_Front",                
					obj_sparkle                 
					);
	}
}