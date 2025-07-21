global.card_pile = ds_list_create();
global.dealer_hand = ds_list_create();
global.player_hand = ds_list_create();

// timers
shuffle_delay = 18;
dealer_delay = 18;
result_delay = 40;

function deck_add(_card_type, _quantity) {
	var _x = 75;
	var _y = room_height / 2 - 10;
	for (var _i = 0; _i < _quantity; _i++) {
		var _card = instance_create_layer(_x, _y, "Instances", obj_card);
		_card.visible = true;
		_card.card_type = _card_type;
		with (_card) {
			assign_card_type_index();
		}
		ds_list_add(global.card_pile, _card);
		
	}
}

function process_deck() {
	var _deck = global.card_pile;
	
	for (var _i = 0; _i < ds_list_size(_deck); _i++) {
		_card = ds_list_find_value(_deck, _i);
		_card.y += _i * 2;
	}
}

function deal_cards() {
	var _deck = global.card_pile;
	
	for (var _i = 0; _i < 3; _i++) {
		var _card = ds_list_find_value(global.card_pile, _i);
		
		if (instance_exists(_card)) {
			_card.hand = "dealer";
			_card.alarm[0] = shuffle_delay * _i;
			ds_list_delete(global.card_pile, _i);
			ds_list_add(global.dealer_hand, _card);
		}
	}
	alarm[0] = shuffle_delay;
}


function update() {
}



deck_add("ROCK", 8);
deck_add("PAPER", 8);
deck_add("SCISSORS", 8);
process_deck();

ds_list_shuffle(global.card_pile);
deal_cards();