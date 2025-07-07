image_speed = 0;
image_index = 1;

function update() {
	set_depth();
}

function set_depth() {
	if (y > obj_player.y) {
		depth = obj_player.depth - 20;
	}
	else {
		depth = obj_player.depth + 20;
	}
}

