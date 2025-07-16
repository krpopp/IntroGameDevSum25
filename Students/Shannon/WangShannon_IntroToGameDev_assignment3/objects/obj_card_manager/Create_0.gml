global.card_pile = ds_list_create();

function deck_add(_card_type, _quantity) {
	var _x = 50;
	var _y = -40;
	for (var _i = 0; _i < _quantity; _i++) {
		var _card = instance_create_layer(_x, _y, "Instances", obj_card);
		_card.card_type = _card_type;
		with (_card) {
			assign_card_type_index();
		}
		ds_list_add(global.card_pile, _card);
		
	}
}

function deal_cards(_pile) {
}


function update() {
}



deck_add("ROCK", 8);
deck_add("PAPER", 8);
deck_add("SCISSORS", 8);

ds_list_shuffle(global.card_pile);
deal_cards(global.card_pile);