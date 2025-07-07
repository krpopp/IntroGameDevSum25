function update() {
	set_depth();
}

function set_depth() {
	if (y + 10 > obj_player.y) {
		depth = obj_player.depth - 20;
	}
	else {
		depth = obj_player.depth + 20;
	}
}

