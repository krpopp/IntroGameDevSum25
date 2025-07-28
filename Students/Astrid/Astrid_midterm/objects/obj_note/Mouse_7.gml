
//depth = -1; 

//if (is_dragging) {
//    is_dragging = false;

//    if (hit_slot != noone) {
//		global.is_placed = true;
//        if (note_id == hit_slot.pair_id) {
//			//obj_check_button.correct_count += 1;
//            show_message(string(note_id) + string(hit_slot.pair_id)+ ", is correct   ");

//            hit_slot.is_occupied = true;
//            hit_slot.occupied_note = id;
       
//        } else {
//			//obj_check_button.wrong_count += 1;
//			show_message(string(note_id) + string(hit_slot.pair_id) + ",  is not correct  ");
         
//        }
//    }
//}


is_dragging = false;
depth = -1;


var hit_slot = instance_position(mouse_x, mouse_y, obj_slot);
if (hit_slot != noone) {
    with (obj_slot) {
        if (occupied_note == other.id) {
            is_occupied = false;
            occupied_note = noone;
			audio_play_sound(snd_down, 10, false);
			audio_sound_gain(snd_down, 2, 0);
        }
    }
    
  
    hit_slot.is_occupied = true;
    hit_slot.occupied_note = id;
}