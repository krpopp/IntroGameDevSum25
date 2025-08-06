//audio_play_sound(snd_hover, 1, false); 

if (!global.current_hover_note) {
    global.current_hover_note = id;
    depth = -100;
    //hover_offset = 10;
		audio_play_sound(snd_hover, 10, false);
			audio_sound_gain(snd_hover, 0.5, 0);
} else if (depth > global.current_hover_note.depth) {
    exit; 
}

