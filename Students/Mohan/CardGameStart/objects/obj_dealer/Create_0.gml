deal_timer = 0;
deal_interval = 15; // frames between each card (adjust for speed)
deal_state = "opponent";
opponent_hand = ds_list_create();

// offsets card's x position in the player's hand
hand_x_offset = 100;

// total number of cards in the deck
num_cards = 24;

enum STATES {
    DEAL,
    PICK,
    COMPARE,
    CLEANUP,
    RESHUFFLE
}

state = STATES.DEAL;

// lists for various states cards can be in
deck = ds_list_create();
player_hand = ds_list_create();
discard = ds_list_create();
// COMPUTER HAND LIST

// variables to track which cards the player has clicked on
global.player_choice_one = noone;
global.player_choice_two = noone;

// track player's score
points = 0;

// ✅ fixed position for original stack (middle-left)
var stack_x = 40;
var stack_y = room_height * 0.4;

for (var _i = 0; _i < num_cards; _i++) {
    // create a card at middle-left
    var _new_card = instance_create_layer(stack_x, stack_y, "Instances", obj_card);

    // stack appearance offset
    _new_card.y = stack_y - (2 * _i);

    _new_card.target_x = stack_x;
    _new_card.target_y = stack_y - (2 * _i);

    // set the card's sprite
    _new_card.face_index = _i % 4;

    // card state
    _new_card.in_player_hand = false;
    _new_card.face_up = false;

    // add the card to the deck
    ds_list_add(deck, _new_card);
}

// shuffle
randomize();
ds_list_shuffle(deck);

// maintain visual stack depth
for (var _i = 0; _i < num_cards; _i++) {
    deck[| _i].depth = num_cards - _i;
    deck[| _i].target_y = stack_y - (2 * _i); // also corrected this to use stack_y
}
