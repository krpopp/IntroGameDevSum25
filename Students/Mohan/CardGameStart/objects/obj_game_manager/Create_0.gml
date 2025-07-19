// Game States
enum STATES {
    DEAL,
    PICK,
    COMPARE,
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

// Create managers
deck_manager = instance_create_layer(0, 0, "Instances", obj_deck_manager);