switch(state) {
	case STATES.DEAL:
    deal_timer++;

    if (deal_timer >= deal_interval) {
        deal_timer = 0;

        // Deal opponent first
        if (ds_list_size(opponent_hand) < 3) {
            var index = ds_list_size(opponent_hand);
            var card = ds_list_find_value(deck, ds_list_size(deck) - 1);
            ds_list_delete(deck, ds_list_size(deck) - 1);
            ds_list_add(opponent_hand, card);

            var target_y = room_height * 0.1;
            var target_x = room_width * 0.45 + (index - 1) * 110;

            card.x = 40;
            card.y = room_height * 0.4; // deck start (middle-left)
            card.target_x = target_x;
            card.target_y = target_y;
            card.base_y = target_y;

            card.in_opponent_hand = true;
            card.in_player_hand = false;
        }

        // Then deal player
        else if (ds_list_size(player_hand) < 3) {
            var index = ds_list_size(player_hand);
            var card = ds_list_find_value(deck, ds_list_size(deck) - 1);
            ds_list_delete(deck, ds_list_size(deck) - 1);
            ds_list_add(player_hand, card);

            var target_y = room_height * 0.7;
            var target_x = room_width * 0.45 + (index - 1) * 110;

            card.x = 40;
            card.y = room_height * 0.4; // deck start (middle-left)
            card.target_x = target_x;
            card.target_y = target_y;
            card.base_y = target_y;

            card.in_player_hand = true;
            card.in_opponent_hand = false;
        }

        else {
            state = STATES.PICK;
        }
    }
    break;


	case STATES.PICK:
		//COMPUTER PICKS CARD
		//PLAYER CAN ONLY CHOOSE ONE CARD
	    if (global.player_choice_one != noone && global.player_choice_two != noone)
	    {
	        state = STATES.COMPARE;
	    }
		break;
	case STATES.COMPARE:
		//ROCK PAPER SCISSORS LOGIC 
		if (global.player_choice_one.face_index == global.player_choice_two.face_index)
	    {
	        points++;
	        state = STATES.CLEANUP
	    }
	    else
	    {
	        global.player_choice_one.face_up = false;
	        global.player_choice_two.face_up = false;
	        state = STATES.PICK;
	    }
	    global.player_choice_one = noone;
	    global.player_choice_two = noone;
		break;
	case STATES.CLEANUP:
		var _player_card_num = ds_list_size(player_hand);
	    if (_player_card_num > 0)
	    {
	        var _next_card = ds_list_find_value(player_hand, ds_list_size(player_hand) - 1);
	        ds_list_delete(player_hand, ds_list_size(player_hand) - 1);
	        ds_list_add(discard, _next_card);
	        _next_card.target_x = room_width * 0.8;
	        _next_card.target_y = y - ds_list_size(discard);
	        _next_card.face_up = false;
			_next_card.in_player_hand = false;
	    }
	    else
	    {
	        if (ds_list_size(deck) == 0)
	        {
	            state = STATES.RESHUFFLE;
	        }
	        else
	        {
	            state = STATES.DEAL;
	        }
	    }
		break;
	case STATES.RESHUFFLE:
		//RESHUFFLE THE DISCARD TO THE DECK
		break;
}


