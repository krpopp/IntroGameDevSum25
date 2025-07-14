
if(face_up) {
	sprite_index = spr_card_front;
	image_index = face_index;
} else {
	sprite_index = spr_card_back;
	image_index = 0;
}

draw_self();