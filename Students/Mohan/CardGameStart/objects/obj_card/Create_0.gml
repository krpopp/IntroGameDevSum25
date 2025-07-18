x = 100;
y = room_height * 0.5;
target_x = x;
target_y = y;

base_y = room_height * 0.7;

// Add these:
spread_index = 0;       // set externally when dealing cards: 0, 1, 2, ...
in_player_hand = false; // true if this card belongs to the player
in_opponent_hand = false; // true if belongs to opponent
has_flipped = false;
