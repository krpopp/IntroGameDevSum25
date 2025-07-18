if (obj_dealer.state == STATES.PICK) {
    if (in_player_hand && !face_up) {
        // Mouse coordinates
        var mx = mouse_x;
        var my = mouse_y;

        // Card sprite bounds for stable hitbox
        var padding = 4;
        var is_hovering = (
            mx >= x - padding && mx <= x + sprite_width + padding &&
            my >= base_y - padding && my <= base_y + sprite_height + padding
        );

        // Adjust target_y based on stable hover state
        if (is_hovering) {
            target_y = base_y - 20;
        } else {
            target_y = base_y;
        }

        // Handle selection
        if (is_hovering && mouse_check_button_pressed(mb_left)) {
            if (global.player_choice_one == noone) {
                global.player_choice_one = id;
                face_up = true;
            } else if (global.player_choice_two == noone) {
                global.player_choice_two = id;
                face_up = true;
            }
        }
    }
}
