if (distance_to_object(obj_player) < 80 && mouse_check_button_pressed(mb_left)) {
    var tb = obj_textbox_controller;

    if (!instance_exists(tb)) {
        tb = instance_create_layer(x, y, "Instances", obj_textbox_controller);
    }

    if (!tb.is_showing) {
        tb.text_array = ["Hi there!", "Do you want a pizza?"];
        tb.current_text = 0;
        tb.is_showing = true;
        tb.show_choices = false;
        tb.choice_callback_object = id;
        tb.close_callback_object = id;
        tb.source_object = id;
        tb.source_bin_id = id;
    }
}
