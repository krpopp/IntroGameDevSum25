

if(dealing) {
	var _player_card_num = ds_list_size(player_hand);
	if(_player_card_num < 5) {
		var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
		ds_list_delete(deck, ds_list_size(deck) - 1);
		ds_list_add(player_hand, _dealt_card);
		
		_dealt_card.x = room_width/4 + _player_card_num * hand_x_offset;
		_dealt_card.y = room_height * 0.8;
		_dealt_card.in_player_hand = true;
	} else {	
		dealing = false;
		playing = true;
	}
}
if(playing) {
	if(global.player_choice_one != noone && global.player_choice_two != noone) {
			playing = false;
			resolve = true;
		}
} 
if(resolve) {
	if(global.player_choice_one.face_index == global.player_choice_two.face_index) {
			player_points++;
			resolve = false;
			clean_up = true;
	} else {
			global.player_choice_one.face_up = false;
			global.player_choice_two.face_up = false;
			resolve = false;
			playing = true;
	}
	global.player_choice_one = noone;
	global.player_choice_two = noone;
}
if(clean_up) {
	var _player_card_num = ds_list_size(player_hand);
	if(_player_card_num > 0) {
		var _next_card = ds_list_find_value(player_hand, ds_list_size(player_hand) - 1);
		ds_list_delete(player_hand, ds_list_size(player_hand) - 1);
		ds_list_add(discard, _next_card);
		_next_card.x = room_width * 0.9;
		_next_card.y = y - ds_list_size(discard);
		_next_card.face_up = false;
	} else {
		if(ds_list_size(deck) == 0) {
			clean_up = false;
			shuffle = true;
		} else {
			clean_up = false;
			dealing = true;
		}
	}
}
if(shuffle) {
	
}