if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);

        if (tb != noone && tb.is_showing) exit;

        if (tb == noone) {
            tb = instance_create_layer(x, y - 80, "Instances", obj_textbox);
        }

        tb.text_array = [];

        if (!has_been_checked) {
            tb.text_array[0] = "Nothing here hehe";
            has_been_checked = true;
        } else {
            tb.text_array[0] = "Don't check anymore. Just go delivery. Nothing here.";
        }

        tb.current_text = 0;
        tb.is_showing = true;
    }
}
