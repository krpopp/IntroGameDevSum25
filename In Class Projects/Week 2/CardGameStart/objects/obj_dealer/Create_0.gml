
hand_x_offset = 100;

num_cards = 24;

dealing = true;

deck = ds_list_create();
player_hand = ds_list_create();

for(var _i = 0; _i < num_cards; _i++) {
	//create a card
	var _new_card = instance_create_layer(x, y , "Instances", obj_card);
	
	//set the new card's postion
	_new_card.y = y - (2*_i);
	
	//set the new card's sprite
	_new_card.face_index = _i % 4;
	
	//set that the card isn't in the player's hand
	_new_card.in_player_hand = false;
	
	_new_card.face_up = false;
	
	//add the card to the deck
	ds_list_add(deck, _new_card);
}
