function shuffle_deck() {
    ds_list_shuffle(deck);
    
    for (var i = 0; i < ds_list_size(deck); i++) {
        var card = deck[| i];
        card.depth = ds_list_size(deck) - i;
        card.target_y = deck_y - (2 * i);
    }
}

function deal_card_to_player() {
    if (ds_list_size(deck) == 0) return noone;
    
    // Take from top of deck
    var card = ds_list_find_value(deck, ds_list_size(deck) - 1);
    ds_list_delete(deck, ds_list_size(deck) - 1);
    ds_list_add(player_hand, card);
    
    // Position in hand
    var index = ds_list_size(player_hand) - 1;
    card.target_x = room_width * 0.45 + (index - 1) * 110;
    card.target_y = room_height * 0.7;
    card.base_y = card.target_y;
    card.owner = "player";
    card.hand_position = index;
    card.face_up = true;
    
    return card;
}

function deal_card_to_opponent() {
    if (ds_list_size(deck) == 0) return noone;
    
    // Take from top of deck
    var card = ds_list_find_value(deck, ds_list_size(deck) - 1);
    ds_list_delete(deck, ds_list_size(deck) - 1);
    ds_list_add(opponent_hand, card);
    
    // Position in hand
    var index = ds_list_size(opponent_hand) - 1;
    card.target_x = room_width * 0.45 + (index - 1) * 110;
    card.target_y = room_height * 0.1;
    card.base_y = card.target_y;
    card.owner = "opponent";
    card.hand_position = index;
    card.face_up = false;  
    
    return card;
}

function move_to_discard(card) {
    var index = ds_list_find_index(player_hand, card);
    if (index != -1) {
        ds_list_delete(player_hand, index);
    } else {
        index = ds_list_find_index(opponent_hand, card);
        if (index != -1) {
            ds_list_delete(opponent_hand, index);
        }
    }
    
    ds_list_add(discard, card);
    card.owner = "discard";
    card.target_x = discard_x;
    card.target_y = discard_y - (ds_list_size(discard) * 2);
}

function reshuffle_discard_to_deck() {
    while (ds_list_size(discard) > 0) {
        var card = ds_list_find_value(discard, 0);
        ds_list_delete(discard, 0);
        ds_list_add(deck, card);
        
        card.owner = "deck";
        card.face_up = false;
    }
    
    // Shuffle
    shuffle_deck();
    
    // Reposition
    for (var i = 0; i < ds_list_size(deck); i++) {
        var card = deck[| i];
        card.target_x = deck_x;
        card.target_y = deck_y - (2 * i);
        card.depth = ds_list_size(deck) - i;
    }
}

function get_deck_size() {
    return ds_list_size(deck);
}

function get_player_hand_size() {
    return ds_list_size(player_hand);
}

function get_opponent_hand_size() {
    return ds_list_size(opponent_hand);
}