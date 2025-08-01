if (!instance_exists(obj_textbox_controller)) exit;

with (obj_textbox_controller) {
    if (is_showing) {
        var box_height = 160;
        var text_margin = 20;
        var vertical_offset = 130; // move the whole box up

        var box_top = room_height - box_height - vertical_offset;
        var box_bottom = room_height - vertical_offset;

        draw_set_alpha(0.95);
        draw_set_color(c_black);
        draw_rectangle(0, box_top, room_width, box_bottom, false);

        draw_set_alpha(1);
        draw_set_color(c_white);
        var border_offset = 5;
        draw_rectangle(border_offset, box_top + border_offset, room_width - border_offset, box_bottom - border_offset, true);
        draw_rectangle(border_offset + 2, box_top + border_offset + 2, room_width - border_offset - 2, box_bottom - border_offset - 2, true);

        draw_set_font(fnt_main);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text_ext(text_margin, box_top + text_margin, text_array[current_text], 25, room_width - (text_margin * 2));

        draw_set_color(c_yellow);
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        if (current_text < array_length(text_array) - 1) {
            draw_text(room_width - text_margin, box_bottom - 10, "Press ENTER for next >");
        } else if (!show_choices) {
            draw_text(room_width - text_margin, box_bottom - 10, "Press ENTER to close >");
        }

        if (show_choices && current_text == array_length(text_array) - 1) {
            draw_set_font(fnt_main);
            draw_set_color(c_yellow);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            var choice_x = 440;
            var choice_y_start = box_top + 20;

            if (choice_callback_object != noone && choice_callback_object.object_index == obj_garage) {
                draw_text(choice_x, choice_y_start, "1. YES");
                draw_text(choice_x, choice_y_start + 32, "2. NO");
            } else if (choice_callback_object != noone && choice_callback_object.object_index == obj_npc1) {
                draw_text(choice_x, choice_y_start, "1. Veggie Pizza");
                draw_text(choice_x, choice_y_start + 32, "2. Meat Pizza");
            }
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_font(-1);
    }
}
