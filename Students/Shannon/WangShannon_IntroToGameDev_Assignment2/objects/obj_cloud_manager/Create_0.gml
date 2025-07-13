max_clouds = 20;
gen_speed = 5;
gen_timer = 15;

global.clouds = ds_list_create();

function update() {
}

function generate_clouds() {
	if (ds_list_size(global.clouds)) {
		if (gen_timer > 0) {
			gen_timer--;
		}
		else {
		}
	}
}