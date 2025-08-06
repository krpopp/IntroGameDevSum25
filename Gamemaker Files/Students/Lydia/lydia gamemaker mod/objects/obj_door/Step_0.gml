if (place_meeting(x, y, obj_player)) {
    if (keyboard_check_pressed(vk_space)) {
        room_goto(Room2);
		audio_play_sound(snd_door,0,false);
    }
}


depth = - 2000;