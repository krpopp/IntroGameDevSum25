if (global.start) {
    frame_timer += 1 / room_speed;

    if (image_index >= 8 && !at_final_frame) {
        at_final_frame = true;
        fail_timer = 0;
    }

    var has_heater_index = -1;
    if (is_array(global.collected_items)) {
        for (var i = 0; i < array_length(global.collected_items); i++) {
            if (global.collected_items[i] == "heater") {
                has_heater_index = i;
                break;
            }
        }
    }

    if (!at_final_frame) {
        if (frame_timer >= 5) {
            if (has_heater_index != -1) {
                image_index = max(0, image_index - 1);
                global.collected_items[has_heater_index] = undefined; 
            } else {
                image_index += 1;
            }
            frame_timer = 0;
        }
    } else {
        fail_timer += 1 / room_speed;

        if (fail_timer >= 3) {
            room_goto(rm_fail);
        }
    }
}
