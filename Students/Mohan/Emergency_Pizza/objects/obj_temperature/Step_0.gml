// Update frame timer
frame_timer += 1 / room_speed;

if (image_index >= 8 && !at_final_frame) {
    at_final_frame = true;
    fail_timer = 0;
}

if (!at_final_frame) {
    if (frame_timer >= 5) {
        image_index += 1;
        frame_timer = 0;
    }
} else {
    fail_timer += 1 / room_speed;

    if (fail_timer >= 3) {
        room_goto(rm_fail);
    }
}
