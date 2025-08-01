if (timer_active) {
    time_remaining -= 1/room_speed;
    
    if (time_remaining <= 0) {
        time_remaining = 0;
        timer_active = false;
        room_restart();
    }
}