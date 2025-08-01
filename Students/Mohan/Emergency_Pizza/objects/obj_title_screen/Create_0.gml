title_y = room_height / 2;
move_up = true;

options = ["Start", "Quit"];
selected_index = 0;
arrow_x_offset = -40;

show_menu = false;

if (!surface_exists(application_surface)) {
    gpu_set_texfilter(false);
}

audio_play_sound(snd_start, 1, false);