randomize();

image_x_scale = 0.9;
image_y_scale = 0.9;
max_clouds = 20;
gen_speed = 5;
gen_def_timer = 30;
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
			var _max_tries = 3000;
			
			repeat (_max_tries) {
				var _x = irandom_range(60, room_width - 30);
				var _y = irandom_range(90, room_height - 20);
				
				var _cloud_w = sprite_get_width(spr_cloud);
				var _cloud_h = sprite_get_height(spr_cloud);
				var _scale = 0.2;
				
				if (!collision_rectangle(_x - _cloud_w*_scale, _y - _cloud_h*_scale, _x + _cloud_w*_scale, _y + _cloud_h*_scale, obj_cloud, false, true)) {
					instance_create_layer(_x, _y, "Instances", obj_cloud);
					gen_timer = gen_def_timer;
					break;
				}
			}
		}
	}
}