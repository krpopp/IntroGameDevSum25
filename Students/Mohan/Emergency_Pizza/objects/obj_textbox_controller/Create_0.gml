text_array = [];
current_text = 0;
is_showing = false;
show_choices = false;
choice_callback_object = noone;
close_callback_object = noone;
source_object = noone;
source_bin_id = noone;

interaction_range = 64; 

if (!variable_global_exists("has_seen_intro")) {
    global.has_seen_intro = false;
}
