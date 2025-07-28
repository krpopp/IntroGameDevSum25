with (obj_note) {
    is_hovered = false;
}

var top_hovered = noone;
var highest_depth = -1000000;
with (obj_note) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if (depth > highest_depth) {
            highest_depth = depth;
            top_hovered = id;
        }
    }
}

//if (top_hovered != noone) {
//    top_hovered.is_hovered = true;
    
//    global.show_text = top_hovered.text;
    
//    if (!top_hovered.was_hovered) {

//    }
//    top_hovered.was_hovered = true;
//} else {
//    global.show_text = "";
//}


if (top_hovered != noone) {
    top_hovered.is_hovered = true;
    
    // update content in display area
    display_area.display_text = top_hovered.text;
    display_area.is_active = true;
    
    if (!top_hovered.was_hovered) {
		audio_play_sound(snd_hover, 10, false);
			audio_sound_gain(snd_hover, 0.5, 0);
    
    }
    top_hovered.was_hovered = true;
} else {
    // if hovering on no card
    display_area.is_active = false;
}

global.current_hover_note = top_hovered;

