// Always initialize these
box_height = 160;
text_margin = 20;
text_array = [];
current_text = 0;
is_showing = false;
show_choices = false;              
choice_callback_object = noone;
// Ensure global var is safe
if (!variable_global_exists("has_seen_intro")) {
    global.has_seen_intro = false;
}

// Only show intro once
if (!global.has_seen_intro) {
    text_array[0] = "Welcome to Emergency Pizza Delivery!";
    text_array[1] = "Your heating system is broken...";
    text_array[2] = "The pizza is your only source of warmth!";
    text_array[3] = "Press Z to hug the pizza and stay warm.";
    is_showing = true;
    global.has_seen_intro = true;
}

close_callback_object = noone; 
