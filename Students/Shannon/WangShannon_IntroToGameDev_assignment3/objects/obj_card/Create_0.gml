
// defaults
image_speed = 0;
depth = -500;

// card details
card_type = "ROCK"; 
card_type_index = 1;
hand = "none";

// card state
card_state = "pile";
card_flipped = false;

// dealing
deal_speed = 0.3;

// pile
pile_x = 75;
pile_y = room_height / 2;

// dealer
dealer_x = room_width / 2;
dealer_y = 150;
dealer_play_x = room_width/2;
dealer_play_y = 310;
global.dealer_pick = noone;

// player

player_x = room_width / 2;
player_y = room_height - 150;
player_play_x = room_width / 2;
player_play_y = room_height - 310;
global.player_pick = noone;

// discard

discard_x = room_width - 75;
discard_y = 150;



function assign_card_type_index() {
	if (card_type == "ROCK") {
		card_type_index = 1;
	}
	else if (card_type == "PAPER") {
		card_type_index = 2;
	}
	else if (card_type == "SCISSORS") {
		card_type_index = 3;
	}
}

function update() {
	switch_card_state();
	check_flipped();
}

function switch_card_state() {
	
	switch (card_state) {
		case "pile":
			x = lerp(x, pile_x, deal_speed);
			//y = lerp(y, pile_y, deal_speed);
			break;
		case "dealing":
		
			if (ds_list_find_index(global.card_pile, id) != -1) {
				ds_list_delete(global.card_pile, ds_list_find_index(global.card_pile, id));
			}
		
			switch (hand) {
				case "none":
					break;
				case "dealer":
					x = lerp(x, dealer_x, deal_speed);
					y = lerp(y, dealer_y, deal_speed);
					break;
				case "player":
					x = lerp(x, player_x, deal_speed);
					y = lerp(y, player_y, deal_speed);
					break;		
			}
			
			break;
		case "player_hand":
			var _card_w = sprite_get_width(spr_card)/2;
			var _card_h = sprite_get_height(spr_card)/2;
			
			if (global.player_pick == noone &&
			point_in_rectangle(mouse_x, mouse_y, x - _card_w, y - _card_h, x + _card_w, y + _card_h)) {
				y = lerp(y, room_height - 156, 0.2);
				if (mouse_check_button_pressed(mb_left)) {
					global.player_pick = card_type;
					global.player_card = id;
					card_state = "player_played";
					audio_play_sound(snd_move_card, false, false);
				}
			}
			else {
				y = lerp(y, room_height - 150, 0.2);
			}
			
			break;
		case "dealer_hand":
		
			break;
		case "player_played":
			x = lerp(x, player_play_x, 0.2);
			y = lerp(y, player_play_y, 0.2);
			break;
		case "dealer_played":
			x = lerp(x, dealer_play_x, 0.2);
			y = lerp(y, dealer_play_y, 0.2);
			
			if (obj_card_manager.result_delay <= 0 && !card_flipped) {
				card_flipped = true;
			}
			break;
		case "discard":
		
			x = lerp(x, discard_x, 0.2);
			y = lerp(y, discard_y, 0.2);
			
			break;
	}
}

function check_flipped() {
	if (card_flipped && image_index == 0) {
		image_index = card_type_index;
	}
}