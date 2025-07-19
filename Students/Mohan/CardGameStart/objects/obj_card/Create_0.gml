// Position and movement
x = 100;
y = room_height * 0.5;
target_x = x;
target_y = y;
base_y = room_height * 0.7;

// Card properties
owner = "deck";  // "deck", "player", "opponent", "discard"
card_type = 0;   // 0 = rock, 1 = paper, 2 = scissors
face_up = false;
hand_position = -1;  // 0, 1, or 2 (position in hand)

// Visual properties
hover_offset = 20;  // How much to move up when hovered
is_hovering = false;