// Slide in the main message
if (message_y < message_target_y) {
    message_y += slide_speed;
} else {
    message_y = message_target_y;
    
    // Start showing details after message arrives
    if (details_timer > 0) {
        details_timer--;
    } else {
        show_details = true;
    }
}

// Restart option
if (keyboard_check_pressed(ord("R"))) {
    room_goto(rm_menu); // or rm_game to play again
}

// Continue option
if (keyboard_check_pressed(vk_space) && show_details) {
    game_end(); // or room_goto(rm_menu)
}
