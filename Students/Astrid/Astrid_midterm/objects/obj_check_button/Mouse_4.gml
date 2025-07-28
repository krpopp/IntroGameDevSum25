is_pressed = true;
alarm[0] = 10; 

var correct = 0; 
var wrong = 0;

with (obj_slot) {
    if (is_occupied && instance_exists(occupied_note)) {
        if (occupied_note.note_id == pair_id) {
            correct++;  
        } else {
            wrong++;    
        }
    }
}
audio_play_sound(snd_button, 10, false);

var unplaced = instance_number(obj_note) - correct - wrong;

var message = "";
message += "Correct Cards: " + string(correct) + " ;    " ;
message += "Wrong Cards: " + string(wrong) + " ;     ";
message += "Un_placed cards: " + string(total_notes - correct - wrong);

show_message(message);

with (obj_slot) {
    should_blink = (is_occupied && instance_exists(occupied_note) && (occupied_note.note_id != pair_id));
    
    if (should_blink) {
        blink_state = true;
        blink_timer = 90;
    }
}

if(correct == 10){
	room_goto(Room2);
	audio_stop_sound(snd_bgm);
}