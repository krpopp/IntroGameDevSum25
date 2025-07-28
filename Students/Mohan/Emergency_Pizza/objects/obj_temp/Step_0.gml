frame_timer--;

if (frame_timer <= 0) {
    // Move to next (colder) frame
    temperature_frame++;
    
    if (temperature_frame > 9) {
        // Pizza is frozen - game over
        room_goto(rm_fail);
    } else {
        // Reset timer for next frame
        frame_timer = 5 * room_speed;
        // Update sprite to show current temperature
        image_index = temperature_frame - 1;
    }
}

// That's it for the temperature system!

// For rm_fail, just need this simple object:
// CREATE EVENT (in obj_fail_controller for rm_fail)
// (Nothing needed)

// DRAW EVENT (in obj_fail_controller for rm_fail)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_red);
draw_text_transformed(room_width/2, room_height/2, 
    "You failed to deliver pizza!!!!!!", 2, 2, 0);
draw_set_color(c_white);
draw_text(room_width/2, room_height/2 + 60, "Press R to restart");

// STEP EVENT (in obj_fail_controller for rm_fail)
if (keyboard_check_pressed(ord("R"))) {
    room_goto(rm_game);
}