
deal_timer = 0;
pick_timer = 0;
compare_timer = 0;
cleanup_timer = 0;
_y_offset = 0;
//offets card's x position in the player's hand
hand_x_offset = 100;
_num_card_picked = 0;

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
computer_hand = ds_list_create();
//variables to track which cards the player has clicked on
global.player_choice = noone;
global.computer_choice = noone;

//track's player's score
global.player_points = 0;
global.computer_points = 0;

for(var _i = 0; _i < num_cards; _i++) {
	//create a card
	var _new_card = instance_create_layer(x, y , "Instances", obj_cards);
	
	//set the new card's postion
	_new_card.y = y - (2*_i);
	
	_new_card.target_x = x;
	_new_card.target_y = y - (2*_i);
	
	//set the new card's sprite
	_new_card.face_index = _i % 3;
	
	//set that the card isn't in the player's hand
	_new_card.in_player_hand = false;
	_new_card.in_computer_hand = false; 
	
	_new_card._face_up = false;
	
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