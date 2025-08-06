if (is_showing && instance_exists(source_object)) {
    if (point_distance(source_object.x, source_object.y, obj_player.x, obj_player.y) > interaction_range) {
        is_showing = false;
    }
}

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
    }
}