if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);

        if (tb == noone || tb.source_object == id || !tb.is_showing) {
            if (tb == noone) {
                tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
            }

            tb.text_array[0] = "You should talk to the Delivery Manager—they know which pizza to bring.";
            tb.text_array[1] = "Also, I’ve heard people sometimes toss useful tools in the trash bins.";
            tb.text_array[2] = "Might be worth checking before you leave!";
            tb.current_text = 0;
            tb.show_choices = false;
            tb.source_object = id;
            tb.is_showing = true;
        }
    }
}
