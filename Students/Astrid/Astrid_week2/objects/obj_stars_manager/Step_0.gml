var num_stars = instance_number(obj_star);

frames_since_star++;

if (frames_since_star > frames_bt_star || num_stars < 10) {
	if(num_stars < max_stars) {
		var new_star = instance_create_layer(
			random_range(150, room_width - 100),
			random_range(600, room_height - 150),
			"Instances",
			obj_star
		);
		
		with(new_star) {
			var tries = 0;
			while(tries < 100 && collision_rectangle(
				x - 100, y - 50,
				x + 100, y + 50,
				obj_star,
				false, true) != noone
			) {
				x = random_range(100, room_width - 100);
				y = random_range(600, room_height - 200);
				tries++;
			}
		}
		
		frames_since_star = 0;
	}
}