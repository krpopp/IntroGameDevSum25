enum CloudSize {
	Small,
	Medium,
	Large,
	VeryLarge,
}

//defaults
size = CloudSize.Small;
growth_timer = 180;

growth_anim = 0;
growth_anim_max_time = 3;
growth_anim_timer = growth_anim_max_time;

image_speed = 0;

function update() {
	grow_animation();
}

function grow_animation() {
	if (growth_anim < 3) {
		if (growth_anim_timer > 0) {
			growth_anim_timer--;
		}
		else {
			image_index++;
			growth_anim_timer = growth_anim_max_time;
		}
	}
}