randomize();

global.card_pile = ds_list_create();
global.dealer_hand = ds_list_create();
global.player_hand = ds_list_create();

current_card = noone;
player_flipped = false;
dealer_dealt = false;

// timers
shuffle_max = 15;
shuffle_delay = shuffle_max;
dealer_max = 18;
dealer_delay = dealer_max;
dealer_move_max = 20;
dealer_move_delay = dealer_move_max;
result_max = 40;
result_delay = result_max;

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
		_card.depth = _i * 5;
	}
}


function update() {
	deal_cards();
}

function deal_cards() {
	if (ds_list_size(global.dealer_hand) < 3) {
		if (current_card == noone && ds_list_size(global.card_pile) > 0) {
			current_card = ds_list_find_value(global.card_pile, 0);
			shuffle_delay = shuffle_max;
		}

		if (instance_exists(current_card)) {
			if (shuffle_delay > 0) {
				shuffle_delay--;
			} else {
				current_card.hand = "dealer";
				current_card.card_state = "dealing";

				ds_list_delete(global.card_pile, 0);
				ds_list_add(global.dealer_hand, current_card);
				
				current_card.dealer_x = room_width/2 - 100 + (100 * ds_list_find_index(global.dealer_hand, current_card));
				
				current_card = noone;
			}
		}
	}
	else if (ds_list_size(global.player_hand) < 3) {
		if (current_card == noone && ds_list_size(global.card_pile) > 0) {
			current_card = ds_list_find_value(global.card_pile, 0);
			shuffle_delay = shuffle_max;
		}

		if (instance_exists(current_card)) {
			if (shuffle_delay > 0) {
				shuffle_delay--;
			} else {
				current_card.hand = "player";
				current_card.card_state = "dealing";

				ds_list_delete(global.card_pile, 0);
				ds_list_add(global.player_hand, current_card);
				
				current_card.player_x = room_width/2 - 100 + (100 * ds_list_find_index(global.player_hand, current_card));
				
				current_card = noone;
			}
		}
	}
	else if (ds_list_size(global.player_hand) == 3 && ds_list_size(global.dealer_hand) == 3
		&& !player_flipped) {
		if (dealer_delay > 0) {
			dealer_delay--;
		}
		else {
			for (var _i = 0; _i < 3; _i++) {
				var _card = ds_list_find_value(global.player_hand, _i);
				_card.card_state = "player_hand";
				_card.card_flipped = true;
			
				var _dcard = ds_list_find_value(global.player_hand, _i);
				_dcard = "dealer_hand";
			}
			player_flipped = true;
			dealer_delay = dealer_max;
		}
	}
	else if (!dealer_dealt) {
		if (dealer_move_delay > 0) {
			dealer_move_delay--;
		}
		else {
			var _card = ds_list_find_value(global.dealer_hand, irandom_range(0, 2));
			_card.card_state = "dealer_played";
			dealer_dealt = true;
			dealer_move_delay = dealer_move_max;
		}
	}
}



deck_add("ROCK", 8);
deck_add("PAPER", 8);
deck_add("SCISSORS", 8);
ds_list_shuffle(global.card_pile);
process_deck();
