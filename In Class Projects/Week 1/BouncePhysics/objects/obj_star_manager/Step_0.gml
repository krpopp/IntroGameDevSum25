var num_stars = instance_number(obj_star);

frames_since_star++;

if (frames_since_star > frames_bt_star || num_stars < 5) {
	if(num_stars < max_stars) {
		var new_star = instance_create_layer(
			random_range(30, room_width - 30),
			random_range(20, room_height - 100),
			"Instances",
			obj_star
		);
		
		with(new_star) {
			var tries = 0;
			while(tries < 3000 && collision_rectangle(
				x - 12, y - 12,
				x + 12, y + 12,
				obj_star,
				false, true) != noone
			) {
				x = random_range(30, room_width - 30);
				y = random_range(20, room_height - 100);
				tries++;
			}
		}
		
		frames_since_star = 0;
	}
}