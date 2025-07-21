randomize();

phase = "dealing";

global.card_pile = ds_list_create();
global.dealer_hand = ds_list_create();
global.player_hand = ds_list_create();
global.discard_order = ds_list_create();
global.discard = ds_stack_create();

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
result_max = 120;
result_delay = result_max;
reshuffle_max = 5;
reshuffle_delay = reshuffle_max;

//

global.dealer_card = noone;
global.player_card = noone;

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
	switch (phase) {
		case "dealing": 
		if (ds_list_size(global.dealer_hand) < 3 && !dealer_dealt) {
			if (current_card == noone && ds_list_size(global.card_pile) > 0) {
				current_card = ds_list_find_value(global.card_pile, 0);
				shuffle_delay = shuffle_max;
			}

			if (instance_exists(current_card)) {
				if (shuffle_delay > 0) {
					shuffle_delay--;
				} else {
					audio_play_sound(snd_move_card, false, false);
					current_card.hand = "dealer";
					current_card.card_state = "dealing";

					ds_list_delete(global.card_pile, ds_list_find_index(global.card_pile, current_card));
					ds_list_add(global.dealer_hand, current_card);
				
					current_card.dealer_x = room_width/2 - 100 + (100 * ds_list_find_index(global.dealer_hand, current_card));
				
					current_card = noone;
				}
			}
		}
		else if (ds_list_size(global.player_hand) < 3 && !dealer_dealt) {
			if (current_card == noone && ds_list_size(global.card_pile) > 0) {
				current_card = ds_list_find_value(global.card_pile, 0);
				shuffle_delay = shuffle_max;
			}

			if (instance_exists(current_card)) {
				if (shuffle_delay > 0) {
					shuffle_delay--;
				} else {
					audio_play_sound(snd_move_card, false, false);
					current_card.hand = "player";
					current_card.card_state = "dealing";

					ds_list_delete(global.card_pile, ds_list_find_index(global.card_pile, current_card));
					ds_list_add(global.player_hand, current_card);
				
					current_card.player_x = room_width/2 - 100 + (100 * ds_list_find_index(global.player_hand, current_card));
				
					current_card = noone;
				}
			}
		}
		else {
			phase = "flipping";
		}
		break;
		
	case "flipping":
	
		if (ds_list_size(global.player_hand) == 3 && ds_list_size(global.dealer_hand) == 3
		&& !player_flipped) {
			if (dealer_delay > 0) {
				dealer_delay--;
			}
			else {
				for (var _i = 0; _i < 3; _i++) {
					var _card = ds_list_find_value(global.player_hand, _i);
					_card.card_state = "player_hand";
					_card.card_flipped = true;

					var _dcard = ds_list_find_value(global.dealer_hand, _i);
					_dcard.card_state = "dealer_hand";
				}
				player_flipped = true;
				dealer_delay = dealer_max;
				
			}
		}
		else {
			phase = "dealer_reveal";
		}
		break;
		
	case "dealer_reveal":
		if (!dealer_dealt) {
			if (dealer_move_delay > 0) {
				dealer_move_delay--;
			}
			else {
				audio_play_sound(snd_move_card, false, false);
				var _card = ds_list_find_value(global.dealer_hand, irandom_range(0, 2));
				_card.card_state = "dealer_played";
				dealer_dealt = true;
				ds_list_delete(global.dealer_hand, ds_list_find_index(global.dealer_hand, _card));
			
				global.dealer_pick = _card.card_type;
				global.dealer_card = _card;
				dealer_move_delay = dealer_move_max;
			}
		}
		else {
			phase = "calculating";
			//show_debug_message("eee");
		}
		break;
	case "calculating":
		if (global.dealer_pick != noone && global.player_pick != noone) {
			if (result_delay > 0) {
				result_delay--;
			}
			else {
				if (global.dealer_pick == global.player_pick) {
					//tie
				}
				else if (global.dealer_pick == "ROCK" && global.player_pick == "PAPER"
				|| global.dealer_pick == "SCISSORS" && global.player_pick == "ROCK"
				|| global.dealer_pick == "PAPER" && global.player_pick == "SCISSORS") {
					// player win 
					global.player_score++;
					audio_play_sound(snd_win, false, false);
				
				}
				else {
					// dealer win
					global.dealer_score++;
					audio_play_sound(snd_lose, false, false);
				
				}
				result_delay = result_max;
			
				ds_list_add(global.discard_order, global.dealer_card);
				ds_list_add(global.discard_order, global.player_card);
				for (var _i = 0; _i < ds_list_size(global.dealer_hand); _i++) {
					ds_list_add(global.discard_order, ds_list_find_value(global.dealer_hand, _i));
				}
				for (var _i = 0; _i < ds_list_size(global.player_hand); _i++) {
					ds_list_add(global.discard_order, ds_list_find_value(global.player_hand, _i));
				}
				/*for (var _i = 0; _i < 6; _i++) {
					var _card = ds_list_find_value(global.discard_order, _i);
					
					if (instance_exists(_card)) {
						_card.discard_y = room_height/2 - ds_stack_size(global.discard) * 2;
						_card.card_flipped = false;
						_card.image_index = 0;
						_card.depth -= _card.discard_y;
					}
				}*/
			
				global.dealer_pick = noone;
			}
		}
		else if (global.dealer_pick = noone) {
			phase = "discarding";
		}
		break;
	case "discarding":
		if (ds_list_size(global.discard_order) > 0) {
			if (shuffle_delay > 0) {
				shuffle_delay--;
			}
			else {
				var _card = ds_list_find_value(global.discard_order, 0);
			
				if (instance_exists(_card)) {
					_card.card_state = "discard";
					_card.discard_y = room_height/2 - ds_stack_size(global.discard) * 2;
					_card.card_flipped = false;
					_card.image_index = 0;
					_card.depth = -500 + _card.discard_y;
					ds_stack_push(global.discard, _card);
					ds_list_delete(global.discard_order, 0);
				}
				shuffle_delay = shuffle_max;
			}
		
		}
		else if (ds_list_size(global.discard_order) == 0) {
			dealer_dealt = false;
			current_card = noone;
			player_flipped = false;
			global.dealer_card = noone;
			global.dealer_pick = noone;
			global.player_card = noone;
			global.player_pick = noone;
			phase = "dealing";
			// resetting
		
		}
		
		break;
	case "reshuffle": 
		if (ds_stack_size(global.discard) > 0) {
			if (reshuffle_delay > 0) {
				reshuffle_delay--;
				
			}
			else {
				var _card = ds_stack_pop;
				ds_list_add(global.card_pile, _card);
				_card.card_state = "pile";
				reshuffle_delay = reshuffle_max;
			}
			
		}
		break;
	}
}



deck_add("ROCK", 8);
deck_add("PAPER", 8);
deck_add("SCISSORS", 8);
ds_list_shuffle(global.card_pile);
process_deck();
