

switch(state) {
	case STATES.DEAL:
	    var _player_card_num = ds_list_size(player_hand);
		var _computer_card_num = ds_list_size(computer_hand);
		deal_timer ++;
		

	
	_y_offset = 0;
		
		if(deal_timer > 30){
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
			
	    }
		else if (_player_card_num < 3)
	    {
	        var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
	        ds_list_delete(deck, ds_list_size(deck) - 1);
	        ds_list_add(player_hand, _dealt_card);
        
	        _dealt_card.target_x = room_width / 3 + _player_card_num * hand_x_offset;
	        _dealt_card.target_y = room_height * 0.8;
	        _dealt_card.in_player_hand = true;
			_dealt_card._face_up = true; 
			deal_timer = 0;
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
		if(pick_timer > 60){
		
		if(global.computer_choice == noone ){
		var _num_card_picked = choose(0,1,2); 
		global.computer_choice = ds_list_find_value(computer_hand, _num_card_picked);
		global.computer_choice.target_y = room_height * 0.35;
		global.computer_choice.target_x = room_width / 3 + 1 * hand_x_offset;
		}
		//PLAYER CAN ONLY CHOOSE ONE CARD
	    if (global.player_choice != noone )
	    {
			
	        state = STATES.COMPARE;
	    }
		}
		break;
		
	case STATES.COMPARE:
	if (state == STATES.COMPARE ) {
	    show_debug_message("Entered COMPARE state");
		}
		compare_timer ++;
		
		
		if(compare_timer > 30){
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
			exit;
		}
	    else
	    {
	        global.computer_points ++;
			state = STATES.CLEANUP;
	        
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
if(cleanup_timer > 30){
	if (global.computer_choice != noone ) {
        global.computer_choice.target_x = _discard_x;
        global.computer_choice.target_y = _discard_y + _y_offset;
        _y_offset += 2;
        ds_list_add(discard, global.computer_choice);
		global.computer_choice = noone;
		cleanup_timer = 0;
    }

    else if (global.player_choice != noone) {
        global.player_choice.target_x = _discard_x;
        global.player_choice.target_y = _discard_y + _y_offset;
        _y_offset += 2;
        ds_list_add(discard, global.player_choice);
		global.player_choice = noone;
		cleanup_timer = 0;
    }
	
else if(ds_list_size(computer_hand) > 0 ){
	var loop_timer = 0;
	for (var _i = 2; _i >= 0 ; _i--) {
		
		if(loop_timer > 30){
	        var card = computer_hand[| _i];  
			card.face_up = true;
	        card.target_x = _discard_x;
	        card.target_y = _discard_y + _y_offset;
	        _y_offset += 2;
	        ds_list_add(discard, card);
			ds_list_delete(computer_hand, _i);
			loop_timer = 0;
		}
    }
}else if(ds_list_size(player_hand) > 0 ){
	for (var _i = 2; _i >= 0; _i--) {
        var card = player_hand[| _i];       
        card.target_x = _discard_x;
        card.target_y = _discard_y + _y_offset;
        _y_offset += 2;
        ds_list_add(discard, card);
		ds_list_delete(player_hand, _i);
		cleanup_timer = 0;
	}
}else if(deck != noone){
		
	state = STATES.DEAL
}else{
		
	state = STATES.RESHUFFLE
}		
}
	   
		break;


case STATES.RESHUFFLE:


	deal_timer = 0;
	pick_timer = 0;
	compare_timer = 0;
	cleanup_timer = 0;
	_y_offset = 0;

for (var _i = 0; _i < ds_list_size(discard); _i++) {
        var card = discard[| _i];       
        card.target_x = x;
        card.target_y = y - (2*_i);
        ds_list_add(deck, card);
		ds_list_delete(discard, _i);
	}

randomize();

ds_list_shuffle(deck);
for(var _i = 0; _i < num_cards; _i++) {
	deck[| _i].depth = num_cards - _i;
	deck[| _i].target_y = y - (2 * _i);
}

state = STATES.DEAL
		break;
}

