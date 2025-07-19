// Smooth movement to target position
if (abs(x - target_x) > 1) {
    x = lerp(x, target_x, 0.1);
} else {
    x = target_x;
}

if (abs(y - target_y) > 1) {
    y = lerp(y, target_y, 0.1);
} else {
    y = target_y;
}

// Hover effect for player cards only (from your original code)
if (owner == "player" && obj_game_manager.state == STATES.PICK) {
    var mx = mouse_x;
    var my = mouse_y;
    var padding = 4;
    
    // Check if mouse is over this card
    is_hovering = (mx >= x - padding && mx <= x + sprite_width + padding &&
                   my >= y - padding && my <= y + sprite_height + padding);
    
    // Apply hover effect - card moves up
    if (is_hovering) {
        target_y = base_y - 20;  // Your original hover offset
    } else {
        target_y = base_y;
    }
}

// Simple click detection - just notify dealer
if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        // Tell the dealer which card was clicked
        with (obj_game_manager) {
            card_clicked = other.id;
        }
    }
}