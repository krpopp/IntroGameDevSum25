var player_near = false;

if (instance_exists(obj_player)) {
    var dist = point_distance(x, y, obj_player.x, obj_player.y);
    player_near = dist < interaction_range;

    // Auto-hide textbox if too far
    if (!player_near && textbox_instance != noone) {
        with (textbox_instance) {
            is_showing = false;
            instance_destroy();
        }
        warning_stage = 0;
        textbox_instance = noone;
    }

    // Player is nearby
    if (player_near) {
        // Show initial warning
        if (warning_stage == 0 && textbox_instance == noone) {
            textbox_instance = instance_create_layer(x, y - 80, "Instances", obj_textbox);
            textbox_instance.text_array[0] = "WARNING: DON'T GO INTO IT";
            textbox_instance.current_text = 0;
            textbox_instance.is_showing = true;
            warning_stage = 1;
        }

        // Handle click
        if (mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
            if (warning_stage == 1) {
                textbox_instance.text_array[0] = "If you really want to go in, click again.";
                textbox_instance.current_text = 0;
                warning_stage = 2;
            }
            else if (warning_stage == 2) {
                if (textbox_instance != noone) {
                    with (textbox_instance) instance_destroy();
                }
                instance_destroy(); // Destroys the danger object
            }
        }
    }
}
