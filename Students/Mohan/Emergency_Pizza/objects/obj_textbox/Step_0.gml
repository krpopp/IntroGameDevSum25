// Toggle textbox with Space
if (keyboard_check_pressed(vk_space)) {
    if (!is_showing) {
        is_showing = true;
        current_text = 0;
    } else {
        is_showing = false;
    }
}

// Show next text with Enter
if (is_showing && keyboard_check_pressed(vk_enter)) {
    current_text++;
    
    if (current_text >= array_length(text_array)) {
        is_showing = false;
        current_text = 0;
    }
}