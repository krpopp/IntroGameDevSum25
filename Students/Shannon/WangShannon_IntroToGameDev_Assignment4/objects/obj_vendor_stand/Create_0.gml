image_speed = 0;
depth = obj_player.depth + 50;
image_xscale = 1.2;
iamge_yscale = 1.2;


function update() {
	set_depth();
}

function set_depth() {
	if (y + 20 > obj_player.y) {
		depth = obj_player.depth - 20;
	}
	else {
		depth = obj_player.depth + 20;
	}
}

