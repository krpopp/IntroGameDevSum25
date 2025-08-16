// Background overlay
draw_set_alpha(0.9);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Success message (slides in)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_lime);
draw_text_transformed(room_width/2, message_y - 80, 
    "PIZZA DELIVERED!", 3, 3, 0);

// The twist reveal
if (show_details) {
    draw_set_color(c_white);
    draw_text_ext(room_width/2, message_y, 
        "Delivery Address: CIRCUITS & FIXES Robot Repair Shop\n\n" +
        "\"Thanks for making it! We've been ordering pizzas\n" +
        "to find and rescue damaged delivery units.\n" +
        "Let's get that heating coil fixed!\"\n\n" +
        "Welcome to the Robot Collective.", 
        20, 400); // line spacing and width
    
    // Show delivery stats
    draw_set_color(c_yellow);
    draw_text(room_width/2, message_y + 120, 
        "Delivery Time: " + string(obj_game_controller.delivery_time) + " seconds");
    draw_text(room_width/2, message_y + 140, 
        "Temperature Frames Survived: " + string(9 - obj_player.temperature_frame + 1) + "/9");
    
    // Options
    draw_set_color(c_gray);
    draw_text(room_width/2, room_height - 60, "Press SPACE to continue");
    draw_text(room_width/2, room_height - 40, "Press R to deliver another pizza");
}

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);