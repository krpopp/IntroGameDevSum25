
//offets card's x position in the player's hand
hand_x_offset = 100;

//total number of cards in the deck
num_cards = 24;

enum STATES {
	DEAL,
	PICK,
	COMPARE,
	CLEANUP,
	RESHUFFLE
}

state = STATES.DEAL;

//lists for various states cards can be in
deck = ds_list_create();
player_hand = ds_list_create();
discard = ds_list_create();
//COMPUTER HAND LIST

//variables to track which cards the player has clicked on
global.player_choice_one = noone;
global.player_choice_two = noone;

//track's player's score
points = 0;

for(var _i = 0; _i < num_cards; _i++) {
	//create a card
	var _new_card = instance_create_layer(x, y , "Instances", obj_card);
	
	//set the new card's postion
	_new_card.y = y - (2*_i);
	
	_new_card.target_x = x;
	_new_card.target_y = y - (2*_i);
	
	//set the new card's sprite
	_new_card.face_index = _i % 4;
	
	//set that the card isn't in the player's hand
	_new_card.in_player_hand = false;
	
	_new_card.face_up = false;
	
	//add the card to the deck
	ds_list_add(deck, _new_card);
}

randomize();
//SHUFFLE THE DECK
ds_list_shuffle(deck);

for(var _i = 0; _i < num_cards; _i++) {
	deck[| _i].depth = num_cards - _i;
	deck[| _i].target_y = y - (2 * _i);
}