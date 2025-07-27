key_left = keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_up = keyboard_check(ord("W"));
key_down = keyboard_check(ord("S"));

// Calculate movement
hsp = (key_right - key_left) * move_speed;
vsp = (key_down - key_up) * move_speed;

// Apply movement
x += hsp;
y += vsp;

// Animation logic
if (hsp == 0 && vsp == 0) {
    // Standing still - idle animation
    if (image_index < idle_start || image_index > idle_end) {
        image_index = idle_start;
    }
    image_speed = 0.2; // Slow idle animation
} 
else if (hsp > 0) {
    // Moving right
    if (image_index < walk_right_start || image_index > walk_right_end) {
        image_index = walk_right_start;
    }
    image_speed = 0.5;
}
else if (hsp < 0) {
    // Moving left
    if (image_index < walk_left_start || image_index > walk_left_end) {
        image_index = walk_left_start;
    }
    image_speed = 0.5;
}
else if (vsp < 0) {
    // Moving up
    if (image_index < move_up_start || image_index > move_up_end) {
        image_index = move_up_start;
    }
    image_speed = 0.5;
}
else if (vsp > 0) {
    // Moving down
    if (image_index < move_down_start || image_index > move_down_end) {
        image_index = move_down_start;
    }
    image_speed = 0.5;
}

// Special case: Moving up but stopped
if (key_up && !key_left && !key_right && !key_down && hsp == 0 && vsp == 0) {
    image_index = move_up_stop;
    image_speed = 0;
}
