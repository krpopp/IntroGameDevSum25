if (is_showing && keyboard_check_pressed(vk_enter)) {
    current_text++;

    if (current_text >= array_length(text_array)) {
        is_showing = false;
        current_text = 0;

        if (!global.has_seen_intro) {
            global.has_seen_intro = true;
            global.timer_active = true;
        }

        // Callback logic
        if (variable_instance_exists(close_callback_object, "has_talked")) {
            close_callback_object.has_talked = true;
            if (!close_callback_object.item_given) {
                close_callback_object.item_given = true;
                array_push(global.special_items, "Hidden Pizza Lover's Token");
            }
        }
    }
}

if (show_choices && keyboard_check_pressed(ord("1"))) {
    global.chosen_pizza_type = "veggie";
    choice_callback_object.has_chosen = true;
    instance_create_layer(20, 60, "GUI", obj_pizza_vegan);
    is_showing = false;
} 
else if (show_choices && keyboard_check_pressed(ord("2"))) {
    global.chosen_pizza_type = "meat";
    choice_callback_object.has_chosen = true;
    instance_create_layer(20, 60, "GUI", obj_pizza_meat);
    is_showing = false;
}