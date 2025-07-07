card_spawn_timer = 0;

randomize();

function update() {
	if (!global.settings_pause) {
		spawn_cards()
	}
}

function spawn_cards() {
	if (card_spawn_timer == 0) {
		var _card = instance_create_layer(random_range(0, room_width), -50, "FallingCards", obj_falling_card);
		_card.visible = true;
		card_spawn_timer = irandom_range(40, 80);
	}
	else {
		card_spawn_timer--;
	}

}

