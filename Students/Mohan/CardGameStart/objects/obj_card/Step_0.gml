if (obj_dealer.state == STATES.PICK) {
    if (in_player_hand) {
        // Mouse hover logic
        var mx = mouse_x;
        var my = mouse_y;
        var padding = 4;
        var is_hovering = (
            mx >= x - padding && mx <= x + sprite_width + padding &&
            my >= base_y - padding && my <= base_y + sprite_height + padding
        );

        // Hover move up
        target_y = is_hovering ? base_y - 20 : base_y;

        // Click to select (no longer flips)
        if (is_hovering && mouse_check_button_pressed(mb_left)) {
            if (global.player_choice_one == noone) {
                global.player_choice_one = id;
            } else if (global.player_choice_two == noone) {
                global.player_choice_two = id;
            }
        }

        // Flip automatically
        if (!face_up) {
            face_up = true;
        }

        // After first flip, push opponent's middle card
        if (face_up && !has_flipped) {
            has_flipped = true;

            // Move middle opponent card down by modifying its base_y
            with (obj_card) {
                if (in_opponent_hand && spread_index == 1) {
                    base_y += 20;
                    target_y = base_y;
                }
            }
        }
    }
}
