if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        if (!has_chosen && !instance_exists(obj_textbox)) {
            var tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
            tb.text_array[0] = "Hi! How are you?";
            tb.text_array[1] = "Do you know which pizza you want to get now?";
            tb.current_text = 0;
            tb.is_showing = true;
            tb.show_choices = true;
            tb.choice_callback_object = id;
        }
    }
}
