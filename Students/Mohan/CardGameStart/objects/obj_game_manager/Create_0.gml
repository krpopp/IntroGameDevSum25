enum STATES {
    DEAL,
    OPPONENT_PICK, 
    PLAYER_PICK,   
    COMPARE,
    MOVE_TO_DISCARD, 
    RESHUFFLE
}
state = STATES.DEAL;

// Score tracking
player_score = 0;
opponent_score = 0;

// Card selection tracking
player_selected_card = noone;
opponent_selected_card = noone;
card_clicked = noone;

// Timing
deal_timer = 0;
deal_interval = 15;
compare_timer = 0;
compare_duration = 60; 
opponent_pick_timer = 0;
opponent_pick_delay = 30; 
move_timer = 0;
move_interval = 10; 

// Round tracking
cards_played_this_round = 0; 
is_first_round = true;
cards_to_move = ds_list_create(); 

// Create managers
deck_manager = instance_create_layer(0, 0, "Instances", obj_deck_manager);

// Reshuffle animation variables
reshuffle_started = false;
reshuffle_timer = 0;
cards_to_shuffle = noone;
shuffle_animation_cards = noone;
total_cards_to_shuffle = 0;
shuffle_show_timer = 0;

reshuffle_started = false;
reshuffle_timer = 0;
reshuffle_delay_timer = 0;