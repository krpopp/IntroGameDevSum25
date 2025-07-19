switch(state) {
    case STATES.DEAL:
        deal_timer++;
        
        if (deal_timer >= deal_interval) {
            deal_timer = 0;
            
            // Deal to opponent first
            if (ds_list_size(deck_manager.opponent_hand) < deck_manager.cards_per_hand) {
                // Take card from top of deck
                var card = ds_list_find_value(deck_manager.deck, ds_list_size(deck_manager.deck) - 1);
                ds_list_delete(deck_manager.deck, ds_list_size(deck_manager.deck) - 1);
                ds_list_add(deck_manager.opponent_hand, card);
                
                // Position in opponent's hand
                var index = ds_list_size(deck_manager.opponent_hand) - 1;
                card.target_x = room_width * 0.45 + (index - 1) * 110;
                card.target_y = room_height * 0.1;
                card.base_y = card.target_y;
                card.owner = "opponent";
                card.hand_position = index;
                card.face_up = false;
            }
            // Then deal to player
            else if (ds_list_size(deck_manager.player_hand) < deck_manager.cards_per_hand) {
                // Take card from top of deck
                var card = ds_list_find_value(deck_manager.deck, ds_list_size(deck_manager.deck) - 1);
                ds_list_delete(deck_manager.deck, ds_list_size(deck_manager.deck) - 1);
                ds_list_add(deck_manager.player_hand, card);
                
                // Position in player's hand
                var index = ds_list_size(deck_manager.player_hand) - 1;
                card.target_x = room_width * 0.45 + (index - 1) * 110;
                card.target_y = room_height * 0.7;
                card.base_y = card.target_y;
                card.owner = "player";
                card.hand_position = index;
                card.face_up = true;
            }
            else {
                // Dealing complete
                state = STATES.PICK;
            }
        }
        break;
        
    case STATES.PICK:
        // Handle player card selection
        if (card_clicked != noone && player_selected_card == noone) {
            if (card_clicked.owner == "player") {
                player_selected_card = card_clicked;
                
                // Move player's selected card to middle
                card_clicked.target_x = room_width * 0.5;
                card_clicked.target_y = room_height * 0.5;
                
                // AI picks middle card (index 1) from opponent hand
                if (ds_list_size(deck_manager.opponent_hand) >= 2) {
                    opponent_selected_card = ds_list_find_value(deck_manager.opponent_hand, 1); // Middle card
                } else {
                    // Fallback if less than 3 cards
                    var random_index = irandom(ds_list_size(deck_manager.opponent_hand) - 1);
                    opponent_selected_card = ds_list_find_value(deck_manager.opponent_hand, random_index);
                }
                
                // Move opponent's selected card down
                opponent_selected_card.target_y = opponent_selected_card.base_y + 20;
                
                // Move to compare
                state = STATES.COMPARE;
                compare_timer = 0;
            }
            card_clicked = noone;
        }
        break;
        
    case STATES.COMPARE:
        // First frame - do the comparison
        if (compare_timer == 0) {
            // Rock Paper Scissors logic
            var player_type = player_selected_card.card_type;
            var opponent_type = opponent_selected_card.card_type;
            
            // Flip opponent's card to show content
            opponent_selected_card.face_up = true;
            
            // Determine winner (0=scissors, 1=rock, 2=paper)
            var winner = "tie";
            
            if (player_type == opponent_type) {
                winner = "tie";
            }
            else if ((player_type == 0 && opponent_type == 2) ||  // Scissors beats Paper
                     (player_type == 1 && opponent_type == 0) ||  // Rock beats Scissors
                     (player_type == 2 && opponent_type == 1)) {  // Paper beats Rock
                winner = "player";
                player_score++;
            }
            else {
                winner = "opponent";
                opponent_score++;
            }
            
            // Update global scores
            global.score_bottom = player_score;
            global.score_top = opponent_score;
        }
        
        // Wait for duration
        compare_timer++;
        
        // After waiting, move cards and continue
        if (compare_timer >= compare_duration) {
            // Move player card to discard
            var index = ds_list_find_index(deck_manager.player_hand, player_selected_card);
            if (index != -1) {
                ds_list_delete(deck_manager.player_hand, index);
            }
            ds_list_add(deck_manager.discard, player_selected_card);
            player_selected_card.owner = "discard";
            player_selected_card.target_x = room_width * 0.85;
            player_selected_card.target_y = room_height * 0.5 - (ds_list_size(deck_manager.discard) * 2);
            
            // Move opponent card to discard
            index = ds_list_find_index(deck_manager.opponent_hand, opponent_selected_card);
            if (index != -1) {
                ds_list_delete(deck_manager.opponent_hand, index);
            }
            ds_list_add(deck_manager.discard, opponent_selected_card);
            opponent_selected_card.owner = "discard";
            opponent_selected_card.target_x = room_width * 0.85;
            opponent_selected_card.target_y = room_height * 0.5 - (ds_list_size(deck_manager.discard) * 2);
            
            // Reset selections
            player_selected_card = noone;
            opponent_selected_card = noone;
            
            // Decide next state
            if (ds_list_size(deck_manager.player_hand) == 0) {
                // All cards played, check if we need to reshuffle
                if (ds_list_size(deck_manager.deck) < deck_manager.cards_per_hand * 2) {
                    state = STATES.RESHUFFLE;
                } else {
                    state = STATES.DEAL;
                }
            } else {
                // Still have cards in hand
                state = STATES.PICK;
            }
        }
        break;
        
    case STATES.RESHUFFLE:
        // Move all discarded cards back to deck
        while (ds_list_size(deck_manager.discard) > 0) {
            var card = ds_list_find_value(deck_manager.discard, 0);
            ds_list_delete(deck_manager.discard, 0);
            ds_list_add(deck_manager.deck, card);
            
            card.owner = "deck";
            card.face_up = false;
        }
        
        // Shuffle
        ds_list_shuffle(deck_manager.deck);
        
        // Reposition cards in deck
        for (var i = 0; i < ds_list_size(deck_manager.deck); i++) {
            var card = deck_manager.deck[| i];
            card.target_x = deck_manager.deck_x;
            card.target_y = deck_manager.deck_y - (2 * i);
            card.depth = ds_list_size(deck_manager.deck) - i;
        }
        
        // Go to deal state
        state = STATES.DEAL;
        break;
}

