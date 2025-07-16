
// defaults
image_speed = 0;

// card details
card_type = "ROCK"; 
card_type_index = 1;

// card state
card_state = "pile";
card_flipped = false;




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