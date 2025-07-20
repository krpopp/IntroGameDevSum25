// Lists for card organization
deck = ds_list_create();
player_hand = ds_list_create();
opponent_hand = ds_list_create();
discard = ds_list_create();

// Deck configuration
num_cards = 24;  // 8 sets of 3 types
cards_per_hand = 3;

// Positions
deck_x = 40;
deck_y = room_height * 0.4;
discard_x = room_width * 0.85;
discard_y = room_height * 0.4;  // Same height as deck

// Create all cards
for (var i = 0; i < num_cards; i++) {
    var new_card = instance_create_layer(deck_x, deck_y - (3 * i), "Instances", obj_card);
    
    // Set initial position to final position (no animation)
    new_card.x = deck_x;
    new_card.y = deck_y - (3 * i);
    new_card.target_x = deck_x;
    new_card.target_y = deck_y - (3 * i);
    
    // Set card type (0=scissors, 1=rock, 2=paper)
    new_card.card_type = i mod 3;
    new_card.owner = "deck";
    new_card.face_up = false;
    
    // Add to deck
    ds_list_add(deck, new_card);
}

// Initial shuffle
randomize();
ds_list_shuffle(deck);

for (var i = 0; i < ds_list_size(deck); i++) {
    var card = deck[| i];
    card.depth = 100 - i;
    card.target_y = deck_y - (3 * i);
    card.y = card.target_y;
}