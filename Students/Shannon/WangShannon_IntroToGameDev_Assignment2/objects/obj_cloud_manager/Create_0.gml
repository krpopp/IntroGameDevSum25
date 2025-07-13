randomize();

max_clouds = 20;
gen_speed = 5;
gen_def_timer = 45;
gen_timer = gen_def_timer;

with (obj_cloud) {
	instance_destroy();
}

function update() {
	generate_clouds();
}

function generate_clouds() {
	if (instance_number(obj_cloud) < max_clouds) {
		if (gen_timer > 0) {
			gen_timer--;
		}
		else {
			instance_create_layer(irandom_range(10, room_width - 10), irandom_range(30, room_height - 30), 
			"Instances", obj_cloud);
			gen_timer = gen_def_timer;
		}
	}
}