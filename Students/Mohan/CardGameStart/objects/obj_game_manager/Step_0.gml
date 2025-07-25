switch(state) {
    case STATES.DEAL:
    deal_timer++;
    
    if (deal_timer >= deal_interval) {
        deal_timer = 0;
        
        if (ds_list_size(deck_manager.opponent_hand) < deck_manager.cards_per_hand) {
            var deck_size = ds_list_size(deck_manager.deck);
            if (deck_size > 0) {
                var card = ds_list_find_value(deck_manager.deck, deck_size - 1);
                ds_list_delete(deck_manager.deck, deck_size - 1);
                ds_list_add(deck_manager.opponent_hand, card);
                audio_play_sound(snd_shuffle, 1, false);
                
                var index = ds_list_size(deck_manager.opponent_hand) - 1;
                card.target_x = room_width * 0.45 + (index - 1) * 110;
                card.target_y = room_height * 0.1;
                card.base_y = card.target_y;
                card.owner = "opponent";
                card.hand_position = index;
                card.face_up = false;
                
                for (var i = 0; i < ds_list_size(deck_manager.deck); i++) {
                    var deck_card = deck_manager.deck[| i];
                    deck_card.depth = 100 - i;
                    deck_card.target_y = deck_manager.deck_y - (3 * i);
                }
            }
        }
        else if (ds_list_size(deck_manager.player_hand) < deck_manager.cards_per_hand) {
            var deck_size = ds_list_size(deck_manager.deck);
            if (deck_size > 0) {
                var card = ds_list_find_value(deck_manager.deck, deck_size - 1);
                ds_list_delete(deck_manager.deck, deck_size - 1);
                ds_list_add(deck_manager.player_hand, card);
                
                // Play shuffle sound when dealing card
                audio_play_sound(snd_shuffle, 1, false);
                
                var index = ds_list_size(deck_manager.player_hand) - 1;
                card.target_x = room_width * 0.45 + (index - 1) * 110;
                card.target_y = room_height * 0.7;
                card.base_y = card.target_y;
                card.owner = "player";
                card.hand_position = index;
                card.face_up = true;
                
                for (var i = 0; i < ds_list_size(deck_manager.deck); i++) {
                    var deck_card = deck_manager.deck[| i];
                    deck_card.depth = -100 - i;
                    deck_card.target_y = deck_manager.deck_y - (3 * i);
                }
            }
        }
        else {
            state = STATES.OPPONENT_PICK;
            opponent_pick_timer = 0;
        }
    }
    break;
        
    case STATES.OPPONENT_PICK:
        opponent_pick_timer++;
        
        if (opponent_pick_timer >= opponent_pick_delay) {
            if (is_first_round && cards_played_this_round == 0) {
                if (ds_list_size(deck_manager.opponent_hand) >= 2) {
                    opponent_selected_card = ds_list_find_value(deck_manager.opponent_hand, 1);
                }
            } else {
                var random_index = irandom(ds_list_size(deck_manager.opponent_hand) - 1);
                opponent_selected_card = ds_list_find_value(deck_manager.opponent_hand, random_index);
            }
            
            if (opponent_selected_card != noone) {
                opponent_selected_card.target_x = room_width * 0.45;
                opponent_selected_card.target_y = room_height * 0.3;
                opponent_selected_card.depth = -10;
            }
            
            state = STATES.PLAYER_PICK;
            cards_played_this_round++;
        }
        break;
        
    case STATES.PLAYER_PICK:
        if (opponent_selected_card != noone && opponent_selected_card.y != opponent_selected_card.target_y) {
            card_clicked = noone;
        }
        if (card_clicked != noone && player_selected_card == noone) {
            if (card_clicked.owner == "player") {
                player_selected_card = card_clicked;
                
                card_clicked.target_x = room_width * 0.45;
                card_clicked.target_y = room_height * 0.5;
                card_clicked.depth = -11;
                
                state = STATES.COMPARE;
                compare_timer = 0;
            }
            card_clicked = noone;
        }
        break;
        
    case STATES.COMPARE:
        compare_timer++;
        
        if (compare_timer == 90) {  
            opponent_selected_card.face_up = true;
            player_selected_card.face_up = true; 
			
			audio_play_sound(snd_show, 1, false);
			
            var player_card_type = player_selected_card.card_type;
            var opponent_card_type = opponent_selected_card.card_type;
            
            if (player_card_type == opponent_card_type) {
                // Tie - no points
            }
            else if ((player_card_type == 0 && opponent_card_type == 2) ||  // Scissors beats Paper
                     (player_card_type == 1 && opponent_card_type == 0) ||  // Rock beats Scissors
                     (player_card_type == 2 && opponent_card_type == 1)) {  // Paper beats Rock
                player_score++;
            }
            else {
                opponent_score++;
            }
            
            global.score_bottom = player_score;
            global.score_top = opponent_score;
        }
        
        if (compare_timer >= 150) {  
            ds_list_clear(cards_to_move);
            
            opponent_selected_card.face_up = true;
            ds_list_add(cards_to_move, opponent_selected_card);
            
            ds_list_add(cards_to_move, player_selected_card);
            
            for (var i = ds_list_size(deck_manager.opponent_hand) - 1; i >= 0; i--) {
                var card = deck_manager.opponent_hand[| i];
                if (card != opponent_selected_card) {
                    ds_list_add(cards_to_move, card);
                }
            }
            
            for (var i = ds_list_size(deck_manager.player_hand) - 1; i >= 0; i--) {
                var card = deck_manager.player_hand[| i];
                if (card != player_selected_card) {
                    ds_list_add(cards_to_move, card);
                }
            }
            
            state = STATES.MOVE_TO_DISCARD;
            move_timer = 0;
            is_first_round = false;
        }
        break;
        
	case STATES.MOVE_TO_DISCARD:
	    move_timer++;
    
	    if (move_timer >= move_interval && ds_list_size(cards_to_move) > 0) {
	        var card = cards_to_move[| 0];
	        ds_list_delete(cards_to_move, 0);
	        audio_play_sound(snd_shuffle, 1, false);
        
	        var index = ds_list_find_index(deck_manager.player_hand, card);
	        if (index != -1) {
	            ds_list_delete(deck_manager.player_hand, index);
	        } else {
	            index = ds_list_find_index(deck_manager.opponent_hand, card);
	            if (index != -1) {
	                ds_list_delete(deck_manager.opponent_hand, index);
	            }
	        }
        
	        ds_list_add(deck_manager.discard, card);
	        card.owner = "discard";
	        card.target_x = deck_manager.discard_x;
	        var discard_index = ds_list_size(deck_manager.discard) - 1;
	        card.target_y = deck_manager.discard_y - (3 * discard_index);
	        card.depth = -100 - discard_index;
	        card.face_up = true;
        
	        move_timer = 0;
	    }
    
	    if (ds_list_size(cards_to_move) == 0) {
	        player_selected_card = noone;
	        opponent_selected_card = noone;
        
	        if (ds_list_size(deck_manager.deck) < deck_manager.cards_per_hand * 2) {
	            state = STATES.RESHUFFLE;
	        } else {
	            state = STATES.DEAL;
	        }
	    }
	    break;
    
	case STATES.RESHUFFLE:
	    if (!reshuffle_started) {
	        reshuffle_started = true;
	        reshuffle_timer = 0;
	        reshuffle_delay_timer = 30; 
        
	        with (obj_card) {
	            original_lerp_speed = 0.1; 
	            lerp_speed = 0.05; 
	        }
	    }
    
	    if (reshuffle_delay_timer > 0) {
	        reshuffle_delay_timer--;
	        break;
	    }
    
	    reshuffle_timer++;
    
	    if (ds_list_size(deck_manager.discard) > 0 && reshuffle_timer % 5 == 0) {
	        var last_index = ds_list_size(deck_manager.discard) - 1;
	        var card = ds_list_find_value(deck_manager.discard, last_index);
	        ds_list_delete(deck_manager.discard, last_index);
	        ds_list_add(deck_manager.deck, card);
	        audio_play_sound(snd_shuffle, 1, false);
        
	        card.owner = "deck";
	        card.face_up = false;
        
	        var deck_index = ds_list_size(deck_manager.deck) - 1;
	        card.target_x = deck_manager.deck_x;
	        card.target_y = deck_manager.deck_y - (3 * deck_index);
	        card.depth = -100 - deck_index;
	    }
	    else if (ds_list_size(deck_manager.discard) == 0) {
	        with (obj_card) {
	            lerp_speed = original_lerp_speed;
	        }
        
	        ds_list_shuffle(deck_manager.deck);
        
	        for (var i = 0; i < ds_list_size(deck_manager.deck); i++) {
	            var card = deck_manager.deck[| i];
	            card.target_x = deck_manager.deck_x;
	            card.target_y = deck_manager.deck_y - (3 * i);
	            card.depth = -100 - i;
	        }
        
	        reshuffle_started = false;
	        is_first_round = true;
	        cards_played_this_round = 0;
        
	        state = STATES.DEAL;
	    }
	    break;
}