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

if(face_up) {
	sprite_index = spr_card_front;
	image_index = face_index;
} else {
	sprite_index = spr_card_back;
	image_index = 0;
}

draw_self();