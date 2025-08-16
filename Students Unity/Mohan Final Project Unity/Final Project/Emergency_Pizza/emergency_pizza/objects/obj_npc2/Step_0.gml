if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);

        if (tb == noone || tb.source_object == id || !tb.is_showing) {
            if (tb == noone) {
                tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
            }

            var pizza_hint = (global.correct_pizza == "meat")
                ? "I heard the Meat Pizza is the one they’re expecting today."
                : "I think it’s the Veggie Pizza that needs to be delivered.";

            tb.text_array[0] = pizza_hint;
            tb.text_array[1] = "Make sure to bring the right one, or you’ll be in trouble.";
            tb.current_text = 0;
            tb.show_choices = false;
            tb.source_object = id;
            tb.is_showing = true;
        }
    }
}
