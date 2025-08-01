if (instance_exists(obj_player)) {
    var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;
    if (near && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
        var tb = instance_find(obj_textbox, 0);
        if (tb == noone || !tb.is_showing) {
            audio_play_sound(snd_robot, 1, false);
            if (tb == noone) {
                tb = instance_create_layer(x, y, "Instances", obj_textbox);
            }
            tb.source_object = id;
            
            if (!global.has_chosen) {
                if (global.has_gift) {
                    room_goto(rm_special);
                    return;
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
                        return;
                    }
                    else if (global.correct_pizza == "vegan" && has_vegan && !has_meat) {
                        room_goto(rm_succeed);
                        global.has_checked_pizza = true;
                        return;
                    }
                    else if (has_meat || has_vegan) {
                        room_goto(rm_fail);
                        global.has_checked_pizza = true;
                        return;
                    }
                    tb.text_array[0] = "Where's the pizza?";
                    tb.show_choices = false;
                    tb.current_text = 0;
                    tb.is_showing = true;
                } else {
                    tb.text_array[0] = "You already checked the pizza!";
                    tb.show_choices = false;
                    tb.current_text = 0;
                    tb.is_showing = true;
                }
            }
        }
    }
}