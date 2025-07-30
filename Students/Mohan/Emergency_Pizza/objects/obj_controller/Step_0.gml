if (global.timer_active) {
    global.time_remaining -= 1 / room_speed;
    if (global.time_remaining <= 0) {
        global.time_remaining = 0;
        global.timer_active = false;
        room_restart(); // or room_goto(room_gameover);
    }
}