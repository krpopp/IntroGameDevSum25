enum CloudSize {
	Nothing,
	Small,
	Medium,
	Large,
	VeryLarge,
}

//defaults
size = CloudSize.Small;
growth_max_timer = 350;
growth_timer = growth_max_timer;

growth_anim = 0;
growth_anim_max_time = 3;
growth_anim_timer = growth_anim_max_time;

//destroy
destroyed = false;
destroy_anim_max_time = 4;
destroy_anim_timer = destroy_anim_max_time;
destroy_anim = 0;

image_speed = 0;
depth = obj_bottom_shadow.depth - 8;


function update() {
	if (!destroyed) {
		grow_animation();
		change_size();
	}
	else {
		destroy();
	}
}

function grow_animation() {
	if (growth_anim < 2) {
		if (growth_anim_timer > 0) {
			growth_anim_timer--;
		}
		else {
			image_index++;
			growth_anim++;
			growth_anim_timer = growth_anim_max_time;
		}
	}
}

function change_size() {
	
	if (size == CloudSize.Small) {
		if (growth_timer > 0) {
			growth_timer--;
		}
		else {
			growth_anim = 0;
			growth_timer = growth_max_timer;
			size = CloudSize.Medium;
		}
	}
	else if (size == CloudSize.Medium) {
		if (growth_timer > 0) {
			growth_timer--;
		}
		else {
			growth_anim = 0;
			growth_timer = growth_max_timer;
			size = CloudSize.Large;
		}
	}
	else if (size == CloudSize.Large) {
		if (growth_timer > 0) {
			growth_timer--;
		}
		else {
			growth_timer = growth_max_timer;
			size = CloudSize.VeryLarge;
		}
	}
}

function destroy() {
	if (destroy_anim == 0) {
		if (size == CloudSize.Small) image_index = 9;
		else if (size == CloudSize.Medium) image_index = 13;
		else image_index = 17;
	}
	
	if (destroy_anim_timer > 0) {
		destroy_anim_timer--;
	}
	else {
		image_index++;
		destroy_anim++;
		destroy_anim_timer = destroy_anim_max_time;
	}
	
	if (destroy_anim == 3) {
		instance_destroy();
	}
		
}