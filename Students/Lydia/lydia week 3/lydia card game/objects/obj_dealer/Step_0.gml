

switch(state) {
	case STATES.DEAL:
	    _player_card_num = ds_list_size(player_hand);
		_computer_card_num = ds_list_size(computer_hand);
		deal_timer ++;
		audio_played = false; 

	
	
		
		if(deal_timer > 20){
	    if (_computer_card_num < 3 )
	    {
	        var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
	        ds_list_delete(deck, ds_list_size(deck) - 1);
	        ds_list_add(computer_hand, _dealt_card);
        
	        _dealt_card.target_x = room_width / 3 + _computer_card_num * hand_x_offset;
	        _dealt_card.target_y = room_height * 0.1;
	        _dealt_card.in_computer_hand = true;
			_dealt_card._face_up = false; 
			deal_timer = 0;
			audio_play_sound(snd_move,1,false);
			
	    }
		else if (_player_card_num < 3)
	    {
	        var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
	        ds_list_delete(deck, ds_list_size(deck) - 1);
	        ds_list_add(player_hand, _dealt_card);
        
	        _dealt_card.target_x = room_width / 3 + _player_card_num * hand_x_offset;
	        _dealt_card.target_y = room_height * 0.8;
	        _dealt_card.in_player_hand = true;
			_dealt_card._face_up = false; 
			deal_timer = 0;
			audio_play_sound(snd_move,1,false);
	    }
		
	    else
	    {
			
			state = STATES.PICK;
	        
	    }
		}
		break;
		
	case STATES.PICK:
	if (state == STATES.PICK ) {
	    show_debug_message("Entered pick state");
		}
		//COMPUTER PICKS CARD
		pick_timer ++;
		if(pick_timer > 30 && audio_played == false){
			audio_play_sound(snd_move,1,false);
			audio_played = true; 
		}
		if (global.player_choice != noone )
	    {
			global.player_choice.target_y = room_height * 0.57;
		}
		
		if(pick_timer > 60){
		
		if(global.computer_choice == noone ){
		_num_card_picked = choose(0,1,2); 
		global.computer_choice = ds_list_find_value(computer_hand, _num_card_picked);
		global.computer_choice.target_y = room_height * 0.35;
		global.computer_choice.target_x = room_width / 3 + 1 * hand_x_offset;
		audio_play_sound(snd_move,1,false);
		}
		//PLAYER CAN ONLY CHOOSE ONE CARD
	    if (global.player_choice != noone )
	    {
			//global.player_choice.target_y = room_height * 0.57;
	        state = STATES.COMPARE;
	    }
		}
		break;
		
	case STATES.COMPARE:
	if (state == STATES.COMPARE ) {
	    show_debug_message("Entered COMPARE state");
		}
		compare_timer ++;
		
		
		if(compare_timer > 20){
		global.computer_choice._face_up = true;
		
		}
		
		//ROCK PAPER SCISSORS LOGIC 
		
	if(compare_timer > 120 ){
		compare_timer = 0;
		if(global.player_choice.face_index == global.computer_choice.face_index){
			
			state = STATES.CLEANUP;
			exit;
		}
		else if(global.player_choice.face_index - global.computer_choice.face_index == 1||global.player_choice.face_index - global.computer_choice.face_index == -2){
			global.player_points ++;
			state = STATES.CLEANUP;
			audio_play_sound(snd_win,1,false);
			exit;
		}
	    else
	    {
	        global.computer_points ++;
			state = STATES.CLEANUP;
			audio_play_sound(snd_lose,1,false);
	        
			exit;
	    }
		
		}
	    
		break;
		
		
	case STATES.CLEANUP:
		if (state == STATES.CLEANUP ) {
	    show_debug_message("Entered CLEANUP state");
		}
		show_debug_message("CLEANUP state: cleanup_timer = " + string(cleanup_timer));
		
		var _discard_x = room_width - x - spr_cards.sprite_width;
		var _discard_y = y;
		
		cleanup_timer ++;
if(cleanup_timer > 20){
	cleanup_timer = 0;
	_player_card_num = ds_list_size(player_hand);
	_computer_card_num = ds_list_size(computer_hand);
	if (global.computer_choice != noone ) {
        global.computer_choice.target_x = _discard_x;
        global.computer_choice.target_y = _discard_y - _y_offset;
		global.computer_choice.depth =  global.computer_choice.target_y;		
        _y_offset += 2;
        ds_list_add(discard, global.computer_choice);
		ds_list_delete(computer_hand, ds_list_find_index(computer_hand, global.computer_choice));
		global.computer_choice.in_computer_hand = false; 
		global.computer_choice = noone;
		audio_play_sound(snd_move,1,false);
    }

    else if (global.player_choice != noone) {
        global.player_choice.target_x = _discard_x;
        global.player_choice.target_y = _discard_y - _y_offset;
		global.player_choice.depth =  global.player_choice.target_y;
        _y_offset += 2;
        ds_list_add(discard, global.player_choice);
		ds_list_delete(player_hand, ds_list_find_index(player_hand, global.player_choice))
		global.player_choice.in_player_hand = false; 
		global.player_choice = noone;
		audio_play_sound(snd_move,1,false);
    }
	

	else if (_computer_card_num > 0 )
	    {
	        var _discarded_card = ds_list_find_value(computer_hand, ds_list_size(computer_hand) - 1);
	        ds_list_delete(computer_hand, ds_list_size(computer_hand) - 1);
	        ds_list_add(discard, _discarded_card);
        
	        _discarded_card.target_x = _discard_x;
	        _discarded_card.target_y = _discard_y - _y_offset;
	        _discarded_card.in_computer_hand = false;
			_discarded_card._face_up = true; 
			_y_offset += 2; 
			_discarded_card.depth = _discarded_card.target_y;
			audio_play_sound(snd_move,1,false);
	    }

	else if (_player_card_num > 0 )
	    {
	        var _discarded_card = ds_list_find_value(player_hand, ds_list_size(player_hand) - 1);
	        ds_list_delete(player_hand, ds_list_size(player_hand) - 1);
	        ds_list_add(discard, _discarded_card);
        
	        _discarded_card.target_x = _discard_x;
	        _discarded_card.target_y = _discard_y - _y_offset;
	        _discarded_card.in_player_hand = false;
			_discarded_card._face_up = true; 
			_y_offset += 2;
			_discarded_card.depth = _discarded_card.target_y;
			audio_play_sound(snd_move,1,false);
			
	 }else if(ds_list_size(deck) == 0){
	_y_offset = 0;
	state = STATES.RESHUFFLE
}else{
	deal_timer = 0;
	pick_timer = 0;
	compare_timer = 0;
	cleanup_timer = 0;
	state = STATES.DEAL
}		
}
	   
		break;


case STATES.RESHUFFLE:


	deal_timer = 0;
	pick_timer = 0;
	compare_timer = 0;
	cleanup_timer = 0;
	num_cards = 24; 
	reshuffle_timer++; 
	
	if (ds_list_size(discard) > 0 ){
		if(reshuffle_timer > 5){
			reshuffle_timer = 0; 
	        var _resetted_card = ds_list_find_value(discard, ds_list_size(discard) - 1);
	        ds_list_delete(discard, ds_list_size(discard) - 1);
	        ds_list_add(deck, _resetted_card);
        
	        _resetted_card.target_x = x;
	        _resetted_card.target_y = y - _y_offset;
			_resetted_card._face_up = false; 
			_y_offset += 2;
			_resetted_card.depth = _resetted_card.target_y;
			audio_play_sound(snd_move,1,false);
			
		}
	 }
else{
	

	randomize();
	_y_offset = 0; 
	ds_list_shuffle(deck);
	if(reshuffle_timer > 5){
	
		if(shuffled_cards < 24){
			var shuffled_card = ds_list_find_value(deck,shuffled_cards);
			shuffled_card.target_y = y - 2*shuffled_cards;
			shuffled_card.depth = shuffled_card.target_y;
			audio_play_sound(snd_move,1,false);
			reshuffle_timer = 0;
			shuffled_cards ++; 
		}
		else{
			
	for(var _i = 0; _i < num_cards; _i++) {
	deck[| _i].target_y = y - (2 * _i);
	deck[| _i].depth =  deck[| _i].target_y;
	//show_debug_message("thisishappenning")
	//audio_play_sound(snd_move,1,false);
}	

	
shuffled_cards = 0; 
state = STATES.DEAL
		}
}
}

		break;


}