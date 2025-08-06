var num_clouds = instance_number(obj_cloud);

frames_since_cloud++;

if (frames_since_cloud > frames_bt_cloud || num_clouds < 5) {
	if(num_clouds < max_cloud) {
		var new_cloud = instance_create_layer(
			random_range(30, room_width - 30),
			random_range(50, room_height - 100),
			"Instances",
			obj_cloud
		);
		
		
		
		
		with(new_cloud) {
			var tries = 0;
			while(tries < 3000 && collision_rectangle(
				x - 24, y - 24,
				x + 24, y + 24,
				obj_cloud,
				false, true) != noone
			) {
				x = random_range(30, room_width - 30);
				y = random_range(20, room_height - 100);
				tries++;
			}
		}
		
		frames_since_cloud = 0;
	}
}