if(abs(x - target_x) > 1) {
	x = lerp(x, target_x, 0.1);
} else {
	x = target_x;
}

if(abs(y - target_y) > 1) {
	y = lerp(y, target_y, 0.1);
} else {
	y = target_y;
}

if(_face_up) {
	sprite_index = spr_cards;
	image_index = face_index;
} else {
	sprite_index = spr_cards;
	image_index = 3;
}

draw_self();