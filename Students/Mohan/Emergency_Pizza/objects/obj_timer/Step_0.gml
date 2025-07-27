// STEP EVENT
// Countdown timer
if (timer_active) {
    time_remaining -= 1/room_speed;
    
    // Check if time's up
    if (time_remaining <= 0) {
        time_remaining = 0;
        timer_active = false;
        // Game over - pizza got too cold!
        room_restart(); // or room_goto(room_gameover);
    }
}