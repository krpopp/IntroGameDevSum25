x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);


image_index ++;

	
life -= 1; 
if (life <= 0){
	instance_destroy(obj_stars);
}

	