if (!instance_exists(obj_player)) exit;

var player_near = point_distance(x, y, obj_player.x, obj_player.y) < 64;
var player_clicked = mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id);

if (player_near && player_clicked) {
    var textbox = instance_exists(obj_textbox_controller) ? instance_find(obj_textbox_controller, 0) : noone;

    if (textbox == noone) {
        textbox = instance_create_layer(x, y, "Instances", obj_textbox_controller);
    }

    with (textbox) {
        text_array = [
            "Welcome to Emergency Pizza Delivery!",
            "Find the pizza seller to get the pizza",
            "If you are not sure who and what to deliver",
			"Ask any robot you can see.",
			"But always remember you should not make the pizza cool down",
			"Always check your pizza temerpature on top left.",
        ];
        current_text = 0;
        is_showing = true;
        source_object = other; // <-- this is the key line
    }
}
