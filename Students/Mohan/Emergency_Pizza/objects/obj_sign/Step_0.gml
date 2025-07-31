if (!instance_exists(obj_player)) exit;

var player_near = point_distance(x, y, obj_player.x, obj_player.y) < 64;
var player_clicked = mouse_check_button_pressed(mb_left) && position_meeting(mouse_x, mouse_y, id);

if (player_near && player_clicked) {
    var textbox = instance_exists(obj_textbox) ? instance_find(obj_textbox, 0) : noone;

    if (textbox == noone) {
        textbox = instance_create_layer(x, y - 80, "Instances", obj_textbox);
    }

    textbox.text_array[0] = "Welcome to Emergency Pizza Delivery!";
    textbox.text_array[1] = "Your heating system is broken...";
    textbox.text_array[2] = "The pizza is your only source of warmth!";
    textbox.text_array[3] = "Press Z to hug the pizza and stay warm.";
    textbox.current_text = 0;
    textbox.is_showing = true;
    textbox.show_choices = false;
}
