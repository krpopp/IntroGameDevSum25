if (!global.timer_active) {
    for (var i = 0; i < array_length(global.collected_items); i++) {
        var item = global.collected_items[i];
        if (item == obj_pizza_meat || item == obj_pizza_vegan) {
            global.timer_active = true;
            break;
        }
    }
}

if (global.timer_active) {
    global.time_remaining -= 1 / room_speed;

    if (global.time_remaining <= 0) {
        global.time_remaining = 0;
        global.timer_active = false;
        room_restart(); // or room_goto(rm_fail);
    }
}