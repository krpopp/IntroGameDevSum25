// Set sprite based on face up/down
if (face_up) {
    sprite_index = spr_card_front;
    image_index = card_type;  // 0=scissors, 1=rock, 2=paper
} else {
    sprite_index = spr_card_back;
    image_index = 0;
}

// Draw the card
draw_self();