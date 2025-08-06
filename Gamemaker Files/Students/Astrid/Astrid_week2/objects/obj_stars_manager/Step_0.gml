var num_stars = instance_number(obj_star);

frames_since_star++;

if (frames_since_star > frames_bt_star || num_stars < 6) {
	if(num_stars < max_stars) {
		var new_star = instance_create_layer(
			random_range(100, room_width - 100),
			random_range(300, room_height - 150),
			"Instances",
			obj_star
		);
		
		with(new_star) {
			var tries = 0;
			while(tries < 3000 && collision_rectangle(
				x - 70, y - 100,
				x + 70, y + 100,
				obj_star,
				false, true) != noone
			) {
				x = random_range(50, room_width - 50);
				y = random_range(300, room_height - 150);
				tries++;
			}
		}
		
		frames_since_star = 0;
	}
}