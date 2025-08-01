if (!instance_exists(obj_player)) exit;

var near = point_distance(x, y, obj_player.x, obj_player.y) < interaction_range;

if (near && mouse_check_button_pressed(mb_left)) {
    var tb = instance_find(obj_textbox, 0);

    if (tb != noone && tb.is_showing) exit;

    if (tb == noone) {
        tb = instance_create_layer(x, y - 100, "Instances", obj_textbox);
    }

    tb.text_array = [];
    tb.text_array[0] = "You found.";
    tb.text_array[1] = "You got.";
    tb.text_array[2] = "Good luck.";

    tb.current_text = 0;
    tb.is_showing = true;

    global.has_gift = true;
}
