if (!variable_global_exists("special_items")) {
    global.special_items = [];
}

if (!variable_instance_exists(id, "has_talked")) has_talked = false;
if (!variable_instance_exists(id, "item_given")) item_given = false;

if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < 80;

    if (near && mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) {

            if (!has_talked && !instance_exists(obj_textbox)) {
                var tb = instance_create_layer(x, y - 100, layer_get_name(0), obj_textbox);
                tb.text_array = [
                    "Don't be afraid of me.",
                    "Just want to let you know I'm also into pizza, hehe.",
                    "I'm going back to sleep now."
                ];
                tb.current_text = 0;
                tb.is_showing = true;
                tb.close_callback_object = id;
            }

            else if (has_talked && !instance_exists(obj_textbox)) {
                var tb = instance_create_layer(x, y - 100, layer_get_name(0), obj_textbox);
                tb.text_array = [ "zzz...." ];
                tb.current_text = 0;
                tb.is_showing = true;
            }
        }
    }
}
