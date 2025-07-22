//offsets card's x position in the player's hand
hand_x_offset = 100;

//total number of cards in the deck
num_cards = 24;

timer_preparing = room_speed * 1.3;
alarm[0] = timer_preparing;



enum STATES {
	Prepare,
	DEAL,
	PICK,
	COMPARE,
	CLEANUP,
	RESHUFFLE
}

state = STATES.Prepare;

//we created three lists, but still didn't sign any values in them
deck = ds_list_create();
player_hand = ds_list_create();
bot_hand = ds_list_create();
discard = ds_list_create();

timer_before = 90;
is_time = false;

is_dealing = false;
timer_dealing = 30;

timer_discard = 30;
is_discarding = false;

timer_shuffle = 10;
is_shuffling = false;

timer_clean = 90;
is_cleaning = false;

//variables to track which cards the player has clicked on
global.bot_choice_one = noone;
global.player_choice_two = noone;

//track's player's score
global.bot_points = 0;
global.player_points = 0;

y = room_height * 0.5 - 30;

for(var _i = 0; _i < num_cards; _i++) {
	
	//create a card
	var _new_card = instance_create_layer(x, y , "Instances", obj_card);
	
	//set the new card's postion
	_new_card.y = y - (2 *_i);
	
	_new_card.target_x = x;
	_new_card.target_y = y - (2 *_i);
	
	//set the new card's sprite
	_new_card.face_index = _i % 3;
	
	//set that the card isn't in the player's hand
	_new_card.in_player_hand = false;
	_new_card.in_bot_hand = false;
	
	_new_card.face_up = false;
	
	//add the card values all to the deck
	ds_list_add(deck, _new_card);
	

}


randomize();
//SHUFFLE THE DECK
ds_list_shuffle(deck);


//give depth
for(var _i = 0; _i < num_cards; _i++) {
	deck[| _i].depth = num_cards - _i;
	deck[| _i].target_y = y - (4 * _i);
}