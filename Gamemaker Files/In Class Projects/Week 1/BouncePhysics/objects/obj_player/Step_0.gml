y_vel += grav;

x_vel *= 0.9;

r_x += x_vel;
r_y += y_vel;

var to_move_x = round(r_x);
var to_move_y = round(r_y);

r_x -= to_move_x;
r_y -= to_move_y;

var dir = sign(to_move_y);

while(to_move_y != 0) {
	var colliding = false;
	var collideWith = noone;
	
	if(dir >= 0) {
		collideWith = instance_place(x, y + dir, obj_player);
		if(collideWith != noone) {
			if(place_meeting(x, y, collideWith) == false) {
				colliding = true;
				//obj_player.x = 10;
				//collideWith.x = 10;
				collideWith.y_vel = max(0, collideWith.y_vel + 2);
			}
		} else {
			collideWith = instance_place(x, y + dir, obj_burger);
			if(collideWith != noone) {
				if(place_meeting(x, y, collideWith) == false) {
					colliding = true;
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


