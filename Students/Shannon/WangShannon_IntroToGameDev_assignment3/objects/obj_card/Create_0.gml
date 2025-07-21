
// defaults
image_speed = 0;

// card details
card_type = "ROCK"; 
card_type_index = 1;
hand = "none";

// card state
card_state = "pile";
card_flipped = false;

// dealing
deal_speed = 0.7;

// pile
pile_x = 75;
pile_y = room_height / 2;

// player




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
}

function switch_card_state() {
	
	switch (card_state) {
		case "pile":
			break;
		case "dealing":
			switch (hand) {
				case "none":
					break;
				case "dealer":
					x = lerp(x, dealer_x, deal_speed);
					y = lerp(x, dealer_y, deal_speed);
					break;
				case "player":
					x = lerp(x, player_x, deal_speed);
					y = lerp(y, player_y, deal_speed);
					break;
			}
			break;
		case "player_hand":
			break;
		case "dealer_hand":
			break;
		case "played":
			break;
		case "discard":
			break;
	}
}