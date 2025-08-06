switch(state) {
	
	case STATES.Prepare:
	break;

	case STATES.DEAL:
	    var _bot_card_num = ds_list_size(bot_hand);
		var _player_card_num = ds_list_size(player_hand);
		
		//if(timer_preparing == 0){
			//is_dealing = true;
				if(!is_dealing){
				//timer_dealing = 30;
				//is_dealing = true;
				timer_dealing -= 1;
					 if(timer_dealing <= 0){
						timer_dealing = 30;
						is_dealing = true;
					 }
			}
		//}
		
		
			if(is_dealing){
				//timer_dealing -= 1;
				
				if ( _player_card_num < 3) { 
			
			    var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
			        ds_list_delete(deck, ds_list_size(deck) - 1);
			        ds_list_add(player_hand, _dealt_card);
        
			        _dealt_card.target_x = room_width / 4 + _player_card_num * hand_x_offset;
			        _dealt_card.target_y = room_height * 0.1;
			        _dealt_card.in_player_hand = true;
					audio_play_sound(snd_deal,1,false);
					
						is_dealing = false;		

				} else if ( _bot_card_num < 3) {
					//move the cards from deck to players-hand, and move values into player_hand list
			        var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
			        ds_list_delete(deck, ds_list_size(deck) - 1);
			        ds_list_add(bot_hand, _dealt_card);
        
			        _dealt_card.target_x = room_width / 4 + _bot_card_num * hand_x_offset;
			        _dealt_card.target_y = room_height * 0.7;
			        _dealt_card.in_bot_hand = true;
					audio_play_sound(snd_deal,1,false);
					
						is_dealing = false;	
				} else {
					state = STATES.PICK;
				}
			} 
			
		break;
		
		
	case STATES.PICK:
		//COMPUTER PICKS CARD
		//PLAYER CAN ONLY CHOOSE ONE CARD
		var middle_card = ds_list_find_value(player_hand, 1);
		
		if(global.bot_choice_one == noone){
			if (ds_list_size(player_hand) == 3) {
 
		    middle_card.target_y = room_height * 0.3;
			audio_play_sound(snd_deal,1,false);
    
		    middle_card.face_up = false;
			
			global.bot_choice_one = middle_card;
   
			}
		}
	
	
	    if (global.bot_choice_one != noone && global.player_choice_two != noone)
		    { is_time = true;
			//show_message("123");
	    }
		
		if(is_time){
			timer_before ++;
			if(timer_before > 130){
			global.bot_choice_one.face_up = true;
					state = STATES.COMPARE;
					is_time = false;
			}
		}
		
		if(is_time = false){
			timer_before = 90;
		}
		
		break;
		
		
	case STATES.COMPARE:
		var is_not_equal = noone;
		var _equal = false;
		var timer_comparing = 60;
		//show_message("123");
		
		if(!is_not_equal){
				timer_dealing -= 1;
				if(timer_dealing <= 0){
					if (global.bot_choice_one.face_index == global.player_choice_two.face_index){
						_equal = true;
							//show_message("1234");
			
				    }
					    else if (global.bot_choice_one.face_index > global.player_choice_two.face_index 
						|| global.bot_choice_one.face_index < global.player_choice_two.face_index){
							is_not_equal = true;
						}
			 }
		}

			
			
	if(is_not_equal){
		audio_play_sound(snd_correct,1,false);
		
				if (global.bot_choice_one.face_index - global.player_choice_two.face_index == -1
					|| global.bot_choice_one.face_index - global.player_choice_two.face_index == 2){
				        global.bot_points += 1;
				        state = STATES.CLEANUP;
								//show_message("11111");
				} 
		
					else{
				        global.player_points += 1;
				        state = STATES.CLEANUP;
								//show_message("333333");
						} 
	}
			
			if(_equal){
				state = STATES.CLEANUP;
			}
		
		break;
		
		
	case STATES.CLEANUP:
	//show_message("1111");
		
		var _player_card_num = ds_list_size(player_hand);
		var _bot_card_num = ds_list_size(bot_hand);
		
		var player_discard = ds_list_find_value(player_hand, ds_list_size(player_hand) - 1);
		var bot_discard = ds_list_find_value(bot_hand, ds_list_size(bot_hand) - 1);
		
		
			if(!is_discarding){
				timer_discard -= 1;
						//show_message(timer_discard);
						 if(timer_discard <= 0){
							timer_discard = 30;
							is_discarding = true;
						 }
				}
		
			if(is_discarding){
			    if (_player_card_num > 0){
	        
			        ds_list_delete(player_hand, ds_list_size(player_hand) - 1);
			        ds_list_add(discard, player_discard);
			        player_discard.target_x = room_width * 0.85;
			        player_discard.target_y = room_height * 0.15 + ds_list_size(discard) * 5.5;
					player_discard.depth = - ds_list_size(discard);
				
			        player_discard.face_up = true;
					player_discard.in_player_hand = false;
					global.player_choice_two = noone;
					audio_play_sound(snd_deal,1,false);
				
					is_discarding = false;
			    }
		
				else if (_bot_card_num > 0){
	        
			        ds_list_delete(bot_hand, ds_list_size(bot_hand) - 1);
			        ds_list_add(discard, bot_discard);
			        bot_discard.target_x = room_width * 0.85;
			        bot_discard.target_y = room_height * 0.15 + ds_list_size(discard) * 5.5;
					bot_discard.depth = - ds_list_size(discard);
				
			        bot_discard.face_up = true;
					bot_discard.in_bot_hand = false;
					global.bot_choice_one = noone;
					bot_discard.in_bot_hand = false;
					audio_play_sound(snd_deal,1,false);
			
					is_discarding = false;
			    }
		
			   else{
		       
				   if (ds_list_size(discard) == 24)
			        {
			            state = STATES.RESHUFFLE;
		        }
		        else
		        {
		            state = STATES.DEAL;
		        }
		    }
		
		}

		break;
		

	case STATES.RESHUFFLE:
		//RESHUFFLE THE DISCARD TO THE DECK
		
		
			if(ds_list_size(discard) > 0){
			var _new_deck = ds_list_find_value(discard, ds_list_size(discard) - 1);
			
			ds_list_delete(discard, ds_list_size(discard) - 1);
			ds_list_add(deck, _new_deck);
			_new_deck.target_x = room_width * 0.1;
			_new_deck.target_y = room_height * 0.4 + ds_list_size(discard) * 5.5;
			_new_deck.face_up = false;
			_new_deck.depth = - ds_list_size(deck);
			audio_play_sound(snd_deal,1,false);
					//is_shuffling = false;
			}
		
			else
			{
			randomize();
			//SHUFFLE THE DECK
			ds_list_shuffle(deck);
			
			
			 for(var i = 0; i < ds_list_size(deck); i++){
		        var card = deck[| i];
        
		        card.target_x = room_width * 0.1; 
       
		        card.target_y = room_height * 0.3 + (ds_list_size(deck) - 1 - i) * 6; 
		        card.depth = -i;
		        card.face_up = false;
		        }
					state = STATES.DEAL;
			}
		
		break;
}