if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left)) {
        var tb = instance_find(obj_textbox, 0);

        // Prevent overlap with existing textbox
        if (tb != noone && tb.is_showing) exit;

        if (tb == noone) {
            tb = instance_create_layer(x, y - 80, "Instances", obj_textbox);
        }

        tb.text_array = [];

        if (!has_given_item) {
            has_given_item = true;

            // Initialize global list if not already
            if (!variable_global_exists("collected_items")) {
                global.collected_items = [];
            }

            // Add "special_pizza" to item list
            array_push(global.collected_items, "special_pizza");

            // Set global type for delivery logic
            global.chosen_pizza_type = "special_pizza";

            tb.text_array[0] = "You received the legendary Special Pizza!";
        } else {
            tb.text_array[0] = "You already got the gift. Go.";
        }

        tb.current_text = 0;
        tb.is_showing = true;
    }
}
