var player_nearby = false;
if (instance_exists(obj_player)) {
    if (distance_to_object(obj_player) < interaction_range) {
        player_nearby = true;
    }
}

if (player_nearby && mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
    var textbox = instance_exists(obj_textbox_controller) ? instance_find(obj_textbox_controller, 0) : noone;

    if (textbox != noone && textbox.is_showing && textbox.source_bin_id == id) {
        exit;
    }

    if (textbox == noone) {
        textbox = instance_create_layer(x, y, "Instances", obj_textbox_controller);
    }

    with (textbox) {
        text_array = [];

        if (!other.has_been_opened) {
            other.item_index = irandom(array_length(other.item_names) - 1);
            var item_name = other.item_names[other.item_index];
            var item_desc = other.item_descriptions[other.item_index];

            text_array[0] = "You found: " + item_name;
            text_array[1] = item_desc;
			
			if(item_name == "Boost engery drink"){
				global.has_speedup = true;
			}
			
            array_push(global.collected_items, item_name);
            other.has_been_opened = true;
        } else {
            text_array[0] = "It's empty now. Hurry up!";
        }

        current_text = 0;
        is_showing = true;
        show_choices = false;
        source_bin_id = other.id;
    }
}

var textbox = instance_exists(obj_textbox_controller) ? instance_find(obj_textbox_controller, 0) : noone;
if (textbox != noone && textbox.is_showing && textbox.source_bin_id == id) {
    if (distance_to_object(obj_player) > interaction_range) {
        textbox.is_showing = false;
        textbox.current_text = 0;
    }
}
