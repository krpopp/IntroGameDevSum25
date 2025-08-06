if (is_showing && keyboard_check_pressed(vk_enter)) {
    current_text++;

    if (current_text >= array_length(text_array)) {
        is_showing = false;
        current_text = 0;

        show_choices = false;
        choice_callback_object = noone;
        close_callback_object = noone;
        source_object = noone;
        source_bin_id = noone;

        if (!global.has_seen_intro) {
            global.has_seen_intro = true;
            global.timer_active = true;
        }

        if (variable_instance_exists(close_callback_object, "has_talked")) {
            close_callback_object.has_talked = true;
            if (!close_callback_object.item_given) {
                close_callback_object.item_given = true;
                array_push(global.special_items, "Hidden Pizza Lover's Token");
            }
        }
    }
}

if (!show_choices 
    && current_text >= 2 
    && current_text < array_length(text_array)
    && instance_exists(choice_callback_object)) {
    show_choices = true;
}

if (show_choices && instance_exists(choice_callback_object) && keyboard_check_pressed(ord("1"))) {
    global.chosen_pizza_type = "veggie";
    choice_callback_object.has_chosen = true;

    instance_create_layer(150, 30, "Instances", obj_pizza_vegan);

    text_array = ["Good choice. Now remember to deliver on time."];
    current_text = 0;
    show_choices = false;
}

else if (show_choices && instance_exists(choice_callback_object) && keyboard_check_pressed(ord("2"))) {
    global.chosen_pizza_type = "meat";
    choice_callback_object.has_chosen = true;

    instance_create_layer(150, 30, "Instances", obj_pizza_meat);

    text_array = ["Good choice. Now remember to deliver on time."];
    current_text = 0;
    show_choices = false;
}

if (is_showing && instance_exists(source_object)) {
    if (point_distance(source_object.x, source_object.y, obj_player.x, obj_player.y) > interaction_range) {
        is_showing = false;
    }
}