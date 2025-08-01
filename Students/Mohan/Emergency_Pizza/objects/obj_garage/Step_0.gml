if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);

        if (tb == noone || tb.source_object == id || !tb.is_showing) {
            if (tb == noone) {
                tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
            }

            tb.source_object = id;

            if (!global.has_chosen) {
                if (global.has_gift) {
                    room_goto(rm_special);
                }
                tb.text_array[0] = "Hurry up and choose the pizza! AND BACK WITH PIZZA!";
                tb.show_choices = false;
                tb.current_text = 0;
                tb.is_showing = true;
            } else {
                if (!global.has_checked_pizza) {
                    var has_meat = instance_exists(obj_pizza_meat);
                    var has_vegan = instance_exists(obj_pizza_vegan);

                    if (global.correct_pizza == "meat" && has_meat && !has_vegan) {
                        room_goto(rm_succeed);
                        global.has_checked_pizza = true;
                    }
                    else if (global.correct_pizza == "vegan" && has_vegan && !has_meat) {
                        room_goto(rm_succeed);
                        global.has_checked_pizza = true;
                    }
                    else if (has_meat || has_vegan) {
                        room_goto(rm_fail);
                        global.has_checked_pizza = true;
                    }
                }
            }
        }
    }
}
