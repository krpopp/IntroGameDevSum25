if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);

        if (tb == noone || tb.source_object == id || !tb.is_showing) {
            if (tb == noone) {
                tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
            }

            if (!has_chosen) {
                tb.text_array[0] = "Do you know which pizza to pick up now?";
                tb.current_text = 0;
                tb.show_choices = true;
                tb.choice_callback_object = id;
                tb.source_object = id;
            } else {
                tb.text_array[0] = "Hurry up and deliver the pizza!";
                tb.current_text = 0;
                tb.show_choices = false;
                tb.source_object = id;
            }

            tb.is_showing = true;
        }
    }
}
