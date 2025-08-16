var player_nearby = false;
if (instance_exists(obj_player)) {
    if (distance_to_object(obj_player) < interaction_range) {
        player_nearby = true;
    }
}

// 🖱️ Player clicked while near this object
if (player_nearby && mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        
        var textbox = instance_find(obj_textbox, 0);
        if (textbox == noone) {
            textbox = instance_create_depth(x, y - 48, -1000, obj_textbox);
        }

        textbox.text_array = [];

        if (!has_been_opened) {
            // Pick random item
            item_index = irandom(array_length(item_names) - 1);
            var item_name = item_names[item_index];
            var item_desc = item_descriptions[item_index];

            textbox.text_array[0] = "You found: " + item_name;
            textbox.text_array[1] = item_desc;

            array_push(global.collected_items, item_name);

            has_been_opened = true;
        } else {
            textbox.text_array[0] = "It's empty now. Hurry up!";
        }

        textbox.current_text = 0;
        textbox.is_showing = true;

        // 🔗 Track which bin opened it
        textbox.source_bin_id = id;
    }
}

// 🚪 Auto-close textbox if player walks away from this bin
var textbox = instance_find(obj_textbox, 0);
if (textbox != noone && textbox.is_showing && textbox.source_bin_id == id) {
    if (distance_to_object(obj_player) > interaction_range) {
        textbox.is_showing = false;
        textbox.current_text = 0;
    }
}
