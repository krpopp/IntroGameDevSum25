if (move_up) {
    title_y -= 2;
    if (title_y <= room_height / 4) {
        title_y = room_height / 4;
        move_up = false;
        show_menu = true;
    }
} else if (show_menu) {
    if (keyboard_check_pressed(vk_up)) {
        selected_index = (selected_index - 1 + array_length(options)) mod array_length(options);
    }
    if (keyboard_check_pressed(vk_down)) {
        selected_index = (selected_index + 1) mod array_length(options);
    }

    if (keyboard_check_pressed(vk_enter)) {
        if (options[selected_index] == "Start") {
            room_goto(rm_main);
        } else if (options[selected_index] == "Quit") {
            game_end();
        }
    }
}
