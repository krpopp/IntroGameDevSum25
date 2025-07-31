// Advance dialogue
if (is_showing && keyboard_check_pressed(vk_enter)) {
    current_text++;

    if (current_text >= array_length(text_array)) {
        // End of dialogue
        is_showing = false;
        current_text = 0;

        // 🔁 Reset all shared-state to avoid leaking into other objects
        show_choices = false;
        choice_callback_object = noone;
        close_callback_object = noone;
        source_object = noone;
        source_bin_id = noone;

        // Optional global logic for intro
        if (!global.has_seen_intro) {
            global.has_seen_intro = true;
            global.timer_active = true;
        }

        // Optional callback logic (e.g. reward from NPC)
        if (variable_instance_exists(close_callback_object, "has_talked")) {
            close_callback_object.has_talked = true;
            if (!close_callback_object.item_given) {
                close_callback_object.item_given = true;
                array_push(global.special_items, "Hidden Pizza Lover's Token");
            }
        }
    }
}

// Show choices — only when callback is valid AND on 2nd line or later
if (!show_choices 
    && current_text >= 2 
    && current_text < array_length(text_array)
    && instance_exists(choice_callback_object)) {
    show_choices = true;
}

// Choice: Veggie
if (show_choices && instance_exists(choice_callback_object) && keyboard_check_pressed(ord("1"))) {
    global.chosen_pizza_type = "veggie";
    choice_callback_object.has_chosen = true;

    instance_create_layer(150, 30, "Instances", obj_pizza_vegan);

    text_array = ["Good choice. Now remember to deliver on time."];
    current_text = 0;
    show_choices = false;
}

// Choice: Meat
else if (show_choices && instance_exists(choice_callback_object) && keyboard_check_pressed(ord("2"))) {
    global.chosen_pizza_type = "meat";
    choice_callback_object.has_chosen = true;

    instance_create_layer(150, 30, "Instances", obj_pizza_meat);

    text_array = ["Good choice. Now remember to deliver on time."];
    current_text = 0;
    show_choices = false;
}
