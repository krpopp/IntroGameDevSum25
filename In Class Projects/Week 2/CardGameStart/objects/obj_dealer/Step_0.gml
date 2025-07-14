

if(dealing) {
	var _player_card_num = ds_list_size(player_hand);
	if(_player_card_num < 4) {
		var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
		ds_list_delete(deck, ds_list_size(deck) - 1);
		ds_list_add(player_hand, _dealt_card);
		
		_dealt_card.x = room_width/4 + _player_card_num * hand_x_offset;
		_dealt_card.y = room_height * 0.8;
		_dealt_card.in_player_hand = true;
	} else {	
		dealing = false;
	}
} else {

}