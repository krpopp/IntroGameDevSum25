
	var count = random_range(5,10);
	for (var i = 0; i < count; i++){
		var cloud = instance_create_layer(mouse_x, mouse_y, "Instances", obj_stars);
		
		cloud.direction = random (360);
		
		cloud.speed = random_range(2,5);
	}
