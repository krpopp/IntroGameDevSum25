if (!instance_exists(obj_player)) exit;

var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

if (near && mouse_check_button_pressed(mb_left)) {
    var tb = instance_find(obj_textbox, 0);

    if (tb != noone && tb.is_showing) exit;

    if (tb == noone) {
        tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
    }

    tb.text_array = [];

    if (global.chosen_pizza_type == "special_pizza") {
        tb.text_array[0] = "Whoa! Is that the legendary Special Pizza?";
        tb.text_array[1] = "You're the chosen one! Please... deliver it safely!";

        // Remove the special pizza instance from player or room
        var special_pizza = instance_nearest(obj_player.x, obj_player.y, obj_special_pizza);
        if (instance_exists(special_pizza)) {
            with (special_pizza) {
                instance_destroy();
            }
        }

        // Give the hidden gift
        instance_create_layer(obj_player.x, obj_player.y - 16, "Instances", obj_hidden_gift);
    } else {
        tb.text_array[0] = "Hi there! Have you picked the right pizza yet?";
        tb.text_array[1] = "I hope you brought something tasty.";
    }

    tb.current_text = 0;
    tb.is_showing = true;
}
